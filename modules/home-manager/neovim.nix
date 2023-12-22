{ pkgs, ... }:
{
  programs.neovim = { 
    enable = true;
    extraLuaConfig = ''
    local opt = vim.opt

    -- Tabs / Indentation
    opt.tabstop = 2
    opt.shiftwidth = 2
    opt.softtabstop = 2
    opt.expandtab = true
    opt.smartindent = true
    opt.wrap = false

    -- Search
    opt.incsearch = true
    opt.ignorecase = true
    opt.smartcase = true
    opt.hlsearch = false

    -- Appearance
    opt.number = true
    opt.relativenumber = true
    opt.termguicolors = true
    opt.signcolumn = "yes"
    opt.cmdheight = 1
    opt.scrolloff = 10
    opt.completeopt = "menuone,noinsert,noselect"

    -- Behavior
    opt.hidden = true
    opt.errorbells = false
    opt.swapfile = false
    opt.backup = false
    opt.undodir = vim.fn.expand("~/.nvim/undodir")
    opt.undofile = true
    opt.backspace = "indent,eol,start"
    opt.splitright = true
    opt.splitbelow = true
    opt.autochdir = false
    opt.iskeyword:append("-")
    opt.mouse:append("a")
    opt.clipboard:append("unnamedplus")
    opt.modifiable = true
    opt.encoding = "UTF-8"

    vim.g.mapleader = " "
    vim.g.maplocalleader = " "

    local keymap = vim.keymap;
    keymap.set("n", "<leader>fk", ":Telescope keymaps<CR>")
    keymap.set("n", "<leader>fh", ":Telescope help_tags<CR>")
    keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
    keymap.set("n", "<leader>fa", ":Telescope <CR>")
    keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
    keymap.set("n", "<leader>fb", ":Telescope buffers<CR>")
    local default_opts = { noremap = true, silent = true};

    -- Buffer Navigation
    keymap.set('n', "<leader>bn", ":bnext<CR>", default_opts) -- Next buffer
    keymap.set('n', "<leader>bp", ":bprevious<CR>", default_opts) -- Prev buffer

    -- Directory Navigation
    keymap.set('n', "<leader>m", ":NvimTreeFocus<CR>", default_opts)
    keymap.set('n', "<leader>e", ":NvimTreeToggle<CR>", default_opts)

    -- Pane and Window Navigation
    keymap.set('n', "<C-h>", "<C-w>h", default_opts) -- Navigate Left
    keymap.set('n', "<C-j>", "<C-w>j", default_opts) -- Navigate Down
    keymap.set('n', "<C-k>", "<C-w>k", default_opts) -- Navigate Up
    keymap.set('n', "<C-l>", "<C-w>l", default_opts) -- Navigate Right

    -- Window Management
    keymap.set('n', "<leader>lg", ":LazyGit<CR>", default_opts) -- Opens LazyGit

    -- Indenting
    keymap.set('v', "<", "<gv") -- Shift Indentation to Left
    keymap.set('v', ">", ">gv") -- Shift Indentation to Right

    local api = vim.api

    -- Zen Mode
    keymap.set('n', "<leader>zm", ":ZenMode<CR>", default_opts) -- Opens ZenMode

    local lspConfig = {};
    lspConfig.on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }

      keymap.set('n', "<leader>fd", ":Lspsaga finder<CR>", opts) -- go to definition
      keymap.set('n', "<leader>gd", ":Lspsaga peek_definition<CR>", opts) -- peek definition
      keymap.set('n', "<leader>gD", ":Lspsaga goto_definition<CR>", opts) -- go to definition
      keymap.set('n', "<leader>ca", ":Lspsaga code_action<CR>", opts) -- see available code actions
      keymap.set('n', "<leader>rn", ":Lspsaga rename<CR>", opts) -- smart rename
      keymap.set('n', "<leader>D", ":Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
      keymap.set('n', "<leader>d", ":Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
      keymap.set('n', "<leader>pd", ":Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to prev diagnostic in buffer
      keymap.set('n', "<leader>nd", ":Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
      keymap.set('n', "K", ":Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor

      if client.name == "pyright" then
        keymap.set('n', "<Leader>oi", ":PyrightOrganizeImports<CR>",  opts)
      end
    end

    lspConfig.diagnostic_signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = "" }


    ----------------- auto cmds -------------------
      -- auto-format on save
      local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
          group = lsp_fmt_group,
          callback = function()
          local efm = vim.lsp.get_active_clients({ name = "efm" })

          if vim.tbl_isempty(efm) then
          return
          end

          vim.lsp.buf.format({ name = "efm", async = true })
          end,
          })
    -------------------------------------------------------------------
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      require("luasnip/loaders/from_vscode").lazy_load()
      luasnip.config.setup({})

      vim.opt.completeopt = "menu,menuone,noselect"

      cmp.setup({
          snippet = {
          expand = function(args)
          luasnip.lsp_expand(args.body)
          end,
          },
          mapping = cmp.mapping.preset.insert({
              ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
              ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
              ["<C-e>"] = cmp.mapping.abort(), -- close completion window
              ["<CR>"] = cmp.mapping.confirm({ select = false }),
              }),
          -- sources for autocompletion
          sources = cmp.config.sources({
              { name = "nvim_lsp" }, -- lsp
              { name = "luasnip" }, -- snippets
              { name = "buffer" }, -- text within current buffer
              { name = "path" }, -- file system paths
              }),
          -- configure lspkind for vs-code like icons
            formatting = {
              format = lspkind.cmp_format({
                  maxwidth = 50,
                  ellipsis_char = "...",
                  }),
            },
      })
    --------------------------------------------------------------------

      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local lspcon = require("lspconfig")

      for type, icon in pairs(lspConfig.diagnostic_signs) do
        local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

          local capabilities = cmp_nvim_lsp.default_capabilities()
          lspcon.lua_ls.setup({
              capabilities = capabilities,
              on_attach = lspConfig.on_attach,
              settings = { -- custom settings for lua
              Lua = {
              -- make the language server recognize "vim" global
              diagnostics = {
              globals = { "vim" },
              },
              workspace = {
              -- make language server aware of runtime files
              library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
              },
              },
              },
              },
              });

    lspcon.rnix.setup({capabilities = capabilities, on_attach = lspConfig.on_attach})

    local stylua = require("efmls-configs.formatters.stylua")
    local luacheck = require("efmls-configs.linters.luacheck")

    lspcon.efm.setup({
        filetypes = {
        "lua",
        },
        init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        hover = true,
        documentSymbol = true,
        codeAction = true,
        completion = true,
        },
        settings = {
        languages = {
        lua = { luacheck, stylua },
        },
        },
        })



    for _, v in ipairs({
        "Normal",
        "NormalNC",
        "Comment",
        "Constant",
        "Special",
        "Identifier",
        "Statement",
        "PreProc",
        "Type",
        "Underlined",
        "Todo",
        "String",
        "Function",
        "Conditional",
        "Repeat",
        "Operator",
        "Structure",
        "LineNr",
        "NonText",
        "SignColumn",
        "CursorLineNr",
        "EndOfBuffer",
        "InsertEnter",
        "CursorLine",
        "NormalFloat",
        "TablineFill",
        "NvimTreeNormal",
        "WhichKeyFloat",
    }) do api.nvim_set_hl(0, v, {bg = "none"}) end

    '';
    plugins = 
      with pkgs.vimPlugins; [
      { plugin = oxocarbon-nvim;
        config = ''
          lua vim.cmd.colorscheme("oxocarbon")
          '';
      }
    {
      plugin = nvim-tree-lua;
      config = ''
        packadd! nvim-tree.lua
        lua require 'nvim-tree'.setup({filters = {dotfiles = false}})
        '';
    }
    {
      plugin = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [ p.lua p.markdown p.markdown_inline p.nix ]));
      config = ''
        lua require 'nvim-treesitter.configs'.setup({build = ":TSUpdate", event = { "BufReadPre", "BufNewFile", }, highlight = {enable = true, additional_vim_regex_highlighting = true}})
        '';
    }
    {
      plugin =  which-key-nvim;
      config = ''
        lua require 'which-key'.setup()
        '';
    }
    {
      plugin = lualine-nvim;
      config = ''
        lua require 'lualine'.setup({options = {theme = require('lualine.themes.iceberg_dark')}})
        '';
    }
    { plugin = telescope-nvim;

      config = ''
        lua require 'telescope'.setup({defaults = {mappings = {i = {["<C-j>"] = "move_selection_next",["<C-k>"] = "move_selection_previous",},},},pickers = {find_files = {theme = "dropdown",previewer = false,hidden = true,},live_grep = {theme = "dropdown",previewer = false,},find_buffers = {theme = "dropdown",previewer = false,},},})
        '';
    }
    {
      plugin = mason-nvim;
      config = ''
        lua require 'mason'.setup({event = "BufReadPre", ui = {icons = {package_instlled = '✓', package_pending = '➜', package_uninstalled = '✗'}}})
        '';
    }
    {
      plugin = mason-lspconfig-nvim;
      config = ''
        lua require 'mason-lspconfig'.setup({event = "BufReadPre"})
        '';
    }
    {
      plugin = lspsaga-nvim;
      config = ''
        lua require 'lspsaga'.setup({move_in_saga = { prev = "<C-k>", next = "<C-j>" }, finder_action_keys = {open = "<CR>"}, definition_action_keys = {edit = "<CR>"}})
        '';
    }
    {
      plugin = comment-nvim;
      config = ''
        lua require 'Comment'.setup()
        '';
    }
    nvim-lspconfig
    cmp-buffer
    nvim-autopairs
    efmls-configs-nvim
    nvim-cmp
    luasnip
    lspkind-nvim
    cmp_luasnip
    cmp-nvim-lsp
    markdown-preview-nvim
    vim-illuminate
    plenary-nvim
    vim-highlightedyank
    nvim-web-devicons
    presence-nvim
    lazygit-nvim
    zen-mode-nvim
    { plugin = indent-blankline-nvim;
      config = ''
        lua require 'ibl'.setup()
        '';
    }
    {
      plugin = nvim-surround;
      config = ''
        lua require 'nvim-surround'.setup({});
      '';
    }
    ];
  };


  programs.ripgrep.enable = true; # Required for file searching

  programs.lazygit = { 
    enable = true;
    settings = { 
      lightTheme = false;
    };
  };

}
