;;;; cl-m4 - m4.lisp
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

(in-suite all)
(defsuite m4)
(in-suite m4)

(set-dispatch-macro-character #\# #\> #'cl-heredoc:read-heredoc)

(deftest test-m4-macro-exists (macro)
  (with-m4-lib
    (is (functionp (m4-macro macro)))))

(defmacro with-m4-error (message &body body)
  (let ((error (gensym)))
    `(let ((,error (make-array 0 :element-type 'character :adjustable t :fill-pointer 0)))
       (progn
         (with-output-to-string (*error-output* ,error)
           ,@body)
         (is (equal ,message ,error))))))
  
(defmacro defm4test (name macro (&rest args) &key (result "") signal (error ""))
  `(deftest ,name ()
     (test-m4-macro-exists ,macro)
     (with-m4-lib
      (with-m4-error ,error
         ,(if signal
              `(signals ,signal (funcall (m4-macro ,macro) ,macro t ,@args))
            `(is (equal ,result (funcall (m4-macro ,macro) ,macro t ,@args))))))))

(deftest m4-test (m4 result &key (error "") include-path depends)
  (mapc #'test-m4-macro-exists depends)
  (let ((out (make-array 0 :element-type 'character :adjustable t :fill-pointer 0)))
    (with-input-from-string (input-stream m4)
      (with-output-to-string (output-stream out)
        (with-m4-error error
          (cl-m4:process-m4 input-stream output-stream :include-path include-path)
          (is (equal result out)))))))

(defun relative-pathname (pathname)
  (merge-pathnames pathname
                   (asdf:system-relative-pathname 'cl-m4 "test/")))
