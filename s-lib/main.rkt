#lang racket/base
(require racket/string)
(require racket/list)

(provide (all-defined-out))

;; ------------------------------------------------------------
;; A collection of functions and macros for string manipulation
;; ------------------------------------------------------------

;; Remove beginning and ending whitespaces
(define s-trim string-trim)

;; Remove beginning whitespaces
(define (s-trim-left str)
  (string-trim str #:right? #f))

;; Remove ending whitespaces
(define (s-trim-right str)
  (string-trim str #:left? #f))

;; Remove one trailing \n, \r or \r\n from str.
(define (s-chomp str)
  (let ([len (string-length str)])
    (if (> len 2)
        (let ([last-let (substring str (- len 1) len)]
              [pen-let (substring str (- len 2) (- len 1))])
          (cond [(and (string=? pen-let "\r")
                      (string=? last-let "\n"))
                 (substring str 0 (- len 2))]
                [(string=? last-let "\r")
                 (substring str 0 (- len 1))]
                [(string=? last-let "\n")
                 (substring str 0 (- len 1))]
                [else str])) str)))

(define (substring? str seq)
  (regexp-match? (regexp-quote seq) str))

;; Convert all adjacent whitespace characters to a single space.
(define (s-collapse-whitespaces str)
  (let ([pattern #px"[ ]{2,}"])
    (if (regexp-match pattern str)
	(s-collapse-whitespaces (regexp-replace pattern str " "))
 	str)))

;; If str is longer than n wrap the words with seq
(define (s-word-wrap str n seq)
  (let ([len (string-length str)])
    (if (< len  n) str
	(string-append (substring str 0 n) seq
		       (s-word-wrap (substring str n len) n seq)))))

;; If str is shorter than n pad it with spaces so it's centered
(define (s-center str n)
  (let* ([st (string-trim str)]
	 [len (string-length st)])
    (if (> len n) str
	(let* ([all (- n len)]
	       [post-spaces (quotient all 2)]
	       [pre-spaces (- all post-spaces)])
	  (string-append (make-string pre-spaces #\space) st
			 (make-string post-spaces #\space))))))

;; If str is shorter than n, pad it with s on the left
(define (s-pad-left str n s)
  (let ([len (string-length str)])
    (if (> len n) str
	(string-append (make-string (- n len)
				    (first (string->list s)))
		       str))))

;; If str is shorter than n, pad it with s on the right
(define (s-pad-right str n s)
  (let ([len (string-length str)])
    (if (> len n) str
	(string-append str
		       (make-string (- n len)
				    (first (string->list s)))))))

;; If str is longer than n, cut it down to n and add seq at the end
(define (s-truncate str n seq)
  (let* ([str-len (string-length str)]
	 [seq-len (string-length seq)]
	 [dif (- n seq-len)])
    (cond [(> n str-len) str]
	  [(< dif 0) str]
     	  [else
	   (string-append (substring str 0 dif) seq)])))

;; Returns up to the n first chars of str
(define (s-left str n)
  (if (< (string-length str) n) str
      (substring str 0 n)))

;; Returns up to the n last chars of str
(define (s-right str n)
  (let ([len (string-length str)])
    (if (< len n) str
	(substring str (- len n) len))))

;; Remove suffix seq if it is at end of str
(define (s-chop-suffix str seq)
  (let ([len (string-length seq)])
    (if (equal? (s-right str len) seq)
	(substring str 0 (- (string-length str) len))
	str)))

;; Remove prefix seq if it is at the start of str
(define (s-chop-prefix str seq)
  (let ([len (string-length seq)])
    (if (equal? (s-left str len) seq)
	(substring str len (string-length str))
	str)))

;; Remove prefixes one by one in order, if they are at the start of str.
(define (s-chop-prefixes lst str)
  (if (empty? lst) str
      (s-chop-prefixes
       (rest lst)
       (s-chop-prefix str (first lst)))))

;; Returns the longest prefix s1 and s2 have in common.
(define (s-shared-start s1 s2)
  (let next ([l1 (string->list s1)]
	     [l2 (string->list s2)]
	     [res '()])
    (if (or (empty? l1) (empty? l2)
	    (not (eq? (first l1) (first l2))))
	(list->string res)
	(next (rest l1) (rest l2)
	      (append res (list (first l1)))))))

;; Returns the longest suffix s1 and s2 have in common.
(define (s-shared-end s1 s2)
  (let next ([l1 (reverse (string->list s1))]
	     [l2 (reverse (string->list s2))]
	     [res '()])
    (if (or (empty? l1) (empty? l2)
	    (not (eq? (first l1) (first l2))))
	(list->string res)
	(next (rest l1) (rest l2)
	      (cons (first l1) res)))))

;; Make a string string str repeat n times.
(define (s-repeat str n)
  (let loop ([s str] [count 2])
    (if (> count n) s
	(loop (string-append s str) (add1 count)))))

;; Concatenate prefix and s
(define (s-prepend str prefix)
  (string-append prefix str))

;;Concatenate s and suffix.
(define s-append string-append)

;; Splits str into a list of strings on newline characters
(define (s-lines str)
  (if (eq? str "") '("")
      (regexp-split #rx"\n" str)))

;; Match seq sequence transformed to regular expression
(define (s-match str seq)
  (let ([res (regexp-match (regexp seq) str)])
    (if res res '())))

;; Return a list of matches for regex seq in str.
(define (s-match-strings-all str seq)
  (regexp-match* (regexp seq) str))

;; Slices str up at every index matching seq
(define (s-slice-at str seq)
  (let [(lst (regexp-split (regexp-quote seq) str))]
    (cons (first lst) (map (lambda (x) (string-append seq x)) (rest lst)))))

;; Split str into substrings bounded by matches for seq separator
(define (s-split str seq)
  (regexp-split (regexp-quote seq) str))

;; Join all the strings in lst with seq in between.
(define (s-join lst seq)
  (if (empty? (rest lst)) (first lst)
      (string-append (first lst) seq (s-join (rest lst) seq))))

;; Is s1 equal to s2
(define s-equals? string=?)

;; Is s1 less than s2?
(define s-less? string<?)

;; Does seq match s?
(define (s-matches? str seq)
  (regexp-match-exact? (regexp seq) str))

;; Is str nil or blank?
(define (s-blank? str)
  (cond [(empty? str) #f]
        [(string=? str "") #t]
        [(string=? str " ") #t]
        [else #f]))

;; Is str anything but nil or the empty string?
(define (s-present? str)
  (cond [(not (string? str)) #f]
        [(string=? str " ") #t]
        [(s-blank? str) #f]
        [else #t]))

;; Does str end with seq?
(define (s-ends-with? str seq)
  (let ([seq-len (string-length seq)]
        [str-len (string-length str)])
    (string=? (substring str (- str-len seq-len) str-len) seq)))

;; Does str starts with seq?
(define (s-starts-with? str seq)
  (let ([seq-len (string-length seq)])
   (string=? (substring str 0 seq-len) seq)))

;; Does str contains seq?
(define (s-contains? str seq)
  (regexp-match? (regexp-quote seq) str))

;; Are all the letters in str in lower case?
(define (s-lowercase? str)
  (for/and ([i (filter (lambda(x) (not (eq? x #\space))) (string->list str))])
    (char-lower-case? i)))

;; All the letters in str in uppercase?
(define (s-uppercase? str)
  (for/and ([i (filter (lambda(x) (not (eq? x #\space))) (string->list str))])
    (char-upper-case? i)))

;; Are both lowercase and uppercase in str?
(define (s-mixedcase? str)
  (and (not (s-uppercase? str))
       (not (s-lowercase? str))))

;; Is the first letter upper case, and all other letters lower case?
(define (s-capitalized? str)
  (and (char-upper-case? (first (string->list (substring str 0 1))))
       (s-lowercase? (substring str 1 (string-length str)))))

;; Is str a number?
(define (s-numeric? str)
  (for/and ([i (string->list str)])
    (char-numeric? i)))

;; Convert str to downcase
(define s-downcase string-downcase)

;; Replaces old with new in str.
(define (s-replace str old new)
  (regexp-replace (regexp old) str new))

;; Convert str to upper case.
(define s-upcase string-upcase)

;; Convert the first word's first character to upper case and the rest to lower case in str
(define (s-capitalize str)
  (string-append (s-upcase (substring str 0 1))
                 (s-downcase (substring str 1 (string-length str)))))

;; Convert each word's first character to upper case and the rest to lower case in s.
(define s-titleize 
  string-titlecase)

;; Returns first index of seq in str, or nil.
(define (s-index-of str seq)
  (let ([l (regexp-match-positions (regexp (s-downcase seq)) (s-downcase str))])
    (if l (car (first l)) '())))

;; Reverse s
(define (s-reverse str)
  (foldr
   (lambda (f s) (string-append (string f) s)) ""
   (foldl cons '() (string->list str))))

;; Returns string if present
(define (s-presence str)
  (if (or (empty? str)
          (string=? str ""))
      '() str))

;; Count occurances of seq
(define (s-count-matches str seq)
  (length (regexp-match* (regexp seq) str)))

;; to run the tests:
;; - if package installed run in terminal:
;; raco test s-lib
;; - if package not installed; cd to dir and run:
;; raco test main.rkt

(module+ test
  (require rackunit)

  (newline)
  (displayln "Running unit tests for S-LIB...")

  (check-equal? (s-trim "   abc") "abc")
  (check-equal? (s-trim "  xxx    ") "xxx")
  (check-equal? (s-trim "abc") "abc")

  (check-equal? (s-trim-left "   xyz") "xyz")
  (check-equal? (s-trim-left "   abc ") "abc ")
  (check-equal? (s-trim-left "string") "string")

  (check-equal? (s-trim-right "abc   ") "abc")
  (check-equal? (s-trim-right "  xyz  ") "  xyz")
  (check-equal? (s-trim-right "xxx") "xxx")

  (check-equal? (s-chomp "abc\n") "abc")
  (check-equal? (s-chomp "def\r") "def")
  (check-equal? (s-chomp "ghi\r\n") "ghi")
  (check-equal? (s-chomp "string") "string")
  
  (check-equal? (substring? "alabala" "bal") #t)
  (check-equal? (substring? "bla *** bla" "*** ") #t)
  (check-equal? (substring? "this is a line" "linu") #f)

  (check-equal? (s-collapse-whitespaces "   this  string") " this string")
  (check-equal? (s-collapse-whitespaces "this") "this")
  (check-equal? (s-collapse-whitespaces "this string") "this string")

  (check-equal? (s-word-wrap "b" 3 "x") "b")
  (check-equal? (s-word-wrap "aaabbbccc" 3 "xx") "aaaxxbbbxxcccxx")
  (check-equal? (s-word-wrap "abcde" 2 "y") "abycdye") ;
  (check-equal? (s-word-wrap "" 2 "a") "")

  (check-equal? (s-center "blabla" 3) "blabla")
  (check-equal? (s-center "ala" 4) " ala")
  (check-equal? (s-center "aaa " 5) " aaa ")
  (check-equal? (s-center "xxxx" 8) "  xxxx  ")

  (check-equal? (s-pad-left "xxxx" 3 "a") "xxxx")
  (check-equal? (s-pad-left "abcd" 5 "x") "xabcd")
  (check-equal? (s-pad-right "abcd" 5 "x") "abcdx")
  (check-equal? (s-pad-right "xxxx" 3 "a") "xxxx")

  (check-equal? (s-truncate "abcd" 5 "bla") "abcd")
  (check-equal? (s-truncate "abcdefgh" 5 "..") "abc..")
  (check-equal? (s-truncate "abcdef" 4 "xyxyz") "abcdef")

  (check-equal? (s-left "abc" 10) "abc")
  (check-equal? (s-left "abcdef" 3) "abc")
  (check-equal? (s-right "abc" 10) "abc")
  (check-equal? (s-right "aaaabcdef" 3) "def")

  (check-equal? (s-chop-suffix "test.rkt" ".rkt") "test")
  (check-equal? (s-chop-suffix "test.rkt" ".rlt") "test.rkt")
  (check-equal? (s-chop-suffix "test.rkt" "") "test.rkt")
  (check-equal? (s-chop-suffix "te" "tes") "te")

  (check-equal? (s-chop-prefix "bla.bla" "bla.") "bla")
  (check-equal? (s-chop-prefix "bla.bla" "bal") "bla.bla")
  (check-equal? (s-chop-prefix "test" "") "test")
  (check-equal? (s-chop-prefix "test" "testing") "test")

  (check-equal? (s-chop-prefixes '("bal" "bla") "test") "test")
  (check-equal? (s-chop-prefixes '("/abc" "/def") "/abc/def/ghi") "/ghi")
  (check-equal? (s-chop-prefixes '("/dej" "/abd") "/abd/def/j") "/def/j")

  (check-equal? (s-shared-start "this is a text" "this and that") "this ")
  (check-equal? (s-shared-start "this is a text" "what is a text") "")
  (check-equal? (s-shared-start "text" "texts") "text")
  (check-equal? (s-shared-start "" "texts") "")

  (check-equal? (s-shared-end "check end" "this is the end") " end")
  (check-equal? (s-shared-end "check end" "this") "")
  (check-equal? (s-shared-end "abcd" "babcd") "abcd")
  (check-equal? (s-shared-end "" "this") "")

  (check-equal? (s-repeat "ab" 3) "ababab")
  (check-equal? (s-repeat "b" 0) "b")
  (check-equal? (s-repeat "" 5) "")

  (check-equal? (s-prepend "abc" "xx") "xxabc")
  (check-equal? (s-prepend "" "abc") "abc")
  (check-equal? (s-prepend "" "") "")

  (check-equal? (s-append "abc" "d") "abcd")
  (check-equal? (s-append "xxx" "") "xxx")

  (check-equal? (s-lines "haha") '("haha"))
  (check-equal? (s-lines "bla\nbla") '("bla" "bla"))
  (check-equal? (s-lines "") '(""))
  
  (check-equal? (s-match "abcdef" "^def") '())
  (check-equal? (s-match "abcdefg" "^abc") '("abc"))

  (check-equal? (s-blank? "") #t)
  (check-equal? (s-blank? " ") #t)
  (check-equal? (s-blank? "_") #f)
  (check-equal? (s-blank? '()) #f)

  (check-equal? (s-present? "") #f)
  (check-equal? (s-present? '()) #f)
  (check-equal? (s-present? " ") #t)
  (check-equal? (s-present? "abc") #t)
  

  (check-equal? (s-match-strings-all "abXabY" "ab." ) '("abX" "abY"))
  (check-equal?  (s-match-strings-all  "foo bar baz" "\\<") '()) 
  
  (check-equal? (s-slice-at "bla" "-") '("bla"))
  (check-equal? (s-slice-at "ha-ha ha-ha" "-") '("ha" "-ha ha" "-ha"))
  (check-equal? (s-slice-at "" "ha") '(""))

  (check-equal? (s-split "hahaha" "-") '("hahaha"))
  (check-equal? (s-split "" "-") '(""))
  (check-equal? (s-split "this-is-a-string" "-") '("this" "is" "a" "string"))

  (check-equal? (s-join '("string") "x") "string")
  (check-equal? (s-join '("a" "b" "c" "d") "x") "axbxcxd")
  (check-equal? (s-join '("string") "") "string")

  (check-equal? (s-matches? "123" "^[0-9]+$" ) #t)
  (check-equal? (s-matches? "a123" "^[0-9]+$") #f)
  
  (check-equal? (s-ends-with? "string" "nng") #f)
  (check-equal? (s-ends-with? "hello.com" ".com") #t)
  (check-equal? (s-ends-with? "hey" "") #t)

  (check-equal? (s-starts-with? "string" "stra") #f)
  (check-equal? (s-starts-with? "xxxlove" "xxx") #t)
  (check-equal? (s-starts-with? "str" "") #t)

  (check-equal? (s-contains? "" "bla") #f)
  (check-equal? (s-contains? "haha" "") #t)
  (check-equal? (s-contains? "this" "is") #t)
  (check-equal? (s-contains? "this" "that") #f)

  (check-equal? (s-lowercase? "abcd") #t)
  (check-equal? (s-lowercase? "abCd") #f)
  (check-equal? (s-lowercase? "") #t)

  (check-equal? (s-uppercase? "ABC") #t)
  (check-equal? (s-uppercase? "ACCCd") #f)
  (check-equal? (s-uppercase? "") #t)

  (check-equal? (s-mixedcase? "ABC") #f)
  (check-equal? (s-mixedcase? "abc") #f)
  (check-equal? (s-mixedcase? "aBAAA") #t)
  (check-equal? (s-mixedcase? "") #f)

  (check-equal? (s-capitalized? "haaa") #f)
  (check-equal? (s-capitalized? "aHHH") #f)
  (check-equal? (s-capitalized? "This is capitalized") #t)

  (check-equal? (s-numeric? "12340") #t)
  (check-equal? (s-numeric? "1234 ") #f)
  (check-equal? (s-numeric? "a3") #f)
  (check-equal? (s-numeric? "") #t)

  (check-equal? (s-downcase "ABC") "abc")
  (check-equal? (s-downcase "ab") "ab")
  (check-equal? (s-downcase "AbC") "abc")

  (check-equal? (s-upcase "abc") "ABC")
  (check-equal? (s-upcase "ABc") "ABC")
  (check-equal? (s-upcase "AB") "AB")

  (check-equal? (s-capitalize "this world") "This world")
  (check-equal? (s-capitalize "ANOTHER time") "Another time")
  (check-equal? (s-capitalize "This") "This")

  (check-equal? (s-replace "this ist the string" "ist" "was")
                "this was the string")
  (check-equal? (s-replace "another string" "ingi" "other") "another string")

  (check-equal? (s-titleize "haha") "Haha")
  (check-equal? (s-titleize "This expression") "This Expression")
  (check-equal? (s-titleize "String") "String")

  (check-equal? (s-index-of "this is a string" "is") 2)
  (check-equal? (s-index-of "this is another string" "hah") '())
  (check-equal? (s-index-of "string" "") 0)
  (check-equal? (s-index-of "sTRing" "tr") 1)

  (check-equal? (s-reverse "abcde") "edcba")
  (check-equal? (s-reverse "") "")
  (check-equal? (s-reverse "a") "a")

  (check-equal? (s-presence "bla") "bla")
  (check-equal? (s-presence "") '())
  (check-equal? (s-presence '()) '())

  (check-equal? (s-count-matches "this is a string" "is") 2)
  (check-equal? (s-count-matches "this is another string" "bla") 0)
)

