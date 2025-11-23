vim.filetype.add({
  pattern = {
    ['.*%.todo%.txt'] = 'todotxt',
  },
  filename = {
    ['todo.txt'] = 'todotxt',
  }
})
