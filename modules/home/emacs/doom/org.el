;;; $DOOMDIR/org.el -*- lexical-binding: t; -*-

(setq org-directory "~/Notes/")

(setq org-default-notes-file (concat org-directory "Inbox.org"))

(setq org-log-done 'time)

(require 'org-mobile)

(setq org-mobile-directory "~/OrgMobile/")
(setq org-mobile-inbox-for-pull (concat org-directory "Inbox (Mobile).org"))

(use-package! org-roam
  :custom
  (org-roam-directory (concat org-directory "Roam/"))
  (org-roam-dailies-directory "Journal/"))

(add-to-list 'org-agenda-files org-roam-directory)

(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d!)")))

(setq org-capture-templates
      '(("t" "todo" plain (file org-default-notes-file)
         "* TODO %?\n%U\n" :clock-in t :clock-resume t)))

(setq org-agenda-custom-commands
      '(("r" "To refile"
         ((tags
           "REFILE"
           ((org-agenda-overriding-header "To refile")
            (org-tags-match-list-sublevels nil)))))))

(require 'vulpea)

(defun jk/org-agenda-buffer-category ()
  "Get category of item at point for agenda."
  (let* ((file-name (when buffer-file-name
                      (file-name-sans-extension
                       (file-name-nondirectory buffer-file-name))))
         (title (vulpea-buffer-prop-get "title"))
         (category (org-get-category)))
    (or (if (and title (string-equal category file-name))
            title
          category)
        "")))

(setq org-agenda-prefix-format
      '((agenda . " %i %-12(jk/org-agenda-buffer-category)%?-12t% s ")
        (todo . " %i %-12(jk/org-agenda-buffer-category) ")
        (tags  . " %i %-12(jk/org-agenda-buffer-category) ")
        (search . " %i %-12(jk/org-agenda-buffer-category) ")))

(require 'org-roam-dailies)

(add-to-list 'org-refile-targets `(,(concat org-roam-directory org-roam-dailies-directory) :maxlevel . 3))
