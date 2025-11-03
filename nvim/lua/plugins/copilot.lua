return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,       -- Enable inline ghost text
          auto_trigger = true,  -- Auto-show suggestions as you type
          debounce = 75,        -- Delay in ms before showing
          keymap = {
            accept = "<C-l>",   -- Accept suggestion
            next = "<M-]>",     -- Next suggestion
            prev = "<M-[>",     -- Previous suggestion
            dismiss = "<C-]>",  -- Dismiss suggestion
          },
        },
        panel = { enabled = true }, -- Optional side panel (Ctrl-Enter to open)
      })
    end,
  },
}
