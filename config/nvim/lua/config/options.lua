local o = vim.opt

o.termguicolors = true
o.background = 'dark'
o.errorbells = false
o.mouse = ''

-- indent
o.tabstop = 4
o.softtabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

-- ui
o.number = true
o.relativenumber = true
o.cursorline = true
o.wrap = true
o.linebreak = true
o.showmode = false        -- lualine shows the mode
o.showtabline = 2
o.cmdheight = 1
o.signcolumn = 'yes'       -- own column for git/diagnostic signs
o.scrolloff = 8           -- keep 8 lines of context above/below the cursor
o.sidescrolloff = 8
o.pumblend = 10           -- slightly see-through completion menu
o.shortmess:append('atcI') -- shorter messages, no intro screen

-- search
o.ignorecase = true
o.smartcase = true

-- files (undo history lives in ~/.local/state/nvim/undo)
o.swapfile = false
o.backup = false
o.writebackup = false
o.undofile = true

o.updatetime = 300

local aug = vim.api.nvim_create_augroup('rishu', { clear = true })

-- Strip trailing whitespace on save, keeping the cursor where it was
vim.api.nvim_create_autocmd('BufWritePre', {
    group = aug,
    callback = function()
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Keep splits equal when the terminal resizes
vim.api.nvim_create_autocmd('VimResized', { group = aug, command = 'wincmd =' })

vim.api.nvim_create_autocmd('FileType', {
    group = aug,
    pattern = 'scss',
    callback = function() vim.opt_local.iskeyword:append('@-@') end,
})

vim.cmd([[
    iabbrev teh the
    iabbrev ed export default
    iabbrev imf import from
    iabbrev cf const = () => {return}
]])
