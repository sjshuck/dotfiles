-- Conditionally require module
local function try_require(module_name)
    local should_return_module, module = pcall(require, module_name)

    return function()
        if should_return_module then
            should_return_module = false -- only loop once
            return module
        end
    end
end

-- Ensure lazy.nvim
local lazy_nvim_path = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazy_nvim_path) then
    vim.fn.system {
        'git', 'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazy_nvim_path,
    }
end
vim.opt.rtp:prepend(lazy_nvim_path)

for lazy in try_require 'lazy' do
    lazy.setup {
        -- Colorschemes
        { 'Jzice/vim-colorschemes' },

        -- Status
        { 'vim-airline/vim-airline',
            init = function()
                vim.g.airline_powerline_fonts = true
            end,
        },
        { 'vim-airline/vim-airline-themes' },

        -- Adding color to all buffers based on content
        { 'ap/vim-css-color' },
        { 'powerman/vim-plugin-AnsiEsc' },

        -- General functionality
        { 'preservim/nerdtree',
            init = function()
                vim.g.NERDTreeWinSize = 40
                vim.g.NERDTreeShowHidden = true
            end,
        },
        { 'tpope/vim-fugitive' },
        { 'tpope/vim-abolish' },
        { 'sjshuck/vim-hs-sort-imports' },
        --'~/code/vim-hs-sort-imports',
        { 'iamcco/markdown-preview.nvim' }, -- must :call mkdp#util#install() once
        { 'chrisbra/unicode.vim' },

        -- LSP, completion
        { 'neovim/nvim-lspconfig' },
        { 'hrsh7th/nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp' },

        -- Syntax highlighting
        { 'OrangeT/vim-csharp' },
        { 'neovimhaskell/haskell-vim',
            init = function()
                vim.g.haskell_indent_disable = true
            end,
        },
        { 'purescript-contrib/purescript-vim',
            init = function()
                vim.g.purescript_unicode_conceal_enable = false
            end,
        },
        { 'vmchale/dhall-vim' },
        { 'udalov/kotlin-vim' },
        { 'elixir-editors/vim-elixir' },
        { 'hashivim/vim-terraform' },
        { 'vito-c/jq.vim' },
        { 'cespare/vim-toml' },
        { 'kongo2002/fsharp-vim' },
        { 'lnl7/vim-nix' },
        { 'idris-hackers/idris-vim' },
    }
end

vim.opt.termguicolors = true
vim.cmd 'colorscheme PaperColor'

vim.opt.background = 'dark'
vim.g.enable_bold_font = true
vim.g.enable_italic_font = true

vim.opt.splitright = true
vim.opt.number = true
vim.opt.colorcolumn = '81'

vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.mouse = 'a'

vim.cmd [[
    autocmd filetype ruby,yaml,html,xml set shiftwidth=2
    autocmd bufnewfile,bufread Jenkinsfile set filetype=groovy
    autocmd bufnewfile,bufread Dockerfile.* set filetype=dockerfile
    autocmd bufnewfile,bufread tsconfig.json set filetype=jsonc
    autocmd bufnewfile,bufread *.fsproj set filetype=xml
    autocmd bufnewfile,bufread * syntax sync fromstart
]]

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local function nmap(seq, what, opts)
    local all_opts = { noremap = true, silent = true }
    if opts then
        for k, v in pairs(opts) do all_opts[k] = v end
    end
    return vim.keymap.set('n', seq, what, all_opts)
end
nmap('<space>e', vim.diagnostic.open_float)
nmap('[d',       vim.diagnostic.goto_prev)
nmap(']d',       vim.diagnostic.goto_next)
nmap('<space>q', vim.diagnostic.setloclist)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function lsp_on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local nmap = function(seq, what)
        return nmap(seq, what, { buffer = bufnr })
    end
    nmap('gD',        vim.lsp.buf.declaration)
    nmap('gd',        vim.lsp.buf.definition)
    nmap('K',         vim.lsp.buf.hover)
    nmap('gi',        vim.lsp.buf.implementation)
    nmap('<C-k>',     vim.lsp.buf.signature_help)
    nmap('<space>wa', vim.lsp.buf.add_workspace_folder)
    nmap('<space>wr', vim.lsp.buf.remove_workspace_folder)
    nmap('<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end)
    nmap('<space>D',  vim.lsp.buf.type_definition)
    nmap('<space>rn', vim.lsp.buf.rename)
    nmap('<space>ca', vim.lsp.buf.code_action)
    nmap('gr',        vim.lsp.buf.references)
    nmap('<space>f',  vim.lsp.buf.formatting)
end
local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
}
local lsp_capabilities = nil
for cmp_nvim_lsp in try_require 'cmp_nvim_lsp' do
    lsp_capabilities = cmp_nvim_lsp.default_capabilities()
end

for lspconfig in try_require 'lspconfig' do
    local function lsp_server_setup(server, opts)
        local all_opts = {
            on_attach = lsp_on_attach,
            flags = lsp_flags,
            capabilities = lsp_capabilities,
        }
        if opts then
            for k, v in pairs(opts) do all_opts[k] = v end
        end
        return lspconfig[server].setup(all_opts)
    end
    lsp_server_setup 'bashls'
    lsp_server_setup 'dhall_lsp_server'
    lsp_server_setup 'fsautocomplete'
    lsp_server_setup 'hls'
    lsp_server_setup 'kotlin_language_server'
    lsp_server_setup 'lua_ls'
    lsp_server_setup 'nixd'
    lsp_server_setup 'purescriptls'
    lsp_server_setup 'pyright'
    lsp_server_setup 'terraformls'
    lsp_server_setup 'tsserver'
end

for cmp in try_require 'cmp' do
    cmp.setup {
        mapping = cmp.mapping.preset.insert {
            ['<C-n>'] = cmp.mapping.select_next_item(),
            ['<C-p>'] = cmp.mapping.select_prev_item(),
        },
        sources = cmp.config.sources {
            { name = 'nvim_lsp' },
        },
    }
end
