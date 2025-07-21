;;; -*- lexical-binding: t -*-

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(use-package auto-package-update
  :ensure t
  :custom
  (auto-package-update-interval 7)
  (auto-package-update-delete-old-versions t)
  (auto-package-update-hide-results t)
  (auto-package-update-prompt-before-update t)
  :config
  (auto-package-update-maybe))

(use-package general
  :ensure t
  :demand t
  :config
  ;; Set up '\' as the global leader key
  (general-create-definer tl/leader
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix ","
    :global-prefix "M-,")

  ;; Config
  (tl/leader
    "f c" '(:ignore t :wk "config")
    "f c c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "config.org")
    "f c i" '((lambda () (interactive) (find-file "~/.config/emacs/init.el")) :wk "init.el")
    "f c e" '((lambda () (interactive) (find-file "~/.config/emacs/early-init.el")) :wk "early-init.el")
    "f c r" '((lambda ()
                (interactive)
                (load-file "~/.config/emacs/init.el"))
              :wk "reload config"))

  ;; Files
  (tl/leader
    "f" '(:ignore t :wk "files")
    "f f" '(find-file :wk "find file")
    "f u" '(sudo-edit-find-file :wk "find file as root")
    "f U" '(sudo-edit :wk "edit file as root"))

  ;; Org mode
  (tl/leader
    "o" '(:ignore t :wk "org")
    "o a" '(:ignore t :wk "attachments")
    "o a a" '(org-attach-attach :wk "attach")
    "o a o" '(org-attach-open :wk "open")
    "o a O" '(org-attach-open-in-emacs :wk "open here")
    "o t" '(org-todo :wk "todo")
    "o b" '(:ignore t :wk "board")
    "o b a" '(tl/org-board-archive-heading-url :wk "archive")
    "o b o" '(org-board-open :wk "open")
    "o l" '(org-insert-link :wk "link")
    "o s" '(org-schedule :wk "schedule")
    "o d" '(org-deadline :wk "deadline")
    "o h" '(tl/org-make-habit :wk "habit")
    "o r" '(tl/refile-from-inbox :wk "refile")
    "o c" '(org-capture :wk "capture")
    "o r" '((lambda () (interactive) (org-update-statistics-cookies t) (org-agenda-redo-all)) :wk "refresh"))

  ;; Denote
  (tl/leader
    "d" '(:ignore t :wk "denote")
    "d s" '(:ignore t :wk "search")
    "d s s" '(denote-dired :wk "search all")
    "d s a" '((lambda () (interactive) (denote-dired "_area" "title" nil nil)) :wk "areas")
    "d s p" '((lambda () (interactive) (denote-dired "_project" "title" nil nil)) :wk "projects")
    "d s b" '((lambda () (interactive) (denote-dired "_book" "title" nil nil)) :wk "books")
    "d s c" '((lambda () (interactive) (denote-dired "_course" "title" nil nil)) :wk "courses")
    "d s n" '((lambda () (interactive) (denote-dired "_channel" "title" nil nil)) :wk "channels")
    "d n" '(denote :wk "new denote")
    "d l" '(denote-link :wk "link")
    "d L" '(denote-add-links :wk "add links")
    "d h" '(denote-org-link-to-heading :wk "link to heading")
    "d b" '(denote-backlinks :wk "backlinks")
    "d r" '(denote-rename-file :wk "rename")
    "d R" '(denote-rename-file-using-front-matter :wk "rename with tags")
    "d i" '((lambda () (interactive) (find-file (expand-file-name "inbox.org" tl/org-path))) :wk "inbox")
    "d j" '(:ignore t :wk "journal")
    "d j n" '(denote-journal-new-entry :wk "new")
    "d j j" '(denote-journal-new-or-existing-entry :wk "new or existing")
    "d j l" '(denote-journal-link-or-create-entry :wk "link or create"))

  ;; Toggles
  (tl/leader
    "t" '(:ignore t :wk "toggle")
    "t l" '(display-line-numbers-mode :wk "line numbers")
    "t r" '(visual-line-mode :wk "truncated lines")
    "t t" '(org-tidy-toggle :wk "org property drawers")))

(setq user-full-name "Teia Lesuten")
(setq user-mail-address "teia.leusten@proton.me")

(defvar tl/org-path "~/Drive/"
  "Directory for org notes.")
(defvar tl/org-areas-path (file-name-concat tl/org-path "areas/")
  "Subdirectory for area notes.")
(defvar tl/org-journal-path (file-name-concat tl/org-path "journal/")
  "Subdirectory for my journal.")
(defvar tl/org-projects-path (file-name-concat tl/org-path "projects/")
  "Subdirectory for project notes.")
(defvar tl/org-resources-path (file-name-concat tl/org-path "resources/")
  "Subdirectory for resouces.")
(defvar tl/org-attachments-path (file-name-concat tl/org-path "attachments/")
  "Subdirectory for attachments.")

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode-hook . rainbow-delimiters-mode))

(use-package vertico
  :ensure t
  :custom
  (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  (vertico-cycle t)  ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode)
  :bind
  (:map vertico-map
      ("C-j" . vertico-next)
      ("C-k" . vertico-previous)))

;; Emacs minibuffer configurations.
(use-package emacs
  :custom
  ;; Support opening new minibuffers from inside existing minibuffers.
  (enable-recursive-minibuffers t)
  ;; Hide commands in M-x which do not work in the current mode.  Vertico
  ;; commands are hidden in normal buffers. This setting is useful beyond
  ;; Vertico.
  (read-extended-command-predicate #'command-completion-default-include-p)
  ;; Do not allow the cursor in the minibuffer prompt
  (minibuffer-prompt-properties
   '(read-only t cursor-intangible t face minibuffer-prompt)))

(use-package orderless
  :ensure t
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :ensure t
  ;; Bind `marginalia-cycle' locally in the minibuffer.  To make the binding
  ;; available in the *Completions* buffer, add it to the
  ;; `completion-list-mode-map'.
  :bind
  (:map minibuffer-local-map
        ("M-A" . marginalia-cycle))

  ;; Marginalia must be activated in the :init section of use-package such that
  ;; the mode gets enabled right away. Note that this forces loading the
  ;; package.
  :init
  (marginalia-mode))

(use-package denote
  :ensure t
  :hook (dired-mode-hook . denote-dired-mode)
  :bind
  (:map global-map
      ("C-c n n" . denote)
      ("C-c n s" . denote-subdirectory)
      ("C-c n d" . denote-dired)
      ("C-c n g" . denote-grep)
      ;; If you intend to use Denote with a variety of file types, it is
      ;; easier to bind the link-related commands to the `global-map', as
      ;; shown here.  Otherwise follow the same pattern for `org-mode-map',
      ;; `markdown-mode-map', and/or `text-mode-map'.
      ("C-c n q c" . denote-query-contents-link) ; create link that triggers a grep
      ("C-c n q f" . denote-query-filenames-link) ; create link that triggers a dired
      ;; Key bindings specifically for Dired.
      :map dired-mode-map
      ("C-c C-d C-i" . denote-dired-link-marked-notes)
      ("C-c C-d C-r" . denote-dired-rename-files)
      ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
      ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter))
  :config
  (setq denote-directory tl/org-path)
  (setq denote-save-buffers nil)
  (setq denote-known-keywords '("journal" "book" "course" "channel" "project" "area"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-prompts '(title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-excluded-keywords-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  (setq denote-date-prompt-use-org-read-date t)
  (denote-rename-buffer-mode 1))

(use-package denote-org
  :ensure t)

(use-package denote-journal
  :ensure t
  :commands (denote-journal-new-entry
             denote-journal-new-or-existing-entry
             denote-journal-link-or-create-entry)
  :hook (calendar-mode-hook . denote-journal-calendar-mode)
  :config
  ;; Use the "journal" subdirectory of the `denote-directory'.  Set this
  ;; to nil to use the `denote-directory' instead.
  (setq denote-journal-directory tl/org-journal-path)
  ;; Default keyword for new journal entries. It can also be a list of
  ;; strings.
  (setq denote-journal-keyword "journal")
  ;; Read the doc string of `denote-journal-title-format'.
  (setq denote-journal-title-format 'day-date-month-year))

(defun tl/front-matter-header (category)
  "Return Org front matter string with CATEGORY inserted after filetags line."
  (concat "#+title:      %s\n"
          "#+date:       %s\n"
          "#+filetags:   %s\n"
          (format "#+category:   %s\n" category)
          "#+identifier: %s\n"))

(defvar tl/front-matter-footer
  (concat "#+startup:    show2levels\n"
          "#+options:    toc:2\n"))

(defun tl/assemble-front-matter (category &rest contents)
  "Assemble front matter from CATEGORY, HEADER, CONTENTS..., and FOOTER.
    Each CONTENT string will have a newline appended automatically."
  (concat (tl/front-matter-header category)
          (mapconcat #'identity contents "\n")
	  "\n"
          tl/front-matter-footer
          "\n"))

(with-eval-after-load 'org-capture
  (add-to-list 'org-capture-templates
               `("j" "Journal" entry
                 (file denote-journal-path-to-new-or-existing-entry)
                 ,(concat "* ACTIVITY LOG\n%?\n"
                          "* THOUGHTS & IDEAS\n"
                          "* COMPLETED TASKS")
                 :kill-buffer t
                 :empty-lines 1
                 :jump-to-captured t)))

(defvar tl/book-front-matter
  (tl/assemble-front-matter "resource"
   "#+author:     %%^{Author}"
   "#+year:       %%^{Year}"
   "#+isbn:       %%^{ISBN}"
   "#+url:        %%^{URL}"))

(defvar tl/book-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
          "* CHAPTERS\n\n"
	  "* RESOURCES\n\n"
	  "* LINKS :link:\n"
          "%?\n\n"))

(with-eval-after-load 'org-capture
  (add-to-list
   'org-capture-templates
   '("b" "Book" plain
     (file denote-last-path)
     #'(lambda ()
         (let ((denote-use-directory tl/org-resources-path)
               (denote-use-keywords '("book"))
               (denote-use-template tl/book-template)
               (denote-org-front-matter tl/book-front-matter)
               (denote-org-capture-specifiers nil))
           (denote-org-capture)))
     :no-save t
     :immediate-finish nil
     :kill-buffer t
     :jump-to-captured t)))

(defvar tl/course-front-matter
  (tl/assemble-front-matter "resource"
   "#+author:     %%^{Author}"
   "#+provider:   %%^{Provider}"
   "#+url:        %%^{URL}"))

(defvar tl/course-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
          "* LESSONS\n"
          "%?\n\n"))

(with-eval-after-load 'org-capture
  (add-to-list
   'org-capture-templates
   '("c" "Course" plain
     (file denote-last-path)
     #'(lambda ()
         (let ((denote-use-directory tl/org-resources-path)
               (denote-use-keywords '("course"))
               (denote-use-template tl/course-template)
               (denote-org-front-matter tl/course-front-matter)
               (denote-org-capture-specifiers nil))
           (denote-org-capture)))
     :no-save t
     :immediate-finish nil
     :kill-buffer t
     :jump-to-captured t)))

(defvar tl/channel-front-matter
  (tl/assemble-front-matter "resource"
   "#+url:        %%^{URL}"))

(defvar tl/channel-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
          "* VIDEOS\n"
          "%?\n\n"))

