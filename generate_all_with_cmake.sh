#! /bin/bash
# ---------------------------------------------------------------------------------------------------
#
#		 generate_all_with_cmake.sh : 	Nom de ce batch  
#
#      Batch de lancement de toutes les générations d'une application Linux (sources C) avec gcc 11.3.0 et clang 14.0.6-1
#    avec l'utilitaire CMAKE, on d'une seule génération, si le troisième paramètre optionnel fait partie de la liste suivante :
#    
#          [GCC32|GCC64|CLANG32|CLANG64]
#
#     Dans les grands principes, il y a un fichier CMakeLists.txt différent pour chaque catégorie de compilateurs stocké sous build.cmake\"Id du Compilateur"
#     qu'il faut recopier systèmatiquement sur le répertoire des sources de l'application (le 1er paramètre). C'est une "obligation" cmake.
#     Ensuite, une fois copié dans ce répertoire, et après un ménage dans les répertoires utiles à cmake (précaution), il n'y a plus qu'à générer les Makefile "ad hoc" avec l'aide 
#     de l'utilitaire cmake (dont l'exécutable doit être accessible dans le PATH !). 
#     Pour terminer, il faut ensuite générer l'application attendue par l'exécution de chacun de ces Makefile, là aussi avec le bon générateur "make" de chaque compilateur,
#     et pour chacune des versions Debug et Release.
#
# 	PS : la procédure "create_dir.sh" permet de créer TOUS les répertoires utiles à ces générations multiples 
#          et ensuite on lance generate_all_with_cmake.sh "nom_répertoire" "nom_appli" [id_generator].
# 
# 	AUTHOR : 						Thierry DECHAIZE
#   Date de création :				13 mars 2023   
# 	Date dernière modification : 	16 mars 2023 : don't forget "space" for test value of string -> [[ "$3" == "idcomp" ]]
# 	Détails des modifications : 	test value of third parameter is OK for GGC32, GCC64, CLANG32, CLANG64
# 	Version de ce script :			1.1.4  ->  "Version majeure" . "Version mineure" . "niveau de patch"
#
# ---------------------------------------------------------------------------------------------------

