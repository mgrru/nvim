local mason = {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  priority = 800,
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  },
  config = function(_,opts)
    require("mason").setup(opts)
  end,
}


local mason_lsp = {
  "williamboman/mason-lspconfig.nvim",
  event = "VeryLazy",
  priority = 200,
  opts = {
    ensure_installed = {
      "lua_ls",
      "rust_analyzer",
      "volar",
      "tsserver",
    },
  },
  config = function(_,opts)
    require("mason-lspconfig").setup(opts)
    require("mason-lspconfig").setup_handlers {
      function(server_name)
        require("lspconfig")[server_name].setup {}
      end,
      ["volar"] = function()
        require("lspconfig").volar.setup {
          init_options = {
            vue = {
              hybridMode = true,
            },
          },
          filetypes = {
            "javascript",
            "typescript",
            "vue",
          },
        }
      end,
      ["tsserver"] = function()
        local ts_path = require("mason-registry").get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server"
        -- local ts_path = "/home/ru/.local/share/pnpm/global/5/node_modules/@vue/typescript-plugin/lib"
        local lsp = require("lspconfig")

        lsp.tsserver.setup {
          init_options = {
            plugins = {
              {
                name = "@vue/typescript-plugin",
                location = ts_path,
                languages = { "javascript", "typescript", "vue" },
              },
            },
          },
          filetypes = {
            "javascript",
            "typescript",
            "vue",
          },
        }
      end,
    }
  end,
}

local lspconfig = {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    "mason.nvim",
    "mason-lspconfig.nvim",
  },
  opts = {},
  config = function() end,
}

return {
  mason,
  mason_lsp,
  lspconfig
}
