-- Teste edit
-- Configurações básicas de visualização
vim.opt.number = true           -- Ativa os números das linhas [8-10]
vim.opt.relativenumber = true   -- Ativa números relativos (excelente para navegação rápida) [8, 10, 11]
vim.opt.cursorline = true       -- Destaca visualmente a linha onde o cursor está [8, 9, 11]

-- Configurações de tabulação (indentação)
vim.opt.tabstop = 4             -- Largura visual de um Tab (ajuste para 2 ou 4 conforme preferir) [8, 9]
vim.opt.shiftwidth = 4          -- Quantidade de espaços para indentação automática [8, 9, 12]
vim.opt.expandtab = true        -- Converte a tecla Tab em espaços [8, 9, 12]
vim.opt.smartindent = true      -- Indentação inteligente ao criar novas linhas [8, 9, 11]

-- Tecla Leader
vim.g.mapleader = " "           -- Define a tecla Espaço como tecla Leader (essencial para atalhos) [8, 11, 13]

vim.opt.clipboard = "unnamedplus"
-- ========================================================
-- Gerenciando Plugins Nativamente com vim.pack (Nvim 0.12+)
-- ========================================================
vim.pack.add({
  -- Tema Visual (ex: Tokyonight para deixar o editor bonito)
  { src = 'https://github.com/folke/tokyonight.nvim' },

  -- Configurações nativas de LSP (nvim-lspconfig)
  { src = 'https://github.com/neovim/nvim-lspconfig' },

  -- O instalador portátil de servidores (Mason)
  { src = 'https://github.com/williamboman/mason.nvim' },

  -- A ponte entre o Mason e as configurações nativas do Neovim
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },

  -- ========================================================
  -- Dependências Compartilhadas (Essenciais)
  -- ========================================================
  "https://github.com/nvim-lua/plenary.nvim",       -- Utilitários para busca e arquivos [cite: 130, 170]
  "https://github.com/MunifTanjim/nui.nvim",         -- Componentes de UI (usado pelo Neo-tree) [cite: 130]
  "https://github.com/nvim-tree/nvim-web-devicons", -- Ícones elegantes para arquivos e pastas [cite: 130, 171]

  -- ========================================================
  -- Barra Lateral (Neo-tree)
  -- ========================================================
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3') -- Garante estabilidade na versão 3 [cite: 131]
  },

  -- ========================================================
  -- Fuzzy Finder (Telescope)
  -- ========================================================
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
  
  { src = 'https://github.com/akinsho/bufferline.nvim' },
})


-- ========================================================
-- Ativação pós-carregamento
-- ========================================================
-- Uma vez adicionado no vim.pack, você pode carregar o tema visual normalmente
vim.cmd([[colorscheme tokyonight]])


-- Inicializar o Mason [10]
require("mason").setup({
  ui = {
    border = "rounded",
  }
})

-- Inicializar a ponte com Ativação Automática Nativa [8]
require("mason-lspconfig").setup({
  -- Lista de servidores que você quer garantir que o Mason instale automaticamente [11]
  ensure_installed = {
    "ts_ls",          -- TypeScript/JavaScript
    "basedpyright",   -- Python
    "gopls",          -- Go
    "omnisharp",      -- C#
    "lua_ls",         -- Lua
    "cssls",          -- CSS
    "html",           -- HTML
  },
  -- Ativa automaticamente via vim.lsp.enable() todos os servidores instalados [7, 12]
  automatic_enable = true 
})


vim.diagnostic.config({
  virtual_text = false, -- Desativa o texto "fantasma" que fica ao lado do código
  severity_sort = true, -- Ordena os problemas por gravidade (Erros antes de Warnings)
  float = {
    border = 'rounded', -- Deixa as janelas flutuantes com bordas arredondadas
    source = 'always',  -- Mostra qual LSP gerou aquele warning (ex: lua_ls)
  },
})

require('telescope').setup({
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = "❯ ",
    path_display = { "truncate" }, -- Trunca caminhos muito longos
     file_ignore_patterns = {
      "node_modules/",
      "%.git/",
      "target/",
      "build/"
    },
  },
  pickers = {
    find_files = {
      hidden = true,     -- Inclui arquivos ocultos (ex: .config, .env, .bashrc) [3, 4]
      no_ignore = true,  -- Busca arquivos mesmo que estejam listados no .gitignore [3, 4]
    },
  },
})

require("neo-tree").setup({
    window = {
        position = "right"
    },
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,      -- Show hidden files
            hide_gitignored = false,    -- Show git-ignored files
        }
    },
    event_handlers = {

          {
            event = "file_open_requested",
            handler = function()
              -- auto close
              -- vim.cmd("Neotree close")
              -- OR
              require("neo-tree.command").execute({ action = "close" })
            end
          },

        },
})

-- ========================================================
-- Atalhos Ergonômicos (Keymaps)
-- ========================================================

-- Atalho para abrir/fechar a Barra Lateral (Neo-tree)
vim.keymap.set('n', '<leader>e', '<cmd>Neotree toggle right<CR>', { desc = 'Alternar barra lateral de arquivos' })

-- Atalhos para busca inteligente (Telescope)
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Fuzzy find: Arquivos no projeto' })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Fuzzy find: Buscar palavra no projeto' })
vim.keymap.set('n', '<leader>fb', function() require('telescope.builtin').buffers() end, { desc = 'Fuzzy find: Alternar entre arquivos abertos' })
vim.keymap.set('n', '<leader>fh', function() require('telescope.builtin').help_tags() end, { desc = 'Fuzzy find: Buscar ajuda do Neovim' })

require("bufferline").setup({
  options = {
    mode = "buffers",            -- Garante que ele mostre os arquivos abertos como abas [cite: 101, 102]
    always_show_bufferline = true, 
    separator_style = "thin",    -- Estilo elegante e fino de divisória
    show_buffer_close_icons = true,
    show_close_icon = true,
  }
})

-- ========================================================
-- Salvamento Automático (Auto-Save estilo VS Code)
-- ========================================================
local auto_save_group = vim.api.nvim_create_augroup("VSCodeAutoSave", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost" }, {
  group = auto_save_group,
  pattern = "*",
  callback = function()
    -- Condições de segurança para o salvamento automático:
    -- 1. vim.bo.modified: Só tenta salvar se o arquivo realmente tiver alterações [cite: 75]
    -- 2. vim.bo.buftype == "": Evita tentar salvar buffers de plugins (como Neo-tree ou Telescope)
    -- 3. file ~= "": Evita tentar salvar buffers novos que ainda não têm nome no disco
    local file = vim.api.nvim_buf_get_name(0)
    if vim.bo.modified and vim.bo.buftype == "" and file ~= "" then
      vim.cmd("silent! write")
    end
  end,
})

