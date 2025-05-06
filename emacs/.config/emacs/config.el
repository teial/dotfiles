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

(setopt use-package-hook-name-suffix nil)

(unbind-key "C-z")

(use-package general
  :ensure t
  :demand t
  :config
  ;; Set up ',' as the global leader key
  (general-create-definer tl/leader
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix ","
    :global-prefix "M-,")

  ;; Files
  (tl/leader
   "." '(find-file :wk "find file")
   "f" '(:ignore t :wk "files")
   "f c" '(:ignore t :wk "config")
   "f c c" '((lambda () (interactive) (find-file "~/.config/emacs/config.org")) :wk "config.org")
   "f c i" '((lambda () (interactive) (find-file "~/.config/emacs/init.el")) :wk "init.el")
   "f c e" '((lambda () (interactive) (find-file "~/.config/emacs/early-init.el")) :wk "early-init.el")
   "f c r" '((lambda ()
	       (interactive)
	       (load-file "~/.config/emacs/init.el"))
	     :wk "reload config"))

  ;; Toggles
  (tl/leader
   "t" '(:ignore t :wk "toggle")
   "t l" '(display-line-numbers-mode :wk "line numbers")
   "t r" '(visual-line-mode :wk "truncated lines")
   "t t" '(org-tidy-toggle :wk "org property drawers")))

(setq user-full-name "Teia Lesuten")
(setq user-mail-address "teia.leusten@proton.me")

(defvar tl/org-path "~/Forge/teial/"
  "Directory for org notes.")

(defvar tl/org-journal-path (file-name-concat tl/org-path "journal/")
  "Subdirectory for my journal.")

(defvar tl/org-projects-path (file-name-concat tl/org-path "projects/")
  "Subdirectory for project notes.")

(defvar tl/org-areas-path (file-name-concat tl/org-path "areas/")
  "Subdirectory for area notes.")

(defvar tl/org-skills-path (file-name-concat tl/org-path "skills/")
  "Subdirectory for skill notes.")

(defvar tl/org-garden-path (file-name-concat tl/org-path "garden/")
  "Subdirectory for my digital garden notes.")

(defvar tl/org-languages-path (file-name-concat tl/org-path "languages/")
  "Subdirectory for my language learning notes.")

(defvar tl/org-resources-path (file-name-concat tl/org-path "resources/")
  "Subdirectory for resouces.")

(use-package rainbow-delimiters
  :ensure t
  :hook
  (prog-mode-hook . rainbow-delimiters-mode)
  (org-mode-hook . rainbow-delimiters-mode))

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
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook))

