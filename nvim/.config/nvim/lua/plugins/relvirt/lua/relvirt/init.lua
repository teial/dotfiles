local M = {}

M.opts = {
    ignored_filetypes = {},
    space_reserve = 0, -- columns reserved for virtual number
}

local api = vim.api
local ns = api.nvim_create_namespace("rel_lines")

-- Toggle state (buffer-local)
vim.g.relvirt_enabled = true

local function is_blank(buf, lnum)
    local line = api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1] or ""
    return line:match("^%s*$") ~= nil
end

local function get_window_width(win) return vim.api.nvim_win_get_width(win or 0) end

local function get_line_width(buf, lnum)
    local line = vim.api.nvim_buf_get_lines(buf, lnum, lnum + 1, false)[1] or ""
    return vim.fn.strdisplaywidth(line)
end

local function virtual_text_width(virt_text)
    local total = 0
    for _, chunk in ipairs(virt_text) do
        total = total + vim.fn.strdisplaywidth(chunk[1])
    end
    return total
end

local function get_total_virtual_text_width(buf, lnum)
    local marks = vim.api.nvim_buf_get_extmarks(buf, -1, { lnum, 0 }, { lnum, -1 }, {
        details = true,
    })

    local width = 0
    for _, mark in ipairs(marks) do
        local details = mark[4]
        if details and details.virt_text then width = width + virtual_text_width(details.virt_text) end
    end
    return width
end

local function should_suppress_number(buf, lnum, win, reserve)
    reserve = reserve or M.opts.space_reserve
    local line_width = get_line_width(buf, lnum)
    local virt_width = get_total_virtual_text_width(buf, lnum)
    local win_width = get_window_width(win)
    return (line_width + virt_width + reserve) >= win_width
end

local function render_line(buf, lnum, cur, win)
    local rel = math.abs(cur - lnum)
    -- Suppress number if it's the cursor line, or if the line is blank or has virtual text
    if rel == 0 or is_blank(buf, lnum) or should_suppress_number(buf, lnum, win, M.opts.space_reserve) then return end
    local text = string.format("%d", rel)

    api.nvim_buf_set_extmark(buf, ns, lnum, 0, {
        id = lnum + 1,
        virt_text = { { text, "LineNr" } },
        virt_text_pos = "eol",
        hl_mode = "combine",
    })
end

local function refresh(buf)
    local win = api.nvim_get_current_win()
    local cur = api.nvim_win_get_cursor(win)[1] - 1
    local topline = vim.fn.line("w0", win) - 1
    local botline = vim.fn.line("w$", win) - 1
    local lastline = api.nvim_buf_line_count(buf) - 1

    topline = math.max(0, topline)
    botline = math.min(lastline, botline)

    api.nvim_buf_clear_namespace(buf, ns, topline, botline + 1)

    for l = topline, botline do
        render_line(buf, l, cur, win)
    end
end

local function is_ignored_filetype(buf)
    local ft = vim.bo[buf].filetype
    for _, pattern in ipairs(M.opts.ignored_filetypes or {}) do
        if ft:match("^" .. pattern .. "$") then return true end
    end
    return false
end

local function setup_autocmd()
    api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "WinScrolled" }, {
        group = api.nvim_create_augroup("RelVirt", { clear = true }),
        callback = function(ev)
            if is_ignored_filetype(ev.buf) then return end
            if vim.g.relvirt_enabled then
                refresh(ev.buf)
            else
                vim.api.nvim_buf_clear_namespace(ev.buf, ns, 0, -1)
            end
        end,
    })
end

function M.toggle()
    vim.g.relvirt_enabled = not vim.g.relvirt_enabled
    if vim.g.relvirt_enabled then
        vim.cmd("doautocmd <nomodeline> CursorMoved")
    else
        vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    end
end

function M.setup(opts)
    M.opts = vim.tbl_deep_extend("force", M.opts, opts or {})
    vim.api.nvim_create_user_command("RelvirtToggle", M.toggle, {})
    setup_autocmd()
end

return M
