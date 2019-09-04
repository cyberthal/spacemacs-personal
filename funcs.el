;; * funcs.el in private/personal layer
;; * offset
;; ** Insert inactive timestamp of current time

(defun leo-org-time-and-date-stamp-inactive ()
  "Insert inactive timestamp of current time"

  ;; Calls org-time-stamp-inactive with universal prefix
  (interactive)
  (org-insert-time-stamp (current-time) t t)
  )

;; ** leo-checklist-to-not-done

(defun leo-checklist-to-not-done
    ()
  "Replaces all checklist X with SPACE"
  (interactive)

  (save-excursion
    (while (search-forward "[X]" nil t)
      (replace-match "[ ]" nil t))
    )
  )

;; Org-Mode: "boxes" Advance down org-mode checklist with C-S-n
(fset 'boxes
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("" 0 "%d")) arg)))
;; binding it to a handy key, since as a command it won't macro repeat
(global-set-key (kbd "C-S-n") 'boxes)

;; ** Textmind startup

(defun leo-textmind-startup ()
    (interactive)

  (spacemacs/toggle-fullscreen-frame)
  (make-frame)
  (spacemacs/toggle-fullscreen-frame)
  (persp-load-state-from-file "Textmind-main"))
;; ** proc sprinted DONE
;; *** pipify word list DONE

(defun leo-pipify-word-list (arg)
  "Converts multi-line word list into one line separated by pipes."
  (interactive "p")

  (dotimes (number arg)
    (end-of-line)
    (insert " | ")
    (delete-char 1)
    (end-of-line)))
