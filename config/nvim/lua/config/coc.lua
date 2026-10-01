-- coc.nvim. Extensions listed here install themselves on first launch, e.g.
-- vim.g.coc_global_extensions = { 'coc-json', 'coc-tsserver', 'coc-go' }

local map = vim.keymap.set
local s = { silent = true }
local expr = { silent = true, expr = true, replace_keycodes = false }

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- completion: Tab / S-Tab to move, Enter to confirm, C-Space to open
map('i', '<Tab>', 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<Tab>" : coc#refresh()', expr)
map('i', '<S-Tab>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], expr)
map('i', '<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"]], expr)
map('i', '<C-Space>', 'coc#refresh()', { silent = true, expr = true })

-- diagnostics
map('n', '[g', '<Plug>(coc-diagnostic-prev)', s)
map('n', ']g', '<Plug>(coc-diagnostic-next)', s)

-- go to
map('n', 'gd', '<Plug>(coc-definition)', s)
map('n', 'gy', '<Plug>(coc-type-definition)', s)
map('n', 'gi', '<Plug>(coc-implementation)', s)
map('n', 'gr', '<Plug>(coc-references)', s)

-- K: docs on hover
function _G.show_docs()
    local word = vim.fn.expand('<cword>')
    if vim.tbl_contains({ 'vim', 'help' }, vim.bo.filetype) then
        vim.cmd('help ' .. word)
    elseif vim.fn['coc#rpc#ready']() == 1 then
        vim.fn.CocActionAsync('doHover')
    else
        vim.cmd('!' .. vim.o.keywordprg .. ' ' .. word)
    end
end
map('n', 'K', '<cmd>lua _G.show_docs()<CR>', s)

local aug = vim.api.nvim_create_augroup('coc_rishu', { clear = true })
vim.api.nvim_create_autocmd('CursorHold', {
    group = aug,
    command = "silent call CocActionAsync('highlight')",
})
vim.api.nvim_create_autocmd('FileType', {
    group = aug,
    pattern = { 'typescript', 'json' },
    command = "setl formatexpr=CocAction('formatSelected')",
})
vim.api.nvim_create_autocmd('User', {
    group = aug,
    pattern = 'CocJumpPlaceholder',
    command = "call CocActionAsync('showSignatureHelp')",
})

-- Refactor / fix. These stay on backslash (not leader) because that's
-- where they always ended up in the old init.vim, and <leader>a/<leader>ac
-- are already used by floaterm and Claude.
map('n', '\\rn', '<Plug>(coc-rename)', s)
map({ 'n', 'x' }, '\\f', '<Plug>(coc-format-selected)', s)
map({ 'n', 'x' }, '\\a', '<Plug>(coc-codeaction-selected)', s)
map('n', '\\ac', '<Plug>(coc-codeaction)', s)
map('n', '\\qf', '<Plug>(coc-fix-current)', s)

-- function / class text objects
map({ 'x', 'o' }, 'if', '<Plug>(coc-funcobj-i)', s)
map({ 'x', 'o' }, 'af', '<Plug>(coc-funcobj-a)', s)
map({ 'x', 'o' }, 'ic', '<Plug>(coc-classobj-i)', s)
map({ 'x', 'o' }, 'ac', '<Plug>(coc-classobj-a)', s)

-- scroll hover popups (normal-mode C-f / C-b belong to fzf)
local nowait = { silent = true, nowait = true, expr = true }
map('i', '<C-f>', [[coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(1)\<CR>" : "\<Right>"]], nowait)
map('i', '<C-b>', [[coc#float#has_scroll() ? "\<C-r>=coc#float#scroll(0)\<CR>" : "\<Left>"]], nowait)
map('v', '<C-f>', [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"]], nowait)
map('v', '<C-b>', [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"]], nowait)

-- selection ranges
map({ 'n', 'x' }, '<C-s>', '<Plug>(coc-range-select)', s)

vim.api.nvim_create_user_command('Format', "call CocAction('format')", {})
vim.api.nvim_create_user_command('Fold', "call CocAction('fold', <f-args>)", { nargs = '?' })
vim.api.nvim_create_user_command('OR', "call CocAction('runCommand', 'editor.action.organizeImport')", {})

-- CocList
local list = { silent = true } -- no <nowait>: it would shadow <leader>ai/as/sv/ev/ps
map('n', '<leader>a', ':<C-u>CocList diagnostics<CR>', list)
map('n', '<leader>e', ':<C-u>CocList extensions<CR>', list)
map('n', '<leader>o', ':<C-u>CocList outline<CR>', list)
map('n', '<leader>s', ':<C-u>CocList -I symbols<CR>', list)
map('n', '<leader>j', ':<C-u>CocNext<CR>', list)
map('n', '<leader>k', ':<C-u>CocPrev<CR>', list)
map('n', '<leader>p', ':<C-u>CocListResume<CR>', list)
