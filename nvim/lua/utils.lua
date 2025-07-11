-- utils.lua - Utility functions for NvChad configuration

-- Get Git repository information
local function get_git_info()
  local ok, git_branch = pcall(vim.fn.system, "git branch --show-current 2>/dev/null")
  if not ok then return nil end

  git_branch = git_branch:gsub("\n", "")
  if git_branch == "" then return nil end

  local ok2, git_status = pcall(vim.fn.system, "git status --porcelain 2>/dev/null")
  local has_changes = ok2 and git_status:gsub("\n", "") ~= ""

  return {
    branch = git_branch,
    dirty = has_changes
  }
end

-- Get system information
local function get_system_info()
  local function safe_system_call(cmd, default)
    local ok, result = pcall(vim.fn.system, cmd)
    return ok and result:gsub("\n", "") or default
  end

  return {
    os = safe_system_call("uname -s", "Unknown"),
    host = safe_system_call("hostname", "localhost"),
    uptime = safe_system_call("uptime | awk '{print $3 $4}' | sed 's/,//'", "N/A")
  }
end

-- Count code files in current directory
local function get_file_stats()
  local extensions = {"lua", "py", "js", "ts", "rs", "go", "c", "cpp", "java", "rb", "php"}
  local find_cmd = "find . -type f \\( "

  for i, ext in ipairs(extensions) do
    if i > 1 then find_cmd = find_cmd .. " -o " end
    find_cmd = find_cmd .. "-name '*." .. ext .. "'"
  end
  find_cmd = find_cmd .. " \\) 2>/dev/null | wc -l"

  local ok, result = pcall(vim.fn.system, find_cmd)
  return ok and tonumber(result:gsub("\n", "")) or 0
end

-- Create gradient-style decorative line
local function create_gradient_line(width, chars)
  local line = ""
  chars = chars or {"▰", "▱"}

  for i = 1, width do
    local idx = (i % 2 == 0) and 2 or 1
    line = line .. chars[idx]
  end
  return line
end

