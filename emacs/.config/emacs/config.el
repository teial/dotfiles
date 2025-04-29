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

(use-package evil
  :ensure t
  :init ;; tweak evil's configuration before loading it
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-respect-visual-line-mode t)
  :config
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (setq evil-collection-mode-list '(dashboard))
  (evil-collection-init))
(use-package evil-tutor
  :ensure t)

(use-package general
  :ensure t
  :config
  (general-evil-setup t)
  ;; Set up ',' as the global leader key
  (general-create-definer tl/leader-def
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix ","
    :global-prefix "M-,") ;; access leader in insert mode
  (general-create-definer tl/localleader-def
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix ";"
    :global-prefix "M-;") ;; access local leader in insert mode
  ;; Buffer manipulation
  (tl/leader-def
   "b" '(:ignore t :wk "buffer")
   "bb" '(switch-to-buffer :wk "Switch buffer")
   "bk" '(kill-this-buffer :wk "Kill this buffer")
   "bn" '(next-buffer :wk "Next buffer")
   "bp" '(previous-buffer :wk "Previous buffer")
   "br" '(revert-buffer :wk "Revert buffer")))

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

(add-hook 'org-mode-hook 'org-indent-mode)

(use-package toc-org
  :ensure t
  :init (add-hook 'org-mode-hook 'toc-org-mode))

(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq ring-bell-function 'ignore)

(setq display-line-numbers-type 'relative) 
(global-display-line-numbers-mode 1)
(global-visual-line-mode 1)

(add-to-list 'default-frame-alist '(undecorated-round . t))

(set-frame-parameter (selected-frame) 'alpha '(85 . 85))
(add-to-list 'default-frame-alist '(alpha . (85 . 85)))

(modify-all-frames-parameters '((internal-border-width . 8)))

(setq which-key-sort-order #'which-key-key-order-alpha
      which-key-sort-uppercase-first nil
      which-key-add-column-padding 1
      which-key-max-display-columns nil
      which-key-min-display-lines 6
      which-key-side-window-max-height 0.25
      which-key-idle-delay 0.0
      which-key-max-description-length 25
      which-key-allow-imprecise-window-fit t
	which-key-separator " → ")
(which-key-mode 1)
(which-key-setup-side-window-bottom)
