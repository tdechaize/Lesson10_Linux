#! /bin/bash
# ---------------------------------------------------------------------------------------------------
# 
# 		 Compil_link_GCC_32b_linux.sh : 	Nom de ce batch  
# 
#      Batch de lancement d'une génération d'une application sous Linux (plusieurs sources C) 
#      avec le compilateur GCC 32 bits inclus dans Linux Mint 21.1 Vera (compatible Ubuntu)
# 
#     Dans les grands principes, on modifie certaines variables d'environnement, afin 
#     de pouvoir lancer une compilation des différents sources C et enfin de l'édition de lien
#     finale (ou du gestionnaire de librairie) qui génère l'application attendue.
#     Ce batch prend quatre paramètres  :
# 				le répertoire de l'application (le 1er paramètre) qui doit contenir un sous-répertoire \src 
# 								contenant les sources de celle-ci.
# 				le nom de l'application (qui doit être identique au nom du fichier principal source C (main ou Winmain), 
# 								ainsi qu'au nom du fichier des ressources -> extension ".rc")
# 				le type de génération (compilation + edition de lien/manager de librairie) attendue parmi 
# 							la liste suivante : console|lib|shared
# 				le type de génération attendue parmi la liste suivante : Debug|Release
# 
# 	PS : la procédure "create_dir.sh" permet de créer TOUS les répertoires utiles à ces générations multiples 
# 			(certains compilateurs ne sont pas capables de les créer ONLINE s'ils sont absents !!)
# 
# 	AUTHOR : 						Thierry DECHAIZE
#   Date de création :				17 Mars 2023   
# 	Date dernière modification : 	
# 	Détails des modifications : 	
# 	Version de ce script :			1.1.4  ->  "Version majeure" . "Version mineure" . "niveau de patch"
# 
# ---------------------------------------------------------------------------------------------------

function usage() {
  echo "Usage : $0 DIRECTORY_APPLI NAME_APPLI [type_génération] [Debug|release]" 
  echo "  avec type_génération = [console|lib|shared]"
}

if [[ -z "$1" || -z "$2" ]]; then
	usage
	exit 1
fi
if [ ! -d "$1" ]; then
  echo "ERROR : $1 does not exist."
  exit 1
fi

echo "Directory des sources : $1"
echo "Nom de l'application  : $2"
echo "Type de génération  	: $3"
export SOURCE_DIR=$1
export NAME_APPLI=$2
export DIRINIT=$PWD
cd $SOURCE_DIR

#    Génération d'une application [console|lib|shared (compil + link/ar) pour le compilateur GCC 32 bits
export OBJS=""
if [[ "$3" == "console" ]]; then 
   echo "GCC 11.3.0 32 bits : Genération console de l'application $2 en mode : $4"
   if [[ "$4" == "Debug" ]]; then 
       export CFLAGS="-m32 -g -DDEBUG -D_DEBUG"
       if [[ -f src_c.txt ]]; then 
	   	   for src_c in $(cat src_c.txt); do
                gcc $CFLAGS -o objgcc32/Debug/${src_c}.o -c src/${src_c}.c
		        OBJS+=" objgcc32/Debug/${src_c}.o"
		   done
       fi
	   gcc $CFLAGS -o objgcc32/Debug/${NAME_APPLI}.o -c src/${NAME_APPLI}.c
       gcc $CFLAGS $OBJS objgcc32/Debug/${NAME_APPLI}.o -o bingcc32/Debug/${NAME_APPLI}.exe -lGL -lglut -lGLU -lm -lXxf86vm -lXext -lX11
   elif [[ "$4" == "Release" ]]; then
       export CFLAGS="-O2 -m32 -DNDEBUG"
       if [[ -f src_c.txt ]]; then 
	   	   for src_c in $(cat src_c.txt); do
                gcc $CFLAGS -o objgcc32/Release/${src_c}.o -c src/${src_c}.c
		        OBJS+=" objgcc32/Release/${src_c}.o"
		   done
       fi
       gcc $CFLAGS -o objgcc32/Release/${NAME_APPLI}.o -c src/${NAME_APPLI}.c
       gcc $CFLAGS -s $OBJS objgcc32/Release/${NAME_APPLI}.o -o bingcc32/Release/${NAME_APPLI}.exe -lGL -lglut -lGLU -lm -lXxf86vm -lXext -lX11
    fi
