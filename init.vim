" ========= Core =========
set number
set encoding=utf-8
set termguicolors " Recommended for true color support in the terminal

" Disable netrw to use nvim-tree instead
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1

" Use Neovim's default plug dir
call plug#begin(stdpath('data') . '/plugged')

" Theme (works on NVIM)
Plug 'junegunn/seoul256.vim'

" start page
Plug 'goolord/alpha-nvim'


" General complete
Plug 'f3fora/cmp-spell'

" Better statusline (Neovim-native)
Plug 'nvim-lualine/lualine.nvim'

" Icons (Neovim-native)
Plug 'nvim-tree/nvim-web-devicons'

" File explorer (replace NERDTree)
Plug 'nvim-tree/nvim-tree.lua'

" Fuzzy finder (replace fzf)
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim' " telescope dep

" Treesitter (better syntax/AST)
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }

" LSP + helpers (replace coc/ale/gutentags/tagbar)
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'stevearc/aerial.nvim' " replace vista.vim

" C++ niceties that still work well
Plug 'andymass/vim-matchup' " enhanced % matching
Plug 'tpope/vim-commentary' " gcc to comment
Plug 'tpope/vim-projectionist' " alt file switching
Plug 'tpope/vim-dispatch' " async builds
Plug 'vim-test/vim-test' " tests runner
Plug 'stevearc/conform.nvim' " format code

" Completion engine
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" LSP support
Plug 'neovim/nvim-lspconfig'


" Markdown (kept; all NVIM-friendly)
Plug 'plasticboy/vim-markdown'
Plug 'godlygeek/tabular'
Plug 'masukomi/vim-markdown-folding'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install', 'for': 'markdown' }
Plug 'dhruvasagar/vim-table-mode'
Plug 'mzlogin/vim-markdown-toc', { 'do': 'make install' }
Plug 'reedes/vim-pencil'
Plug 'junegunn/goyo.vim'

call plug#end()

" ======= UI =======
silent! colorscheme seoul256
nnoremap <expr> p (v:register == '"' ? '"0p' : 'p')
nnoremap <expr> P (v:register == '"' ? '"0P' : 'P')

" ======= Telescope =======
nnoremap <leader>ff :Telescope find_files<CR>
nnoremap <leader>fg :Telescope live_grep<CR>
nnoremap <leader>fb :Telescope buffers<CR>
nnoremap <leader>fh :Telescope help_tags<CR>

" ======= nvim-tree =======
" ======= nvim-tree =======
nnoremap <leader>e :NvimTreeToggle<CR>

lua << EOF
-- nvim-tree setup
require("nvim-tree").setup({
  -- Do not show gitignored files
  filters = {
    custom = { ".git", "node_modules", ".cache" },
  },
  -- Show git status icons
  git = {
    enable = true,
    ignore = false,
  },
  -- How the tree is rendered
  renderer = {
    -- Show icons for files and folders
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
    },
  },
  -- Close nvim-tree when a file is opened
  actions = {
    open_file = {
      quit_on_open =false,
    },
  },
  -- Set width of the sidebar
  view = {
    width = 35,
  },
})
EOF
" ======= lualine =======
lua << EOF
require('lualine').setup({})
EOF

" ======= Treesitter (FIXED Indentation/Syntax) =======
lua << EOF
require('nvim-treesitter.configs').setup({
ensure_installed = { "c", "cpp", "cmake", "python", "lua", "markdown", "markdown_inline" },
highlight = { enable = true },
incremental_selection = { enable = true },
indent = { enable = true },
})
EOF

" ======= LSP (clangd) + Aerial (structure outline) (FIXED: Using Mason handlers for custom config) =======
lua << EOF
-- Load lspconfig once to get server definitions
local lspconfig = require('lspconfig')

require('mason').setup()
require('mason-lspconfig').setup({
ensure_installed = { 'clangd' },

-- Configure custom options using the 'handlers' table.
-- This ensures mason handles the installation while we apply custom lspconfig setup.
handlers = {
    -- Set custom configuration for clangd
    clangd = function ()
        -- We use the lspconfig object here to access the clangd definition
        lspconfig.clangd.setup({
            cmd = { "clangd" },
            capabilities = vim.lsp.protocol.make_client_capabilities(),
        })
    end,
    
    -- Fallback: Use the default setup for all other language servers managed by Mason
    ['*'] = function (server_name)
        lspconfig[server_name].setup({})
    end,
}

})


