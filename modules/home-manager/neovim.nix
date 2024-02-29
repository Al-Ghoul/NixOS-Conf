{ nixvim, pkgs, ... }: {

  programs = {
    nixvim = {
      enable = true;
      # NOTE: Remove dap's configurations if you're willing to remove plugins.dap 
      extraConfigLua = ''
        --[[
        Well since nixvim dap's configurations option turning everything into 
        a lua object, with values strictly turned to strings I have to set some options manually like
        lldb's program option (it has to be a lua function)
        ]] --
          local dap = require("dap");
          dap.configurations.cpp = { 
            {
              name = "Launch",
              type = "lldb",
              request = "launch",
              program = function()
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. '/', "file")
              end,
              cwd = "''${workspaceFolder}",
              stopOnEntry = false,
            }
          }
          dap.configurations.c = dap.configurations.cpp;

          local dapui = require("dapui")
          dap.listeners.before.attach.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.launch.dapui_config = function()
            dapui.open()
          end
          dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
          end
          dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
          end

          vim.keymap.set('n', '<F5>', function() require('dap').continue() end)
          vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
          vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
          vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
          vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
          vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
          vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
          vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
          vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
          vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
          require('dap.ui.widgets').hover()
          end)
          vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
            require('dap.ui.widgets').preview()
          end)
          vim.keymap.set('n', '<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
          end)
          vim.keymap.set('n', '<Leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
          end)

          local api = vim.api

          for _, v in ipairs({
                   "Normal",
                   "NormalNC",
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
                   "Folded",

               }) do api.nvim_set_hl(0, v, {bg = "none"}) end

      '';

      globals = { mapleader = ","; };

      keymaps = [
        {
          action = ":LazyGit<CR>";
          key = "<leader>lg";
          mode = "n";
          options = {
            silent = true;
            desc = "Open up lazygit";
          };
        }

        {
          action = "<C-w>h";
          key = "<C-h>";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
            desc = "Navigate to the left screen/file/buffer";
          };
        }
        {
          action = "<C-w>j";
          key = "<C-j>";
          mode = "n";
          options = {
            silent = true;
            desc = "Navigate down to the bottom screen/file/buffer";
          };
        }
        {
          action = "<C-w>k";
          key = "<C-k>";
          mode = "n";
          options = {
            silent = true;
            desc = "Navigate up to the upper screen/file/buffer";
          };
        }
        {
          action = "<C-w>l";
          key = "<C-l>";
          mode = "n";
          options = {
            silent = true;
            desc = "Navigate to the right screen/file/buffer";
          };
        }

        {
          action = ":noh<CR>";
          key = "<esc>";
          mode = "n";
          options = {
            silent = true;
            desc = "Turns off search highlighting";
          };
        }

        {
          action = ":Lspsaga code_action<CR>";
          key = "<leader>ca";
          mode = "n";
          options = {
            silent = true;
            desc = "Opens up Lspsaga's code actions";
          };
        }
        {
          action = ":Lspsaga peek_definition<CR>";
          key = "<leader>gd";
          mode = "n";
          options = {
            silent = true;
            desc = "Peek symbol's definition";
          };
        }

        {
          action = ":Lspsaga goto_definition<CR>";
          key = "<leader>gD";
          mode = "n";
          options = {
            silent = true;
            desc = "Goto symbol's definition";
          };
        }
        {
          action = ":Lspsaga finder<CR>";
          key = "<leader>fd";
          mode = "n";
          options = {
            silent = true;
            desc = "Find symbol's definition in current buffer";
          };
        }
        {
          action = ":Lspsaga rename<CR>";
          key = "<leader>rn";
          mode = "n";
          options = {
            silent = true;
            desc = "Rename all occurrences for the current symbol";
          };
        }
        {
          action = ":Lspsaga show_line_diagnostics<CR>";
          key = "<leader>D";
          mode = "n";
          options = {
            silent = true;
            desc = "Show diagnostics for the current line";
          };
        }
        {
          action = ":Lspsaga show_cursor_diagnostics<CR>";
          key = "<leader>d";
          mode = "n";
          options = {
            silent = true;
            desc = "Show diagnostics for the symbol under the cursor";
          };
        }
        {
          action = ":Lspsaga diagnostic_jump_prev<CR>";
          key = "<leader>pd";
          mode = "n";
          options = {
            silent = true;
            desc = "Jump to previous diagnostic in current buffer";
          };
        }

        {
          action = ":Lspsaga diagnostic_jump_next<CR>";
          key = "<leader>nd";
          mode = "n";
          options = {
            silent = true;
            desc = "Jump to next diagnostic in current buffer";
          };
        }
        {
          action = ":Lspsaga hover_doc<CR>";
          key = "K";
          mode = "n";
          options = {
            silent = true;
            desc = "Show documentation for the symbol under the cursor";
          };
        }

        {
          action = ":Telescope keymaps<CR>";
          key = "<leader>fk";
          mode = "n";
          options = {
            silent = true;
            desc = "Open Telescope's keymaps search";
          };
        }

        {
          action = ":Telescope help_tags<CR>";
          key = "<leader>fh";
          mode = "n";
          options = {
            silent = true;
            desc = "Open Telescope's tags search";
          };
        }

        {
          action = ":Telescope find_files<CR>";
          key = "<leader>ff";
          mode = "n";
          options = {
            silent = true;
            desc = "Open Telescope's files search";
          };
        }
        {
          action = ":Telescope<CR>";
          key = "<leader>fa";
          mode = "n";
          options = {
            silent = true;
            desc = "Open Telescope";
          };
        }
        {
          action = ":Telescope live_grep<CR>";
          key = "<leader>fg";
          mode = "n";
          options = {
            silent = true;
            desc = "Open Telescope's grep";
          };
        }
        {
          action = ":Telescope buffers<CR>";
          key = "<leader>fb";
          mode = "n";
          options = {
            silent = true;
            desc = "Open Telescope's buffers search";
          };
        }
        {
          action = ":Telescope undo<CR>";
          key = "<leader>tu";
          mode = "n";
          options = {
            silent = true;
            desc = "Open Telescope's undotree";
          };
        }
        {
          action = ":NvimTreeFocus<CR>";
          key = "<leader>m";
          mode = "n";
          options = {
            silent = true;
            desc = "Move focus on nvim tree";
          };
        }
        {
          action = ":NvimTreeToggle<CR>";
          key = "<leader>e";
          mode = "n";
          options = {
            silent = true;
            desc = "Toggle nvim tree";
          };
        }
        {
          action = "<gv";
          key = "<";
          mode = "v";
          options = {
            silent = true;
            desc = "Shift indentation to the left";
          };
        }
        {
          action = ">gv";
          key = ">";
          mode = "v";
          options = {
            silent = true;
            desc = "Shift indentation to the right";
          };
        }
      ];

      options = {
        # Tabs / Indentation
        tabstop = 2;
        shiftwidth = 2;
        softtabstop = 2;
        expandtab = true;
        smartindent = true;
        wrap = false;

        # Search
        incsearch = true;
        ignorecase = true;
        smartcase = true;
        hlsearch = true;

        # Appearance
        number = true;
        relativenumber = true;
        termguicolors = true;
        signcolumn = "yes";
        cmdheight = 1;
        scrolloff = 10;
        completeopt = "menu,menuone,noselect";

        # Behavior
        hidden = true;
        errorbells = false;
        swapfile = false;
        backup = false;
        undofile = true;
        backspace = "indent,eol,start";
        splitright = true;
        splitbelow = true;
        autochdir = false;
        modifiable = true;
        encoding = "UTF-8";
      };

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      colorschemes.oxocarbon = { enable = true; };
      plugins = {
        nix.enable = true;
        nix-develop.enable = true;
        nvim-tree = {
          enable = true;
          disableNetrw = true;
          openOnSetup = true;
        };
        airline = {
          enable = true;
          theme = "transparent";
        };
        which-key.enable = true;
        auto-session = {
          enable = true;
          autoRestore.enabled = true;
          autoSession.enabled = true;
        };
        barbecue.enable = true;
        better-escape.enable = true;
        comment-nvim.enable = true;
        cursorline.enable = true;

        diffview.enable = true;
        emmet.enable = true;
        efmls-configs.enable = true; # #
        fidget.enable = true;
        hmts.enable = true;
        indent-blankline.enable = true;
        lastplace.enable = true;
        lint.enable = true;
        markdown-preview.enable = true;
        navbuddy = {
          enable = true;
          lsp.autoAttach = true;
        };
        noice.enable = true;
        nvim-colorizer.enable = true;
        nvim-ufo.enable = true;
        plantuml-syntax.enable = true;
        quickmath.enable = true;
        specs.enable = true;
        spider = {
          enable = true;
          keymaps = {
            motions = {
              b = "b";
              e = "e";
              ge = "ge";
              w = "w";
            };
          };
        };
        surround.enable = true;
        telescope = {
          enable = true;
          extensions = { undo = { enable = true; }; };
        };
        todo-comments.enable = true;
        toggleterm.enable = true;
        treesitter.enable = true;
        treesitter-context.enable = true;
        rainbow-delimiters.enable = true;
        ts-autotag.enable = true;
        vim-matchup.enable = true;
        wilder = {
          enable = true;
          modes = [ "/" "?" ":" ];
        };

        presence-nvim = {
          enable = true;
          enableLineNumber = true;
          showTime = false;
        };

        lspsaga.enable = true;
        lsp = {
          enable = true;
          servers = {
            nixd.enable = true;
            tsserver.enable = true;
            tailwindcss.enable = true;
            clangd = {
              enable = true;
              cmd = [ "clangd" "--offset-encoding=utf-16" ];
            };
            cmake.enable = true;
            prismals.enable = true;
            jsonls.enable = true;
            pyright.enable = true;
          };
        };

        luasnip = {
          enable = true;
          fromVscode = [{ }];
        };
        nvim-cmp = {
          enable = true;
          snippet.expand = "luasnip";
          sources =
            [
              { name = "nvim_lsp"; }
              { name = "luasnip"; }
              { name = "path"; }
              { name = "buffer"; }
            ];

          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = {
              action = "cmp.mapping.select_prev_item()";
              modes = [
                "i"
                "s"
              ];
            };
            "<Tab>" = {
              action = "cmp.mapping.select_next_item()";
              modes = [
                "i"
                "s"
              ];
            };
          };
        };
        lsp-format.enable = true;
        lsp-lines.enable = true;

        dap = {
          enable = true;
          adapters = {
            executables = {
              lldb = {
                command = "lldb-vscode";
              };
            };
          };
          extensions = {
            dap-ui.enable = true;
          };
        };
      };



      extraPlugins = with pkgs.vimPlugins; [
        lazygit-nvim
        friendly-snippets
        vim-highlightedyank
        vim-visual-multi
      ];
    };

    ripgrep.enable = true;
    lazygit = {
      enable = true;
      settings = {
        gui.theme = { lightTheme = false; };
        customCommands = [{
          key = "C";
          command = "git cz";
          description = "commit with commitizen";
          context = "files";
          loadingText = "opening commitizen commit tool";
          subprocess = true;
        }];
      };
    };
  };

}
