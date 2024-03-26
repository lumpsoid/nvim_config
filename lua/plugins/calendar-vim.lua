return {
  'mattn/calendar-vim',
  config = function ()
    vim.g.calendar_monday = 2
    vim.g.calendar_diary='/home/qq/Documents/notes'
    vim.g.calendar_filetype = 'markdown'

    vim.cmd [[ 
    function MyCalAction(day,month,year,week,dir)
      let formatted_month = printf('%02d', a:month)
      let formatted_day = printf('%02d', a:day)
      let path = g:calendar_diary . '/' . a:year . '_' . formatted_month . '_' . formatted_day . '.md'
      if !filereadable(path)
          call writefile(['- '], path)
      endif

      execute 'wincmd p'
      execute 'edit ' . fnameescape(path)
    endfunction

    let calendar_action = 'MyCalAction'
    ]]
  end
}
