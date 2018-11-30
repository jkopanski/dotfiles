(setq doom-font (font-spec :family "Input" :size 16))

(def-package! dhall-mode)
(def-package! direnv)

(direnv-mode)

(after! dante
(setq-default
 dante-repl-command-line-methods-alist
  `((styx  . ,(lambda (root) (dante-repl-by-file root '("styx.yaml") '("styx" "repl" dante-target))))
    (nix   . ,(lambda (root) (dante-repl-by-file root '("shell.nix" "default.nix")
                                                      '("nix-shell" "--run" (concat "cabal new-repl " (or dante-target "") " --builddir=dist/dante")))))
    (stack . ,(lambda (root) (dante-repl-by-file root '("stack.yaml") '("stack" "repl" dante-target))))
    (new-build . ,(lambda (root) (when (or (directory-files root nil ".+\\.cabal$") (file-exists-p "cabal.project"))
                                   '("cabal" "new-repl" dante-target "--builddir=dist/dante"))))
    (bare . ,(lambda (_) '("cabal" "repl" dante-target "--builddir=dist/dante"))))))

(after! web-mode
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(after! typescript-mode
  (setq typescript-indent-level 2))

(add-hook 'before-save-hook #'delete-trailing-whitespace)
