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
#     qu'il faut recopier systèmatiquemet sur le répertoire des sources de l'application (le 1er paramètre). C'est une "obligation" cmake
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
# 	Date dernière modification : 	16 mars 2023 : don't forget "space" for test value of string into double brackets -> [[ "$3" == "idcomp" ]]
# 	Détails des modifications : 	test value of third parameter is OK for GGC32, GCC64, CLANG32, CLANG64
# 	Version de ce script :			1.1.4  ->  "Version majeure" . "Version mineure" . "niveau de patch"
#
# ---------------------------------------------------------------------------------------------------

function usage() {
  echo "Usage : $0 DIRECTORY_APPLI NAME_APPLI [Compilateur]" 
  echo "  avec compilateur = [GCC32|GCC64|CLANG32|CLANG64]"
  echo "  et si pas de troisème paramètre, génération de toutes les compilations avec les utilitaires "make" spécifiques à chaque catégorie de compilateurs"
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
echo "Type de génération 	: $3"

export DIRINIT=$PWD
export PATHSAV=$PATH
export SOURCE_DIR=$1
export NAME_APPLI=$2
#   export PATH=/home/thierry/Sources/tools:/home/thierry/Sources/script_build:$PATH
cd $SOURCE_DIR

function search_src() {
rm --interactive=never src_c.txt || true
yourfilenames=`ls ./src/*.c`
for eachfile in $yourfilenames
do
  nb_src=0
  fname=$(basename $eachfile)
  fbname=${fname%.*}
  if [[ "$fbname" != "$NAME_APPLI" ]]; then 
	  nb_src=$((nb_src+1))
	  if [[ $nb_src -eq 1 ]]; then 
	     echo $fbname > src_c.txt
	  else
		 echo $fbname >> src_c.txt			 
	  fi
  fi 	  
done
}

#             Recherche des sources C qui ne sont pas ceux du programme "main" (dont le nom du fichier correspond au nom du programme généré : $NAME_APPLI)
search_src

#             Génération cmake pour GCC 11.3.0 intégré à Linux Mint 21.1 Vera en version 32 bits
function gen_gcc32() {
echo "Lancement d'une génération batch pour le compilateur gcc 11.3.0 32 bits"
./build.shell/Compil_link_GCC_32b_linux.sh $SOURCE_DIR $NAME_APPLI console Debug
./build.shell/Compil_link_GCC_32b_linux.sh $SOURCE_DIR $NAME_APPLI console Release
}

#             Génération cmake pour GCC 11.3.0 intégré à Linux Mint 21.1 Vera en version 64 bits
function gen_gcc64() {
echo "Lancement d'une génération batch pour le compilateur gcc 11.3.0 64 bits"
./build.shell/Compil_link_GCC_64b_linux.sh $SOURCE_DIR $NAME_APPLI console Debug
./build.shell/Compil_link_GCC_64b_linux.sh $SOURCE_DIR $NAME_APPLI console Release
}
 
#             Génération cmake pour CLANG 14.0.6 intégré à Linux Mint 21.1 Vera en version 32 bits
function gen_clang32() {
echo "Lancement d'une génération batch pour le compilateur clang 14.0.6 32 bits"
./build.shell/Compil_link_CLANG_32b_linux.sh $SOURCE_DIR $NAME_APPLI console Debug
./build.shell/Compil_link_CLANG_32b_linux.sh $SOURCE_DIR $NAME_APPLI console Release
}

#             Génération cmake pour CLANG 14.0.6 intégré à Linux Mint 21.1 Vera en version 64 bits
function gen_clang64() {
echo "Lancement d'une génération batch pour le compilateur clang 14.0.6 32 bits"
./build.shell/Compil_link_CLANG_64b_linux.sh $SOURCE_DIR $NAME_APPLI console Debug
./build.shell/Compil_link_CLANG_64b_linux.sh $SOURCE_DIR $NAME_APPLI console Release
}


if [[ "$3" == "GCC32" ]]; then 
   gen_gcc32
   rm --interactive=never src_c.txt || true
   cd $DIRINIT
   exit 1
elif [[ "$3" == "GCC64" ]]; then 
   gen_gcc64
   rm --interactive=never src_c.txt || true
   cd $DIRINIT
   exit 1
elif [[ "$3" == "CLANG32" ]]; then 
   gen_clang32
   rm --interactive=never src_c.txt || true
   cd $DIRINIT
   exit 1
elif [[ "$3" == "CLANG64" ]]; then 
   gen_clang64
   rm --interactive=never src_c.txt || true
   cd $DIRINIT
   exit 1
else 
   gen_gcc32
   gen_gcc64
   gen_clang32
   gen_clang64
   rm --interactive=never *.7z *.tgz *.tar || true
   rm --interactive=never src_c.txt || true
   # "C:\CodeBlocks\cbp2make.exe" --local -in $(project_dir)$(project_filename) -out makefile
   python3 ../../tools/Size_exec.py $NAME_APPLI
   python3 ../../tools/Calc_checksums.py $NAME_APPLI
   export datecurr=`date +"%d-%m-%Y"`
   export DAY=${datecurr:0:2}
   export MONTH=${datecurr:3:2}
   export YEAR=${datecurr:6:4}
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