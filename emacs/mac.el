;;; Sharing Clipboard with Mac Clipboard
;;; http://d.hatena.ne.jp/kiririmode/20110129/p1
(defvar prev-yanked-text nil "*previous yanked text")
(setq interprogram-cut-function
      (lambda (text &optional push)
        ; use pipe
        (let ((process-connection-type nil))
          (let ((proc (start-process "pbcopy" nil "pbcopy")))
            (process-send-string proc string)
            (process-send-eof proc)
            ))))
(setq interprogram-paste-function
      (lambda ()
        (let ((text (shell-command-to-string "pbpaste")))
          (if (string= prev-yanked-text text)
              nil
            (setq prev-yanked-text text)))))
