-- NOTE: These need to be set up before any plugins are loaded.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- [[ Setting Options ]]
-- See `:help vim.o`
vim.opt.switchbuf = "useopen,uselast"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true
vim.opt.winwidth = 10
vim.opt.winminwidth = 10
vim.opt.equalalways = true
vim.opt.swapfile = false
vim.opt.incsearch = true

-- [[ Whitespace Characters ]]

vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·", extends = ">", precedes = "<", nbsp = "␣" }

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Preview substitutions
vim.opt.inccommand = "split"

-- Minimum lines to keep above and below cursor.
vim.opt.scrolloff = 8;

-- [[ Indentation Settings ]]

vim.o.smarttab = true
vim.opt.cpoptions:append("I")
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.breakindent = true

vim.o.undofile = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.number = true
vim.opt.signcolumn = "yes"
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.numberwidth = 2

vim.opt.cmdheight = 1
vim.opt.colorcolumn = "120"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.undofile = true
vim.opt.ruler = false

vim.o.updatetime = 250
vim.o.timeoutlen = 1000

vim.o.completeopt = "menu,preview,noselect"

vim.o.termguicolors = true

vim.api.nvim_create_autocmd("FileType", {
    desc = "Remove formatoptions",
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
})

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0

-- [[ Keymaps ]]
-- See `:help vim.keymap.set()`

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves Line Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves Line Up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Search Result" })

vim.keymap.set("n", "<leader><leader>[", "<cmd>bprev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader><leader>]", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader><leader>l", "<cmd>b#<CR>", { desc = "Last Buffer" })
vim.keymap.set("n", "<leader><leader>d", "<cmd>bdelete<CR>", { desc = "Delete Buffer" })

vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

vim.keymap.set("n", "[d]", function()
    vim.diagnostic.jump( { count = -1 })
end, { desc = "Previous Diagnostic Message" })
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
end, { desc = "Next Diagnostic Message" })

vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open Floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open Diagnostics List" })

vim.diagnostic.config({
    virtual_text = {
        prefix = "●", -- Could be '●', '▎', 'x'
    },
    severity_sort = true,
    float = {
        source = "if_many",
    },
})

vim.opt.clipboard = "unnamedplus"

vim.keymap.set(
    "i",
    "<C-p>",
    "<C-r><C-p>+",
    { noremap = true, silent = true, desc = "Paste from clipboard from within insert mode" })

vim.keymap.set("n", "<leader>mj", ":m .+1<CR>==", { desc = "Move selected lines down" })
vim.keymap.set("n", "<leader>mk", ":m .-2<CR>==", { desc = "Move selected lines up" })
vim.keymap.set("v", "<leader>mj", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down in visual mode" })
vim.keymap.set("v", "<leader>mk", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up in visual mode" })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set({"n", "v", "x"}, "<C-s>", "<cmd>w<CR><ESC>", { desc  = "Save File" })
