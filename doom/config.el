;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq confirm-kill-emacs nil)

(setq evil-cross-lines t)

;;; Window navigation

(map! :leader
      :desc "Focus Treemacs"
      "e" #'treemacs)

;; Vim-style window navigation with Ctrl.
(map! :n
      "C-h" #'evil-window-left
      "C-j" #'evil-window-down
      "C-k" #'evil-window-up
      "C-l" #'evil-window-right)

(defun my/eglot-code-actions ()
  "Run Eglot code actions."
  (interactive)
  (call-interactively #'eglot-code-actions))

(map! :leader
      :desc "Code actions"
      "c a" #'my/eglot-code-actions)

;; ; behaves like :
(map! :n ";" #'evil-ex)

;;; Floating vterm
(require 'vterm)

(defvar my/vterm-float-frame nil)
(defvar my/vterm-float-buffer "*vterm-float*")

(defun my/vterm-float-center (frame parent)
  "Center FRAME inside PARENT."
  (let* ((parent-width  (frame-pixel-width parent))
         (parent-height (frame-pixel-height parent))
         (child-width   (frame-pixel-width frame))
         (child-height  (frame-pixel-height frame))
         (left (/ (- parent-width child-width) 2))
         (top  (/ (- parent-height child-height) 2)))
    (set-frame-position frame left top)))

(defun my/vterm-float-toggle ()
  "Toggle a centered floating vterm."
  (interactive)

  ;; If the floating terminal already exists, close it.
  (if (and my/vterm-float-frame
           (frame-live-p my/vterm-float-frame))

      (progn
        (delete-frame my/vterm-float-frame)
        (setq my/vterm-float-frame nil))

    ;; Otherwise create it.
    (let* ((parent (selected-frame))
           (frame
            (make-frame
             `((parent-frame . ,parent)
               (minibuffer . nil)
               (undecorated . t)
               (border-width . 1)
               (internal-border-width . 10)

               ;; Terminal size.
               (width . 100)
               (height . 30)

               ;; Don't show scrollbars.
               (vertical-scroll-bars . nil)
               (horizontal-scroll-bars . nil)

               ;; Make the child frame interactive.
               ;; Don't treat it as another normal Emacs frame.
               (no-other-frame . t)
               (desktop-dont-save . t)))))

      (setq my/vterm-float-frame frame)

      ;; Center it inside the parent frame.
      (my/vterm-float-center frame parent)

      ;; Create/use the vterm buffer inside the child frame.
      (with-selected-frame frame
        (let ((buffer (get-buffer my/vterm-float-buffer)))
          (if (and buffer
                   (buffer-live-p buffer))
              (set-window-buffer (frame-root-window frame) buffer)
            (set-window-buffer
             (frame-root-window frame)
             (vterm my/vterm-float-buffer)))

          (delete-other-windows)
          (select-window (frame-root-window frame)))

        ;; Give the terminal focus.
        (select-frame-set-input-focus frame)))))

;;; Alt+i toggles the terminal in normal buffers.
(map! :n "M-i" #'my/vterm-float-toggle)

;;; Alt+i also toggles it while vterm has focus.
(after! vterm
  (define-key vterm-mode-map
    (kbd "M-i")
    #'my/vterm-float-toggle))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `with-eval-after-load' block, otherwise Doom's defaults may override your
;; settings. E.g.
;;
;;   (with-eval-after-load 'PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look them up).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