elif [[ "$3" == "lib" ]]; then 
   echo "GCC 11.3.0 32 bits : Genération d une librairie statique $2 en mode : $4"
   if [[ "$4" == "Debug" ]]; then 
       export CFLAGS="-m32 -g -DDEBUG -D_DEBUG"
       if [[ -f src_c.txt ]]; then 
	   	   for src_c in $(cat src_c.txt); do
                gcc $CFLAGS -o objgcc32/Debug/${src_c}.o -c src/${src_c}.c
		        OBJS+=" objgcc32/Debug/${src_c}.o"
		   done
       fi
	   gcc $CFLAGS -o objgcc32/Debug/${NAME_APPLI}.o -c src/${NAME_APPLI}.c
       ar rcs bingcc32/Debug/lib${NAME_APPLI}.a $OBJS objgcc32/Debug/${NAME_APPLI}.o
   elif [[ "$4" == "Release" ]]; then
       export CFLAGS="-O2 -m32 -DNDEBUG"
       if [[ -f src_c.txt ]]; then 
	   	   for src_c in $(cat src_c.txt); do
                gcc $CFLAGS -o objgcc32/Release/${src_c}.o -c src/${src_c}.c
		        OBJS+=" objgcc32/Release/${src_c}.o"
		   done
       fi
       gcc $CFLAGS -o objgcc32/Release/${NAME_APPLI}.o -c src/${NAME_APPLI}.c
       ar rcs bingcc32/Release/lib${NAME_APPLI}.a $OBJS objgcc32/Release/${NAME_APPLI}.o
    fi
elif [[ "$3" == "shared" ]]; then 
   echo "GCC 11.3.0 32 bits : Genération d une libraririe partagée (shared) $2 en mode : $4"
   if [[ "$4" == "Debug" ]]; then 
       export CFLAGS="-m32 -g -DDEBUG -D_DEBUG"
       if [[ -f src_c.txt ]]; then 
	   	   for src_c in $(cat src_c.txt); do
                gcc $CFLAGS -o objgcc32/Debug/${src_c}.o -c src/${src_c}.c
		        OBJS+=" objgcc32/Debug/${src_c}.o"
		   done
       fi
	   gcc $CFLAGS -o objgcc32/Debug/${NAME_APPLI}.o -c src/${NAME_APPLI}.c
       gcc $CFLAGS -shared -s -Wl,--out-implib,objgcc32/Debug/lib${NAME_APPLI}.a -W1,—export-all-symbols -Wl,—enable-auto-image-base $OBJS objgcc32/Debug/${NAME_APPLI}.o -o bingcc32/Debug/lib${NAME_APPLI}.so -lGL -lglut -lGLU -lm -lXxf86vm -lXext -lX11
   elif [[ "$4" == "Release" ]]; then
       export CFLAGS="-O2 -m32 -DNDEBUG"
       if [[ -f src_c.txt ]]; then 
	   	   for src_c in $(cat src_c.txt); do
                gcc $CFLAGS -o objgcc32/Release/${src_c}.o -c src/${src_c}.c
		        OBJS+=" objgcc32/Release/${src_c}.o"
		   done
       fi
       gcc $CFLAGS -o objgcc32/Release/${NAME_APPLI}.o -c src/${NAME_APPLI}.c
       gcc $CFLAGS -shared -s -Wl,--out-implib,objgcc32/Release/lib${NAME_APPLI}.a -W1,—export-all-symbols -Wl,—enable-auto-image-base $OBJS objgcc32/Release/${NAME_APPLI}.o -o bingcc32/Release/lib${NAME_APPLI}.so -lGL -lglut -lGLU -lm -lXxf86vm -lXext -lX11
    fi
fi

echo "GCC 11.3.0 32 bits : Fin de genération de l'application $2 en mode : $4"
cd $DIRINIT
exit 0