function usage() {
  echo "Usage : $0 DIRECTORY_APPLI NAME_APPLI [Compilateur]" 
  echo "  avec compilateur = [GCC32|GCC64|CLANG32|CLANG64]"
  echo "  et si pas de troisième paramètre, génération de toutes les compilations + link avec les utilitaires \"make\" spécifiques à chaque catégorie de compilateurs générés par CMAKE"
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
echo "Generateur  			: $3"

export DIRINIT=$PWD
export PATHSAV=$PATH
export SOURCE_DIR=$1
export NAME_APPLI=$2
cd $SOURCE_DIR

#             Génération cmake pour GCC 11.3.0 intégré à Linux Mint 21.1 Vera en version 32 bits
function gengcc32() {
rm --interactive=never CMakeLists.txt || true
rm --interactive=never build.cmake/gcc32/Debug/CMakeCache.txt || true
rm --interactive=never build.cmake/gcc32/Release/CMakeCache.txt || true
cp build.cmake/gcc32/CMakeLists.txt .
cmake -G "Unix Makefiles" -B build.cmake/gcc32/Debug -DCMAKE_BUILD_TYPE=Debug -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt .
cmake -G "Unix Makefiles" -B build.cmake/gcc32/Release -DCMAKE_BUILD_TYPE=Release -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt .
cd build.cmake/gcc32/Debug
make . all
cd ..
cd Release
make . all
cd $SOURCE_DIR
rm --interactive=never CMakeLists.txt || true
}

#             Génération cmake pour GCC 11.3.0 intégré à Linux Mint 21.1 Vera en version 64 bits
function gengcc64() {
rm --interactive=never CMakeLists.txt || true
rm --interactive=never build.cmake/gcc64/Debug/CMakeCache.txt || true
rm --interactive=never build.cmake/gcc64/Release/CMakeCache.txt || true
cp build.cmake/gcc64/CMakeLists.txt .
cmake -G "Unix Makefiles" -B build.cmake/gcc64/Debug -DCMAKE_BUILD_TYPE=Debug -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt .
cmake -G "Unix Makefiles" -B build.cmake/gcc64/Release -DCMAKE_BUILD_TYPE=Release -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt .
cd build.cmake/gcc64/Debug
make . all
cd ..
cd Release
make . all
cd $SOURCE_DIR
rm --interactive=never CMakeLists.txt || true
}
 
#             Génération cmake pour CLANG 14.0.6 intégré à Linux Mint 21.1 Vera en version 32 bits
function genclang32() {
rm --interactive=never CMakeLists.txt || true
rm --interactive=never build.cmake/clang32/Debug/CMakeCache.txt || true
rm --interactive=never build.cmake/clang32/Release/CMakeCache.txt || true
cp build.cmake/clang32/CMakeLists.txt .
cmake -G "Unix Makefiles" -B build.cmake/clang32/Debug -DCMAKE_BUILD_TYPE=Debug -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt -D_CMAKE_TOOLCHAIN_PREFIX=llvm- .
cmake -G "Unix Makefiles" -B build.cmake/clang32/Release -DCMAKE_BUILD_TYPE=Release -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt -D_CMAKE_TOOLCHAIN_PREFIX=llvm- .
cd build.cmake/clang32/Debug
make . all
cd ..
cd Release
make . all
cd $SOURCE_DIR
rm --interactive=never CMakeLists.txt || true
}

#             Génération cmake pour CLANG 14.0.6 intégré à Linux Mint 21.1 Vera en version 64 bits
function genclang64() {
rm --interactive=never CMakeLists.txt || true
rm --interactive=never build.cmake/clang64/Debug/CMakeCache.txt || true
rm --interactive=never build.cmake/clang64/Release/CMakeCache.txt || true
cp build.cmake/clang64/CMakeLists.txt .
cmake -G "Unix Makefiles" -B build.cmake/clang64/Debug -DCMAKE_BUILD_TYPE=Debug -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt -D_CMAKE_TOOLCHAIN_PREFIX=llvm- .
cmake -G "Unix Makefiles" -B build.cmake/clang64/Release -DCMAKE_BUILD_TYPE=Release -DNAME_APPLI=$NAME_APPLI -DCMAKE_USER_MAKE_RULES_OVERRIDE=~/ClangOverrides.txt -D_CMAKE_TOOLCHAIN_PREFIX=llvm- .
cd build.cmake/clang64/Debug
make . all
cd ..
cd Release
make . all
cd $SOURCE_DIR
rm --interactive=never CMakeLists.txt || true
}

if [[ "$3" == "GCC32" ]]; then 
   gengcc32
   cd $DIRINIT
   exit 1
elif [[ "$3" == "GCC64" ]]; then 
   gengcc64
   cd $DIRINIT
   exit 1
elif [[ "$3" == "CLANG32" ]]; then 
   genclang32
   cd $DIRINIT
   exit 1
elif [[ "$3" == "CLANG64" ]]; then 
   genclang64
   cd $DIRINIT
   exit 1
else 
   gengcc32
   gengcc64
   genclang32
   genclang64
   rm --interactive=never *.7z *.tgz *.tar || true
   # "C:\CodeBlocks\cbp2make.exe" --local -in $(project_dir)$(project_filename) -out makefile
   python3 ../../tools/Size_exec.py $NAME_APPLI
   python3 ../../tools/Calc_checksums.py $NAME_APPLI
   export datecurr=`date +"%d-%m-%Y"`
   export DAY=`echo $datecurr | cut -c 1-2`
   export MONTH=`echo $datecurr | cut -c 4-5`
   export YEAR=`echo $datecurr | cut -c 7-10`
   echo "Jour : $DAY"
   echo "Mois : $MONTH"
   echo "Ann?e : $YEAR"
   7z a "$NAME_APPLI"_"$YEAR"-"$MONTH"-"$DAY"_src.7z src\*.* res\*.* data\*.* build.cmake\* build.batch\* *.sh *.txt *.html *.md doxygen\* doc\* *.cbp *.workspace '-xr!*.bak' -mhe=on -p""$NAME_APPLI"_tde@03!"
   7z a -ttar "$NAME_APPLI"-"$YEAR"-"$MONTH"_"$DAY"_all.tar * '-x!*.7z' '-xr!*.bak'
   7z a "$NAME_APPLI"_"$YEAR"-"$MONTH"-"$DAY"_all.7z *.tar -mhe=on -p""$NAME_APPLI"_tde@03!"
   rm --interactive=never *.tar || true
   cd $DIRINIT
fi 
exit 0