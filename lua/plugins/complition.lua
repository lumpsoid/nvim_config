return {
  --completion
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  {
    'L3MON4D3/LuaSnip',
  },
  'saadparwaiz1/cmp_luasnip',
  'rafamadriz/friendly-snippets',
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'windwp/nvim-autopairs',
      'hrsh7th/cmp-nvim-lsp',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local ls = require("luasnip")
      ls.log.set_loglevel("info")
      local cmp = require('cmp')
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on(
        'confirm_done',
        cmp_autopairs.on_confirm_done()
      )
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load({ paths = "~/snippets" })


      require("which-key").add({
        {
          group = "luasnip",
          mode = "i",
          { "<C-L>", "<cmd>lua require('luasnip').expand()<CR>", desc = "Expand snip" },
          { "<C-J>", "<cmd>lua require('luasnip').jump(1)<CR>",  desc = "Jump to the next snip position" },
          { "<C-K>", "<cmd>lua require('luasnip').jump(-1)",     desc = "Jump to the previous snip position" },
        },
      })

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-o>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        sources = cmp.config.sources({
          { name = 'luasnip' },
          { name = 'nvim_lsp' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end
  },
}
