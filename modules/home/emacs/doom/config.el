;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq custom-file "~/.emacs-custom.el")
(load custom-file 'noerror)

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

(setq cljr-suppress-middleware-warnings t)

(after! org
  (setq org-directory "~/Org/")

  (setq org-agenda-files (list org-directory))

  (setq org-capture-templates
        '(("j" "Journal entry" entry (file+olp+datetree "Journal.org") "*** %U\n%?")
          ("i" "Inbox" entry (file "Inbox.org") "* %?\n%U")))

  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAIT(w)" "PROJ(p)" "|" "DONE(d!)")
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

(after! clojure-mode
  (add-hook! '(clojure-mode-local-vars-hook
               clojurec-mode-local-vars-hook
               clojurescript-mode-local-vars-hook)
             :append
             (defun jk/configure-lsp-clojure ()
               (setq-local lsp-enable-indentation nil
                           lsp-completion-enable nil))
             #'lsp!))

;; (require 'journalctl-mode)
;; (add-to-list 'journalctl-list-of-options "user-unit")

(use-package! lsp-tailwindcss
  :init
  (setq lsp-tailwindcss-add-on-mode t)
  (add-hook 'before-save-hook 'lsp-tailwindcss-rustywind-before-save))
