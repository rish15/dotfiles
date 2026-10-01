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
