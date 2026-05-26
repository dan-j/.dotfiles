local map = vim.keymap.set

-- clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- resize windows
map("n", "<C-Up>", "<cmd>resize +2<CR>")
map("n", "<C-Down>", "<cmd>resize -2<CR>")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>")
map("n", "<S-l>", "<cmd>bnext<CR>")
map("n", "<leader>q", "<cmd>bdelete<CR>", { desc = "Close buffer" })

-- file explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
map("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", { desc = "Reveal file in explorer" })

-- telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<CR>", { desc = "Diagnostics" })

-- git (fugitive)
map("n", "<leader>gg", "<cmd>Git<CR>", { desc = "Git status" })
map("n", "<leader>gb", "<cmd>Git blame<CR>", { desc = "Git blame" })
map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", { desc = "Git diff" })
map("n", "<leader>gl", "<cmd>Git log<CR>", { desc = "Git log" })

-- formatting (conform, falls back to LSP)
map("n", "<leader>lf", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file" })

-- diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Cmd-/ → toggle line comment  (requires iTerm2: Profiles → Keys → add Cmd-/ → Send Escape Sequence → value: /)
-- Cmd-Shift-/ → toggle block comment  (requires iTerm2: add Cmd-? → Send Escape Sequence → value: ?)
map("n", "<M-/>", "gcc",  { remap = true, desc = "Toggle line comment" })
map("v", "<M-/>", "gc",   { remap = true, desc = "Toggle line comment" })
map("n", "<M-?>", "gbc",  { remap = true, desc = "Toggle block comment" })
map("v", "<M-?>", "gb",   { remap = true, desc = "Toggle block comment" })

-- stay in indent mode
map("v", "<", "<gv")
map("v", ">", ">gv")

-- move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
