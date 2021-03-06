;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Numbers
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


(unit protected jazz.backend.scheme.runtime.core.number


;;;
;;;; Fixnum
;;;


;; not very efficient but have to test for now

(define (jazz:fixnum->flonum n)
  (if (%%fixnum? n)
      (##fixnum->flonum n)
    (jazz:type-error n jazz:Fixnum)))

(define (jazz:flonum->fixnum n)
  (if (%%flonum? n)
      (##flonum->fixnum n)
    (jazz:type-error n jazz:Flonum)))


(define (jazz:arithmetic-shift-left x y)
  (arithmetic-shift x y))

(define (jazz:arithmetic-shift-right x y)
  (arithmetic-shift x (- y)))


;;;
;;;; Flownum
;;;


(define jazz:sharp/sharp/fl+ ##fl+)
(define jazz:sharp/sharp/fl- ##fl-)
(define jazz:sharp/sharp/fl* ##fl*)
(define jazz:sharp/sharp/fl/ ##fl/)


;;;
;;;; Infinity
;;;


(define jazz:+infinity
  +inf.0)

(define jazz:-infinity
  -inf.0)


;;;
;;;; Random
;;;


(cond-expand
  (gambit
    (define jazz:random-integer random-integer)
    (define jazz:random-real random-real)
    (define jazz:random-source-randomize! random-source-randomize!)
    (define jazz:random-source-pseudo-randomize! random-source-pseudo-randomize!)
    (define jazz:default-random-source default-random-source))
  
  (else)))
