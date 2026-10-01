-- vim-plug. Add a Plug() line, then :PlugInstall
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- look (configured in ui.lua)
Plug('catppuccin/nvim', { as = 'catppuccin' })
Plug('nvim-lualine/lualine.nvim')
Plug('akinsho/bufferline.nvim')
Plug('lukas-reineke/indent-blankline.nvim')
Plug('nvim-tree/nvim-web-devicons')
Plug('ryanoasis/vim-devicons')  -- NERDTree icons
-- treesitter rewrote itself for nvim 0.12 ('main'); 'master' is the 0.11 version
Plug('nvim-treesitter/nvim-treesitter', {
    branch = vim.fn.has('nvim-0.12') == 1 and 'main' or 'master',
    ['do'] = ':TSUpdate',
})

-- navigation / search
Plug('preservim/nerdtree')
Plug('junegunn/fzf', { ['do'] = function() vim.fn['fzf#install']() end })
Plug('junegunn/fzf.vim')
Plug('jremmen/vim-ripgrep')
Plug('mbbill/undotree')
Plug('voldikss/vim-floaterm')
Plug('junegunn/goyo.vim')

-- git
Plug('tpope/vim-fugitive')            -- :Git commit / status / push
Plug('lewis6991/gitsigns.nvim')       -- hunk signs + inline blame (GitLens-style)
Plug('sindrets/diffview.nvim')        -- commit history + diffs

-- editing
Plug('neoclide/coc.nvim', { branch = 'release' })
Plug('tpope/vim-surround')
Plug('preservim/nerdcommenter')
Plug('prettier/vim-prettier', { ['do'] = 'npm install' })

-- languages
Plug('fatih/vim-go', { ['do'] = ':GoUpdateBinaries' })
Plug('leafgarland/typescript-vim')
Plug('pangloss/vim-javascript')
Plug('ekalinin/Dockerfile.vim')
Plug('iamcco/markdown-preview.nvim', {   -- README in the browser
    ['do'] = function() vim.fn['mkdp#util#install']() end,
    ['for'] = { 'markdown', 'vim-plug' },
})
Plug('MeanderingProgrammer/render-markdown.nvim') -- README rendered in the buffer
Plug('trixnz/sops.nvim')  -- SOPS files decrypt on open, re-encrypt on save (:SopsToggle)

-- AI
Plug('coder/claudecode.nvim')

vim.call('plug#end')

---------------------------------------------------------------- nerdtree
vim.g.NERDTreeDirArrowExpandable = ''
vim.g.NERDTreeDirArrowCollapsible = ''
vim.g.NERDTreeMinimalUI = 1
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeWinSize = 30
vim.g.NERDTreeWinPos = 'left'

---------------------------------------------------------------- fzf / rg
vim.g.fzf_preview_window = { 'right:20%', 'ctrl-/' }
vim.g.fzf_layout = {
    window = { width = 0.9, height = 0.5, yoffset = 0.5, xoffset = 0.5, highlight = 'Todo', border = 'rounded' },
}
vim.g.rg_derive_root = 'true'

---------------------------------------------------------------- go
vim.g.go_highlight_types = 1
vim.g.go_highlight_fields = 1
vim.g.go_highlight_functions = 1
vim.g.go_highlight_function_calls = 1
vim.g.go_highlight_operators = 1
vim.g.go_highlight_extra_types = 1
vim.g.go_highlight_build_constraints = 1
vim.g.go_highlight_generate_tags = 1
vim.g.go_diagnostics_enabled = 0
vim.g.go_metalinter_enabled = {}
vim.g.go_jump_to_error = 0
vim.g.go_fmt_command = 'goimports'
vim.g.go_auto_sameids = 0

---------------------------------------------------------------- git
local ok_gs, gitsigns = pcall(require, 'gitsigns')
if ok_gs then
    gitsigns.setup({
        current_line_blame = true, -- "author, 2 days ago · message" at end of line
        current_line_blame_opts = { delay = 300 },
        current_line_blame_formatter = '<author>, <author_time:%R> · <summary>',
        on_attach = function(buf) return not vim.b[buf].no_gitsigns end,
    })
end

local ok_dv, diffview = pcall(require, 'diffview')
if ok_dv then
    diffview.setup({ view = { merge_tool = { layout = 'diff3_mixed' } } })
end

---------------------------------------------------------------- markdown
-- Renders in normal mode, shows raw markdown on the line you're editing
local ok_md, render_md = pcall(require, 'render-markdown')
if ok_md then
    render_md.setup({ file_types = { 'markdown' } })
end

---------------------------------------------------------------- sops
-- undofile is on globally, which would write decrypted secrets to
-- ~/.local/state/nvim/undo. Turn it off for SOPS buffers while they're still
-- encrypted (sops.nvim decrypts right after BufReadPost), and for /tmp files
-- so `sops edit` (which opens a decrypted temp file) doesn't leak either.
vim.api.nvim_create_autocmd('BufReadPost', {
    group = vim.api.nvim_create_augroup('sops_no_undo', { clear = true }),
    callback = function(args)
        local name = vim.api.nvim_buf_get_name(args.buf)
        local lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
        if name:match('^/tmp/') or table.concat(lines, '\n'):find('ENC[AES256_GCM,', 1, true) then
            vim.bo[args.buf].undofile = false
        end
    end,
})

---------------------------------------------------------------- claude code
local ok, claudecode = pcall(require, 'claudecode')
if ok then
    claudecode.setup({
        terminal = { split_side = 'right', split_width_percentage = 0.35 },
    })
end
