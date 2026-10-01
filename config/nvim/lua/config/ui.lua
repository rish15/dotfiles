-- Look & feel: Catppuccin Mocha to match waybar / rofi / alacritty / starship.
-- Every setup is pcall'd so a fresh machine still starts before :PlugInstall.

---------------------------------------------------------------- theme
local ok_cat, catppuccin = pcall(require, 'catppuccin')
if ok_cat then
    catppuccin.setup({
        flavour = 'mocha',
        transparent_background = true, -- alacritty's 0.9 opacity shows through
        float = { transparent = false, solid = false },
        term_colors = true,
        styles = { comments = { 'italic' }, keywords = { 'italic' } },
        -- vim-plug isn't auto-detected, so list what we use
        auto_integrations = false,
        integrations = {
            coc_nvim = true,
            gitsigns = true,
            diffview = true,
            fzf = true,
            treesitter = true,
            render_markdown = true,
            indent_blankline = { enabled = true, scope_color = 'lavender' },
        },
    })
    vim.cmd.colorscheme('catppuccin')
end

---------------------------------------------------------------- treesitter
local langs = {
    'go', 'gomod', 'gosum', 'typescript', 'tsx', 'javascript', 'json', 'yaml', 'toml',
    'lua', 'vim', 'vimdoc', 'query', 'bash', 'fish', 'dockerfile', 'sql',
    'html', 'css', 'scss', 'python', 'markdown', 'markdown_inline', 'regex', 'diff', 'gitcommit',
}

if vim.fn.has('nvim-0.12') == 1 then
    -- 'main' branch: install parsers, then turn highlighting on per buffer
    local ok_ts, ts = pcall(require, 'nvim-treesitter')
    if ok_ts then
        ts.install(langs)
        vim.api.nvim_create_autocmd('FileType', {
            callback = function() pcall(vim.treesitter.start) end,
        })
    end
else
    local ok_ts, ts = pcall(require, 'nvim-treesitter.configs')
    if ok_ts then
        ts.setup({
            ensure_installed = langs,
            highlight = { enable = true, additional_vim_regex_highlighting = false },
        })
    end
end

---------------------------------------------------------------- statusline
-- Rounded ends + powerline arrows, same shapes as the Starship prompt
local ok_ll, lualine = pcall(require, 'lualine')
if ok_ll then
    lualine.setup({
        options = {
            theme = 'catppuccin-mocha',
            globalstatus = true,
            section_separators = { left = '', right = '' },
            component_separators = { left = '│', right = '│' },
            disabled_filetypes = { statusline = { 'nerdtree' } },
        },
        sections = {
            lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
            lualine_b = { 'branch', 'diff' },
            lualine_c = {
                { 'filename', path = 1, symbols = { modified = '●', readonly = '' } },
                { 'diagnostics', sources = { 'coc' } },
            },
            lualine_x = { 'g:coc_status', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { { 'location', separator = { right = '' }, left_padding = 2 } },
        },
        extensions = { 'fugitive', 'nerdtree', 'fzf', 'quickfix' },
    })
end

---------------------------------------------------------------- tabline
-- Must load after catppuccin or the colors come out wrong
local ok_bl, bufferline = pcall(require, 'bufferline')
if ok_bl then
    bufferline.setup({
        highlights = ok_cat and require('catppuccin.special.bufferline').get_theme() or nil,
        options = {
            separator_style = 'thin',
            indicator = { style = 'underline' },
            diagnostics = 'coc',
            show_buffer_close_icons = false,
            always_show_bufferline = true,
            offsets = { { filetype = 'nerdtree', text = '  Files', separator = true } },
        },
    })
end

---------------------------------------------------------------- indent guides
local ok_ibl, ibl = pcall(require, 'ibl')
if ok_ibl then
    ibl.setup({
        indent = { char = '│' },
        scope = { show_start = false, show_end = false },
        exclude = { filetypes = { 'markdown', 'help', 'nerdtree', 'fugitive', 'gitcommit' } },
    })
end