(with-eval-after-load 'org-capture
  (add-to-list
   'org-capture-templates
   '("n" "Channel" plain
     (file denote-last-path)
     #'(lambda ()
         (let ((denote-use-directory tl/org-resources-path)
               (denote-use-keywords '("channel"))
               (denote-use-template tl/channel-template)
               (denote-org-front-matter tl/channel-front-matter)
               (denote-org-capture-specifiers nil))
           (denote-org-capture)))
     :no-save t
     :immediate-finish nil
     :kill-buffer t
     :jump-to-captured t)))

(defvar tl/project-front-matter
  (tl/assemble-front-matter "project"))

(defvar tl/project-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
	  "* HABITS\n"
	  "* TASKS\n"
          "* RESOURCES\n"
          "%?\n\n"))

(with-eval-after-load 'org-capture
  (add-to-list
   'org-capture-templates
   '("p" "Project" plain
     (file denote-last-path)
     #'(lambda ()
       (let ((denote-use-directory tl/org-projects-path)
               (denote-use-keywords '("project"))
               (denote-use-template tl/project-template)
               (denote-org-front-matter tl/project-front-matter)
               (denote-org-capture-specifiers nil))
           (denote-org-capture)))
     :no-save t
     :immediate-finish nil
     :kill-buffer t
     :jump-to-captured t)))

