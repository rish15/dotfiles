-- vim-plug. Add a Plug() line, then :PlugInstall
local Plug = vim.fn['plug#']

vim.call('plug#begin')

-- look
Plug('cocopon/iceberg.vim')
Plug('dracula/vim', { as = 'dracula' })
Plug('itchyny/lightline.vim')
Plug('ryanoasis/vim-devicons')

-- navigation / search
Plug('preservim/nerdtree')
Plug('junegunn/fzf', { ['do'] = function() vim.fn['fzf#install']() end })
Plug('junegunn/fzf.vim')
Plug('jremmen/vim-ripgrep')
Plug('mbbill/undotree')
Plug('voldikss/vim-floaterm')
Plug('junegunn/goyo.vim')

-- git
Plug('tpope/vim-fugitive')
Plug('airblade/vim-gitgutter')

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
Plug('iamcco/markdown-preview.nvim', {
    ['do'] = function() vim.fn['mkdp#util#install']() end,
    ['for'] = { 'markdown', 'vim-plug' },
})

-- AI
Plug('coder/claudecode.nvim')

vim.call('plug#end')

---------------------------------------------------------------- theme
-- pcall: first launch on a new machine runs before :PlugInstall
if pcall(vim.cmd.colorscheme, 'iceberg') then
    for _, group in ipairs({ 'Normal', 'NonText', 'StatusLine', 'StatusLineNC', 'TabLine', 'TabLineFill' }) do
        vim.api.nvim_set_hl(0, group, { bg = 'NONE', ctermbg = 'NONE' })
    end
end

---------------------------------------------------------------- lightline
vim.g.lightline = {
    colorscheme = 'iceberg',
    active = {
        left = { { 'mode', 'paste' }, { 'gitbranch', 'readonly', 'filename', 'modified' } },
        right = { { 'lineinfo' }, { 'percent' }, { 'cocstatus', 'filetype' } },
    },
    component_function = {
        gitbranch = 'FugitiveHead',
        cocstatus = 'coc#status',
    },
    tabline = { left = { { 'tabs' } }, right = { { 'close' } } },
    tab = {
        active = { 'filetype', 'filename', 'modified' },
        inactive = { 'filetype', 'filename', 'modified' },
    },
}
vim.api.nvim_create_autocmd('User', {
    pattern = 'CocStatusChange',
    callback = function() pcall(vim.fn['lightline#update']) end,
})

---------------------------------------------------------------- nerdtree
vim.g.NERDTreeDirArrowExpandable = '|'
vim.g.NERDTreeDirArrowCollapsible = '|'
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

---------------------------------------------------------------- claude code
local ok, claudecode = pcall(require, 'claudecode')
if ok then
    claudecode.setup({
        terminal = { split_side = 'right', split_width_percentage = 0.35 },
    })
end
