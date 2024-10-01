{
  pkgs,
  ...
}: {
  programs = {
    nixvim = {
      enable = true;
      autoCmd = [
        {
          event = ["FileType"];
          pattern = [
            "startup"
            "dapui_watches"
            "dap-repl"
            "dapui_console"
            "dapui_stacks"
            "dapui_breakpoints"
            "dapui_scopes"
            "help"
          ];
          callback = {
            __raw = "function() require('ufo').detach() vim.opt_local.foldenable = false end";
          };
        }
      ];
      # NOTE: Remove dap's configurations if you're willing to remove plugins.dap
      extraConfigLua = ''
        local dap = require("dap")
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
        vim.keymap.set('n', '<S-F5>', function() require('dap').terminate() end)
        vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
        vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
        vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
        vim.keymap.set('n', '<Leader>dr', function() require('dap').restart() end)

        vim.keymap.set('n', '<Leader>db', function() require('dap').toggle_breakpoint() end)
        vim.keymap.set('n', '<Leader>dB', function() require('dap').set_breakpoint() end)

        vim.keymap.set('n', '<Leader>dor', function() require('dap').repl.open() end)
        vim.keymap.set('n', '<Leader>drl', function() require('dap').run_last() end)

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

          -- resizing splits
          vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
          vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
          vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
          vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
          -- moving between splits
          vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
          vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
          vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
          vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)

          vim.keymap.set("n", "<space>f", vim.lsp.buf.format, {})

      '';
      globals = {mapleader = ",";};
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

      opts = {
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

      colorschemes.nightfox = {
        enable = true;
        flavor = "terafox";
      };

      plugins = {
        startup = {
          enable = true;
          parts = ["header" "body"];
          sections = {
            body = {
              align = "center";
              content = [
                [" Find File" "FzfLua files" "<leader>ff"]
                [" Find Word" "FzfLua live_grep" "<leader>fg"]
                [" Recent Files" "FzfLua oldfiles" "<leader>of"]
                [" Colorschemes" "FzfLua colorschemes" "<leader>cs"]
                [" New File" "lua require'startup'.new_file()" "<leader>nf"]
              ];
              defaultColor = "";
              foldSection = false;
              highlight = "Statement";
              margin = 5;
              oldfilesAmount = 3;
              title = "Basic Commands";
              type = "mapping";
            };
            header = {
              align = "center";
              content = {__raw = "require('startup.headers').hydra_header";};
              defaultColor = "#741616";
              foldSection = false;
              highlight = "Statement";
              margin = 5;
              oldfilesAmount = 0;
              title = "Header";
              type = "text";
            };
          };
        };
        oil.enable = true;
        nix.enable = true;
        fzf-lua = {
          enable = true;
          keymaps = {
            "<leader>fg" = "live_grep";
            "<leader>ff" = "files";
            "<leader>fk" = "keymaps";
            "<leader>fb" = "buffers";
          };
        };
        harpoon = {
          enable = true;
          keymaps = {
            addFile = "<leader>a";
            toggleQuickMenu = "<leader>e";
            navNext = "<leader>pp";
            navPrev = "<leader>nn";
          };
        };
        airline = {
          enable = true;
          settings.theme = "transparent";
        };
        which-key.enable = true;
        better-escape.enable = true;
        comment.enable = true;
        lastplace.enable = true;
        markdown-preview.enable = true;
        navbuddy = {
          enable = true;
          useDefaultMapping = true;
          lsp.autoAttach = true;
        };
        noice.enable = true;
        fidget.enable = true;
        illuminate.enable = true;
        nvim-ufo.enable = true;
        nvim-colorizer.enable = true;
        emmet.enable = true;
        hmts.enable = true;
        plantuml-syntax.enable = true;
        vim-surround.enable = true;
        todo-comments.enable = true;
        treesitter = {
          enable = true;
          nixvimInjections = true;
          folding = true;
        };
        treesitter-context.enable = true;
        rainbow-delimiters.enable = true;
        vim-matchup.enable = true;
        wilder = {
          enable = true;
          modes = ["/" "?" ":"];
        };

        neocord.enable = true;

        lspsaga.enable = true;
        web-devicons.enable = true;

        lsp = {
          enable = true;
          servers = {
            nixd.enable = true;
            tailwindcss.enable = true;
            clangd = {
              enable = true;
              cmd = ["clangd" "--offset-encoding=utf-16"];
            };
            cmake.enable = true;
            prismals.enable = true;
            jsonls.enable = true;
            pyright.enable = true;
            ts-ls.enable = true;
            astro.enable = true;
            html.enable = true;
            cssls.enable = true;
            marksman.enable = true;
            nginx-language-server.enable = true;
            sqls.enable = true;
            phpactor.enable = true;
            zls.enable = true;
          };
        };
        lint.enable = true;

        ts-autotag.enable = true;

        luasnip = {
          enable = true;
          fromVscode = [{}];
        };

        cmp = {
          enable = true;
          settings = {
            snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            sources = [
              {name = "nvim_lsp";}
              {name = "luasnip";}
              {name = "path";}
              {name = "buffer";}
            ];
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = true })";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            };
          };
        };
        dap = {
          enable = true;
          adapters = {
            executables = {lldb = {command = "lldb-vscode";};};
          };
          configurations = rec {
            cpp = [
              {
                name = "C, C++ & Rust Debugger configurations";
                type = "lldb";
                request = "launch";
                program = {
                  __raw = "function() return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file') end";
                };
                cwd = "\${workspaceFolder}";
                stopOnEntry = false;
              }
            ];
            c = cpp;
          };
          extensions = {dap-ui.enable = true;};
        };

        none-ls = {
          enable = true;
          sources = {
            formatting = {
              black.enable = true;
              alejandra.enable = true;
              mdformat.enable = true;
              htmlbeautifier.enable = true;
              phpcsfixer.enable = true;
              prettierd.enable = true;
            };
          };
        };

        smart-splits = {
          enable = true;
          settings = {
            ignored_events = ["BufEnter" "WinEnter"];
            resize_mode = {
              quit_key = "<ESC>";
              resize_keys = ["h" "j" "k" "l"];
              silent = true;
            };
          };
        };

        codeium-vim.enable = true;

        undotree.enable = true;
        transparent = {
          enable = true;
          settings.extra_groups = ["Folded" "WhichKeyFloat" "NormalFloat"];
        };
        friendly-snippets.enable = true;
        neoscroll.enable = true;
        lazygit.enable = true;
        mark-radar.enable = true;
        marks.enable = true;
        codesnap = {
          enable = true;
          settings = {watermark = "AlGhoul";};
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        vim-highlightedyank
        vim-visual-multi
        vim-airline-themes
      ];
    };

    ripgrep.enable = true;
    lazygit = {
      enable = true;
      settings = {
        gui.theme = {lightTheme = false;};
        customCommands = [
          {
            key = "C";
            command = "git cz";
            description = "commit with commitizen";
            context = "files";
            loadingText = "opening commitizen commit tool";
            subprocess = true;
          }
        ];
      };
    };
  };
}