(use-package denote
  :ensure t
  :hook (dired-mode . denote-dired-mode)
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
    ("C-c n l" . denote-link)
    ("C-c n L" . denote-add-links)
    ("C-c n b" . denote-backlinks)
    ("C-c n q c" . denote-query-contents-link) ; create link that triggers a grep
    ("C-c n q f" . denote-query-filenames-link) ; create link that triggers a dired
    ;; Note that `denote-rename-file' can work from any context, not just
    ;; Dired bufffers.  That is why we bind it here to the `global-map'.
    ("C-c n r" . denote-rename-file)
    ("C-c n R" . denote-rename-file-using-front-matter)

    ;; Key bindings specifically for Dired.
    :map dired-mode-map
    ("C-c C-d C-i" . denote-dired-link-marked-notes)
    ("C-c C-d C-r" . denote-dired-rename-files)
    ("C-c C-d C-k" . denote-dired-rename-marked-files-with-keywords)
    ("C-c C-d C-R" . denote-dired-rename-marked-files-using-front-matter))

  :config
  (setq denote-directory (expand-file-name "~/Forge/teial/"))
  (setq denote-save-buffers nil)
  (setq denote-known-keywords '("journal", "book" "course" "video" "project" "area" "skill" "idea"))
  (setq denote-infer-keywords t)
  (setq denote-sort-keywords t)
  (setq denote-prompts '(title keywords))
  (setq denote-excluded-directories-regexp nil)
  (setq denote-excluded-keywords-regexp nil)
  (setq denote-rename-confirmations '(rewrite-front-matter modify-file-name))
  (setq denote-date-prompt-use-org-read-date t)
  (denote-rename-buffer-mode 1))

(use-package denote-menu
  :ensure t
  :bind
  (:map global-map
    ("C-c n a" . list-denotes)))

(defvar tl/front-matter-header
  (concat "#+title:      %s\n"
          "#+date:       %s\n"
          "#+filetags:   %s\n"
          "#+identifier: %s\n"))

(defvar tl/front-matter-footer
  (concat "#+startup:    overview\n"
  	  "#+options:    toc:2\n"))

(defun tl/assemble-front-matter (&rest contents)
  "Assemble front matter from HEADER, CONTENTS..., and FOOTER.
Each CONTENT string will have a newline appended automatically."
  (concat tl/front-matter-header
          (mapconcat #'identity contents "\n")
          tl/front-matter-footer
          "\n"))

(defvar tl/book-front-matter
  (tl/assemble-front-matter
   "#+author:     %%^{Author}"
   "#+year:       %%^{Year}"
   "#+isbn:       %%^{ISBN}"))

(defvar tl/channel-front-matter
  (tl/assemble-front-matter
   "#+url:        %%^{URL}"))

(defvar tl/area-front-matter
  (tl/assemble-front-matter))

(defvar tl/book-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
          "* CHAPTERS\n"
          "%?\n\n"))

(defvar tl/channel-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
          "* VIDEOS\n"
          "%?\n\n"))

(defvar tl/area-template
  (concat "* TABLE OF CONTENTS :toc:\n"
          "  :PROPERTIES:\n"
          "  :auto-expand: body\n"
          "  :END:\n\n"
          "* goals\n"
          "%?\n\n"))

(with-eval-after-load 'org-capture
  ;; Book template
  (add-to-list
   'org-capture-templates
   '("b" "Book project" plain
     (file denote-last-path)
     #'(lambda ()
         (let ((denote-use-directory tl/org-projects-path)
               (denote-use-keywords '("book"))
               (denote-use-template tl/book-template)
	       (denote-org-front-matter tl/book-front-matter)
               (denote-org-capture-specifiers nil))
           (denote-org-capture)))
     :no-save t
     :immediate-finish nil
     :kill-buffer t
     :jump-to-captured t))

  ;; Channel template
  (add-to-list
   'org-capture-templates
   '("n" "Channel project" plain
     (file denote-last-path)
     #'(lambda ()
         (let ((denote-use-directory tl/org-projects-path)
               (denote-use-keywords '("channel"))
               (denote-use-template tl/channel-template)
	       (denote-org-front-matter tl/channel-front-matter)
               (denote-org-capture-specifiers nil))
           (denote-org-capture)))
     :no-save t
     :immediate-finish nil
     :kill-buffer t
     :jump-to-captured t))

  ;; Area template
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

