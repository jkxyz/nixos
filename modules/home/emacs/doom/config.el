;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Josh Kingsley"
      user-mail-address "josh@joshkingsley.me")

(setq doom-theme 'doom-one)

;; The doom-one theme's comments are very low-contrast by default
(setq doom-one-brighter-comments t)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Tell projectile where to find projects
(setq projectile-project-search-path '("~/Code/" "~/Code/nosco/"))

(defun jk/switch-project-action (dir)
  "Run `magit-status' after switching to a new project."
  (magit-status))

(setq +workspaces-switch-project-function #'jk/switch-project-action)

(use-package! evil-cleverparens
  :hook (clojure-mode . evil-cleverparens-mode)
  :hook (emacs-lisp-mode . evil-cleverparens-mode))

(load-file (concat (file-name-directory load-file-name) "/org.el"))

(setq rmh-elfeed-org-files (list (concat org-directory "Feeds.org")))
