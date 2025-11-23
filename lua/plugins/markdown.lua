return {
  {
    dir = vim.fn.stdpath("config") .. "/lua/markdown-follow",
    name = "markdown-follow",
    opts = {
      wiki_extension = "md",
    },
    keys = {
      { "gx", "<cmd>MdFollowLink<cr>", desc = 'Follow markdown link' },
    },
  },
  {
    dir = vim.fn.stdpath("config") .. "/lua/lumd",
    name = "lumd",
    opts = {
      vaults = {
        default = {
          name = "Main Notes",
          path = vim.fn.expand("~/Notes/matter"),
          description = "General notes"
        },
        sr_language = {
          name = "SR language",
          path = vim.fn.expand("~/Notes/languages/sr"),
          description = "Serbian language learning"
        }
      },
      reference = {
        update_callback = require('qq.rename').update_links,
      },
      modules = {
        refactor = {
          enable = true,
          create_link_patterns = function(old_filepath, new_filepath)
            local old_filename_without_ext = vim.fn.fnamemodify(old_filepath, ":r")
            local new_filename_without_ext = vim.fn.fnamemodify(new_filepath, ":r")
            return old_filename_without_ext, new_filename_without_ext
          end,
        }
      }
    },
    keys = {
      { "<leader>nf", "<cmd>FindOrCreateNote<cr>",              desc = "Find or Create note" },
      { "<C-k>",      "<cmd>FindOrCreateNote<cr>",              mode = "i",                                desc = "Find or Create note" },
      { "<leader>nr", "<cmd>RefactorNote<cr>",                  desc = "Find or Create note" },
      { "<leader>nu", "<cmd>UpdateFilenameFromFrontmatter<cr>", desc = "Update note from frontmatter" },
    },
  },
  --{
  --  "jakewvincent/mkdnflow.nvim",
  --  ft = "markdown",
  --  opts = {
  --    create_dirs = true,
  --    wrap = true,
  --    perspective = {
  --      priority = "root",
  --      fallback = "current",
  --      root_tell = "index.md",
  --    },
  --    links = {
  --      style = "wiki",
  --      name_is_source = true,
  --      -- mkdnflow.nvim: conceal feature uses repeated pattern matches (matchadd) to hide/link text.
  --      -- On long sessions this accumulates many matches and triggers frequent highlight/search updates
  --      -- (update_search_hl / match-related work), causing high CPU use — especially noticeable on
  --      -- low battery or limited CPU when the kernel keeps scheduling the busy thread across cores.
  --      -- Setting links.conceal = false or disabling conceal clears these matches and prevents the
  --      -- continual work (or call :call clearmatches() to clear them at runtime). Keep conceal off
  --      -- if you notice scrolling/typing lag or high CPU.
  --      conceal = false,
  --    },
  --    mappings = {
  --      MkdnEnter = false,
  --      MkdnFollowLink = false,
  --      MkdnNextLink = false,
  --      MkdnPrevLink = false,
  --      MkdnIncreaseHeading = false,
  --      MkdnDecreaseHeading = false,
  --      MkdnNewListItem = false,
  --      MkdnNewListItemAboveInsert = false,
  --      MkdnNewListItemBelowInsert = false,
  --    },
  --    modules = {
  --      bib = false,
  --      lists = false,
  --      tables = false,
  --    },
  --    name_is_source = true,
  --  },
  --  config = function(_, opts)
  --    require("mkdnflow").setup(opts)
  --  end,
  --},
}
