return {
  'jakewvincent/mkdnflow.nvim',
  ft = { 'markdown' },
  config = function ()
    require('mkdnflow').setup({
      create_dirs = false,
      perspective = {
        priority = 'root',
        fallback = 'current',
        root_tell = 'index.md',
      },
      wrap = true,
      links = {
        style = 'wiki',
        name_is_source = true,
      },
      mappings = {
        MkdnNextLink = false,
        MkdnPrevLink = false,
        MkdnIncreaseHeading = false,
        MkdnDecreaseHeading = false,
      }
    })
  end
}
