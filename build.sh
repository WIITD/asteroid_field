 #!/bin/bash

 case $1 in
   compile)
     echo "compiling..."
     fbc -x build/asteroid_field -w all -lang fb -gen gcc -fpu sse -Wc -O3 src/main.bas
     ;;
   build)
     case $2 in
       linux)
         echo "building for linux..."
         fbc -x build/asteroid_field_linux -w all -lang fb -gen gcc -fpu sse -Wc -O3 -target linux src/main.bas
         ./build/asteroid_field_linux
         ;;
       freebsd)
         echo "building for freebsd..."
         fbc -x build/asteroid_field_win64.exe -w all -lang fb -gen gcc -fpu sse -Wc -O3 -target freebsd src/main.bas
         ./build/asteroid_field_freebsd
         ;;
       openbsd)
         echo "building for freebsd..."
         fbc -x build/asteroid_field_win64.exe -w all -lang fb -gen gcc -fpu sse -Wc -O3 -target openbsd src/main.bas
         ./build/asteroid_field_openbsd
         ;;
       win)
         echo "building for windows..."
         fbc -x build/asteroid_field_win64.exe -w all -lang fb -gen gcc -fpu sse -Wc -O3 -prefix /usr/local/ -target x86_64-w64-mingw32 src/main.bas
         echo "done"
         
         echo "running wine..."
         wine build/asteroid_field_win64.exe
         ;;
       *)
         echo "building..."
         fbc -x build/game -w all -lang fb -gen gcc -fpu sse -Wc -O3 src/main.bas
         ./build/asteroid_field
         ;;
     esac
     ;;
   *)
     echo "compiling..."
     fbc -x build/asteroid_field -w all -lang fb -gen gcc -fpu sse -Wc -O3 src/main.bas
     ;;
 esac
 echo "done."
