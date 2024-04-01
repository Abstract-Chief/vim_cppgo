let g:BaseCompilerLibs=""
let g:BaseCompilerUserPath=expand('~')."/.NcompUserLibrary.data"
let g:BaseCompilerFlags="-Wall -g"

function! GetTypeFromName(name)
   let l:len=strlen(a:name)
   for i in range(0,l:len)
      if a:name[l:len-i]=="."
         return a:name[l:len-i+1:]
      endif
   endfor
   return "null"
endfunction
function! SaveInfoCompiler(path, n, str)
    try
        let l:lines = readfile(a:path)
    catch
        let l:lines=["","","",""]
    endtry
    for ind in range(0,4)
       call add(l:lines,"")
    endfor
    let l:lines[a:n]=a:str
    call writefile(l:lines[0:a:n],a:path)
endfunction

function! GetNameWithPoint()
    let l:path=expand('%:p')
    let l:path_parts = split(l:path, '/')
    let l:last_file = l:path_parts[-1]
    return substitute(l:path, '/'.l:last_file, '/.compiler_' . l:last_file, 'g')
endfunction

function! FindInFlagsBaseCompiler(flags,name)
   for id in a:flags
      if id[0] == a:name
         return 1
      endif
   endfor
   return 0
endfunction
function! BaseCompilerNameToPatter(header_name)
   return "^#include\\s*<".a:header_name.">"
endfunction
function! BaseCompilerSearch(header_name)
   execute 'w!'
   "echo 'grep "'.BaseCompilerNameToPatter(a:header_name).'" < '.expand("%:p")
   call systemlist('grep "'.BaseCompilerNameToPatter(a:header_name).'" < '.expand("%:p")) 
   if v:shell_error
      return 0
   endif
   return 1

endfunction
function! GetAutoCompileFlags()
   let l:result=""
   let l:flags=[["math.h","m"],["curses.h","curses"],["ncurses.h","ncurses"],["pthread.h","pthread"],["netdb.h","net"]]
   let l:user_flags=ParseAutoLibrary()
   for item in l:user_flags
      if FindInFlagsBaseCompiler(l:flags,item[0])==0
         call add(l:flags,item)
      endif
   endfor
   for item in l:flags
      if BaseCompilerSearch(item[0])==1
         let l:result=l:result."-l".item[1]." "
      endif
   endfor
   return l:result
endfunction! 
function! GetLibsCompiler()
    try
        let l:file=readfile(GetNameWithPoint())
        return l:file[1]
    catch
        return g:BaseCompilerLibs
    endtry
endfunction

function! GetFlagsCompiler()
    try
        let l:file=readfile(GetNameWithPoint())[0]
        if l:file==""
            return g:BaseCompilerFlags
        endif
        return l:file
    catch
        return g:BaseCompilerFlags
    endtry
endfunction

function! GetCompileCommand()
   try
       let l:file=readfile(GetNameWithPoint())
       if len(l:file)>2
          if l:file[2]!="-"
             return l:file[2]
          endif
       endif
    catch
       echo "not found setting file"
    endtry
    let l:filename=bufname()
    let l:type=GetTypeFromName(l:filename)
    let l:name=fnamemodify(l:filename, ':t:r')
    let l:comp="null"
    if l:type=="c"
        let l:comp="gcc"
    elseif l:type=="cpp"
        let l:comp="g++"
    elseif l:type=="py"
      let l:comp="python"
      if has('python3')
         let l:comp="python3" 
      endif
      return "it|".l:comp." ".l:filename
    else
        echo "dont support this filetype"
       return "null"
    endif
    return "comp|".l:comp ." ". GetFlagsCompiler() ." ". l:filename . " -o " . l:name ." ". GetLibsCompiler()." ".GetAutoCompileFlags() 
endfunction
function! ParseAutoLibrary()
    try
        let l:file=readfile(g:BaseCompilerUserPath)
        let l:result=[]
        for item in l:file
            if stridx(item,":")!=-1
                call add(l:result, split(item,":"))
            endif
        endfor
        return l:result
    catch
        return []
    endtry
endfunction

function! BaseCompilerToHeaderName(header_name)
    let l:header_name2 = substitute(a:header_name,' ','','g')
    if len(l:header_name2)==0 || stridx(l:header_name2,":")!=-1
        return ""
    endif
    if stridx(l:header_name2,".h")==-1
        return l:header_name2.".h"
    endif
    return l:header_name2
endfunction
