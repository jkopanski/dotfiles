(setq doom-font (font-spec :family "Input" :size 19))

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
