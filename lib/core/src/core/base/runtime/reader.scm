;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Reader
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


(unit protected core.base.runtime.reader


(define (jazz:read-source-all port #!optional (container #f) (line #f) (col #f))
  (if container
      (%%input-port-names-set! port (lambda (port) container)))
  (if line
      (%%input-port-line-set! port (%%fx+ line 1)))
  (if col
      (%%input-port-column-set! port (%%fx+ col 1)))
  
  (let ((begin-vector
          (%%read-all-as-a-begin-expr-from-port
            port
            (%%current-readtable)
            ##wrap-datum
            ##unwrap-datum
            (jazz:readtable-start-syntax (%%current-readtable))
            #f)))
    (%%cdr (%%source-code (%%vector-ref begin-vector 1)))))


(define (jazz:read-source-first port #!optional (container #f) (line #f) (col #f))
  (%%car (jazz:read-source-all port container line col))))
