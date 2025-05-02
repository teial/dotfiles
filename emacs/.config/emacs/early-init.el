;; Performance optimizations.
(setq gc-cons-threshold (* 256 1024 1024))
(setq read-process-output-max (* 4 1024 1024))
(setq comp-deferred-compilation t)
(setq comp-async-jobs-number 8)

;; Garbage collector optimization.
(setq gcmh-idle-delay 5)
(setq gcmh-high-cons-threshold (* 1024 1024 1024))

;; Version control optimization.
(setq vc-handled-backends '(Git))

;; Annoyance suppression.
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-log-types '((comp) (bytecomp)))
(setq native-comp-async-report-warnings-errors 'silent)

;; Find GCC and libgccjit paths on MacOS.
(defun homebrew-paths ()
  "Return library paths from Homebrew installations.
Detects paths for gcc, libvterm, and libgccjit packages to be used in LIBRARY_PATH."
  (let* ((paths '())
	 (brew-bin (or (executable-find "brew")
		       (let ((arm-path "/opt/homebrew/bin/brew")
			     (intel-path "/usr/local/bin/brew"))
			 (cond
			  ((file-exists-p arm-path) arm-path)
			  ((file-exists-p intel-path) intel-path))))))

    (when brew-bin
      ;; Get gcc paths.
      (let* ((gcc-prefix (string-trim
			  (shell-command-to-string
			   (concat brew-bin " --prefix gcc"))))
	     (gcc-lib-current (expand-file-name "lib/gcc/current" gcc-prefix)))

	;; Find apple-darwin directory.
	(let* ((default-directory gcc-lib-current)
               (arch-dirs (file-expand-wildcards "gcc/*-apple-darwin*/*[0-9]")))
          (when arch-dirs
            (push (expand-file-name
                   (car (sort arch-dirs #'string>)))
                  paths)))

	(push gcc-lib-current paths))

      ;; Get libgccjit paths
      (let* ((jit-prefix (string-trim
			  (shell-command-to-string
			   (concat brew-bin " --prefix libgccjit"))))
	     (jit-lib-current (expand-file-name "lib/gcc/current" jit-prefix)))
	(push jit-lib-current paths)))

    (message "%s" paths)
    (nreverse paths)))

(defun setup-macos-native-comp-library-paths ()
  "Set up LIBRARY_PATH for native compilation on macOS.
Includes Homebrew GCC paths and CommandLineTools SDK libraries."
  (let* ((existing-paths (split-string (or (getenv "LIBRARY_PATH") "") ":" t))
         (brew-paths (homebrew-paths))
         (clt-paths '("/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"))
         (unique-paths (delete-dups
                        (append existing-paths brew-paths clt-paths))))

    (setenv "LIBRARY_PATH" (mapconcat #'identity unique-paths ":"))))

(defun setup-homebrew-path ()
  "Detect Homebrew prefix and prepend its bin dir to `exec-path` and $PATH."
  (let ((brew (or (executable-find "brew")
		      (let ((arm-path "/opt/homebrew/bin/brew")
			    (intel-path "/usr/local/bin/brew"))
			(cond
			 ((file-exists-p arm-path) arm-path)
			 ((file-exists-p intel-path) intel-path))))))
    (when brew
      (let* ((brew-prefix (string-trim
			 (shell-command-to-string
			  (concat brew " --prefix 2>/dev/null"))))
	    (brew-bin (expand-file-name "bin" brew-prefix)))
	(setenv "PATH" (concat brew-bin path-separator (getenv "PATH")))
	(add-to-list 'exec-path brew-bin)))))

;; Set up library paths for native compilation on macOS.
(when (eq system-type 'darwin)
  (setup-homebrew-path)
  (setup-macos-native-comp-library-paths))

;; Disable package.el in favor of elpaca.
(setq package-enable-at-startup nil)
