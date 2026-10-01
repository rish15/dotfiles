local map = vim.keymap.set
local s = { silent = true }

-- no arrow keys
for _, key in ipairs({ '<Up>', '<Down>', '<Left>', '<Right>' }) do
    map({ 'n', 'v', 'o' }, key, '<Nop>')
end

-- keep search results centered
map('n', 'n', 'nzz')
map('n', 'N', 'Nzz')

-- config
map('n', '<leader>sv', ':source $MYVIMRC<CR>', s)
map('n', '<leader>ev', ':tabedit $MYVIMRC<CR>')

-- <leader>? : keybinding cheatsheet (this config's README) in a float.
-- Read-only, / to search, q / Esc / <leader>? to close.
local help_win
local function toggle_help()
    if help_win and vim.api.nvim_win_is_valid(help_win) then
        vim.api.nvim_win_close(help_win, true)
        help_win = nil
        return
    end
    local path = vim.fn.stdpath('config') .. '/README.md'
    if vim.fn.filereadable(path) == 0 then
        return vim.notify('No README at ' .. path, vim.log.levels.WARN)
    end
    local buf = vim.fn.bufadd(path)
    vim.b[buf].no_gitsigns = true  -- no blame noise in the doc (see gitsigns on_attach)
    vim.fn.bufload(buf)
    vim.bo[buf].buflisted = false  -- keep it out of the buffer tabs
    vim.bo[buf].modifiable = false
    vim.bo[buf].readonly = true

    local w = math.min(110, math.floor(vim.o.columns * 0.85))
    local h = math.floor(vim.o.lines * 0.8)
    help_win = vim.api.nvim_open_win(buf, true, {
        relative = 'editor', style = 'minimal', border = 'rounded',
        width = w, height = h,
        row = math.floor((vim.o.lines - h) / 2) - 1,
        col = math.floor((vim.o.columns - w) / 2),
        title = ' nvim keys ', title_pos = 'center',
    })
    vim.wo[help_win].wrap = true
    vim.wo[help_win].linebreak = true
    vim.wo[help_win].cursorline = true
    vim.wo[help_win].conceallevel = 2

    for _, key in ipairs({ 'q', '<Esc>' }) do
        vim.keymap.set('n', key, toggle_help, { buffer = buf, silent = true, nowait = true })
    end
end
map('n', '<leader>?', toggle_help, { silent = true, desc = 'Keybinding cheatsheet' })

-- editing
map('n', '<F4>', '%x``x')                  -- delete matching pair of brackets
map('n', '<leader><leader>', ':nohlsearch<CR>', s)
map('n', 'ft', 'f{vi{zf<CR>')              -- fold the next {...} block

-- auto-close pairs
for open, pair in pairs({ ['{'] = '{}', ['('] = '()', ['['] = '[]', ['"'] = '""', ["'"] = "''", ['`'] = '``' }) do
    map('i', open, pair .. '<Esc>ha')
end

-- windows / tabs
map('n', '<Tab>', '<C-w><C-w>')
map('n', '<C-Up>', ':resize -1<CR>', s)
map('n', '<C-Down>', ':resize +1<CR>', s)
map('n', '<C-Left>', ':vertical resize -1<CR>', s)
map('n', '<C-Right>', ':vertical resize +1<CR>', s)
map('n', '<C-t>', ':tabedit<CR>', s)
map('n', ']b', ':BufferLineCycleNext<CR>', s)   -- next / prev buffer tab
map('n', '[b', ':BufferLineCyclePrev<CR>', s)
map('n', '<leader>x', ':bp | bd #<CR>', s)      -- close buffer, keep the window

-- plugins
map('n', '<C-n>', ':NERDTreeToggle<CR>', s)
map('n', '<leader>r', ':NERDTreeFocus<CR>R<C-w><C-p>', { remap = true, silent = true }) -- refresh tree
map('n', '<C-f>', ':GFiles<CR>', s)
map('n', '<C-p>', ':Files<CR>', s)
map('n', '<C-b>', ':Buffers<CR>', s)
map('n', '<leader>ps', ':Rg<Space>')
map('n', '<leader>u', ':UndotreeShow<CR>', s)
map('n', '<leader>c', ':Goyo<CR>', s)
map('n', '<leader>ac', ':FloatermNew<CR>', s)

-- git
map('n', '<leader>gb', ':Gitsigns toggle_current_line_blame<CR>', s) -- inline blame on/off
map('n', '<leader>gB', ':Gitsigns blame_line full=true<CR>', s)      -- full commit for this line
map('n', '<leader>gh', ':DiffviewFileHistory %<CR>', s)              -- history of this file
map('n', '<leader>gH', ':DiffviewFileHistory<CR>', s)                -- history of the repo
map('n', '<leader>gd', ':DiffviewOpen<CR>', s)                       -- uncommitted changes
map('n', '<leader>gq', ':DiffviewClose<CR>', s)
map('n', '<leader>gs', ':Git<CR>', s)                                -- status (s stage, cc commit)
map('n', '<leader>gc', ':Git commit<CR>', s)
map('n', ']c', function() if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else vim.cmd('Gitsigns nav_hunk next') end end, s)
map('n', '[c', function() if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else vim.cmd('Gitsigns nav_hunk prev') end end, s)
map('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', s)
map('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', s)
map('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', s)

-- markdown / README
map('n', '<leader>mr', ':RenderMarkdown toggle<CR>', s)  -- rendered <-> raw in nvim
map('n', '<leader>mp', ':MarkdownPreviewToggle<CR>', s)  -- live preview in the browser

-- claude code
map('n', '<leader>ai', ':ClaudeCode<CR>', s)
map('n', '<leader>as', ':ClaudeCodeSend<CR>', s)
map('v', '<leader>as', ':ClaudeCodeSend<CR>', s)
