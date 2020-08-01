""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Title: Manipulate comments
" Description: Functions to add and manipulate comments
" Author: Tyler Wayne (tylerwayne3@gmail.com)
" Last Modified: 2019-12-12
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" FUNCTIONS {{{

function! ToggleComments(comment_char, type)
  let saved_reg = @@

  if a:type ==# 'V'
    silent! normal! `<v`>y
  else
    silent! normal! 0v$y
  endif
  
  let lines = split(@@, '\n')

  " If any of the lines are uncommented
  " then we comment all of the lines
  " This is typical behavior in an editor
  let is_on = 1
  for line in lines
    " if match(line, '\v^\s*# ') < 0
    if match(line, '\v^\s*' . a:comment_char . ' ') < 0
      let is_on = 0
      break
    endif
  endfor

  if is_on
    execute ":silent! '<,'>s@\\v^(\\s*)" . a:comment_char . " @\\1"
  else
    execute ":silent! '<,'>s@\\v^(\\s*)(.*)@\\1" . a:comment_char . " \\2"
  endif

  let @@ = saved_reg
endfunction!

function! AlignComments(comment_char)
  normal! mm
  let l:first_line = line("'<")
  let l:last_line = line("'>")
  let l:position = [] " Note that we use this as a queue

  " Get the position of each comment
  let l:lnum = l:first_line
  while l:lnum <= l:last_line
    call add(l:position, match(getline(l:lnum), a:comment_char))
    let l:lnum += 1
  endwhile

  let l:max_position = max(l:position)

  " Shift the comment in lines which have them to the max distance
  let l:lnum = l:first_line
  while l:lnum <= l:last_line
    let l:pos = remove(l:position, 0)
    if l:pos < 0
    else
      call cursor(l:lnum, l:pos)
      " call setpos('.', [0, l:lnum, l:pos, 0])
      execute "normal! i" . repeat(' ', l:max_position - l:pos) . "\<esc>"
    endif
    let l:lnum += 1
  endwhile

  normal! `m

endfunction

" }}}