-- Get a daily motivational quote
local function get_daily_quote()
  local quotes = {
    "Code is poetry written in logic",
    "Every expert was once a beginner",
    "Progress, not perfection",
    "Make it work, make it right, make it fast",
    "The best debugging tool is still thinking",
    "Simplicity is the ultimate sophistication",
    "Code never lies, comments sometimes do",
    "First, solve the problem. Then, write the code"
  }

  local day_of_year = tonumber(os.date("%j")) or 1
  return quotes[day_of_year % #quotes + 1]
end

-- Generate enhanced NvDash header
function generate_enhanced_header()
  local git_info = get_git_info()
  local sys_info = get_system_info()
  local file_count = get_file_stats()
  local current_time = os.date("%H:%M:%S")
  local current_date = os.date("%Y-%m-%d")
  local cwd = vim.fn.getcwd():gsub(os.getenv("HOME") or "", "~")
  local nvim_version = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
  local lsp_count = #vim.lsp.get_active_clients()

  local header = {
    -- Original ASCII art
    "⬜⬜⬜⬜⬜⬜⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬜⬛⬛🟥🟥🟥🟥🟥⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥🟥🟥⬛⬛🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥🟥⬛⬛⬜⬛🟥🟥🟥⬛⬜⬜⬜⬜⬜",
    "⬜⬛🟥🟥🟥🟥🟥⬛⬜⬜⬜⬛🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥⬛⬜⬜⬜⬛🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥⬛⬜⬜⬜⬛🟥🟥🟥🟥⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬛🟥🟥🟥⬛⬛⬛🟥🟥🟥⬛⬛⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬛🟥🟥🟥🟥🟥🟥🟥⬛🟥⬛⬜⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬜⬛🟥🟥🟥🟥⬛⬛🟥🟥⬛⬛⬜⬜⬜⬜⬜⬜",
    "⬜⬜⬜⬜⬜⬛⬛⬛⬛🟥⬛🟥🟥🟥🟥⬛⬛⬜⬜⬜⬜",
    "⬜⬜⬜⬛⬛⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜⬜",
    "⬜⬜⬛🟥⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥🟥⬛⬜⬜",
    "⬜⬜⬛⬛🟥🟥🟥🟥🟥🟥🟥🟥🟥🟦🟥🟥🟥🟥⬛⬜⬜",
    "⬜⬜⬛⬛⬛🟥⬛🟥⬛⬛🟥🟦🟦🟦🟦🟦🟥🟥🟥⬛⬜",
    "⬜⬛🟥⬛🟥⬛⬛⬛🟥🟥🟥🟦🟦🟦🟦🟦🟦🟥🟥⬛⬜",
    "⬜⬛🟥⬛⬛🟥⬛🟥⬛⬛🟦🟦🟦⬛⬛🟦🟦🟦🟥⬛⬜",
    "⬜⬛🟥⬛🟥⬛⬛⬛🟥🟥🟦🟦⬛⬜⬜⬛🟦🟦🟦🟥⬛",
    "⬜⬛🟥⬛🟥🟥⬛🟥🟥🟦🟦⬛⬜⬜⬜⬛🟦🟦🟦🟥⬛",
    "",
    -- Decorative separator
    "  " .. create_gradient_line(60),
    "",
    -- Enhanced info section
    "  ╭─ 🚀 SESSION INFO ──────────────────────────────╮",
    "  │  👋 Hello Sidd! ⏰ " .. current_time .. " 📅 " .. current_date .. "  │",
    "  │  📂 " .. cwd .. string.rep(" ", math.max(1, 42 - #cwd)) .. "│",
    "  │  ⚡ Neovim v" .. nvim_version .. " | 🖥️ " .. sys_info.host .. string.rep(" ", math.max(1, 25 - #nvim_version - #sys_info.host)) .. "│",
    "  ╰────────────────────────────────────────────────╯",
    "",
    -- Project stats
    "  ╭─ 📊 PROJECT STATS ─────────────────────────────╮",
    "  │  📄 " .. file_count .. " code files | 🔧 LSP: " .. (lsp_count > 0 and lsp_count .. " active" or "inactive") .. string.rep(" ", math.max(1, 15 - #tostring(file_count) - (lsp_count > 0 and #(lsp_count .. " active") or 8))) .. "│",
  }

  -- Git info
  if git_info then
    local git_status = git_info.dirty and "📝 modified" or "✅ clean"
    local git_line = "  │  🌿 " .. git_info.branch .. " (" .. git_status .. ")" .. string.rep(" ", math.max(1, 31 - #git_info.branch - #git_status)) .. "│"
    table.insert(header, git_line)
  else
    table.insert(header, "  │  📦 No git repository                          │")
  end

  table.insert(header, "  ╰────────────────────────────────────────────────╯")
  table.insert(header, "")

  -- Daily quote
  local quote = get_daily_quote()
  table.insert(header, "  💭 \"" .. quote .. "\"")
  table.insert(header, "")
  table.insert(header, "  " .. create_gradient_line(60))
  table.insert(header, "")

  return header
end

-- Generate enhanced buttons with dynamic content
function generate_enhanced_buttons()
  return {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files", hl = "NvDashFind" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles", hl = "NvDashRecent" },
    { txt = "󰈚  Find Word", keys = "fw", cmd = "Telescope live_grep", hl = "NvDashFind" },
    { txt = "󱥚  Themes", keys = "th", cmd = ":lua require('nvchad.themes').open()", hl = "NvDashFind" },
    { txt = "", hl = "NvDashFooter", no_gap = true },
    {
      txt = function()
        local git_info = get_git_info()
        if not git_info then return "" end
        local status_icon = git_info.dirty and "📝" or "✅"
        return "🌿 " .. git_info.branch .. " " .. status_icon
      end,
      no_gap = true,
      hl = "NvDashFooter",
    },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
    {
      txt = function()
        local stats = require("lazy").stats()
        local ms = math.floor(stats.startuptime) .. " ms"
        return "⚡ Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },
    {
      txt = function()
        local file_count = get_file_stats()
        return "📄 " .. file_count .. " code files in project"
      end,
      hl = "NvDashFooter",
      no_gap = true,
    },
    { txt = "─", hl = "NvDashFooter", no_gap = true, rep = true },
  }
end
