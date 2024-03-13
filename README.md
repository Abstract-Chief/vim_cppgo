#установка плагина
   vim plug -> Plug 'Abstract-Chief/vim_cppgo'
   
#пример конфигурации на клавиши F2 F3 F4
   nnoremap <F2> :call CompileMe()<CR> #компиляция 
   nnoremap <F3> :call RunMe_Compiler()<CR> # запуск файла
   nnoremap <F4> :call DebugMe_Compiler()<CR> # дебаг файла для дебага добавьте планин 'cpiger/NeoDebug'

#вспомогательные команды
  :call SetLibCompiler($ARG) # $ARG строка содержащая подключение библеотек например "-lm"
  :call SetFlagsCompiler(($ARG) # $ARG строка содержащая флаги компиляции например "-Wall -g -Werror"
#информация
  Cтандартные флаги компиляции -Wall -g
  Именение компиляции от этих функции локальны для каждого файла тоесть разные файлы разные флаги и библеотеки
  
  

