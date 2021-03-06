;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Errors
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


(unit protected core.exception.runtime.error


(jazz:define-class jazz:Error jazz:Exception (constructor: jazz:allocate-error)
  ((message getter: generate)))


(define (jazz:new-error message)
  (jazz:allocate-error message))


(jazz:define-method (jazz:exception-message (jazz:Error error))
  (jazz:get-error-message error))


(jazz:define-method (jazz:present-exception (jazz:Error error))
  (jazz:get-error-message error))


(define (jazz:raise-jazz-error fmt-string . rest)
  (declare (proper-tail-calls))
  (let ((message (apply jazz:format fmt-string rest)))
    (raise (jazz:new-error message))))


(set! jazz:error jazz:raise-jazz-error))