(defvar tl/area-front-matter
  (tl/assemble-front-matter "area"))

(defvar tl/area-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
	  "* HABITS\n"
	  "* TASKS\n"
          "* RESOURCES\n"
          "%?\n\n"))

(with-eval-after-load 'org-capture
  (add-to-list
   'org-capture-templates
   '("a" "Area" plain
     (file denote-last-path)
     #'(lambda ()
       (let ((denote-use-directory tl/org-areas-path)
               (denote-use-keywords '("area"))
               (denote-use-template tl/area-template)
               (denote-org-front-matter tl/area-front-matter)
               (denote-org-capture-specifiers nil))
           (denote-org-capture)))
     :no-save t
     :immediate-finish nil
     :kill-buffer t
     :jump-to-captured t)))

(use-package evil
  :ensure t
  :init
  ;; Minimize intrusiveness.
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-w-delete t)
  (setq evil-want-C-w-in-emacs-state nil)
  (setq evil-want-C-u-scroll nil)                 ;; I rarely use scroll commands in vim, and I need C-u in Emacs.
  (setq evil-want-C-d-scroll nil)                 ;; For consistency disable this too.
  (setq evil-want-C-i-jump nil)                   ;; Retain Emacs C-u.
  (setq evil-toggle-key "C-`")                    ;; Because the deault C-z is to useful to use for evil toggle.
  (with-eval-after-load 'evil
    (define-key evil-normal-state-map (kbd "C-r") 'isearch-backward))

  :config
  (evil-mode)

  ;; Evil-states per major mode
  (setq evil-default-state 'emacs)
  (setq evil-normal-state-modes '(fundamental-mode
                                  ssh-config-mode
                                  conf-mode
                                  prog-mode
                                  text-mode
                                  repos-mode
                                  dired-mode))

  ;; Minor mode evil states
  (add-hook 'with-editor-mode-hook 'evil-insert-state)
  (add-hook 'git-commit-setup-hook 'evil-insert-state) ;; Start editing Magit in insert state.

  ;; Disable evil in some modes.
  (evil-set-initial-state 'eat-mode 'emacs)
  (evil-set-initial-state 'calendar-mode 'emacs))

(require 'color) ;; for `color-rgb-to-hex` and `color-hsl-to-rgb`

(defvar tl/visible-mark-palette
  '("#800000" "#c23232" "#cd5c5c" "#f4a460" "#eab700")
  "Palette from dark red to light yellow for visible mark faces.")

(defun tl/jump-to-mark ()
  "Jump to the most recent mark, like `C-u C-SPC`."
  (interactive)
  (set-mark-command 4))

(use-package visible-mark
  :ensure (:fetcher github :repo "emacsmirror/visible-mark")
  :init
  (let ((colors tl/visible-mark-palette))
    (setq visible-mark-faces
          (cl-loop for i from 1 to (length colors)
                   for color in colors
                   collect
                   (let ((face-name (intern (format "visible-mark-face%d" i))))
                     (eval `(defface ,face-name
                              '((((type tty) (class mono)))
                                (t (:foreground ,color :box (:color ,color))))
                              ,(format "Visible mark face %d (magenta fixed)." i)))
                     face-name))))
  (setq visible-mark-max (length tl/visible-mark-palette))
  :config
  (global-set-key (kbd "M-o") #'tl/jump-to-mark)
  (global-visible-mark-mode 1))

(setq show-trailing-whitespace t)    ;; Show trailing whitespace.
(setq delete-by-moving-to-trash t)   ;; Use trash-cli rather than rm when deleting files.
(setq sentence-end-double-space nil) ;; Don't use double space to demarkate sentences.

;; keep backup and save files in a dedicated directory
(setq backup-directory-alist
      `((".*" . ,(file-name-concat user-emacs-directory "backups")))
      auto-save-file-name-transforms
      `((".*" ,(file-name-concat user-emacs-directory "backups") t)))

;; Backup by copying file. The safest and also the slowest aproach.
(setq backup-by-copying t)

;; Do more backups.
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

(setq custom-file (make-temp-file "")) ;; Use a temp file as a placeholder.
(setq custom-safe-themes t)            ;; Mark all themes as safe, since we can't persist now.

(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8
      coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

(setq confirm-kill-emacs nil
      confirm-kill-processes nil)

(setq-default fill-column 120)
(add-hook 'org-mode-hook 'turn-on-auto-fill)
(add-hook 'org-mode-hook 'display-fill-column-indicator-mode)
(setq-default display-fill-column-indicator-character ?┊)
(set-face-attribute 'fill-column-indicator nil :foreground "grey90")

(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

(setq ring-bell-function 'ignore)

(setq display-line-numbers-type 'visual)
(setq display-line-numbers-width-start t)
(global-display-line-numbers-mode 1)
(global-visual-line-mode 1)

(setq default-frame-alist
  '((top . 51)
    (left . 200)
    (width . 182)
    (height . 51)))

(add-to-list 'default-frame-alist '(undecorated . t))

(set-frame-parameter (selected-frame) 'alpha '(85 . 85))
(add-to-list 'default-frame-alist '(alpha . (85 . 85)))

(modify-all-frames-parameters '((internal-border-width . 8)))

(global-hl-line-mode)

(setq scroll-margin 3)

(blink-cursor-mode -1)        ; Steady cursor
(pixel-scroll-precision-mode) ; Smooth scrolling
(global-set-key (kbd "<escape>") 'keyboard-escape-quit) ; ESC quits prompts

(use-package sudo-edit
  :ensure t)

(use-package doc-view
  :custom
  (doc-view-resolution 300)
  (doc-view-mupdf-use-svg t)
  (large-file-warning-threshold (* 150 (expt 2 20))))

(defun tl/org-indent-fill-column-advice (res)
  (cond
   ((and (boundp 'org-indent-mode) org-indent-mode)
    (- res
       (length (plist-get (text-properties-at (point))
                          'line-prefix))))
   (t res)))

(advice-add 'current-fill-column :filter-return #'tl/org-indent-fill-column-advice)

(setq org-return-follows-link  t)                        ;; Follow the links
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode)) ;; Associate all org files with org mode
(setq org-hide-emphasis-markers t)                       ;; Hide the markers because I already use colors
(setq org-tags-column 0)                                 ;; Place tags right after the text

;; Remap the change priority keys to use the UP or DOWN key.
(define-key org-mode-map (kbd "C-c <up>") 'org-priority-up)
(define-key org-mode-map (kbd "C-c <down>") 'org-priority-down)

;; Open links in the same window.
(setq org-link-frame-setup
      '((file . find-file)))

;; Enable indent mode.
(setq org-indent-indentation-per-level 4)
(setq org-list-indent-offset 2)
(with-eval-after-load 'org
  (add-hook 'org-mode-hook 'org-indent-mode))

(defun tl/update-statistics-cookies-on-save ()
  (when (derived-mode-p 'org-mode)
    (org-update-statistics-cookies nil)))

(add-hook 'before-save-hook #'tl/update-statistics-cookies-on-save)

(define-key global-map (kbd "C-c c") 'org-capture)
(define-key global-map (kbd "C-c a") 'org-agenda)
(define-key global-map (kbd "C-c t") 'org-todo)
(define-key global-map (kbd "C-c o") 'org-open-at-point)
(define-key global-map (kbd "C-c s") 'org-schedule)
(define-key global-map (kbd "C-c d") 'org-deadline)
(define-key global-map (kbd "C-c l") 'org-insert-link)
(define-key global-map (kbd "C-c q") 'org-set-tags-command)

(setq org-attach-id-dir tl/org-attachments-path)
(setq org-attach-method 'mv)
(setq org-attach-auto-tag "attach")

(use-package org-board
  :ensure t
  :after org
  :config
  (setq org-board-archive-method 'wget)
  (setq org-board-default-browser 'system))

(defun tl/org-board-archive-heading-url ()
  "If the current Org heading has a single URL in the title, archive it with org-board."
  (interactive)
  (when (org-at-heading-p)
    (let* ((title (org-get-heading t t t t))
           (url (when (string-match org-link-bracket-re title)
                  (match-string 1 title))))
      (if url
          (org-board-new url)
        (message "No URL found in heading title.")))))

(with-eval-after-load 'org
  (setq org-habit-show-habits-only-for-today nil) ;; Show habits on all relevant view, not just today's view
  (setq org-habit-graph-column t)
  (setq org-habit-preceding-days 15)
  (setq org-habit-following-days 5))

(defun tl/org-make-habit ()
  "Turn the current TODO heading into a repeating habit using .+N style repeater.
Prompts for :TOD: (Morning, Afternoon, Evening) and :REPEAT_TO_STATE:."
  (interactive)
  (unless (org-get-todo-state)
    (user-error "Current heading is not a TODO item"))
  (let* ((current-state (org-get-todo-state))
         (date (org-read-date nil t nil "Start habit on: "))
         (interval (read-string "Repeat interval (e.g., 1d, 2w, 3m) [default: 1d]: "))
         (interval (if (string-empty-p interval) "1d" interval))
         (date-str (format-time-string (org-time-stamp-format nil t) date))
         (repeater (concat ".+" interval))
         (tod-options '("" "Morning" "Afternoon" "Evening"))
         (tod (completing-read "Time of day (empty for none): " tod-options nil t))
         (repeat-to (completing-read
                     (format "Repeat to state (default: %s): " current-state)
                     org-todo-keywords-1 nil t nil nil current-state)))
    ;; Set only SCHEDULED with repeater
    (org-schedule nil (concat date-str " " repeater))
    (org-set-property "STYLE" "Habit")
    (unless (string-empty-p repeat-to)
      (org-set-property "REPEAT_TO_STATE" repeat-to))
    (unless (string-empty-p tod)
      (org-set-property "TOD" tod))
    (message "Habit set to repeat every %s from %s, TOD: %s, returning to state: %s"
             interval date-str (if (string-empty-p tod) "unspecified" tod) repeat-to)))

(setq org-agenda-files (list tl/org-projects-path tl/org-areas-path tl/org-resources-path))
(setq org-agenda-window-setup 'only-window)     ;; agenda takes whole window
(setq org-agenda-restore-windows-after-quit t)  ;; restore window configuration on exit
(setq org-agenda-inhibit-startup nil)           ;; Ensure visibility is full
(setq org-agenda-dim-blocked-tasks nil)         ;; Don't hide blocked subtasks
(setq org-agenda-show-inherited-tags t)         ;; Show inherited tags (optional)
(setq org-agenda-sticky t)                      ;; Optional: keep custom view until replaced
(setq org-tags-match-list-sublevels t)

(with-eval-after-load 'org-agenda
  (define-key org-agenda-mode-map (kbd "j") 'org-agenda-next-item)
  (define-key org-agenda-mode-map (kbd "k") 'org-agenda-previous-item))

(defun tl/org-get-title (&optional max-length)
  "Return the #+title of the org file corresponding to the current agenda entry.
If MAX-LENGTH is given and the title is longer, truncate it and append '...'."
  (let* ((title (cadar (org-collect-keywords '("TITLE")))))
    (if (and max-length title (> (length title) max-length))
        (concat (substring title 0 (- max-length 3)) "...")
      title)))

(defun tl/org-get-tod-tag ()
  "Return a short tag string for the TOD property of the current Org entry.
[M] for Morning, [N] for Afternoon, [E] for Evening, and \"\" if none."
  (let ((tod (org-entry-get nil "TOD" t)))
    (pcase (and tod (downcase tod))
      ("morning" "[M]")
      ("afternoon" "[N]")
      ("evening" "[E]")
      (_ ""))))

(defun tl/org-agenda-compare-by-tod (a b)
  "Compare two agenda items A and B by their :TOD: property."
  (let* ((tod-order '("Morning" "Afternoon" "Evening"))
         (get-tod (lambda (x)
                    (or (org-entry-get (get-text-property 1 'org-marker x) "TOD") "")))
         (index-a (cl-position (funcall get-tod a) tod-order :test #'string=))
         (index-b (cl-position (funcall get-tod b) tod-order :test #'string=)))
    ;; nil values are treated as after all known TODs
    (setq index-a (or index-a (length tod-order)))
    (setq index-b (or index-b (length tod-order)))
    (< index-a index-b)))

;(setq org-agenda-cmp-user-defined #'tl/org-agenda-compare-by-tod)

;(setq org-agenda-sorting-strategy
;      '((agenda user-defined-up priority-down time-up)
;      (todo user-defined-up priority-down category-keep)
;      (tags user-defined-up)
;      (search user-defined-up)))

(defun tl/org-agenda-indent ()
  "Return an ASCII-style indent like └─ if parent has a TODO keyword."
  (save-excursion
    (let ((level (or (org-current-level) 0)))
      (cond
       ((<= level 1) "    ") ; 4 spaces for top-level alignment
       (t
        (org-up-heading-safe)
        (if (member (org-get-todo-state) org-todo-keywords-1)
            ;; Add spaces to align to (level - 1), then └─
            (let ((spaces (* (1- level) 2))) ; 2 spaces per depth level
              (concat (make-string spaces ?\s) "└─ "))
          "    "))))))

(defvar tl/org-agenda-custom-format
   "  %-12c %?-12t %-35(tl/org-get-title 30) %(tl/org-get-tod-tag) %(tl/org-agenda-indent)")

(setq org-agenda-prefix-format
      `((agenda . ,tl/org-agenda-custom-format)
        (todo   . ,tl/org-agenda-custom-format)
        (tags   . ,tl/org-agenda-custom-format)
        (search . ,tl/org-agenda-custom-format)))

(use-package org-super-agenda
  :ensure t
  :config
  (org-super-agenda-mode t))

(setq org-agenda-custom-commands
      ;; Today's view include habits and tasks scheduled for today, as well as currently worked projects.
      '(("d" "Today"
         ;; Show habits and tasks.
         ((agenda "" ((org-agenda-overriding-header "")
                      (org-agenda-span 'day)
                      (org-super-agenda-groups
                       '(;; Habits
                       (:name "Habits"
                              :habit t
                              :scheduled today
                              :order 1)
                       ;; Scheduled tasks
                       (:name "Tasks"
                              :scheduled today
                              :order 2)
                       ;; Other groups go here.
                       (:discard (:anything t))
                       ))))
          ;; Show tasks from projects I'm currently working in.
          (alltodo "" ((org-agenda-overriding-header "")
                       (org-super-agenda-groups
                        '(;; Projects
                          (:name "Resources"
                                 :and (:category "resource" :todo ("STARTED" "PAUSED" "NEXT"))
                                 :order 3)
                          ;; Discard everything else.
                          (:discard (:anything t))
                          ;; Other groups go here.
                          ))))
          ;; Other sections go here.
          ))
        ;; Other views go here.
        ))

;; Disable greying out DONE headlines.
(setq org-fontify-done-headline nil)

;; Define default TODO states. Per-buffer settings will be set in the file header when required.
(setq org-todo-keywords
      '((sequence
         "TODO(t)"
         "PROJECT(r)"
	 "NEXT(n!)"
	 "STARTED(s!)"
	 "PAUSE(p!)"
	 "WAIT(w@)"
	 "SOMEDAY(s!)"
	 "|"
	 "DONE(d!)"
         "CANCELLED(c@)")))

(setq org-log-into-drawer t) ;; Put state changes with timestamps into the drawer.
(setq org-log-done nil)      ;; The output doesn't go into drawer so I just disable it.

;; Set faces for some TODO states.
(setq org-todo-keyword-faces
      '(("PROJECT" . "#8959a8")
        ("NEXT" . "#c82829")
        ("STARTED" . "#f5871f")
        ("WAIT" . "#d08770")
        ("SOMEDAY" . "#4271ae")
        ("CANCELLED" . "#eab700")))

(setq org-enforce-todo-dependencies t)

(defun tl/org-promote-parent-if-child-progresses ()
  "If current heading switches to NEXT, update parent to STARTED if it's TODO or PROJECT."
  (when (and (equal org-state "NEXT")
             (org-up-heading-safe))
    (let ((parent-state (org-get-todo-state)))
      (when (member parent-state '("TODO" "PROJECT"))
        (org-todo "STARTED")))))

(add-hook 'org-after-todo-state-change-hook
          #'tl/org-promote-parent-if-child-progresses)

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

(defun tl/org-promote-next-sibling-when-done ()
  "When a heading is marked DONE, set the next sibling to NEXT, if it has no children."
  (when (string= org-state "DONE")
    (save-excursion
      (let ((pos (point)))
        (when (org-get-next-sibling)
          (let ((next-state (org-get-todo-state)))
            ;; Check if next sibling has children
            (save-excursion
              (if (org-goto-first-child)
                  ;; Has children — do nothing
                  nil
                ;; No children — promote to NEXT if it's a not-done state
                (when (and next-state (string= next-state "TODO"))
                  (org-todo "NEXT")))))
          (goto-char pos))))))

(add-hook 'org-after-todo-state-change-hook
            #'tl/org-promote-next-sibling-when-done)

(defun tl/org-log-started-task-in-journal ()
  "When a TODO changes from NEXT to STARTED, log a line in today's journal."
  (when (and (string= org-state "STARTED")
             (string= org-last-state "NEXT"))
    (let* ((source-file buffer-file-name)
           (link-description (or (cadar (org-collect-keywords '("TITLE"))) "No title"))
           (journal-file (denote-journal-path-to-new-or-existing-entry)))
      (with-current-buffer (find-file-noselect journal-file)
      (goto-char (point-min))
      (re-search-forward "^\\* ACTIVITY LOG")
      (org-end-of-subtree t nil)
      (unless (bolp) (insert "\n"))
      (insert "** Working on ")
      (denote-link source-file nil link-description)
      (insert "\n")
      (save-buffer)))))

(add-hook 'org-after-todo-state-change-hook
          #'tl/org-log-started-task-in-journal)

(setq org-capture-templates
      `(("i" "Inbox task" entry
         (file ,(expand-file-name "inbox.org" tl/org-path))
         "* %^{Task}  "  ;; prompt in minibuffer
         :immediate-finish t
         :kill-buffer t)))

(defun tl/org-capture-inbox ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "i"))

(define-key global-map (kbd "C-c i") 'tl/org-capture-inbox)

(defun tl/refile-from-inbox ()
  "Refile current task to a selected heading in an area, skill, or goal file.
  The task is inserted as a sibling under the selected heading using `org-refile`,
  set to TODO, and the destination is opened after the operation."
  (interactive)
  (let* ((base-dir tl/org-path)
         (category (completing-read "Refile to: " '("area" "project")))
         (target-dir (expand-file-name category base-dir))
         (org-files (directory-files target-dir t "\\.org$"))
         ;; Map file title → file path
         (file-alist
          (mapcar (lambda (file)
                    (with-temp-buffer
                      (insert-file-contents file nil 0 1024)
                      (let ((title (when (re-search-forward "^#\\+title:[ \t]*\\(.*\\)$" nil t)
                                     (match-string 1))))
                        (cons (or title (file-name-nondirectory file)) file))))
                  org-files))
         (file-title (completing-read "Choose file: " (mapcar #'car file-alist)))
         (target-file (cdr (assoc file-title file-alist)))
         ;; Extract headings
         (targets
          (with-temp-buffer
            (insert-file-contents target-file)
            (org-mode)
            (let ((org-refile-targets `((,target-file :maxlevel . 9))))
              (org-refile-get-targets))))
         (target-heading (completing-read "Choose heading: "
                                          (mapcar (lambda (target) (car target)) targets)))
         ;; Set refile location
         (refile-target (assoc target-heading targets)))

    ;; Mark current task TODO
    (org-todo "TODO")

    ;; Perform the refile
    (let ((org-reverse-note-order t))
      (org-refile nil nil
                  (list (car refile-target)
                        (nth 1 refile-target)    ;; file
                        nil                      ;; position
                        (nth 3 refile-target)))) ;; marker

    ;; Save both source and destination buffers
    (let ((dest-buffer (find-buffer-visiting (nth 1 refile-target))))
      (when dest-buffer
      (with-current-buffer dest-buffer
        (save-buffer)))
      (save-buffer))  ;; save source buffer

    ;; Jump to destination
    (org-refile-goto-last-stored)))

(use-package toc-org
  :ensure t
  :init (add-hook 'org-mode-hook 'toc-org-mode))

(use-package org-auto-tangle
  :ensure t
  :hook (org-mode-hook . org-auto-tangle-mode))

(use-package org-superstar
  :ensure t
  :hook (org-mode-hook . (lambda () (org-superstar-mode 1)))
  :config
  (setq org-hide-leading-stars nil)
  (setq org-superstar-leading-bullet ?\s)
  (setq org-superstar-remove-leading-stars nil)
  (setq org-superstar-headline-bullets-list
	'("☶" "☵" "☴" "☳" "☲" "☱" "☰")))

(use-package org-autolist
  :ensure t
  :hook (org-mode-hook . org-autolist-mode))

(with-eval-after-load 'org
  (require 'org-tempo)
  (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp")))

(use-package org-tidy
  :ensure t
  :hook (org-mode-hook . org-tidy-mode))

(use-package org-auto-expand
  :ensure t
  :config
  (org-auto-expand-mode))

(use-package eshell-syntax-highlighting
  :ensure t
  :after esh-mode
  :hook (eshell-mode-hook . (lambda () (setenv "TERM" "xterm-256color")))
  :config
  (eshell-syntax-highlighting-global-mode +1)
  (setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
        eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
	eshell-history-size 5000
	eshell-buffer-maximum-lines 5000
	eshell-hist-ignoredups t
	eshell-scroll-to-bottom-on-input t
        eshell-destroy-buffer-when-process-dies t))

(use-package doom-themes
  :ensure t
  :config

  ;; No bold, but italic is ok.
  (setq doom-themes-enable-bold nil
        doom-themes-enable-italic nil)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (load-theme 'doom-tomorrow-day :noconfirm)

  ;; Disable bold globally except for bold in text.
  (mapc
   (lambda (face)
     (set-face-attribute face nil :weight 'light :bold nil :italic nil))
   (face-list))

  ;; Set colors for some specifics faces.
  (set-face-attribute 'org-code nil :foreground "#d08770")
  (set-face-attribute 'org-special-keyword nil :foreground "#d08770")
  (set-face-attribute 'org-drawer nil :foreground "#d08770")
  (set-face-attribute 'bold nil :foreground "#8959a8")
  (set-face-attribute 'italic nil :foreground "#eab700"))

(set-face-attribute 'default nil
  :font "AporeticSerifMono Nerd Font"
  :height 160
  :weight 'light)
(set-face-attribute 'variable-pitch nil
  :font "AporeticSerifMono Nerd Font"
  :height 160
  :weight 'light)
(set-face-attribute 'fixed-pitch nil
  :font "AporeticSerifMono Nerd Font"
  :height 160
  :weight 'light)

;; Makes commented text italics.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)

;; Adjust line spacing.
(setq default-text-properties '(line-spacing 0.20 line-height 1.20))
(setq-default cursor-type '(hbar . 17))

(global-set-key (kbd "C-M-=") 'text-scale-increase)
(global-set-key (kbd "C-M--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(use-package nerd-icons
  :ensure t)
;; ibuffer
(use-package nerd-icons-ibuffer
  :ensure t
  :after nerd-icons
  :config
  (add-hook 'ibuffer-mode-hook #'nerd-icons-ibuffer-mode))
;; dired
(use-package nerd-icons-dired
  :ensure t
  :after nerd-icons
  :config
  (add-hook 'dired-mode-hook #'nerd-icons-dired-mode))
;; Completions
(use-package nerd-icons-completion
  :ensure t
  :config
  (nerd-icons-completion-mode))

(use-package dashboard
  :ensure t
  :after nerd-icons
  :config
  (setq dashboard-center-content t
        dashboard-vertically-center-content t
        dashboard-vertically-center-content t
        dashboard-icon-type 'nerd-icons)
  (setq dashboard-startupify-list
	'(dashboard-insert-banner-title
          dashboard-insert-newline
          dashboard-insert-navigator
          dashboard-insert-newline
          dashboard-insert-init-info
          dashboard-insert-items))
  (setq dashboard-week-agenda nil)
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook))

(use-package mood-line
  :ensure t
  :config (mood-line-mode))

(setq which-key-sort-order #'which-key-key-order-alpha
      which-key-sort-uppercase-first nil
      which-key-add-column-padding 1
      which-key-max-display-columns nil
      which-key-min-display-lines 6
      which-key-side-window-slot -10
      which-key-side-window-max-height 0.25
      which-key-idle-delay 0.0
      which-key-max-description-length 25
      which-key-allow-imprecise-window-fit t
      which-key-separator " → ")
(which-key-mode 1)
(which-key-setup-side-window-bottom)

;; Fix which-key overlapping with minibuffer
(defun fix-which-key--show-popup (orig-fn act-popup-dim)
  (let ((height (car act-popup-dim))
        (width  (cdr act-popup-dim)))
    (funcall orig-fn (cons (+ height 2) width))))
(advice-add 'which-key--show-popup :around #'fix-which-key--show-popup)
