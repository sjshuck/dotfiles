local packer = require 'packer'

packer.startup(function(use)
    -- Packer itself
    use 'wbthomason/packer.nvim'

    -- Colorschemes
    use 'flazz/vim-colorschemes'

    -- Status
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'

    -- Adding color to all buffers based on content
    use 'ap/vim-css-color'
    use 'powerman/vim-plugin-AnsiEsc'

    -- General functionality
    use 'preservim/nerdtree'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-abolish'
    use 'sjshuck/vim-hs-sort-imports'
    --use '~/code/vim-hs-sort-imports'

    -- LSP
    use 'neovim/nvim-lspconfig'

    -- Syntax highlighting
    use 'OrangeT/vim-csharp'
    use 'neovimhaskell/haskell-vim'
    use 'purescript-contrib/purescript-vim'
    use 'vmchale/dhall-vim'
    use 'udalov/kotlin-vim'
    use 'elixir-editors/vim-elixir'
    use 'hashivim/vim-terraform'
    use 'vito-c/jq.vim'
    use 'cespare/vim-toml'
    use 'kongo2002/fsharp-vim'
    use 'lnl7/vim-nix'
    use 'idris-hackers/idris-vim'
end)

vim.opt.termguicolors = true

vim.cmd 'colorscheme PaperColor'
vim.opt.background = 'light'
vim.g.enable_bold_font = true
vim.g.enable_italic_font = true
vim.g.airline_powerline_fonts = true

vim.opt.splitright = true
vim.opt.number = true
vim.opt.colorcolumn = '81'

vim.g.NERDTreeWinSize = 60

vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.g.haskell_indent_disable = true

vim.opt.mouse = 'a'

vim.cmd [[
    autocmd filetype ruby,yaml,html,xml set shiftwidth=2
    autocmd bufnewfile,bufread Jenkinsfile set filetype=groovy
    autocmd bufnewfile,bufread Dockerfile.* set filetype=dockerfile
    autocmd bufnewfile,bufread tsconfig.json set filetype=jsonc
    autocmd bufnewfile,bufread *.fsproj set filetype=xml
    autocmd bufnewfile,bufread * syntax sync fromstart
]]

local lspconfig = require 'lspconfig'

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local function set_diagnostic_mappings()
    local opts = {noremap = true, silent = true}
    local function nmap(seq, what)
        return vim.keymap.set('n', seq, what, opts)
    end
    nmap('<space>e', vim.diagnostic.open_float)
    nmap('[d',       vim.diagnostic.goto_prev)
    nmap(']d',       vim.diagnostic.goto_next)
    nmap('<space>q', vim.diagnostic.setloclist)
end
set_diagnostic_mappings()

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local function on_attach(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
    local function nmap(seq, what)
        return vim.keymap.set('n', seq, what, bufopts)
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

local function lsp_server_setup(server, opts)
    local all_opts = {on_attach = on_attach, flags = lsp_flags}
    if opts then
        for k, v in pairs(opts) do
            all_opts[k] = v
        end
    end
    return lspconfig[server].setup(all_opts)
end

lsp_server_setup 'hls'
lsp_server_setup 'pyright'
lsp_server_setup 'terraformls'
lsp_server_setup 'tsserver'