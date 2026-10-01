# Local tools (no Mason)

This config now uses LSP servers, formatters and tree-sitter parsers that are
installed with pacman / the AUR. Nothing is downloaded by Neovim itself.
Requires Neovim 0.11+.

## Install

```sh
sudo pacman -S --needed \
  lua-language-server clang rust-analyzer pyright \
  bash-language-server typescript-language-server \
  vscode-langservers-extracted yaml-language-server taplo-cli \
  stylua ruff python-black shfmt prettier jq \
  tree-sitter-cli ripgrep fd

yay -S marksman-bin              # Markdown LSP (AUR)
sudo pacman -S haskell-language-server   # optional, big
```

Package names can differ slightly between repos: check with `pacman -Ss <name>`
or `yay -Ss <name>`. Run `:ToolsCheck` inside Neovim to see what is missing.
Only install what you use: servers/formatters that are not installed are
skipped silently.

Tree-sitter parsers: neovim already bundles c, lua, vim, vimdoc, markdown.
For the rest try `pacman -Ss tree-sitter-` (e.g. `tree-sitter-python`,
`tree-sitter-rust`, `tree-sitter-bash`); they are linked automatically.

## Keys / commands

| Key / command        | What it does                                   |
| -------------------- | ---------------------------------------------- |
| `gd gD gi gy gr`     | definition / declaration / impl / type / refs  |
| `K`                  | hover docs                                     |
| `<leader>rn`         | rename                                         |
| `<leader>ca`         | code action                                    |
| `<leader>cf`         | format buffer or selection (was `<leader>f`)   |
| `<leader>d`          | line diagnostics (`<leader>e` is Neo-tree)     |
| `[d` `]d`            | previous / next diagnostic                     |
| `<leader>ds` `<leader>ws` | document / workspace symbols (Telescope)  |
| `<leader>uh`         | toggle inlay hints                             |
| `<leader>uf`, `<leader>uF` | toggle format-on-save (global / buffer)  |
| `:FormatToggle[!]`   | same as above                                  |
| `:ToolsCheck`        | report installed / missing tools               |
| `:checkhealth vim.lsp` | built-in LSP diagnostics                     |

## After applying

Start Neovim and run `:Lazy clean` (removes the old mason plugins), then `:ToolsCheck`.
