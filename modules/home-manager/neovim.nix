{pkgs, ...}: {
  programs = {
    nixvim = {
      enable = true;
      performance = {
        byteCompileLua.enable = true;
        byteCompileLua.nvimRuntime = true;
        byteCompileLua.plugins = true;
      };
      extraConfigLua = ''
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
          action = ":Navbuddy<CR>";
          key = "<leader>b";
          mode = "n";
          options = {
            silent = true;
            desc = "Open up navbuddy";
          };
        }

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
        completeopt = "menu,preview,menuone,noselect";

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

      colorschemes.melange.enable = true;

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
        colorizer.enable = true;
        emmet.enable = true;
        plantuml-syntax.enable = true;
        vim-surround.enable = true;
        todo-comments.enable = true;
        treesitter = {
          enable = true;
          nixvimInjections = true;
          folding = true;
        };
        rainbow-delimiters.enable = true;
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
            # prismals.enable = true;
            # intelephense.enable = true;
            jsonls.enable = true;
            pyright.enable = true;
            ts_ls.enable = true;
            astro.enable = true;
            html.enable = true;
            cssls.enable = true;
            marksman.enable = true;
            nginx_language_server.enable = true;
            sqls.enable = true;
            zls.enable = true;
            svelte.enable = true;
          };
        };
        lint.enable = true;

        none-ls = {
          enable = true;
          sources = {
            code_actions = {
              statix.enable = true;
            };
            diagnostics = {
              deadnix.enable = true;
              statix.enable = true;
            };
            completion = {
              luasnip.enable = true;
            };
            formatting = {
              black.enable = true;
              alejandra.enable = true;
              prettier = {
                enable = true;
                disableTsServerFormatter = true;
              };
            };
          };
        };

        ts-autotag.enable = true;

        friendly-snippets.enable = true;
        luasnip = {
          enable = true;
          fromVscode = [{}];
        };

        cmp = {
          enable = true;
          settings = {
            snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
            sources = [
              {name = "luasnip";}
              {name = "nvim_lsp";}
              {name = "path";}
              {name = "buffer";}
            ];
            mapping = {
              "<C-Space>" = "cmp.mapping.complete()";
              "<C-d>" = "cmp.mapping.scroll_docs(-4)";
              "<C-e>" = "cmp.mapping.close()";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<CR>" = "cmp.mapping.confirm({ select = false })";
              "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
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

        codeium-vim = let
          codeiumPkg = pkgs.codeium.overrideAttrs (prevAttrs: rec {
            version = "1.8.59";
            plat = "linux_x64";
            src = pkgs.fetchurl {
              name = "${prevAttrs.pname}-${version}.gz";
              url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_${plat}.gz";
              hash = "sha256-j+5ckDfn87vvaGk+c+yHfF/F5KLLOLirPaR582kUD5U=";
            };
          });
        in {
          enable = true;
          package = pkgs.vimPlugins.codeium-vim.overrideAttrs (finalAttr: p: {
            version = "git";
            src = pkgs.fetchFromGitHub {
              owner = "Exafunction";
              repo = "codeium.vim";
              rev = "5644ac5a0e098ca0cf5deed1c909c3fa5e9901f3";
              sha256 = "sha256-7XElW/54T6VlUJwvXFr4PumrX96jyzZi5XqA9n7hLJA=";
            };
          });
          settings = {bin = "${codeiumPkg}/bin/codeium_language_server";};
        };

        undotree.enable = true;
        transparent = {
          enable = true;
          settings.extra_groups = ["Folded" "WhichKeyFloat" "NormalFloat"];
        };
        neoscroll.enable = true;
        lazygit.enable = true;
        mark-radar.enable = true;
        marks.enable = true;
        codesnap = {
          enable = true;
          settings = {watermark = "AlGhoul";};
        };

        flash.enable = true;
        guess-indent.enable = true;
        hop.enable = true;
        kulala.enable = true;
        cloak.enable = true;
        yanky.enable = true;
        wtf.enable = true;
        comment-box.enable = true;
      };
      #
      extraPlugins = with pkgs.vimPlugins; [
        vim-highlightedyank
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
