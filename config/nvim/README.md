# nvim

Neovim config in Lua with vim-plug and a Catppuccin Mocha theme with a transparent background.
Leader is **Space**.

```
init.lua                 loads the files below in order
lua/config/options.lua   settings, autocmds, abbreviations
lua/config/plugins.lua   plugin list + plugin settings (nerdtree, fzf, go, git, markdown, claude)
lua/config/ui.lua        theme, treesitter, statusline, tabs, indent guides
lua/config/keymaps.lua   general keys
lua/config/coc.lua       completion / LSP keys (coc.nvim)
coc-settings.json        coc popups + diagnostic signs
```

**Install / update:** run `~/dotfiles/install.sh`, or inside nvim run `:PlugInstall` then `:PlugUpdate`.
To add a plugin, put a `Plug('owner/repo')` line in `plugins.lua` and run `:PlugInstall`.
Remove old plugins with `:PlugClean`.

## Keys

`<leader>` = Space · `\` = backslash · modes: n normal, v visual, i insert, o operator

### Moving around

| Key | Action |
|---|---|
| `<Tab>` | Next window |
| `Ctrl+↑ ↓ ← →` | Resize window |
| `]b` / `[b` | Next / prev buffer tab |
| `<leader>x` | Close buffer (keeps the window) |
| `Ctrl+t` | New tab |
| `n` / `N` | Next / prev search match, centered |
| `<leader><leader>` | Clear search highlight |
| Arrow keys | Disabled (use `hjkl`) |

### Files & search

| Key | Action |
|---|---|
| `Ctrl+p` | Find files |
| `Ctrl+f` | Find git-tracked files |
| `Ctrl+b` | Open buffers |
| `<leader>ps` | Ripgrep for text (`:Rg <term>`) |
| `Ctrl+n` | Toggle file tree |
| `<leader>r` | Refresh file tree |

In the fzf picker, `Ctrl+/` toggles preview and `Ctrl+t`, `Ctrl+x` or `Ctrl+v` open the file in a tab, split or vsplit.
In NERDTree, `o` opens, `s`/`i` open in a split, `m` opens the file menu (add, rename, delete), and `?` shows help.

### Code (coc)

| Key | Action |
|---|---|
| `Tab` / `Shift+Tab` (i) | Next / prev completion |
| `Enter` (i) | Accept completion |
| `Ctrl+Space` (i) | Open completion |
| `gd` / `gy` / `gi` / `gr` | Definition / type def / implementation / references |
| `K` | Docs for word under cursor |
| `]g` / `[g` | Next / prev diagnostic |
| `\rn` | Rename symbol |
| `\f` (n, v) | Format selection |
| `\a{motion}` (n, v) | Code action on selection, e.g. `\aap` |
| `\ac` | Code action for buffer |
| `\qf` | Quick-fix current line |
| `Ctrl+s` (n, v) | Expand selection |
| `if` / `af` (v, o) | Inside / around function, e.g. `vaf`, `dif` |
| `ic` / `ac` (v, o) | Inside / around class |
| `Ctrl+f` / `Ctrl+b` (i, v) | Scroll docs popup |
| `<leader>a` | List diagnostics |
| `<leader>o` | Outline of current file |
| `<leader>s` | Search workspace symbols |
| `<leader>e` | Manage coc extensions |
| `<leader>j` / `<leader>k` | Next / prev item in last list |
| `<leader>p` | Reopen last list |

Commands: `:Format` (whole file), `:OR` (organize imports), `:Fold`, `:Prettier`.

### Git

| Key | Action |
|---|---|
| `<leader>gb` | Toggle inline blame (on by default) |
| `<leader>gB` | Full commit info for this line |
| `<leader>gh` | History of this file |
| `<leader>gH` | History of the repo |
| `<leader>gd` | Diff of uncommitted changes |
| `<leader>gq` | Close the diff/history view |
| `<leader>gs` | Git status (fugitive) |
| `<leader>gc` | Commit |
| `]c` / `[c` | Next / prev changed hunk |
| `<leader>hp` | Preview hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |

In git status (`<leader>gs`), `s` stages, `u` unstages, `=` shows the inline diff, `cc` commits, `X` discards and `g?` shows help.
In the history and diff views, `Tab`/`Shift+Tab` moves between files, `-` stages or unstages and `g?` shows help.

### Editing

| Key | Action |
|---|---|
| `{ ( [ " ' `` ` `` (i) | Insert the matching closing pair |
| `F4` | Delete the bracket under cursor and its match |
| `ft` | Fold the next `{ … }` block (`zo` opens, `zc` closes) |
| `<leader>cc` / `<leader>cu` | Comment / uncomment line(s) |
| `<leader>c<Space>` | Toggle comment |
| `cs"'` / `ds"` / `ysiw"` | Change / delete / add surrounding quotes, brackets or tags |
| `<leader>u` | Undo tree |

Abbreviations in insert mode: `teh` becomes `the`, `ed` becomes `export default`, `imf` becomes `import from`, and `cf` becomes `const = () => {return}`.

### Markdown

| Key | Action |
|---|---|
| `<leader>mr` | Toggle rendered / raw markdown |
| `<leader>mp` | Live preview in browser |

### Tools

| Key | Action |
|---|---|
| `<leader>ai` | Open Claude Code |
| `<leader>as` (n, v) | Send line / selection to Claude |
| `<leader>ac` | Floating terminal (`exit` closes it) |
| `<leader>c` | Zen mode (Goyo) |
| `<leader>ev` | Edit `init.lua` in a new tab |
| `<leader>sv` | Reload config |

`<leader>c` waits about a second before opening Goyo, because the comment keys (`<leader>cc`, `<leader>cu`, …) start with it too.
