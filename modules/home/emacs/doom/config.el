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
(setq projectile-project-search-path '("~" "~/Code/" "~/Code/Nosco/"))

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

(use-package! org
  :config
  (setq org-directory "~/Org/")
  ;; (setq org-agenda-files (list org-directory))

  (setq org-archive-location (concat org-directory "archive.org::* %s"))

  (setq org-capture-templates
        '(("t" "todo" plain (file "inbox.org") "* TODO %?\n%U\n")))

  (setq org-link-file-path-type 'relative)

  (setq org-file-apps
        '((auto-mode . emacs)
          (directory . emacs)
          ("\\.pdf" . "evince \"%s\""))))

(use-package! org-roam
  :config
  (setq org-roam-directory (concat org-directory "roam/")))

(defun jk/smartparens-clojure-mode-init ()
  (sp-update-local-pairs '(:open "("
                           :close ")"
                           :actions (wrap insert autoskip navigate)
                           :unless (sp-in-string-p sp-point-before-same-p))))

(add-hook 'clojure-mode-hook 'jk/smartparens-clojure-mode-init)

;; TODO Open PR for doom
(use-package! web-mode
  :mode "\\.njk\\'")
