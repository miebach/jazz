;;;==============
;;;  JazzScheme
;;;==============
;;;
;;;; Platform Product
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


(unit jazz.platform.product


;;;
;;;; Build
;;;


(define (jazz:parse-dot-version version)
  (let ((version (map string->number (jazz:split-string version #\.))))
    (let ((major (%%car version))
          (minor (%%cadr version))
          (build (caddr version)))
      (values major minor build))))


(define jazz:types-units
  '((jazz.platform.types-syntax)
    (jazz.platform.types)))


(define cairo-windows-include (jazz:quote-jazz-pathname "foreign/cairo/include"))
(define cairo-windows-lib (jazz:quote-jazz-pathname "foreign/cairo/lib/windows"))

(cond-expand
  (carbon
    (define jazz:cairo-units
      (receive (major minor build) (jazz:parse-dot-version (jazz:pkg-config-version "cairo-ft"))
        (if (%%fx< minor 4)
            (jazz:error "Cairo 1.4 or higher needed")
          (let ((cc-flags (jazz:pkg-config-cflags "cairo-ft"))
                (ld-flags (jazz:pkg-config-libs "cairo-ft")))
            `((jazz.platform.cairo                cc-options: ,cc-flags ld-options: ,ld-flags)
              (jazz.platform.cairo.cairo-base     cc-options: ,cc-flags ld-options: ,ld-flags)
              (jazz.platform.cairo.cairo-carbon   cc-options: ,cc-flags ld-options: ,ld-flags)))))))
  (windows
    (define jazz:cairo-units
        `((jazz.platform.cairo            cc-options: ,(string-append "-I" cairo-windows-include) ld-options: ,(string-append "-L" cairo-windows-lib " -llibcairo-2"))
          (jazz.platform.cairo.cairo-base cc-options: ,(string-append "-I" cairo-windows-include) ld-options: ,(string-append "-L" cairo-windows-lib " -llibcairo-2")))))
  (x11
    (define jazz:cairo-units
      (receive (major minor build) (jazz:parse-dot-version (jazz:pkg-config-version "cairo-ft"))
        (if (%%fx< minor 4)
            (jazz:error "Cairo 1.4 or higher needed")
          (let ((cc-flags (jazz:pkg-config-cflags "cairo-ft"))
                (ld-flags (jazz:pkg-config-libs "cairo-ft")))
            `((jazz.platform.cairo                cc-options: ,cc-flags ld-options: ,ld-flags)
              (jazz.platform.cairo.cairo-base     cc-options: ,cc-flags ld-options: ,ld-flags)
              (jazz.platform.cairo.cairo-x11      cc-options: ,cc-flags ld-options: ,ld-flags)
              (jazz.platform.cairo.cairo-freetype cc-options: ,cc-flags ld-options: ,ld-flags))))))))


(define (jazz:freetype-units)
  (let ((cc-flags (jazz:pkg-config-cflags "freetype2"))
        (ld-flags (string-append (jazz:pkg-config-libs "fontconfig") (jazz:pkg-config-libs "freetype2"))))
    `((jazz.platform.freetype cc-options: ,cc-flags ld-options: ,ld-flags))))


(cond-expand
 (windows
  (define jazz:pango-units
      (let ((pango-include-path (jazz:quote-jazz-pathname "foreign/pango/include"))
            (glib-include-path  (jazz:quote-jazz-pathname "foreign/glib/include"))
            (pango-lib-path     (jazz:quote-jazz-pathname "foreign/pango/lib/windows"))
            (glib-lib-path      (jazz:quote-jazz-pathname "foreign/glib/lib/windows")))
        `((jazz.platform.pango cc-options: ,(string-append "-I" pango-include-path " -I" glib-include-path " -I" cairo-windows-include) ld-options: ,(string-append "-L" pango-lib-path " -L" glib-lib-path " -llibglib-2.0-0 -llibgobject-2.0-0 -llibpango-1.0-0 -llibpangocairo-1.0-0"))))))

 ((or carbon x11)
   (define jazz:pango-units
     (let ((cc-flags (string-append (jazz:pkg-config-cflags "pango") " " (jazz:pkg-config-cflags "pangocairo")))
           (ld-flags (string-append (jazz:pkg-config-libs "pango") " " (jazz:pkg-config-libs "pangocairo"))))
       `((jazz.platform.pango cc-options: ,cc-flags ld-options: ,ld-flags))))))


(define jazz:windows-units
  (let ((cairo-include-path   (jazz:quote-jazz-pathname "foreign/cairo/include"))
        (cairo-lib-path       (jazz:quote-jazz-pathname "foreign/cairo/lib/windows"))
        (windows-include-path (jazz:quote-jazz-pathname "foreign/windows/include"))
        (windows-lib-path     (jazz:quote-jazz-pathname "foreign/windows/lib"))
        (base-windows-cc-options "-DUNICODE -D_WIN32_WINNT=0x0502"))
    `((jazz.platform.windows)
      (jazz.platform.windows.WinDef      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinTypes    cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinBase     cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinNT       cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinKernel   cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinGDI      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinIDL      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinMM       cc-options: ,base-windows-cc-options ld-options: "-mwindows -lwinmm")
      (jazz.platform.windows.WinUser     cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinShell    cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinCtrl     cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinDlg      cc-options: ,base-windows-cc-options ld-options: "-mwindows")
      (jazz.platform.windows.WinPerf     cc-options: ,(string-append "-I" windows-include-path " " base-windows-cc-options) ld-options: ,(string-append "-L" windows-lib-path " -mwindows -lpdh"))
      (jazz.platform.windows.WinPSAPI    cc-options: ,(string-append "-I" windows-include-path " " base-windows-cc-options) ld-options: ,(string-append "-L" windows-lib-path " -mwindows -lpsapi"))
      (jazz.platform.cairo.cairo-windows cc-options: ,(string-append "-I" cairo-include-path) ld-options: ,(string-append "-L" cairo-lib-path " -lcairo"))
      (jazz.platform.crash.windows       cc-options: ,base-windows-cc-options ld-options: "-mwindows"))))


(define jazz:com-units
  '((jazz.platform.windows.com cc-options: "-DUNICODE -D___SINGLE_HOST" ld-options: "-mwindows -lole32 -loleaut32")))


(define jazz:x11-units
  '((jazz.platform.x11 cc-options: "-I/usr/X11R6/include" ld-options: "-L/usr/X11R6/lib -lX11")
    (jazz.platform.x11.x11-types)))


(cond-expand
  (mac
   (define jazz:clipboard-units
     '((jazz.platform.carbon.carbon-types ld-options: "-framework Carbon")
       (jazz.platform.carbon.clipboard ld-options: "-framework Carbon"))))
  (else
   (define jazz:clipboard-units
     '())))


(cond-expand
  (mac
   (define jazz:crash-units
     '((jazz.platform.crash.mac))))
  (unix
   (define jazz:crash-units
     '((jazz.platform.crash.unix))))
  (windows
   (define jazz:crash-units
     '())))


(cond-expand
  (carbon
    (define (jazz:build-platform descriptor #!key (unit #f) (force? #f))
      (let ((unit-specs `((jazz.platform)
                          (jazz.platform.crash)
                          ,@jazz:crash-units
                          ,@jazz:types-units
                          ,@jazz:cairo-units
                          ,@jazz:pango-units
                          ,@jazz:carbon-units
                          ,@jazz:clipboard-units)))
        (jazz:custom-compile/build unit-specs unit: unit force?: force?)
        (jazz:build-product-descriptor descriptor))))
  (windows
    (define (jazz:build-platform descriptor #!key (unit #f) (force? #f))
      (let ((build (%%repository-directory jazz:Build-Repository))
            (source jazz:kernel-source))
        (define (build-file path)
          (string-append build path))
        
        (define (source-file path)
          (string-append source path))
        
        (define (copy-platform-files)
          (jazz:copy-file (source-file "foreign/cairo/lib/windows/libcairo-2.dll") (build-file "libcairo-2.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/cairo/lib/windows/libfontconfig-1.dll") (build-file "libfontconfig-1.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/cairo/lib/windows/freetype6.dll") (build-file "freetype6.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/cairo/lib/windows/libexpat-1.dll") (build-file "libexpat-1.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/png/lib/windows/libpng14-14.dll") (build-file "libpng14-14.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/zlib/lib/windows/zlib1.dll") (build-file "zlib1.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/glib/lib/windows/libglib-2.0-0.dll") (build-file "libglib-2.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/glib/lib/windows/libgobject-2.0-0.dll") (build-file "libgobject-2.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/glib/lib/windows/libgmodule-2.0-0.dll") (build-file "libgmodule-2.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/glib/lib/windows/libgthread-2.0-0.dll") (build-file "libgthread-2.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/pango/lib/windows/libpango-1.0-0.dll") (build-file "libpango-1.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/pango/lib/windows/libpangowin32-1.0-0.dll") (build-file "libpangowin32-1.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/pango/lib/windows/libpangoft2-1.0-0.dll") (build-file "libpangoft2-1.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/pango/lib/windows/libfontconfig-1.dll") (build-file "libfontconfig-1.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/pango/lib/windows/libexpat-1.dll") (build-file "libexpat-1.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/pango/lib/windows/freetype6.dll") (build-file "freetype6.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/pango/lib/windows/libpangocairo-1.0-0.dll") (build-file "libpangocairo-1.0-0.dll") feedback: jazz:feedback)
          (jazz:copy-file (source-file "foreign/png/lib/windows/libpng14-14.dll") (build-file "libpng14-14.dll") feedback: jazz:feedback))
        
        (let ((unit-specs `((jazz.platform)
                            (jazz.platform.crash)
                            ,@jazz:crash-units
                            ,@jazz:types-units
                            ,@jazz:cairo-units
                            ,@jazz:pango-units
                            ,@jazz:windows-units
                            ,@jazz:com-units)))
          (jazz:custom-compile/build unit-specs unit: unit pre-build: copy-platform-files force?: force?)
          (jazz:build-product-descriptor descriptor)))))
  (x11
    (define (jazz:build-platform descriptor #!key (unit #f) (force? #f))
      (let ((unit-specs `((jazz.platform)
                          (jazz.platform.crash)
                          ,@jazz:crash-units
                          ,@jazz:types-units
                          ,@jazz:cairo-units
                          ,@jazz:pango-units
                          ,@jazz:x11-units
                          ,@jazz:clipboard-units)))
        (jazz:custom-compile/build unit-specs unit: unit force?: force?)
        (jazz:build-product-descriptor descriptor)))))


;;;
;;;; Register
;;;


(jazz:register-product 'jazz.platform
  build: jazz:build-platform))
