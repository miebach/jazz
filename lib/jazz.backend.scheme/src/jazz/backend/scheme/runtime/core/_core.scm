;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Jazz Core
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


(module protected jazz.backend.scheme.runtime.core scheme


(require (jazz.backend.scheme.runtime.core.base64)
         (jazz.backend.scheme.runtime.core.continuation)
         (jazz.backend.scheme.runtime.core.debug)
         (jazz.backend.scheme.runtime.core.development)
         (jazz.backend.scheme.runtime.core.exception)
         (jazz.backend.scheme.runtime.core.foreign)
         (jazz.backend.scheme.runtime.core.memory)
         (jazz.backend.scheme.runtime.core.network)
         (jazz.backend.scheme.runtime.core.number)
         (jazz.backend.scheme.runtime.core.pathname)
         (jazz.backend.scheme.runtime.core.port)
         (jazz.backend.scheme.runtime.core.reader)
         (jazz.backend.scheme.runtime.core.repository)
         (jazz.backend.scheme.runtime.core.stack)
         (jazz.backend.scheme.runtime.core.step)
         (jazz.backend.scheme.runtime.core.structure)
         (jazz.backend.scheme.runtime.core.system)
         (jazz.backend.scheme.runtime.core.table)
         (jazz.backend.scheme.runtime.core.thread)
         (jazz.backend.scheme.runtime.core.time)
         (jazz.backend.scheme.runtime.core.vector)))
