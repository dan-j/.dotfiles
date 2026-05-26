-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  ----------------------------------------------------------------------
  -- Colorscheme
  ----------------------------------------------------------------------
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
        require("tokyonight").setup({ style = "night" })
        vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  ----------------------------------------------------------------------
  -- Treesitter — syntax highlighting & indentation
  ----------------------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "go", "typescript", "javascript", "tsx",
          "lua", "json", "yaml", "markdown", "markdown_inline",
        },
      })
    end,
  },

  ----------------------------------------------------------------------
  -- LSP: mason + lspconfig + cmp integration
  ----------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "ts_ls", "eslint" },
        automatic_installation = true,
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(_, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     vim.tbl_extend("force", opts, { desc = "Go to definition" }))
        vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
        vim.keymap.set("n", "gr",         vim.lsp.buf.references,     vim.tbl_extend("force", opts, { desc = "References" }))
        vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
        vim.keymap.set("n", "K",          vim.lsp.buf.hover,          vim.tbl_extend("force", opts, { desc = "Hover docs" }))
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         vim.tbl_extend("force", opts, { desc = "Rename" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    vim.tbl_extend("force", opts, { desc = "Code action" }))
      end

      -- apply capabilities + on_attach as defaults for all servers
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- nvim-lspconfig ships the cmd/filetypes/root_markers; we just enable
      vim.lsp.enable({ "gopls", "ts_ls", "eslint" })
    end,
  },

  ----------------------------------------------------------------------
  -- Completion
  ----------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  ----------------------------------------------------------------------
  -- Telescope — fuzzy finder
  ----------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          file_ignore_patterns = { "node_modules/", ".git/" },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  ----------------------------------------------------------------------
  -- File explorer
  ----------------------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 35 },
        renderer = { group_empty = true },
        filters = { dotfiles = false },
        git = { enable = true },
      })
    end,
  },

  ----------------------------------------------------------------------
  -- Status line
  ----------------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "tokyonight" },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },

  ----------------------------------------------------------------------
  -- Git
  ----------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns
          local opts = { buffer = bufnr }
          vim.keymap.set("n", "]c", gs.next_hunk, vim.tbl_extend("force", opts, { desc = "Next hunk" }))
          vim.keymap.set("n", "[c", gs.prev_hunk, vim.tbl_extend("force", opts, { desc = "Prev hunk" }))
          vim.keymap.set("n", "<leader>hp", gs.preview_hunk,  vim.tbl_extend("force", opts, { desc = "Preview hunk" }))
          vim.keymap.set("n", "<leader>hs", gs.stage_hunk,    vim.tbl_extend("force", opts, { desc = "Stage hunk" }))
          vim.keymap.set("n", "<leader>hr", gs.reset_hunk,    vim.tbl_extend("force", opts, { desc = "Reset hunk" }))
        end,
      })
    end,
  },
  { "tpope/vim-fugitive" },

  ----------------------------------------------------------------------
  -- Formatting
  ----------------------------------------------------------------------
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          go                = { "goimports", "gofmt" },
          javascript        = { "prettier" },
          typescript        = { "prettier" },
          javascriptreact   = { "prettier" },
          typescriptreact   = { "prettier" },
          json              = { "prettier" },
          yaml              = { "prettier" },
          lua               = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  ----------------------------------------------------------------------
  -- Editing utilities
  ----------------------------------------------------------------------
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function() require("nvim-surround").setup() end,
  },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup() end,
  },

  ----------------------------------------------------------------------
  -- Indent guides
  ----------------------------------------------------------------------
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function() require("ibl").setup() end,
  },

  ----------------------------------------------------------------------
  -- Which-key — keybinding hints
  ----------------------------------------------------------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
      require("which-key").add({
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>h", group = "hunks" },
        { "<leader>l", group = "lsp" },
      })
    end,
  },

  ----------------------------------------------------------------------
  -- Go
  ----------------------------------------------------------------------
  {
    "fatih/vim-go",
    ft = "go",
    init = function()
      -- let nvim-lspconfig/gopls handle these
      vim.g.go_def_mapping_enabled = 0
      vim.g.go_doc_keywordprg_enabled = 0
      vim.g.go_fmt_autosave = 1
    end,
  },

}, {
  ui = { border = "rounded" },
})
