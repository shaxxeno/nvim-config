-- Basic settings
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.spelllang = "en_gb"

-- Leader (this is here so plugins etc pick it up)
vim.g.mapleader = " "  -- anywhere you see <leader> means hit space

-- use nvim-tree instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Use system clipboard
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Display settings
vim.opt.termguicolors = true
vim.o.background = "dark" -- set to "dark" for dark theme

-- Scrolling and UI settings
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8

-- Title
vim.opt.title = true
vim.opt.titlestring = "nvim"

-- Persist undo (persists your undo history between sessions)
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

-- Tab stuff
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search configuration
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- open new split panes to right and below (as you probably expect)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- LSP
vim.lsp.inlay_hint.enable(true)

-- -----------------------------------------------------------------------------------------------
-- Plugin list
-- -----------------------------------------------------------------------------------------------
local plugins = {
  { "nvim-lua/plenary.nvim" },                             -- used by several other plugins
  { "sainnhe/everforest" },                                -- Gruvbox theme (feel free to choose another!)
  { "nvim-tree/nvim-web-devicons",         lazy = true },  -- used by lualine and nvim-tree
  { "nvim-lualine/lualine.nvim" },                         -- Status line
  { "nvim-tree/nvim-tree.lua" },                           -- File browser
  { "rmagatti/auto-session" },                             -- Recover Session

  -- Telescope command menu
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  
  -- TreeSitter
  { "nvim-treesitter/nvim-treesitter", priority = 1000, build = ":TSUpdate" },
  
  -- LSP
  { 'mason-org/mason.nvim' },                      -- installs LSP servers
  { 'neovim/nvim-lspconfig' },                     -- configures LSPs
  { 'mason-org/mason-lspconfig.nvim' },            -- links installed to configured
  { 'stevearc/conform.nvim' },                     -- Formatting where the LSP doesn't
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = {
        ['<CR>'] = { 'select_and_accept', 'fallback' }, 
        ['<Tab>'] = { 'select_and_accept', 'fallback' }, 
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
      },
    },
    opts_extend = { "sources.default" }
  },

  -- Git integration plugins
  { "lewis6991/gitsigns.nvim" },

  -- Lazygit
  { "kdheepak/lazygit.nvim" }
}

-- -----------------------------------------------------------------------------------------------
-- Plugin installation
-- -----------------------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup(plugins)


-- -----------------------------------------------------------------------------------------------
-- Theme
-- -----------------------------------------------------------------------------------------------
vim.g.everforest_background = "hard"  -- "hard", "medium", or "soft"
vim.cmd.colorscheme("everforest")

-- -----------------------------------------------------------------------------------------------
-- Plugin config
-- -----------------------------------------------------------------------------------------------
require("lualine").setup()      -- the status line
require("nvim-tree").setup()    -- the tree file browser panel
require("telescope").setup()    -- command menu
require("auto-session").setup({
    log_level = "error",
    auto_save_enabled = true,
    auto_restore_enabled = true,
})

