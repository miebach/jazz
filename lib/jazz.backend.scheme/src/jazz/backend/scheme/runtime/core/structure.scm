;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Structures
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


(unit protected jazz.backend.scheme.runtime.core.structure


(define (jazz:kind? obj)
  (##type? obj))

(define (jazz:kind-id type)
  (##type-id type))

(define (jazz:kind-name type)
  (##type-name type))

(define (jazz:kind-flags type)
  (##type-flags type))

(define (jazz:kind-super type)
  (##type-super type))

(define (jazz:kind-length type)
  (##type-field-count type))

(define (jazz:kind-fields type)
  (let loop ((index 1)
             (fields (##type-all-fields type))
             (alist '()))
       (if (%%pair? fields)
           (let* ((name (%%car fields))
                  (rest (%%cdr fields))
                  (options (%%car rest))
                  (rest (%%cdr rest))
                  (val (%%car rest))
                  (rest (%%cdr rest)))
             (loop (%%fx+ index 1)
                   rest
                   (%%cons (%%list name index options val)
                           alist)))
         (jazz:reverse! alist))))


(define (jazz:structure? obj)
  (##structure? obj))

(define (jazz:structure-kind obj)
  (##structure-type obj))

(define (jazz:structure-ref obj i type)
  (##structure-ref obj i type #f))

(define (jazz:structure-set! obj val i type)
  (##structure-set! obj val i type #f)))
