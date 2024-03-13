let g:BaseCompilerLibs=""
let g:BaseCompilerFlags="-Wall -g"
function! GetLibsCompiler()
   try
      let l:file=readfile(GetNameWithPoint())
      echo l:file
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
   let l:filename=bufname()
   let l:type=GetTypeFromName(l:filename)
   let l:name=fnamemodify(l:filename, ':t:r')
   let l:comp="gcc"
   if l:type!="c" && l:type!="cpp"
      echo "dont support this filetype"
      return "null"
   endif
   if l:type=="cpp"
      let l:comp="g++"
   endif
   return l:comp ." ". GetFlagsCompiler() ." ". l:filename . " -o " . l:name ." ". GetLibsCompiler() 
endfunction

function! SaveInfoCompiler(path,n,str)
   try
      let l:lines = readfile(a:path)
   catch
      let l:lines=["",""]
   endtry
   let l:lines[a:n]=a:str
   call writefile(l:lines,a:path)
endfunction

function! GetNameWithPoint()
   let l:path=expand('%:p')
   let l:path_parts = split(l:path, '/')
   let l:last_file = l:path_parts[-1]
   return substitute(l:path, '/'.l:last_file, '/.compiler_' . l:last_file, '')
endfunction

function! SetFlagsCompiler(str)
   call SaveInfoCompiler(GetNameWithPoint(),0,a:str)
endfunction

function! SetLibCompiler(str)
   call SaveInfoCompiler(GetNameWithPoint(),1,a:str)
endfunction

function! CompileMe()
   let l:path=expand('%:p')
   let l:command=GetCompileCommand()
   if l:command=="null"
      return "null"
   endif
   echo "compilation command:    ".l:command
   echo "\\/\\/\\/\\/"
   execute "!".l:command
   return l:command
endfunction

function! RunMe_Compiler()
   let l:name=fnamemodify(bufname(), ':t:r')
   if CompileMe()=="null"
      return "null"
   endif
   execute "!./".l:name
   silent! execute "!rm ".l:name
endfunction
function! DebugMe_Compiler()
   let l:name=fnamemodify(bufname(), ':t:r')
   if CompileMe()=="null"
      return "null"
   endif
   silent! execute "NeoDebug"
    call timer_start(1100, {-> feedkeys("file ".l:name."\<CR>", 'i')})
    call timer_start(1450, {-> feedkeys("start\<CR>", 'i')})
   "silent! execute "!rm ".l:name
endfunction

