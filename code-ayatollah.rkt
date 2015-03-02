#!/bin/env racket
;; -*- scheme -*-

#lang at-exp racket/base

(require racket/cmdline racket/list racket/pretty racket/port racket/file)

(define current-file #f)
(define current-code #f)
(define newline-positions #f)
(define errors #f)

(define (bad stx . args)
  (define file (syntax-source stx))
  (unless (equal? file current-file)
    (error 'check-style "internal error: source = ~s for ~s" file stx))
  (unless errors (set! errors #t) (printf "Errors in ~a:\n" file))
  (define (show-stx x)
    (define d (syntax->datum x))
    (unless (pair? d) (display "`"))
    (display
     (regexp-replace #rx"\n+$"
                     (parameterize ([pretty-print-columns 'infinity]
                                    [pretty-print-depth 2])
                       (call-with-output-string (λ (o) (pretty-write d o))))
                     ""))
    (unless (pair? d) (display "'")))
  (define (show-it)
    (when (eq? #t errors)
      (printf "  ~a:~a: " (syntax-line stx) (syntax-column stx)))
    (for ([x (in-list args)])
      (cond [(string? x) (display x)]
            [(syntax? x) (show-stx x)]
            [else        (write x)])))
  (if (eq? #t errors)
    (begin (show-it) (newline))
    (set! errors (cons (cons stx (with-output-to-string show-it)) errors))))

(define (annotate-current-code)
  (printf "----<<< ~a >>>----\n" current-file)
  (when (null? errors) (displayln ";;> *** No style errors found ***"))
  (define (show-line-errors errors n)
    (define (getcol e) (syntax-column (car e)))
    (let*-values ([(errors rest)
                   (partition (λ (e) (eq? n (syntax-line (car e)))) errors)]
                  [(errors)  (sort errors < #:key getcol)]
                  [(cols)    (remove-duplicates (map getcol errors) eq?)]
                  [(cols>=4) (filter (λ (c) (>= c 4)) cols)])
      (when (pair? errors)
        (when (pair? cols>=4)
          (display ";;> ")
          (for ([i (in-list (cons 3 cols>=4))] [j (in-list cols>=4)]
                [n (in-naturals 65)])
            (display (make-string (- j i 1) #\space))
            (display (integer->char n)))
        (newline))
        (let loop ([es errors] [lastcol -1] [n -1])
          (when (pair? es)
            (let* ([e (car es)] [es (cdr es)]
                   [col (getcol e)]
                   [n (if (or (= col lastcol) (< col 4)) n (add1 n))])
              (display ";;> ")
              (cond [(and (null? (cdr errors)) (null? cols>=4))]
                    [(< col 4) (display "* ")]
                    [else (printf "(~a) " (integer->char (+ n 65)))])
              (displayln (cdr e))
              (loop es col n)))))
      rest))
  (for/fold ([errors errors])
            ([nl1 (in-list (cons -1 newline-positions))]
             [nl2 (in-list newline-positions)]
             [n (in-naturals 1)])
    (write-string current-code (current-output-port) (add1 nl1) (add1 nl2))
    (show-line-errors errors n)))

(define (scan-syntax stx scanner)
  (let loop ([stx stx])
    (scanner stx)
    (cond [(syntax->list stx) => (λ (stxs) (for-each loop stxs))]
          [(pair? (syntax-e stx))
           (bad stx "improper list")
           (loop (car (syntax-e stx)))
           (loop (cdr (syntax-e stx)))])))

(define blessed-bracketed-forms (make-weak-hasheq))

(define (all-checks stx)
  (define (BAD . xs) (apply bad stx xs))
  (define (same-id? x y) (eq? (syntax->datum x) (syntax->datum y)))
  (define-syntax-rule (syntax-cases kws [[patt expr ...] ...] ...)
    (begin (syntax-case* stx kws same-id? [patt expr ...] ... [_ (void)])
           ...))
  ;; Formatting issues (don't always work, since they can't see comments)
  (define (is-punct? stx)
    (let ([xs (syntax->list stx)])
      (and xs (= 2 (length xs)) (identifier? (car xs))
           (memq (syntax-e (car xs))
                 '(quote quasiquote unquote unquote-splicing syntax))
           (= (syntax-position stx) (syntax-position (car xs))))))
  (let* ([stxs (syntax->list stx)]
         [head (and (pair? stxs) (syntax->datum (car stxs)))]
         [pos  (syntax-position stx)]
         [span (syntax-span stx)]
         [line (syntax-line stx)]
         [col  (syntax-column stx)]
         [toplevel (and (memq head '(module #%module-begin)) head)]
         [punct? (is-punct? stx)]
         [open  (or (syntax-property stx 'paren-shape) #\()]
         [close (case open [(#\() #\)] [(#\[) #\]] [(#\{) #\}]
                           [else (error 'check-style
                                        "internal error (paren-shape)")])]
         [open  (string open)]
         [close (string close)])
    ;; {...}
    (when (and stxs (equal? "{" open))
      @BAD{should not use curly braces in Racket code})
    ;; [...] -- must appear in blessed places and nowhere else
    (define (check-bracketed stx)
      (or (identifier? stx) ; allow ids, bad syntax gets caught by the sandbox
          (and (equal? #\[ (syntax-property stx 'paren-shape))
               (begin (hash-set! blessed-bracketed-forms stx #t) #t))))
    (define (check-bracketed-forms stx)
      (let ([bads (filter (λ (x) (not (check-bracketed x)))
                          (syntax->list stx))])
        (when (pair? bads)
          @bad[(car bads)]{should use square brackets here@;
                           @(if (null? (cdr bads)) "" " and below")})))
    (define (no-brackets)
      (when (and (equal? "[" open)
                 (not (identifier? stx))
                 (not (hash-ref blessed-bracketed-forms stx #f)))
        @BAD{don't use square brackets here}))
    (syntax-case* stx (cond local define-type =) same-id?
      [(cond B ...)    (check-bracketed-forms #'(B ...))]
      [(local B . _)   (check-bracketed-forms #'(B))]
      [(H _ B ...)     (memq (syntax-e #'H) '(match cases case))
                       (check-bracketed-forms #'(B ...))]
      [(H (B ...) . _) (memq (syntax-e #'H) '(let let* letrec let:))
                       (check-bracketed-forms #'(B ...))]
      [(H (B ...) . _) (memq (syntax-e #'H) '(lambda:))
                       (check-bracketed-forms #'(B ...))]
      [(define-type _ = . _) (no-brackets)]
      [(define-type _ B ...) (check-bracketed-forms #'(B ...))]
      [_ (no-brackets)])
    (when (pair? stxs)
      (unless toplevel
        ;; ( x
        (let ([x (car stxs)])
          (unless (<= (syntax-position x) (+ 1 pos))
            @bad[x]{bad space after the "@open" and before @x}))
        ;; x )
        (let ([x (last stxs)])
          (unless (>= (+ (syntax-position x) (syntax-span x) 1) (+ pos span))
            @bad[x]{bad space after @x and before the "@close"})))
      ;; | (
      (when (eq? toplevel '#%module-begin) ; <-- where the real code goes
        (for ([x (in-list (cdr stxs))])
          (unless (= 0 (syntax-column x))
            @bad[x]{bad space before toplevel expression @x})))
      ;; )(
      (unless (or toplevel punct?)
        (for ([x (in-list stxs)] [y (in-list (cdr stxs))])
          (when (>= (+ (syntax-position x) (syntax-span x))
                    (syntax-position y))
            @bad[y]{missing space before @y})))
      ;; all are either on one-line, or each on a different line (except for
      ;; the head)
      (let* ([special-subforms
              ;; N => these number of initial subforms should be on the same
              ;;      line, the rest should be indented as a body
              ;; 0 => should all be on separate lines (or on one line as usual)
              ;; #f => function call -- line up as usual
              ;; (there's also "flat" toplevel expressions, but that's checked
              ;; above)
              (case head
                [(define define-type lambda lambda: match cases when unless
                  local let let: let* letrec if begin0) 1]
                [(define:) 3]
                [(cond) 0]
                [else #f])]
             [leftmost (foldl (λ (x l)
                                (if (or (not l) (< (syntax-column x)
                                                   (syntax-column l)))
                                  x l))
                              #f stxs)]
             [indent (- (syntax-column leftmost) col)])
        (define (syntax-newlines stx)
          (let* ([start (syntax-position stx)]
                 [end   (sub1 (+ start (syntax-span stx)))])
            (count (λ (n) (< start n end)) newline-positions)))
        ;; stxs should all be on one line: check that the last one isn't going
        ;; over a new line (only if we have >2 items with an id in the head, or
        ;; >1 without)
        (define (check-no-bad-newlines stxs)
          (when (and (pair? stxs) (pair? (cdr stxs))
                     (or (pair? (cddr stxs))
                         (not (identifier? (car stxs))))
                     (positive? (syntax-newlines (last stxs))))
            @bad[(last stxs)]{make this form fit on one line, @;
                              or put it on a separate line}))
        (cond
          [(or toplevel punct?)]
          [(and special-subforms ((length stxs) . < . (add1 special-subforms)))
           (error 'check-style
                  "possible internal error: invalid syntax ~s"
                  (syntax->datum stx))]
          ;; if it's all on one line, then there's nothing to do in this part
          [(let ([lines (map syntax-line stxs)])
             (andmap (λ (l) (= l (car lines))) lines))
           (check-no-bad-newlines stxs)]
          [else
           ;; check the very bad cases first
           (cond
             [(negative? indent)
              (let ([adj (cond [(< indent -10) "outrageously bad"]
                               [(< indent  -5) "horribly bad"]
                               [(< indent  -3) "extremely bad"]
                               [(< indent  -1) "very bad"]
                               [else "bad"])])
                @bad[leftmost]{@adj "out-dentation" (@(- indent) chars)})]
             [(zero? indent) @bad[leftmost]{misleading "flat" indentation}])
           ;; now check more cases in *addition* to that
           ;; check that the first N expressions are on the first line
           ;; [if `special-subforms' is #f it might make sense to pretend it's
           ;; 1 for this check, but this part doesn't know the surrounding
           ;; form, so things like (let ([x 1] <newline> [y 2]) ...) makes it
           ;; barf wrongly.]
           (when special-subforms
             (let* ([line (syntax-line (car stxs))]
                    [b (findf (λ (x) (not (= line (syntax-line x))))
                              (take (cdr stxs) special-subforms))])
               (when b ; this can be in addition to the above <=0 cases
                 @bad[b]{this subform should be on the first line}))
             ;; also check that the prefix are all really on one line
             ;; (questionable, since the advice to split lines would be bogus)
             (check-no-bad-newlines (take stxs (add1 special-subforms))))
           ;; check that the following N+1 forms are all on different lines
           ;; without overlap and all are aligned
           (let* ([xs (drop stxs (+ 1 (or special-subforms 0)))]
                  [col (if (pair? xs)
                         (syntax-column (car xs))
                         (error 'check-style
                                "internal error: missing subforms?"))]
                  [bad-line
                   (for/or ([x (in-list xs)] [y (in-list (cdr xs))])
                     (and (or (= (syntax-line x) (syntax-line y))
                              ;; without line overlap:
                              (>= (+ (syntax-line x) (syntax-newlines x))
                                  (syntax-line y)))
                          y))]
                  [bad-col
                   (for/or ([x (in-list xs)])
                     (and (not (= col (syntax-column x))) x))])
             (cond
               [(and special-subforms (> special-subforms 0)
                     (= (syntax-line (car stxs)) (syntax-line (car xs))))
                @bad[(car xs)]{break the line before this point @;
                               or make the whole @(car stxs) fit on one line}]
               [bad-line
                @bad[bad-line]{
                  this expression (and the rest) should be on a separate @;
                  line (or make the whole @(car stxs) fit on one line)}]
               ;; don't do this in a addition to the <=0 cases
               [(and bad-col (or (positive? indent)
                                 (not (equal? bad-col leftmost))))
                @bad[bad-col]{bad indentation (this doesn't align)}]))]))))
  (define (check-identifier id)
    (unless (identifier? id)
      (error 'check-style "internal error: unexpected an identifier, got ~s"
             id))
    (when (regexp-match? #rx"^[a-z].*[a-z][A-Z]+[a-z]|._|_."
                         (symbol->string (syntax-e id)))
      @bad[id]{bad identifier name @id, use dashes}))
  (define (check-identifiers stx)
    (for-each check-identifier (syntax->list stx)))
  ;; Now some "semantic" tests
  (syntax-cases (define define: lambda let let* letrec let:
                 cond else if not and or true false begin list cons null)
    [[(define (fun x ...) . _)        (check-identifiers #'(fun x ...))]
     [(define: (fun [x : t] ...) . _) (check-identifiers #'(fun x ...))]
     [(let    ([x v] ...) . _)    (check-identifiers #'(x ...))]
     [(let*   ([x v] ...) . _)    (check-identifiers #'(x ...))]
     [(letrec ([x v] ...) . _)    (check-identifiers #'(x ...))]
     [(let: ([x : t v] ...) . _)  (check-identifiers #'(x ...))]]
    [[(if _ _ (if . _)) @BAD{nested @#'if that should be a @#'cond}]]
    [[(if c #t #f)   @BAD{@#'if not needed, just use @#'c as a boolean value}]
     [(if c true false)
                     @BAD{@#'if not needed, just use @#'c as a boolean value}]
     [(if c #f #t)   @BAD{@#'if not needed, just use @#'(not c)}]
     [(if c false true)
                     @BAD{@#'if not needed, just use @#'(not c)}]
     [(if c #t x)    @BAD{@#'if not needed, just use @#'(or c x)}]
     [(if c true x)  @BAD{@#'if not needed, just use @#'(or c x)}]
     [(if c x #f)    @BAD{@#'if not needed, just use @#'(and c x)}]
     [(if c x false) @BAD{@#'if not needed, just use @#'(and c x)}]
     ;; [(if c #f x)    @BAD{might be better to use @#'(and (not c) x)}]
     ;; [(if c false x) @BAD{might be better to use @#'(and (not c) x)}]
     ;; [(if c x  #t)   @BAD{might be better to use @#'(or (not c) x)}]
     ;; [(if c x true)  @BAD{might be better to use @#'(or (not c) x)}]
     ]
    ;; the following two are even more approximately applicable
    [[(cond [c t] [else e]) @BAD{use @#'(if c t e) instead of @#'cond}]]
    [[[else (cond . clauses)]
      @bad[(cadr (syntax->list stx))]{
        flatten this into the surrounding @#'cond}]]
    [[(and)        @BAD{@stx is just the same as @#'#t}]
     [(or)         @BAD{@stx is just the same as @#'#f}]
     [(and c)      @BAD{@#'(and c) is just the same as @#'c}]
     [(or c)       @BAD{@#'(and c) is just the same as @#'c}]
     [(begin e)    @BAD{@#'(begin c) is just the same as @#'c}]
     [(hd x0 xs ...)
      (and (identifier? #'hd)
           (memq (syntax-e #'hd) '(begin and or + * append)))
      (let ([hd (syntax-e #'hd)])
        (for ([x (in-list (cdr (syntax->list stx)))])
          (syntax-case x ()
            [(hd2 . xs)
             (and (identifier? #'hd2) (eq? hd (syntax-e #'hd2)))
             @BAD{no need for the nested @x expression}]
            [_ (void)])))]]
    [[(cons x null) @BAD{use @#'(list x) instead of @#'(cons x null)}]
     [(list)        @BAD{use @#'null instead of @#'(list)}]]))

(define (test-style file)
  (set! current-file file)
  (set! current-code (file->string file))
  (set! newline-positions
        (map car (regexp-match-positions* #rx"\n" current-code)))
  (set! errors       (if (boolean? errors) #f '()))
  (define stx
    (parameterize ([read-accept-reader #t] [port-count-lines-enabled #t])
      (call-with-input-string current-code
        (λ (i)
          (let ([s (read-syntax file i)])
            (if (and (pair? (syntax-e s))
                     (eq? 'module (syntax->datum (car (syntax-e s)))))
              (begin
                (unless (eof-object? (read i))
                  (error 'check-style "internal error: unexpected contents"))
                s)
              (datum->syntax #f
                `(#%module-begin
                  ,s ,@(for/list ([s (in-producer (λ () (read-syntax file i))
                                                  eof)])
                         s))
                (list #f 1 0 1 (string-length current-code)))))))))
  (scan-syntax stx all-checks)
  (unless (boolean? errors) (annotate-current-code)))

(command-line
 #:once-each
 [("-p" "--print") "show errors with the source" (set! errors '())]
 #:args files (for-each test-style files))
