--        _
--       (_)
-- __   __ _   _ __ ___     _ __    ___
-- \ \ / / | | | '_ ` _ \   | '__|  / __|
--  \ V /  | | | | | | | | | |     | (__
--   \_/   |_| |_| |_| |_| |_|      \___|

-- Leader first so every <leader> mapping below picks it up
vim.g.mapleader = ' '

require('config.options')
require('config.plugins')
require('config.ui')
require('config.keymaps')
require('config.coc')
