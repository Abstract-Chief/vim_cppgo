function! CompileMe()
   return CompileMe_DEV(bufname('%'))
endfunction
function! CompileMe_DEV(name)
    let l:path=expand(a:name)
    let l:command=split(GetCompileCommand(a:name),"|")
    if l:command[0]=="null"
        return ["null"]
    elseif l:command[0]=="it"
       execute "!".l:command[1]
       return l:command 
    endif
    echo "compilation command:    ".l:command[1]
    echo "\\/\\/\\/\\/"
    execute "!".l:command[1]
    return l:command
endfunction

function! RunMeDemon_Compiler()
   return RunMe_Compiler_DEV(bufname('%'),1)
endfunction
function! RunMe_Compiler()
   return RunMe_Compiler_DEV(bufname('%'),0)
endfunction
function! RunMe_Compiler_DEV(name,demon)
    let l:name=fnamemodify(a:name, ':t:r')
    let l:r=CompileMe_DEV(a:name)
    if l:r[0]=="null"
        return "null"
    elseif l:r[0]=="it"
       return "it"
    endif
    try
       let l:file=readfile(GetNameWithPoint(a:name))
       if len(l:file)>3
          if l:file[3]!="-"
             let l:name=l:file[3]
          endif
       endif
    catch
       echo "not found setting file"
    endtry 
    if a:demon==1
       silent! execute "!./".l:name." &"
       return "comp"
    endif
    execute "!./".l:name
    silent! execute "!rm ".l:name
    return "comp"
endfunction

function! DebugMe_Compiler()
    let l:name=fnamemodify(bufname(), ':t:r')
    silent! let l:r = CompileMe()
    if l:r[0]=="null"
       return "null"
    elseif l:r[0]=="it"
       return
    endif
    let l:file=readfile(GetNameWithPoint())
    try
       if len(l:file)>3
          if l:file[3]!="-"
             let l:name=l:file[3]
          endif
       endif
    catch
       echo "not found setting file"
    endtry 
    silent! execute "NeoDebug"
    call timer_start(1100, {-> feedkeys("file ".l:name."\<CR>", 'i')})
    call timer_start(1450, {-> feedkeys("start\<CR>", 'i')})
    "silent! execute "!rm ".l:name
endfunction

