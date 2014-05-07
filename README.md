# S-Lib

-------------------------------------------------------------------------------

A collection of functions and macros for string manipulation.
This lib is inspired by [s-el](https://github.com/magnars/s.el) library created by [Magnars](https://github.com/magnars) for [GNU Emacs](https://www.gnu.org/software/emacs/).

This library has not been tested with long strings and the recommendation is to use it (at least  for the moment) only with short strings.

## Installation
In terminal:

```sh
raco pkg install s-lib
```

After installing it, to use it:

```
(require s-lib)
```

## Functions

#### (s-trim str)
Removes beginning and ending white-spaces.

```cl
(s-trim "  bla blabal ")  ;;-> "bla blabal"
```

#### (s-trim-left str)
Removes beginning white-spaces.

```cl
(s-trim-left "   haha")  ;; -> "haha"
```

#### (s-trim-right str)
Removes ending white-spaces.

```cl
(s-trim-right "hahaha!   ")  ;; -> "hahaha!"
```

#### (s-chomp str)
Removes one trailing *\n* *\r* or *\r\n*.

```cl
(s-chomp "abc\n") ;; -> "abc"
```

#### (substring? str seq)
Checks if ```seq``` is part of ```str```.

```cl
(substring? "string" "ing")  ;; -> #t
```

#### (s-collapse-whitespaces str)
Converts all adjacent white-space characters to a single space.

```cl
(s-collapse-whitespaces "this   is    a    line")  ;; -> "this is a line"
```

#### (s-word-wrap str n seq)
If ```str``` is longer than ```n```, wraps the words with ```seq```.

```cl
(s-word-wrap "this" 2 "xx")  ;; -> "thxxisxx"
```

#### (s-center str n)
If ```str``` is shorter than n, it pads it with spaces, so it's centered.

```cl
(s-center "center" 10)  ;; -> "  center  "
```

#### (s-pad-left str n s)
If ```str``` is shorter than ```n```, it pads it with s on the left.

```cl
(s-pad-left "movie" 8 "x")  ;; -> "xxxmovie"
```

#### (s-pad-right str s)
If ```str``` is shorter than ```n```, it pads it with ```s``` on the right.

```cl
(s-pad-right "bl" 5 "a")  ;; -> "blaaa"
```

#### (s-truncate str n seq)
If ```str``` is longer than ```n```, it cuts down to ```n``` and adds ```seq``` at the end.

```cl
(s-truncate "more than life" 7 "...") ;; -> more...
```

#### (s-left str n)
Returns up to the ```n``` _first_ characters of ```str```.

```cl
(s-left "Good bye!" 4)  ;; -> "Good"
```

#### (s-right str n)
Returns up to the ```n``` _last_ characters of ```str```.

```cl
(s-right "Bye bye, my love!" 8)  ;; -> "my love!"
```

#### (s-chop-suffix str seq)
Removes suffix ```seq``` if it is at the end of ```str```.

```cl
(s-chop-suffix "call me" " me") ;; -> "call"
```

#### (s-chop-prefix str seq)
Removes prefix ```seq``` if it is at the beginning of ```str```.

```cl
(s-chop-prefix "Go fetch that ball!" "Go ")  ;; -> "fetch that ball!"
```

#### (s-chop-prefixes lst str)
Remove prefixes one by one in order, if they are at the beginning of ```str```.

```cl
(s-chop-prefixes '("x" "y" "z") "xyzabc")  ;; -> "abc"
```

#### (s-shared-start s1 s2)
Returns the longest prefix ```s1``` and ```s2``` have in common.

```cl
(s-shared-start "this" "that")  ;; -> "th"
```

#### (s-shared-end s1 s2)
Returns the longest suffix ```s1``` and ```s2``` have in common.

```cl
(s-shared-end "walking" "running") ;; -> "ing"
```

#### (s-repeat str n)
Makes ```str``` repeat ```n``` times.

```cl
(s-repeat "ha" 4)  ;; -> "hahahaha"
```

#### (s-prepend str prefix)
Concatenates ```prefix``` and ```str```.

```cl
(s-prepend "ing" "cry")  ;; -> "crying"
```

#### (s-append str suffix)
Concatenates ```str``` and ```suffix```.

```cl
(s-append "runn" "ing")  ;; -> running
```

#### (s-lines str)
Splits str into a list of strings on newline characters.

```cl
(s-lines "this\nand\nthat")  ;; -> '("this" "and" "that")
```

#### (s-match str seq)
Matches ```seq``` sequence transformed to regular expression.

```cl
(s-match "abcdefg" "^abc")  ;; -> '("abc")
```

#### (s-match-strings-all str seq)
Returns a list of matches for regex ```seq``` in ```str```.

```cl
(s-match-strings-all "abXabY" "ab." )  ;; -> '("abX" "abY")
```

#### (s-slice-at str seq)
Slices ```str``` up at every index matching ```seq```.

```cl
(s-slice-at "first0second0third" "0")  ;; -> '("first" "0second" "0third")
```

#### (s-split str seq)
Splits ```str``` into sub-strings bounded to matches for seq separator.

```cl
(s-split "onexxtwoxxthree" "xx")  ;; -> '("one" "two" "three")
```

#### (s-join lst seq)
Joins all the strings in ```lst``` with ```seq``` in between.

```cl
(s-join '("one" "for" "the" "money") " ")  ;; -> "one for the money"
```

#### (s-equals? s1 s2)
Checks if ```s1``` is equal to ```s2```.

```cl
(s-equals "yes" "yes")  ;; -> #t
```

#### (s-less? s1 s2)
Checks if ```s1``` is less than ```s2```.

```cl
(s-less? "hey" "you")  ;; -> #t
```

#### (s-blank? str)
Returns true if ```str``` is ```nil``` or _blank_.

```cl
(s-blank? "")  ;; -> #t
```

#### (s-present? str)
Returns true if ```str``` is anything but ```nil``` or the empty string.

```cl
(s-present? " ")  ;; -> #t
```

#### (s-ends-with? str seq)
Returns true if ```str``` ends with ```seq```.

```cl
(s-ends-with? "fishing" "ing")  ;; #t
```

#### (s-starts-with? str seq)
Returns true if ```str``` starts with ```seq```.

```cl
(s-starts-with? "yours" "you")  ;; -> #t
```

#### (s-contains? str seq)
Returns true if ```str``` contains ```seq```.

```cl
(s-contains? "Hamlet" "am")  ;; -> #t
```

#### (s-lowercase? str)
Checks if all the letters in ```str``` are lowercase.

```cl
(s-lowercase? "strIng")  ;; -> #f
```

#### (s-uppercase? str)
Checks if all the letters in ```str``` are uppercase.

```cl
(s-uppercase? "DANGLER")  ;; -> #t
```

#### (s-mixedcase? str)
Checks if there are both uppercase and lowercase in str

```cl
(s-mixedcase? "HELLO")  ;; -> #f
```

#### (s-capitalized? str)
Checks if the first letter is uppercase and the rest are lower case.

```cl
(s-capitalized? "HELLO")  ;; -> #f
```

#### (s-numeric? str)
Checks if ```str``` is a number.

```cl
(s-numeric? "123")  ;; -> #t
```

#### (s-downcase str)
Converts ```str``` to lower case.

```cl
(s-downcase "CamelCase")  ;; -> "camelcase"
```

#### (s-upcase str)
Converts ```str``` to upper case.

```cl
(s-upcase "CamelCase")  ;; -> CAMELCASE
```

#### (s-replace str old new)
Replaces ```old``` with ```new``` in ```str```.

```cl
(s-replace "The cat eat your tongue" "cat" "monster") ;; -> "The monster eat your tongue"
```

#### (s-capitalize str)
Converts the first word's first character to upper case, and the rest to lower case

```cl
(s-capitalize "this story is Awesome")  ;; -> "This story is awesome"
```

#### (s-titleize str)
Converts each word's first character to upper case and the rest to lower case.

```cl
(s-titleize "the end")  ;; -> "The End"
```

#### (s-index-of str seq)
Returns the first index of ```seq``` in ```str```, or nil.

```cl
(s-index-of "The beauty and the beast" "and")  ;; -> 11
```

#### (s-reverse str)
Reverses ```str```.

```cl
(s-reverse "John Rambo")  ;; ->"obmaR nhoJ"
```

#### (s-presence str)
Returns ```str``` if present.

```cl
(s-presence "string")  ;; -> "string"
```

#### (s-count-matches str seq)
Counts the occurances of ```seq```.

```cl
(s-count-matches "And one, and two, and three and four" "and")  ;; -> 3
```
