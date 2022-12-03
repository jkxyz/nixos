;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; TODO Find a way to make this more portable
(setq custom-file "~/Code/configuration/modules/home/emacs/doom/custom.el")

(setq user-full-name "Josh Kingsley"
      user-mail-address "josh@joshkingsley.me")

(setq doom-font (font-spec :family "DejaVu Sans Mono" :size 14))

(setq doom-theme 'doom-one)

;; The doom-one theme's comments are very low-contrast by default
(setq doom-one-brighter-comments t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Tell projectile where to find projects
(setq projectile-project-search-path '("~" ("~/Code/" . 2)))

(require 'magit)

(defun jk/switch-project-action (_dir)
  "Run `magit-status' after switching to a new project."
  (if (not (magit-toplevel))
      (dired ".")
      (magit-status-setup-buffer)))

(setq +workspaces-switch-project-function #'jk/switch-project-action)

(use-package! evil-cleverparens
  :hook (clojure-mode . evil-cleverparens-mode)
  :hook (emacs-lisp-mode . evil-cleverparens-mode)
  ;; Always enable smartparens-strict-mode
  :hook (evil-cleverparens-mode . smartparens-strict-mode))

(use-package! lsp-ui
  :custom
  (lsp-ui-sideline-show-code-actions nil))

(setq cljr-suppress-middleware-warnings t)

(after! org
  (setq org-directory "~/Org/")

  (setq org-capture-templates
        '(("j" "Journal entry" entry (file+olp+datetree "Journal.org") "*** %U\n%?")
          ("i" "Inbox" entry (file "Inbox.org") "* %?\n%U")))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "PROJ(p)" "|" "DONE(d!)")
          (sequence "|" "CANCELED(c!)")))

  (setq org-log-into-drawer t))

(defun jk/smartparens-clojure-mode-init ()
  (sp-update-local-pairs '(:open "("
                           :close ")"
                           :actions (wrap insert autoskip navigate)
                           :unless (sp-in-string-p sp-point-before-same-p))))

(add-hook 'clojure-mode-hook 'jk/smartparens-clojure-mode-init)

(use-package! web-mode
  :mode "\\.njk\\'")

(defun jk/toggle-cider-completion ()
  "Toggle between lsp-mode and cider-mode completion in the current buffer."
  (interactive)
  (if (-contains-p completion-at-point-functions #'cider-complete-at-point)
      (progn
        (remove-hook 'completion-at-point-functions #'cider-complete-at-point t)
        (add-hook 'completion-at-point-functions #'lsp-completion-at-point nil t))
    (progn
      (add-hook 'completion-at-point-functions #'cider-complete-at-point nil t)
      (remove-hook 'completion-at-point-functions #'lsp-completion-at-point t))))