(with-eval-after-load 'general
  (general-define-key
   :states 'normal
   "C-c c" 'org-capture))

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

(use-package evil
  :ensure t

  :init
  (setq evil-respect-visual-line-mode t)
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-i-jump nil)                        ;; Retain Emacs C-u.
  (setq evil-toggle-key "C-`")                         ;; Because the deault C-z is to useful to use for evil toggle.

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
  (evil-set-initial-state 'eat-mode 'emacs)           ;; Same for Eat.

  ;; Return C-r to its proper state.
  (define-key evil-insert-state-map (kbd "C-r") 'isearch-backward)
  (define-key evil-normal-state-map (kbd "C-r") 'isearch-backward)
  (define-key evil-visual-state-map (kbd "C-r") 'isearch-backward))

(set-face-attribute 'default nil
  :font "Sarasa Term SC Nerd"
  :height 160
  :weight 'medium)
(set-face-attribute 'variable-pitch nil
  :font "Sarasa Term SC Nerd"
  :height 160
  :weight 'medium)
(set-face-attribute 'fixed-pitch nil
  :font "Sarasa Term SC Nerd"
  :height 160
  :weight 'medium)

;; Makes commented text italics.
(set-face-attribute 'font-lock-comment-face nil
  :slant 'italic)

;; Adjust line spacing.
(setq-default line-spacing 0.15)
(setq-default line-height 1.15)

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

(use-package mood-line
  :ensure t
  :config (mood-line-mode))

(with-eval-after-load 'org
  (add-hook 'org-mode-hook 'org-indent-mode))

(use-package toc-org
  :ensure t
  :init (add-hook 'org-mode-hook 'toc-org-mode))

;; Disable greying out DONE headlines.
(setq org-fontify-done-headline nil)

;; Automatically set parent item to DONE when children are all DONE.
(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-todo-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
(add-hook 'org-after-todo-statistics-hook #'org-summary-todo)

;; Define default TODO states. Per-buffer settings will be set in the file header when required.
(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s!)" "WAIT(w/!)" "|" "DONE(d!)")))

(setq org-log-into-drawer t) ;; Put state changes with timestamps into the drawer.
(setq org-log-done nil)      ;; The output doesn't go into drawer so I just disable it.

;; Set faces for some TODO states.
(setq org-todo-keyword-faces
      '(("STARTED" . "#EBCB8B")
        ("WAIT" . "#D08770")))

(use-package org-auto-tangle
  :ensure t
  :hook (org-mode-hook . org-auto-tangle-mode))

(use-package org-bullets
  :ensure t
  :hook (org-mode-hook . (lambda () (org-bullets-mode 1))))

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

(use-package doc-view
  :custom
  (doc-view-resolution 300)
  (doc-view-mupdf-use-svg t)
  (large-file-warning-threshold (* 150 (expt 2 20))))

(use-package eshell-syntax-highlighting
  :ensure t
  :after esh-mode
  :hook (eshell-mode-hool . (lambda () (setenv "TERM" "xterm-256color")))
  :config
  (eshell-syntax-highlighting-global-mode +1)
  (setq eshell-rc-script (concat user-emacs-directory "eshell/profile")
        eshell-aliases-file (concat user-emacs-directory "eshell/aliases")
	eshell-history-size 5000
	eshell-buffer-maximum-lines 5000
	eshell-hist-ignoredups t
	eshell-scroll-to-bottom-on-input t
        eshell-destroy-buffer-when-process-dies t))

(use-package sudo-edit
  :ensure t
  :after general
  :config
  (tl/leader
   "fu" '(sudo-edit-find-file :wk "find file as root")
   "fU" '(sudo-edit :wk "edit file as root")))

(use-package doom-themes
  :ensure t
  :config

  ;; No bold, but italic is ok.
  (setq doom-themes-enable-bold nil
        doom-themes-enable-italic t)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (load-theme 'doom-nord-aurora :noconfirm)

  ;; Disable bold globally.
  (mapc
   (lambda (face)
     (set-face-attribute face nil :weight 'normal :bold nil))
   (face-list)))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq ring-bell-function 'ignore)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(global-visual-line-mode 1)

(setq default-frame-alist
  '((top . 50)
    (left . 230)
    (width . 150)
    (height . 51)))

(add-to-list 'default-frame-alist '(undecorated-round . t))

(set-frame-parameter (selected-frame) 'alpha '(85 . 85))
(add-to-list 'default-frame-alist '(alpha . (85 . 85)))

(modify-all-frames-parameters '((internal-border-width . 8)))

(global-hl-line-mode)

(blink-cursor-mode -1)        ; Steady cursor
(pixel-scroll-precision-mode) ; Smooth scrolling

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
    (funcall orig-fn (cons (+ height 1) width))))
(advice-add 'which-key--show-popup :around #'fix-which-key--show-popup)
