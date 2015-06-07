(require 'package)
(package-initialize)
(setq package-enable-at-startup nil)

(add-to-list 'load-path (concat user-emacs-directory "config"))
(setq package-archives '(("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")))
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

(use-package evil-leader
	     :commands (evil-leader-mode)
	     :ensure evil-leader
	     :demand evil-leader
	     :init (global-evil-leader-mode)
	     :config
	     (progn
		(evil-leader/set-leader "<SPC>")
		(evil-leader/set-key "b" 'ibuffer)
		(evil-leader/set-key "<SPC>" 'other-window)
	       )
	     )

(use-package evil
	     :ensure evil
	     :demand evil
	     :init (evil-mode 1)
	     :config
	     (progn
		(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
		(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
		(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
		(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
		)
	     )
	       
(use-package key-chord
	     :ensure key-chord
	     :demand key-chord
	     :init (key-chord-mode 1)
	     :config
	     (progn
            (key-chord-define evil-insert-state-map "jk" 'evil-normal-state)
	       )
	     )
