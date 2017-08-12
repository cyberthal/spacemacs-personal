;; * config.el of private/personal layer
;; * top
;; ** ergonomics
;; *** visual
;; **** nyan-mode

                                        ; (spaceline-toggle-nyan-cat-on)

;; **** removes annoying left fringe arrow for wrapped lines.
(setq-default fringe-indicator-alist '(
                                       (truncation left-arrow right-arrow)
                                       (continuation nil right-curly-arrow) ;; left-curly-arrow
                                       (overlay-arrow . right-triangle)
                                       (up . up-arrow)
                                       (down . down-arrow)
                                       (top top-left-angle top-right-angle)
                                       (bottom bottom-left-angle bottom-right-angle top-right-angle top-left-angle)
                                       (top-bottom left-bracket right-bracket top-right-angle top-left-angle)
                                       (empty-line . empty-line)
                                       (unknown . question-mark)))


;; *** dired sorting by directories first

(setq dired-listing-switches "-alGhU --group-directories-first")

(add-hook
 'dired-before-readin-hook
 (lambda ()
   (when (file-remote-p default-directory)
     (setq dired-actual-switches "-al"))))

;; *** outshine

(add-hook 'ahk-mode-hook 'outline-minor-mode)

;; ** org-mode & bbcodeize
(with-eval-after-load 'org 
;; *** make org start with wrapped lines.  works.
(setq org-startup-truncated nil)
(setq line-move-visual nil)

;; *** word wrap for org only.  works.
(add-hook 'org-mode-hook #'toggle-word-wrap)


;; *** use org UIUDs

;; Use global IDs (for unique links)
(require 'org-id)


;; *** display

(dolist (face '(org-block-begin-line 
                org-block-end-line 
                org-verbatim 
;;                org-block-background
                org-table
                ))
  (set-face-attribute face nil :inherit 'fixed-pitch)
  )

(add-hook 'org-mode-hook 'variable-pitch-mode)

;; *** org priorities 0-9

(setq org-highest-priority ?0)
(setq org-lowest-priority ?9)
(setq org-default-priority ?5)
;; *** load org agenda files recursively

;; http://stackoverflow.com/questions/17215868/recursively-adding-org-files-in-a-top-level-directory-for-org-agenda-files-take

;; Collect all .org from my Org directory and subdirs

;; **** setup the search function

(setq org-agenda-file-regexp "\\`[^.].*\\.org\\'") ; default value
(setq org-agenda-files nil)
(defun load-org-agenda-files-recursively (dir) "Find all directories in DIR."
    (unless (file-directory-p dir) (error "Not a directory `%s'" dir))
    (unless (equal (directory-files dir nil org-agenda-file-regexp t) nil)
      (add-to-list 'org-agenda-files dir)
    )
    (dolist (file (directory-files dir nil nil t))
        (unless (member file '("." ".."))
            (let ((file (concat dir file "/")))
                (when (file-directory-p file)
                    (load-org-agenda-files-recursively file)
                )
            )
        )
    )
)

;; *** load bbcodeize

(push "~/.emacs.d/private/personal/bbcode/" load-path)
(require 'bbcodeize)

;; *** end org-mode block

) 

;; ** Windows path & exec-path

;; adapted from Xah's code here:
;; http://ergoemacs.org/emacs/emacs_env_var_paths.html

(when (string-equal system-type "windows-nt")
  (let (
        (cb-NT-extra-paths
          '(
            "C:/cygwin/usr/local/bin"
            "C:/cygwin/usr/bin"
            "C:/cygwin/bin"

            ;;"C:/Program Files (x86)/ErgoEmacs/msys/bin"
            )
         )
        )

    (setenv "PATH"
            (concat 
             (getenv "PATH")
             ";"
             (mapconcat 'identity cb-NT-extra-paths ";")
             )
            )
    (setq exec-path
          (append exec-path cb-NT-extra-paths)
          )
        )
  (setq magit-git-executable "c:/Program Files (x86)/Git/bin/git.exe")
  )

;; snippets handy for testing purposes
;; (setenv "PATH" "C:\\msys32\\mingw32\\bin;C:\\msys32\\usr\\local\\bin;C:\\msys32\\usr\\bin;C:\\msys32\\usr\\bin;C:\\Windows\\System32;C:\\Windows;C:\\Windows\\System32\\Wbem;C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\;C:\\msys32\\usr\\bin\\site_perl;C:\\msys32\\usr\\bin\\vendor_perl;C:\\msys32\\usr\\bin\\core_perl")
;; (setq exec-path '("c:/msys32/mingw32/bin" "C:/msys32/usr/local/bin" "C:/msys32/usr/bin" "C:/msys32/usr/bin" "C:/Windows/System32" "C:/Windows" "C:/Windows/System32/Wbem" "C:/Windows/System32/WindowsPowerShell/v1.0/" "C:/msys32/usr/bin/site_perl" "C:/msys32/usr/bin/vendor_perl" "C:/msys32/usr/bin/core_perl" "c:/msys32/mingw32/libexec/emacs/25.1/i686-w64-mingw32"))
;; (getenv "PATH")
;; (insert exec-path)

;; ** Mac path

;; fixes dired display failure
;; by switching from default mac ls to brew coreutils
(when (eq system-type 'darwin)
  (require 'ls-lisp)
  (setq insert-directory-program "gls"))
