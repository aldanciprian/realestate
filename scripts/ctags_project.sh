#!/bin/sh -x

# ./ctags_with_dep.sh file1.c file2.c ... to generate a tags file for these files.
#rm -rf ${1}/project.tags
rm -rf ${1}/tags

#gcc -M $* | sed -e 's/[\\ ]/\n/g' | \
            #sed -e '/^$/d' -e '/\.o:[ \t]*$/d' | \
            #ctags -L - --verbose=yes -f ${1}/project.tags  --c-kinds=+lpx  --c++-kinds=+lpx --fields=+iaS --extra=+q 
#ctags -R --verbose=yes -f ${1}/project.tags  --c-kinds=+lpx  --c++-kinds=+lpx --fields=+iaS --extra=+q 
ctags-exuberant -R --verbose=yes --c-kinds=+cdefglmnpstuvx--c++-kinds=+cdefglmnpstuvx--fields=+iafklmzstn --extra=+fq 
#ctags -R --verbose=yes -f ${1}/project.tags --c++-kinds=+p --fields=+iaS --extra=+q $1
#cdefglmnpstuvx
#cdefglmnpstuvx
