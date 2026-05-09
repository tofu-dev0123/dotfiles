return {
  "3rd/image.nvim",
  lazy = false,
  opts = {
    backend = "sixel",
    processor = "magick_cli",
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = false,
        filetypes = { "markdown", "vimwiki" },
      },
      neorg = { enabled = false },
      typst = { enabled = false },
      html = { enabled = false },
      css = { enabled = false },
    },
    max_width = nil,
    max_height = nil,
    max_width_window_percentage = nil,
    max_height_window_percentage = 50,
    window_overlap_clear_enabled = true,
    window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
    editor_only_render_when_focused = false,
    tmux_show_only_in_active_window = false,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
  },
  config = function(_, opts)
    require("image").setup(opts)

    local original_size = {}

    local function get_buf_images()
      return require("image").get_images({ buffer = vim.api.nvim_get_current_buf() })
    end

    local function current_size(img)
      local rg = img.rendered_geometry or {}
      local w = img.geometry.width or rg.width or 0
      local h = img.geometry.height or rg.height or 0
      return w, h
    end

    local function zoom(factor)
      return function()
        for _, img in ipairs(get_buf_images()) do
          local w, h = current_size(img)
          if w > 0 and h > 0 then
            if not original_size[img.id] then
              original_size[img.id] = { width = w, height = h }
            end
            img.ignore_global_max_size = true
            img:render({
              width = math.max(1, math.floor(w * factor)),
              height = math.max(1, math.floor(h * factor)),
            })
          end
        end
      end
    end

    local function reset()
      for _, img in ipairs(get_buf_images()) do
        local saved = original_size[img.id]
        if saved then
          img.ignore_global_max_size = false
          img:render({ width = saved.width, height = saved.height })
        end
      end
    end

    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
      callback = function(args)
        local map = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
        end
        map("+", zoom(1.1), "Image: zoom in")
        map("-", zoom(0.9), "Image: zoom out")
        map("0", reset, "Image: reset zoom")
      end,
    })
  end,
}
