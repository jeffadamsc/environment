;;; Personal Customizations
(add-to-list 'load-path "~/.emacs.d/lisp")

(mapc (lambda (mode) (when (fboundp mode) (apply mode '(-1))))
      '(tool-bar-mode
        menu-bar-mode
        scroll-bar-mode))
(require 'multi-term)
(setq multi-term-program "/bin/bash")

(defun split-vertical ()
  (interactive)
                                        ;(delete-other-windows)
  (split-window-vertically (floor (* 0.68 (window-height))))
  (other-window 1)
  (multi-term))

(defun split-horizontal ()
  (interactive)
                                        ;(delete-other-windows)
  (when window-system (set-frame-width (selected-frame) 200))
  (split-window-horizontally)
  (other-window 1))


(defun setup-window()
  (interactive)
  (when window-system (set-frame-width (selected-frame) 200))
  (split-window-horizontally)
  (split-window-vertically (floor (* 0.68 (window-height))))
  (other-window 1)
  (multi-term)
  (other-window 1)
  (split-window-vertically (floor (* 0.68 (window-height))))
  (other-window 1)
  (multi-term))
(global-set-key (kbd "C-1") 'setup-window)


(require 'redo)

(when window-system 
  (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
                       '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0)))

(defun select-line ()
  (interactive)
  (beginning-of-line)
  (set-mark-command nil)
  (move-end-of-line nil))


(set-face-attribute 'default nil :height 120)
(setq ring-bell-function #'ignore
      inhibit-startup-screen t)
(setq-default indent-tabs-mode nil
              tab-width 4)

(icomplete-mode)

;; Auto revert everything (including TAGS)
(global-auto-revert-mode)
(setq tags-revert-without-query t)

;; Smoother scrolling
(setq mouse-wheel-scroll-amount '(4 ((shift) . 4)) ; four lines at a time
      mouse-wheel-progressive-speed nil ; don't accelerate scrolling
      mouse-wheel-follow-mouse 't ; scroll window under mouse
      scroll-step 1 ; keyboard scroll one line at a time
      scroll-conservatively 10000 ; don't jump around as much
      auto-window-vscroll nil) ; magic?

;; Don't open logs with nroff
(add-to-list 'auto-mode-alist '("\\.[0-9]+\\'" . fundamental-mode))

;; Add Rethink Lisp indenting... is there a better way to do this?
(require 'rethink)
(set-rethink-lisp-indent)


;; Put backups and autosaves in separate directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Hook for C++
(add-hook 'c++-mode-hook
          (lambda ()
            (c-set-offset 'innamespace 0)))

;; Hook for Javascript
(add-hook 'js-mode-hook
          (lambda ()
            (setq js-indent-level 2)))

;;; Package Support

(add-to-list 'load-path "~/.emacs.d/lisp/use-package/")
(let ((default-directory "~/.emacs.d/lisp/plugins/"))
  (normal-top-level-add-subdirs-to-load-path))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(require 'package)
(push '("marmalade" . "http://marmalade-repo.org/packages/")
        package-archives )
(push '("melpa" . "http://melpa.milkbox.net/packages/")
        package-archives)

(require 'use-package)
(font-lock-add-keywords 'emacs-lisp-mode use-package-font-lock-keywords)
(font-lock-add-keywords 'lisp-interaction-mode use-package-font-lock-keywords)

;; Secret option to refresh packages
(let ((refresh-packages-option "--refresh-packages"))
  (when (member refresh-packages-option command-line-args)
    (delete refresh-packages-option command-line-args)
    (package-refresh-contents)))

(package-initialize)

;;; Packages

(use-package cl-lib)

(use-package custom
  :config (setq custom-file "~/.emacs.d/lisp/custom.el"))

(use-package uniquify
  :config (setq uniquify-buffer-name-style 'post-forward
                uniquify-after-kill-buffer-p t))

;(use-package whitespace
;  :init (add-hook 'prog-mode-hook 'whitespace-mode)
;  :config (setq-default whitespace-style '(face
;                                           trailing
;                                           tabs
;                                           spaces
;                                           lines-tail
;                                           newline
;                                           indentation
;                                           empty
;                                           space-mark
;                                           tab-mark
;                                           newline-mark)
;                        whitespace-line-column 100))
(when window-system
  (use-package solarized-theme
    :config (progn
              (setq solarized-emphasize-indicators nil)
              (setq x-underline-at-descent-line t)
              (load-theme 'solarized-dark t))
    :ensure t)
  (use-package ample-theme
    :disabled t
    :ensure t))


;(require 'evil)
;;(require 'evil-elscreen)
;(evil-mode 1)


;; Going to load first thing with scratch buffer
(use-package auto-indent-mode
  :init (add-hook 'prog-mode-hook 'auto-indent-mode)
  :config (setq auto-indent-blank-lines-on-move nil)
  :ensure t)

;; Going to load first thing with scratch buffer
(use-package highlight-parentheses
  ;; We want to use my fork for this, so no ensure
  :init (add-hook 'prog-mode-hook 'highlight-parentheses-mode)
  :config (setq hl-paren-highlight-adjacent t
                blink-matching-paren nil))

(use-package flycheck
  :init (progn
          (add-hook 'c-mode-hook 'flycheck-mode)
          (add-hook 'c++-mode-hook  'flycheck-mode))
  :config (add-hook 'c++-mode-hook
                    (lambda ()
                      (setq flycheck-clang-language-standard "c++11"
                            flycheck-gcc-language-standard "c++11")))
  :defer t
  :ensure t)

(use-package google-c-style
  :init (add-hook 'c-mode-common-hook 'google-set-c-style)
  :defer t
  :ensure t)

(use-package popwin
  :idle (popwin-mode)
  :idle-priority 2
  ;; Popwin appears to be missing this autoload
  :commands popwin-mode
  :ensure t)

(use-package undo-tree
  :idle (global-undo-tree-mode)
  :idle-priority 3
  :bind (("C-c j" . undo-tree-undo)
         ("C-c k" . undo-tree-redo)
         ("C-c l" . undo-tree-switch-branch)
         ("C-c ;" . undo-tree-visualize))
  :ensure t)

(use-package bash-completion
  :defer t
  :ensure t)

(use-package shell-command
  :idle (shell-command-completion-mode)
  :idle-priority 4
  :config (bash-completion-setup)
  :defer t
  :ensure t)

(use-package expand-region
  :bind ("C-c e" . er/expand-region)
  :ensure t)

(use-package markdown-mode
  :config (add-hook 'markdown-mode-hook
                    (lambda ()
                      (flyspell-mode)
                      (flyspell-buffer)
                      (auto-fill-mode)))
  :defer t
  :ensure t)

(when window-system (set-frame-width (selected-frame) 100))

(defadvice isearch-repeat (after isearch-no-fail activate)
  (unless isearch-success
    (ad-disable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)
    (isearch-repeat (if isearch-forward 'forward))
    (ad-enable-advice 'isearch-repeat 'after 'isearch-no-fail)
    (ad-activate 'isearch-repeat)))

(global-set-key (kbd "C-x 2") 'split-vertical)
(global-set-key (kbd "C-g") 'end-of-buffer)
(global-set-key (kbd "C-x g") 'beginning-of-buffer)
(global-set-key (kbd "C-x 3") 'split-horizontal)
(global-unset-key (kbd "C-r"))
(global-set-key (kbd "C-r") 'redo)
(global-set-key (kbd "C-u") 'undo)

(global-set-key (kbd "<C-up>") 'shrink-window)
(global-set-key (kbd "<C-down>") 'enlarge-window)
(global-set-key (kbd "<C-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<C-right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-v") 'select-line)

(global-unset-key (kbd "C-y"))
(global-set-key (kbd "C-p") 'yank)
(global-set-key (kbd "C-y") 'kill-ring-save)
(global-set-key (kbd "C-d") 'kill-region)
;;remap buffer-list to ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-unset-key (kbd "C-/"))
(global-set-key (kbd "C-/") 'isearch-repeat)

;; Allow C-x C-o to go to the last window
(global-set-key (kbd "C-x C-o")
                (lambda ()
                  (interactive)
                  (other-window -1)))

;; Allow C-x p and C-x C-p to switch frames
(global-set-key (kbd "C-x p")
                (lambda ()
                  (interactive)
                  (other-frame 1)
                  (select-frame-set-input-focus (selected-frame))))
(global-set-key (kbd "C-x C-p")
                (lambda ()
                  (interactive)
                  (other-frame -1)
                  (select-frame-set-input-focus (selected-frame))))
