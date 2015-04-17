;; don't show startup screen
(setq inhibit-startup-screen t)

;; enable column-number display in status bar
(setq column-number-mode t)

;; define hotkeys for macros
(global-set-key (kbd "<f5>")  'compile)
(global-set-key (kbd "<f9>")  'goto-line)
(global-set-key (kbd "<f10>") 'start-kbd-macro)
(global-set-key (kbd "<f11>") 'end-kbd-macro)
(global-set-key (kbd "<f12>") 'call-last-kbd-macro)

;; function decides whether .h file is C or C++ header, sets C++ by
;; default because there's more chance of there being a .h without a
;; .cc than a .h without a .c (ie. for C++ template files)
(defun c-c++-header ()
  "sets either c-mode or c++-mode, whichever is appropriate for
header"
  (interactive)
  (let ((c-file (concat (substring (buffer-file-name) 0 -1) "c")))
    (if (file-exists-p c-file)
        (c-mode)
      (c++-mode))))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c-c++-header))

;; Activate Python highlighting for .pyx files
(add-to-list 'auto-mode-alist '("\\.pyx\\'" . python-mode))

;; turn on fortran mode for .F90
(add-to-list 'auto-mode-alist '("\\.F90\\'" . f90-mode))

;; set tab-width to 4
(setq default-tab-width 4)

;; set default fill column to 80
(setq-default fill-column 80)

;; Always use spaces, not TABs
(setq-default indent-tabs-mode nil)

;; Always truncate long line
(setq-default truncate-lines t)
(setq truncate-partial-width-windows nil) ;; for vertically-split windows

;; hide toolbar
(tool-bar-mode -1)

;; set visible bell instead of audible
(setq visible-bell t)

;; autocomplete in nXML mode
(setq nxml-slash-auto-complete-flag t)

;; load OpenMC RELAX NG schema locating file by default
(require 'rng-loc)
(add-to-list 'rng-schema-locating-files "~/openmc/schemas.xml")

;; Set indentation in Fortran mode
(setq f90-mode-hook
      '(lambda () (setq f90-do-indent 2
                        f90-if-indent 2
                        f90-type-indent 2
                        f90-program-indent 2
                        f90-associate-indent 2)))

;; delete trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; julia mode
(add-to-list 'load-path "~/.elisp")
(require 'julia-mode)
