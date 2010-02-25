;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Module Runtime
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
;;;  Portions created by the Initial Developer are Copyright (C) 1996-2008
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


(unit protected core.module.runtime


(require (core.module.runtime.autoload))


;;;
;;;; Module
;;;


(jazz.define-class jazz.Module jazz.Object () jazz.Object-Class jazz.allocate-module
  ((name    %%get-module-name    ())
   (access  %%get-module-access  ())
   (exports %%get-module-exports ())))


(jazz.define-class-runtime jazz.Module)


(define (jazz.new-module name access)
  (jazz.allocate-module jazz.Module name access (%%make-table test: eq?)))


(jazz.encapsulate-class jazz.Module)


;;;
;;;; Modules
;;;


(define jazz.Modules
  (%%make-table test: eq?))


(define (jazz.register-module name access exported-modules exported-symbols)
  (let ((module (jazz.new-module name access)))
    (let ((exports (%%get-module-exports module)))
      (for-each (lambda (module-name)
                  (%%iterate-table (%%get-module-exports (jazz.get-module module-name))
                    (lambda (name info)
                      (%%table-set! exports name info))))
                exported-modules)
      (for-each (lambda (pair)
                  (let ((name (%%car pair))
                        (info (%%cdr pair)))
                    (%%table-set! exports name info)))
                exported-symbols)
      (%%table-set! jazz.Modules name module)
      module)))


(define (jazz.get-module name)
  (jazz.load-unit name)
  (%%table-ref jazz.Modules name #f))


(define (jazz.require-module name)
  (or (jazz.get-module name)
      (jazz.error "Unknown public module: {s}" name)))


(define (jazz.module-get module-name name #!key (not-found #f))
  (let ((module (jazz.require-module module-name)))
    (let ((info (%%table-ref (%%get-module-exports module) name #f)))
      (if info
          (if (%%symbol? info)
              (jazz.global-value info)
            (jazz.bind (unit-name . locator) info
              (jazz.load-unit unit-name)
              (jazz.global-value locator)))
        not-found))))


(define jazz.module-ref
  (let ((not-found (box #f)))
    (lambda (module-name name)
      (let ((obj (jazz.module-get module-name name not-found: not-found)))
        (if (%%eq? obj not-found)
            (jazz.error "Unable to find '{s} in: {s}" name module-name)
          obj)))))


;;;
;;;; Error
;;;


(define (jazz.type-error value type)
  (jazz.error "{s} expected: {s}" type value))


(define (jazz.dispatch-error field value category)
  (jazz.error "Inconsistent dispatch on method {a}: {s} is not of the expected {s} type" (%%get-field-name field) value (%%get-category-identifier category))))
