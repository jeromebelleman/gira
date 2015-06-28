execute 'source ' . expand('<sfile>:p:h') . '/vimrc'

set nowrap

syntax match Type /^[^-\s]\+$/
syntax match Constant /^".*$/
syntax match Comment /^#.*$/
