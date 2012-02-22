;; emacs
(add-to-list 'load-path "~/.emacs.d/")

;;; uncomment this line to disable loading of "default.el" at startup
;; (setq inhibit-default-init t)

;; turn on font-lock mode
(when (fboundp 'global-font-lock-mode)
  (global-font-lock-mode t))

;; enable visual feedback on selections
(setq transient-mark-mode t)

;; default to better frame titles
(setq frame-title-format
      (concat  "%b - emacs@" (system-name)))

;; default to unified diffs
(setq diff-switches "-u")

;;; highlight ()
(show-paren-mode 1)

;;; display number(toggle with F4)
(require 'linum)
(global-set-key [f4] 'linum-mode)
(setq linum-format "%5d ")

;;;bind ctrl-h to BackSpace
(global-set-key "\C-h" 'delete-backward-char)

;;; dont make backup file
(setq backup-inhibited t)

;;; tab = 2 spece
(setq-default tab-width 2 indent-tabs-mode nil)

;;; indent region
(global-set-key "\M-/" 'indent-region)

;;; undo limit
;;(global-set-key "\C-\/" 'undo)
(setq undo-limit 100000)
(setq undo-strong-limit 130000)

;;; C-l to recenter
(global-set-key "\C-l" 'recenter)

;;; option key to meta
(setq mac-option-modifier 'meta)

;;; yes/no => y/n
(fset 'yes-or-no-p 'y-or-n-p)

;;; p74 change or make window with C-t
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)

;;; bind dabbrev-expand (auto complete) to C-o
(global-set-key "\C-o" 'dabbrev-expand)
(setq dabbrev-case-fold-search nil)

;; Show tab, zenkaku-space, white spaces at end of line
;; http://www.bookshelf.jp/soft/meadow_26.html#SEC317
(defface my-face-tab         '((t (:background "Yellow"))) nil :group 'my-faces)
(defface my-face-zenkaku-spc '((t (:background "LightBlue"))) nil :group 'my-faces)
(defface my-face-spc-at-eol  '((t (:foreground "Red" :underline t))) nil :group 'my-faces)
(defvar my-face-tab         'my-face-tab)
(defvar my-face-zenkaku-spc 'my-face-zenkaku-spc)
(defvar my-face-spc-at-eol  'my-face-spc-at-eol)
(defadvice font-lock-mode (before my-font-lock-mode ())
  (font-lock-add-keywords
   major-mode
   '(("\t" 0 my-face-tab append)
     ("　" 0 my-face-zenkaku-spc append)
     ("[ \t]+$" 0 my-face-spc-at-eol append)
     )))
(ad-enable-advice 'font-lock-mode 'before 'my-font-lock-mode)
(ad-activate 'font-lock-mode)
;; settings for text file
(add-hook 'text-mode-hook
          '(lambda ()
             (progn
               (font-lock-mode t)
               (font-lock-fontify-buffer))))

;; js2-mode
;; wget https://raw.github.com/mooz/js2-mode/master/js2-mode.el
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(setq js2-basic-offset 2)

;; magit
(require 'magit)

(eval-after-load 'magit
  '(progn
     (set-face-background 'magit-item-highlight "#ffd700")
     (set-face-foreground 'magit-diff-add "#40ff40")
     (set-face-foreground 'magit-diff-del "#ff4040")
     (set-face-foreground 'magit-diff-file-header "#4040ff")))

;; auto-save-buffers
;; wget 0xcc.net/misc/auto-save/auto-save-buffers.el
(require 'auto-save-buffers)
(run-with-idle-timer 1.0 t 'auto-save-buffers)

;;; unicode and language settings
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(setq file-name-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