-- Enhanced Aerial configuration to show both members and methods
require('aerial').setup({
  backends = { "lsp", "treesitter", "markdown" },
  layout = { 
    default_direction = "right", 
    min_width = 28,
    max_width = 0.4,  -- Allow it to grow if needed
  },
  manage_folds = false,
  
  -- Explicitly include all symbol kinds (including members and methods)
  filter_kind = {
    "Class",
    "Constructor", 
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Method",
    "Struct",
    "Variable",     -- This includes member variables
    "Field",        -- This includes struct/class fields
    "Property",     -- This includes properties
    "Constant",
    "Namespace",
    "Object",
    "Key",
    "Array",
    "Boolean",
    "Number",
    "String",
  },
  
  -- Show guides for better visual hierarchy
  show_guides = true,
  guides = {
    mid_item = "├─",
    last_item = "└─",
    nested_top = "│ ",
    whitespace = "  ",
  },
  
  -- Highlight the symbol under cursor
  highlight_on_hover = true,
  highlight_on_jump = 300,  -- ms to highlight after jumping
  
  -- Auto-open aerial for C/C++ files
  on_attach = function(bufnr)
    local filetype = vim.bo[bufnr].filetype
    if filetype == "c" or filetype == "cpp" then
      vim.cmd("AerialOpen!")
    end
  end,
  
  -- Keymaps when aerial window is focused
  keymaps = {
    ["?"] = "actions.show_help",
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.jump",
    ["<2-LeftMouse>"] = "actions.jump",
    ["<C-v>"] = "actions.jump_vsplit",
    ["<C-s>"] = "actions.jump_split",
    ["p"] = "actions.scroll",
    ["<C-j>"] = "actions.down_and_scroll",
    ["<C-k>"] = "actions.up_and_scroll",
    ["{"] = "actions.prev",
    ["}"] = "actions.next",
    ["[["] = "actions.prev_up",
    ["]]"] = "actions.next_up",
    ["q"] = "actions.close",
    ["o"] = "actions.tree_toggle",
    ["za"] = "actions.tree_toggle",
    ["O"] = "actions.tree_toggle_recursive",
    ["zA"] = "actions.tree_toggle_recursive",
    ["l"] = "actions.tree_open",
    ["zo"] = "actions.tree_open",
    ["L"] = "actions.tree_open_recursive",
    ["zO"] = "actions.tree_open_recursive",
    ["h"] = "actions.tree_close",
    ["zc"] = "actions.tree_close",
    ["H"] = "actions.tree_close_recursive",
    ["zC"] = "actions.tree_close_recursive",
    ["zr"] = "actions.tree_increase_fold_level",
    ["zR"] = "actions.tree_open_all",
    ["zm"] = "actions.tree_decrease_fold_level",
    ["zM"] = "actions.tree_close_all",
    ["zx"] = "actions.tree_sync_folds",
    ["zX"] = "actions.tree_sync_folds",
  },
})

EOF
" Toggle outline (F9)
nnoremap <F9> :AerialToggle!<CR>


" ======= Formatter (conform.nvim) =======
lua << EOF
require('conform').setup({
  -- This is where you configure formatters for each file type
  formatters_by_ft = {
    cpp = { "clang_format_google" },
    c = { "clang_format_google" },
    -- You can add other formatters here, e.g., lua = { "stylua" }
  },

  -- This section replaces your "let g:formatdef_..." line.
  -- We are defining a new, custom formatter named "clang_format_google".
  formatters = {
    clang_format_google = {
      -- The command to run.
      command = "clang-format",
      -- The arguments to pass, including your desired style.
      args = { "--style=Google" },
    },
  },

  -- This enables auto-formatting every time you save a file.
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
})
EOF

" STEP 1: Define the command
command! Format lua require('conform').format()

" STEP 2: Create the shortcut
nnoremap <leader>f :Format<CR>


" ======= Start page (alpha.nvim) =======
lua << EOF
require'alpha'.setup(require'alpha.themes.dashboard'.config)
EOF


" ======= Start page (alpha.nvim) =======
lua << EOF
local cmp = require'cmp'

cmp.setup {
  snippet = {
    expand = function(args)
      require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'spell' },   -- ✅ spell suggestions for writing
  }, {
    { name = 'buffer' },
    { name = 'path' },
  })
}

-- Setup LSP for C++
-- Setup LSP for C++ (new API, Neovim 0.11+)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config("clangd", {
  capabilities = capabilities,
})

vim.lsp.enable("clangd")
-- Enable spell checking for English
vim.opt.spell = true
vim.opt.spelllang = { 'en_gb' }
EOF

