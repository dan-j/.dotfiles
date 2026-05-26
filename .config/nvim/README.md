# Neovim Config

## Requirements

- Neovim 0.11+
- A [Nerd Font](https://www.nerdfonts.com/) set in your terminal (for icons)
- `make` (for telescope-fzf-native)
- `git`

On first launch, lazy.nvim will bootstrap itself and install all plugins. Treesitter parsers and LSP servers (gopls, ts_ls, eslint) will install automatically.

---

## Leader Key

`<Space>`

---

## File Navigation

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>ef` | Reveal current file in explorer |
| `<leader>ff` | Find files (fuzzy) |
| `<leader>fr` | Recent files |
| `<leader>fg` | Live grep across project |
| `<leader>fb` | Switch buffers |
| `<leader>fh` | Search help tags |

---

## LSP

Triggered automatically when opening Go, TypeScript, or JavaScript files.

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | References |
| `gi` | Go to implementation |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>lf` | Format file |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>d` | Show diagnostic in float |
| `<leader>fd` | All diagnostics (Telescope) |

---

## Completion

| Key | Action |
|-----|--------|
| `<C-Space>` | Trigger completion |
| `<Tab>` / `<S-Tab>` | Next / previous item |
| `<CR>` | Confirm selection |
| `<C-e>` | Abort |
| `<C-b>` / `<C-f>` | Scroll docs |

---

## Git

| Key | Action |
|-----|--------|
| `<leader>gg` | Git status (Fugitive) |
| `<leader>gb` | Git blame |
| `<leader>gd` | Diff current file |
| `<leader>gl` | Git log |
| `]c` / `[c` | Next / previous hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |

---

## Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` + motion | Toggle comment over motion |
| `ys{motion}{char}` | Add surrounding (e.g. `ysiw"`) |
| `cs{old}{new}` | Change surrounding (e.g. `cs"'`) |
| `ds{char}` | Delete surrounding (e.g. `ds"`) |
| `<` / `>` (visual) | Indent / dedent, stay in visual |
| `J` / `K` (visual) | Move selected lines down / up |

---

## Windows & Buffers

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Navigate between windows |
| `<C-arrows>` | Resize windows |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>q` | Close buffer |

---

## Plugin Management

```
:Lazy          — open plugin manager UI
:Lazy update   — update all plugins
:Lazy sync     — install + update + clean
:Mason         — open LSP/tool installer UI
:TSUpdate      — update treesitter parsers
```

---

## Tips

- Press `<Space>` and wait — **which-key** will show all available keybindings
- `:checkhealth` — diagnose any setup issues
- `:LspInfo` — show active LSP servers for the current buffer
