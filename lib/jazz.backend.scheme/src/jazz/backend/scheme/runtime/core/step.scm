;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Step
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


(unit protected jazz.backend.scheme.runtime.core.step


(declare (proper-tail-calls))


(define (install-step-handler proc)
  (define (handler leapable? $code rte execute-body . other)
    (##step-off)
    (process-step
      proc
      $code
      (lambda ()
        (##apply execute-body (##cons $code (##cons rte other))))))
  
  (let ((cs (##current-stepper)))
    (vector-set! cs 0 (vector handler handler handler handler handler handler handler))
    (void)))


(define (process-step proc $code execute)
  (proc
    (##code-locat $code)
    (lambda (cmd)
      (case cmd
        ((step)
         (##step-on)
         (execute))
        ((leap) ;; does this really work????
         (let ((result (execute)))
           (##step-on)
           result))
        ((continue)
         (execute)))))))
