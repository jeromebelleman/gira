execute 'source ' . expand('<sfile>:p:h') . '/vimrc'

set spell spelllang=en_gb

syntax match Statement /^\(Type\|Priority\|Component\|Description\):/
syntax match Statement /^Comment from \w\+, .*$/
syntax match Statement /^New Comment?$/
syntax match Statement /\(Status\|Version\|Security\|Assignee\|Reporter\):/

syntax match Type /^[><]\{3\}.*$/
syntax match Comment /#\( [a-zA-Z,]\+\)\+$/
syntax match Comment /^#.*$/

fun! CompleteField(findstart, base)
  if a:findstart
    " locate the start of the word
    let line = getline('.')
    let start = col('.') - 1
    while start > 0 && line[start - 1] =~ '\S'
      let start -= 1
    endwhile
    return start
  else
    if col('.') < 42
      let path = $HOME . '/.gira/components'
    else
      let path = $HOME . '/.gira/versions'
    endif
    let vals = readfile(path)

    " find field values matching with "a:base"
    let res = []
    for m in vals
      if m =~ '^' . a:base
        call add(res, m)
      endif
    endfor
    return res
  endif
endfun

set completefunc=CompleteField
