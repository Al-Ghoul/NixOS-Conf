{ nixvim, pkgs, ... }: {

  programs = {
    nixvim = {
      enable = true;

      extraConfigLua = ''
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
          key = "<leader>h";
          mode = "n";
          options = {
            noremap = true;
            silent = true;
            desc = "Navigate to the left screen/file/buffer";
          };
        }
        {
          action = "<C-w>j";
          key = "<leader>j";
          mode = "n";
          options = {
            silent = true;
            desc = "Navigate down to the bottom screen/file/buffer";
          };
        }
        {
          action = "<C-w>k";
          key = "<leader>l";
          mode = "n";
          options = {
            silent = true;
            desc = "Navigate up to the upper screen/file/buffer";
          };
        }
        {
          action = "<C-w>l";
          key = "<leader>l";
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
        completeopt = "menuone,noinsert,noselect";

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
        barbar = {
          enable = true;
          keymaps = {
            close = "q";
            next = "]";
            previous = "[";
            moveNext = "}";
            movePrevious = "{";
            pick = "p";
          };
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
        telescope.enable = true;
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

        coq-nvim = {
          enable = true;
          alwaysComplete = true;
          autoStart = true;
          installArtifacts = true;
          recommendedKeymaps = false;
        };

        presence-nvim = {
          enable = true;
          enableLineNumber = true;
          showTime = false;
        };

        obsidian.enable = true;

        lspsaga.enable = true;
        lsp = {
          enable = true;
          servers = {
            nixd.enable = true;
            tsserver.enable = true;
          };
        };

        lsp-format.enable = true;
        lsp-lines.enable = true;
        none-ls = {
          debounce = 250;
          logLevel = "off";
          enable = true;
          enableLspFormat = true;
          sources = {
            diagnostics = {
              deadnix.enable = true;
              eslint_d.enable = true;
              statix.enable = true;
            };
            formatting = {
              eslint_d.enable = true;
              nixfmt.enable = true;
              nixpkgs_fmt.enable = true;
            };
          };
        };
      };

      extraPlugins = with pkgs.vimPlugins; [ lazygit-nvim ];
    };

    ripgrep.enable = true;
    lazygit = {
      enable = true;
      settings = { lightTheme = false; };
    };
  };

}
