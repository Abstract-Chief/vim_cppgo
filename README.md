# изменения
   - добавление автоматической линковки теперь при подключении хедеров таких как <math.h> <ncurses.h> <pthreads.h> не нужно добавлять библеотеки это сделается автоматически
   - возможность установки своих связок библеотека -- линковка пример: AddCompLib(<header_name>,<compilation_flag>) -> AddCompLib("math","m") | AddCompLib("sqlite3.h","sqlite3")  
   
# Установка плагина
   vim plug -> Plug 'Abstract-Chief/vim_cppgo'
   
# Пример конфигурации на клавиши F2 F3 F4
   nnoremap <F2> :call CompileMe()<CR> #компиляция 
   
   nnoremap <F3> :call RunMe_Compiler()<CR> # запуск файла
   
   nnoremap <F4> :call DebugMe_Compiler()<CR> # дебаг файла для дебага добавьте планин 'cpiger/NeoDebug'
 
# Вспомогательные команды
  :call SetMakefile() # установка компиляции с помощью мейкфайла
  :call UnsetMakefile() # возврат к одиночной компиляции 
  
  :call SetLibCompiler($ARG) # $ARG строка содержащая подключение библеотек например "-lm"
  
  :call SetFlagsCompiler(($ARG) # $ARG строка содержащая флаги компиляции например "-Wall -g -Werror"
  
# Информация
  Cтандартные флаги компиляции -Wall -g
  Именение компиляции от этих функции локальны для каждого файла тоесть разные файлы разные флаги и библеотеки


  

