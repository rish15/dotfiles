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

-- markdown / README
map('n', '<leader>mr', ':RenderMarkdown toggle<CR>', s)  -- rendered <-> raw in nvim
map('n', '<leader>mp', ':MarkdownPreviewToggle<CR>', s)  -- live preview in the browser

-- claude code
map('n', '<leader>ai', ':ClaudeCode<CR>', s)
map('n', '<leader>as', ':ClaudeCodeSend<CR>', s)
map('v', '<leader>as', ':ClaudeCodeSend<CR>', s)
