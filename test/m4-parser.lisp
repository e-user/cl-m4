;;;; cl-m4 - m4-parser.lisp
;;;; Copyright (C) 2010  Alexander Kahl <e-user@fsfe.org>
;;;; This file is part of cl-m4.
;;;; cl-m4 is free software; you can redistribute it and/or modify
;;;; it under the terms of the GNU General Public License as published by
;;;; the Free Software Foundation; either version 3 of the License, or
;;;; (at your option) any later version.
;;;;
;;;; cl-m4 is distributed in the hope that it will be useful,
;;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;;; GNU General Public License for more details.
;;;;
;;;; You should have received a copy of the GNU General Public License
;;;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

(in-package :cl-m4-test)

(in-suite m4)
 
(deftest dnl-with-args ()
  (m4-test
#>m4>
dnl(foo)
<- token m4

#>m4>
<- token m4

:error #>m4eof>cl-m4:2:8: excess arguments to builtin `dnl' ignored
m4eof))


(deftest dnl-with-empty-args ()
  (m4-test
#>m4>
dnl()
<- token m4

#>m4>
<- token m4

:error #>m4eof>cl-m4:2:5: excess arguments to builtin `dnl' ignored
m4eof))


(deftest dnl-quote-start ()
  (m4-test
#>m4>
dnl`0
<- token m4

#>m4>
<- token m4))


(deftest dnl-underscore ()
  (m4-test "dnl_foo token" "dnl_foo token"))


(deftest dnl-number ()
  (m4-test "dnl4 token" "dnl4 token"))


(deftest dnl-quote-end ()
  (m4-test
#>m4>
dnl'token token
<- token m4

#>m4>
<- token m4))


(deftest dnl-comment ()
  (m4-test
#>m4>
dnl#token token
<- token m4

#>m4>
<- token m4))


(deftest dnl-quotes ()
  (m4-test
#>m4>
dnl`token' token
<- token m4

#>m4>
<- token m4))


(deftest dnl-word ()
  (m4-test
#>m4>
dnltoken token
<- token m4

#>m4>
dnltoken token
<- token m4))


(deftest dnl-quoted-string-space ()
  (m4-test
#>m4>
dnl `token'
<- token m4

#>m4>
<- token m4))


(deftest dnl-no-newline ()
  (m4-test "dnl" "" :error #>m4eof>cl-m4:1:3: end of file treated as newline
m4eof))


(deftest name-comment-space ()
  (m4-test
#>m4>
token # token
<- token m4

#>m4>
token # token
<- token m4))


(deftest name-dnl-space ()
  (m4-test
#>m4>
token dnl token
<- token m4

#>m4>
token <- token m4))


(deftest name-comment-nospace ()
  (m4-test
#>m4>
token#token
<- token m4

#>m4>
token#token
<- token m4))


(deftest name-dnl-nospace ()
  (m4-test "tokendnltoken" "tokendnltoken"))


(deftest name-dnl-newline ()
  (m4-test
#>m4>
tokendnl
<- token m4

#>m4>
tokendnl
<- token m4))


(deftest quoted-string ()
  (m4-test "`token'" "token"))


(deftest comment-quoted-string ()
  (m4-test
#>m4>
# `token' 
<- token m4

#>m4>
# `token' 
<- token m4))


(deftest comment-name ()
  (m4-test
#>m4>
#token
<- token m4

#>m4>
#token
<- token m4))


(deftest comment-quoted-string-nospace ()
  (m4-test
#>m4>
#`token'
<- token m4

#>m4>
#`token'
<- token m4))


(deftest quoted-dnl ()
  (m4-test "`dnl token'" "dnl token"))


(deftest quoted-comment ()
  (m4-test "`# token'" "# token"))


(deftest double-quotes ()
  (m4-test "``token''" "`token'"))


(deftest triple-quotes ()
  (m4-test "```token'''" "``token''"))


(deftest quoted-newline ()
  (m4-test
#>m4>
`foo
bar' m4

#>m4>
foo
bar m4))


(deftest multi-quotes-newlines ()
  (m4-test
#>m4>
``token'
token
``token''' m4

#>m4>
`token'
token
``token'' m4))


(deftest cascaded-quotes ()
  (m4-test "``token1'token2`token3''" "`token1'token2`token3'"))


(deftest arglist-munchy ()
  (m4-test
#>m4>
define(`foo', `  hello?')dnl
foo
define(`bar',`  '`hello2?')dnl
bar
define(  `bop',  `  '`hello3?')dnl
bop
m4

#>m4>
  hello?
  hello2?
  hello3?
m4

:depends (list "define" "dnl")))
