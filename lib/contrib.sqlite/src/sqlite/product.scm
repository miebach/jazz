;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; SQLite Product
;;;
;;;  The contents of this file are subject to the Mozilla Public License Version
;;;  1.1 (the "License"); you may not use this file except in compliance with
;;;  the License. You may obtain a copy of the License at
;;;  http://www.mozilla.org/MPL/
;;;
;;;  Software distributed under the License is distributed on an "AS IS" basis,
;;;  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
;;;  for the specific language governing rights and limitations under the
;;;  License.
;;;
;;;  The Original Code is JazzScheme.
;;;
;;;  The Initial Developer of the Original Code is Guillaume Cartier.
;;;  Portions created by the Initial Developer are Copyright (C) 1996-2012
;;;  the Initial Developer. All Rights Reserved.
;;;
;;;  Contributor(s):
;;;
;;;  Alternatively, the contents of this file may be used under the terms of
;;;  the GNU General Public License Version 2 or later (the "GPL"), in which
;;;  case the provisions of the GPL are applicable instead of those above. If
;;;  you wish to allow use of your version of this file only under the terms of
;;;  the GPL, and not to allow others to use your version of this file under the
;;;  terms of the MPL, indicate your decision by deleting the provisions above
;;;  and replace them with the notice and other provisions required by the GPL.
;;;  If you do not delete the provisions above, a recipient may use your version
;;;  of this file under the terms of any one of the MPL or the GPL.
;;;
;;;  See www.jazzscheme.org for details.


(unit sqlite.product


;;;
;;;; Build
;;;


(cond-expand
  (windows
    (define jazz:sqlite-units
      (let ((sqlite-include-path  (jazz:quote-jazz-pathname "foreign/sqlite3/include"))
            (sqlite-lib-path      (jazz:quote-jazz-pathname "foreign/sqlite3/lib/windows")))
        `((sqlite.implementation.resqlite3 cc-options: ,(string-append "-I" sqlite-include-path) 
		                                   ld-options: ,(string-append "-L" sqlite-lib-path " -lsqlite3"))))))
  (else
   (define jazz:sqlite-units
     '())))


(define (jazz:build-sqlite descriptor #!key (unit #f) (force? #f))
  (let ((build (%%get-repository-directory jazz:Build-Repository))
        (source jazz:kernel-source))
    (define (build-file path)
      (string-append build path))
    
    (define (source-file path)
      (string-append source path))
    
    (define (copy-platform-files)
      (jazz:copy-file (source-file "foreign/sqlite3/lib/windows/sqlite3.dll") (build-file "sqlite3.dll") feedback: jazz:feedback))
    
    (let ((unit-specs jazz:sqlite-units))
      (jazz:custom-compile/build unit-specs unit: unit pre-build: copy-platform-files force?: force?)
      (if (or (not unit) (not (assq unit unit-specs)))
          (jazz:build-product-descriptor descriptor unit: unit force?: force?)))))


;;;
;;;; Register
;;;


(jazz:register-product 'contrib.sqlite
  build: jazz:build-sqlite))