-- -----------------------------------------------------------------------------------------------
-- Treesitter (syntax highlighting and related stuff!)
-- -----------------------------------------------------------------------------------------------
-- NB: Make sure to add more from this list!
-- https://github.com/nvim-treesitter/nvim-treesitter/tree/master#supported-languages
require("nvim-treesitter.configs").setup({
  ensure_installed = { "typescript", "python"},
  sync_install = false,
  auto_install = true,
  highlight = { enable = true, },
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99

-- -----------------------------------------------------------------------------------------------
-- LSP
-- -----------------------------------------------------------------------------------------------
-- NB: These will FAIL if you don't have the language toolchains installed!
-- NB: Make sure to add more from this list!
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
require("mason").setup()
require("mason-lspconfig").setup({ 
  ensure_installed = { 
    "ruff", 
    "basedpyright",  
    "eslint", 
    "yamlls", 
    "dockerls", 
    "docker_compose_language_service", 
    "bashls", 
    "sqlls", 
    "sqls", 
    "jsonls", 
    "marksman", 
    "terraformls" 
  } 
})

vim.lsp.config("basedpyright", {settings = {basedpyright = {analysis = {typeCheckingMode = "basic"}}}})

require("conform").setup({
  default_format_opts = { 
    lsp_format = "fallback",
    async = false,
    timeout_ms = 5000,
  },
  formatters_by_ft = {
    python = { "ruff_format" },
    lua = { "stylua" },
    yaml = { "prettier" },
    json = { "prettier" },
    markdown = { "prettier" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    sql = { "sqlfluff" },
    ["yaml.github-actions"] = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
  },
  
  format_on_save = {
    timeout_ms = 5000,
    lsp_fallback = true,
  },
  
  formatters = {
    ruff_format = {
      command = "ruff",
      args = { "format", "-" },
    },
  },
})

-- -----------------------------------------------------------------------------------------------
-- Keymap settings
-- -----------------------------------------------------------------------------------------------
-- Basic keys
vim.keymap.set("n", "<space>", ":")  -- hit <space> to start a command, quicker than :
vim.keymap.set("n", "q", "<C-r>")    -- "u" is undo, I map "q" to redo

-- Search navigation
-- n is always forward, N is always backward
-- ' is now forward and ; is backward
vim.keymap.set("n", "n", "v:searchforward ? 'n' : 'N'", { expr = true })
vim.keymap.set("n", "N", "v:searchforward ? 'N' : 'n'", { expr = true })
vim.keymap.set({ "n", "v" }, ";", "getcharsearch().forward ? ',' : ';'", { expr = true })
vim.keymap.set({ "n", "v" }, "'", "getcharsearch().forward ? ';' : ','", { expr = true })

-- toggle line numbers and wrap
vim.keymap.set("n", "<leader>n", ":set nonumber! relativenumber!<CR>")
vim.keymap.set("n", "<leader>w", ":set wrap! wrap?<CR>")

-- Moving between splits and resizing
vim.keymap.set("n", "<C-j>", "<C-W><C-J>")  -- use Ctrl-j (and so on) to move between splits
vim.keymap.set("n", "<C-k>", "<C-W><C-K>")
vim.keymap.set("n", "<C-l>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- Nvim-tree toggle function
local function toggle_nvim_tree()
  local nvimtree = require("nvim-tree.api")
  nvimtree.tree.toggle()
end

vim.keymap.set("n", "<A-t>", toggle_nvim_tree, { desc = "Toggle NvimTree" })

-- Formatting
vim.keymap.set("v", "<leader>fr", function()
  local conform = require("conform")
  conform.format({ lsp_fallback = true })
  vim.cmd.write()
end, { desc = "Format selection" })

local tele_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tele_builtin.git_files, {})  -- ,ff to find git files
vim.keymap.set("n", "<leader>fa", tele_builtin.find_files, {}) -- ,fa to find any files
vim.keymap.set("n", "<leader>fg", tele_builtin.live_grep, {})  -- ,fg to ripgrep
vim.keymap.set("n", "<leader>fb", tele_builtin.buffers, {})    -- ,fb to see recent buffers
vim.keymap.set("n", "<leader>fh", tele_builtin.help_tags, {})  -- ,fh to search help


-- Diagnostics
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = "Show error under cursor" })
vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, { desc = "Go to next error" })
vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, { desc = "Go to previous error" })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = "Show all errors in list" })

-- Tab management
vim.keymap.set("n", "tp", ":tabnext<CR>", { desc = "Go to next tab" })
vim.keymap.set("n", "to", ":tabprev<CR>", { desc = "Go to previous tab" })
vim.keymap.set("n", "tn", ":tabnew<CR>", { desc = "Create new tab" })
vim.keymap.set("n", "tx", ":tabclose<CR>", { desc = "Close current tab" })

-- Telescope git keymaps
vim.keymap.set("n", "<leader>gs", tele_builtin.git_status, { desc = "Git status" })

-- Lazygit
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { desc = "Open LazyGit" })


-- Gitsigns
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle line blame" })
