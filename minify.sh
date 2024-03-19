#! /bin/bash

FLAG=$1;
PATH_ABSOLUT=$PWD/$2;
FILE_TYPE=$3;
FILE_TMP='';
readonly MIN_FILE_TMP_CSS=/tmp/main.min.css;
readonly MIN_FILE_TMP_JS=/tmp/main.min.js;

#Verifica se é uma flag (opção) válida.
if [[ `echo $FLAG | grep -v '[rio]'` ]] || [[ $# < 2 ]]; then
printf '
Você precisa passar uma opção válida:\n
    -r --read - Somente ler e cria um novo arquivo tranformado.\n
    -o --output - Somente ler e mostra a saída transformada.\n
    -i --in-replace - Substitui o texto original pelo transformado.\n
    $ minify -r directory/file.css \n
Obs: '-i' opção só funciona com arquivos especificados: dist/css/header.css.
\n'
   exit 1;
fi

# Verifica se o tipo de arquivo a ser minificado está presente.
if [ -d $PATH_ABSOLUT ] 
   then
    if [[ -z $FILE_TYPE ]] 
        then
          echo "";
          echo "css | js";
          echo "Você deve passar a extensão do tipo de arquivo a ser minificado:";
          echo "minify $1 $2 <?>";
          echo "";
          exit 1;
    fi
    FILE_TYPE=".$FILE_TYPE";
else
   FILE_TYPE=`printf "$PATH_ABSOLUT" | grep -o '[.].*'`;
fi

# Suprime todos os espaços redundantes dos arquivos em geral.
# Redireciona para outra função de acordo com o tipo de arquivo.
minify_general(){
    FILE_TMP=$1;
    scan_dir='';

    if [ -d $PATH_ABSOLUT ]; then
        scan_dir=`ls $PATH_ABSOLUT/*$FILE_TYPE`;

    elif [ -f $PATH_ABSOLUT ]; then
        scan_dir=`ls $PATH_ABSOLUT`;
    else
        echo "Arquivo não encontrado: $PATH_ABSOLUT";
        exit 1;
    fi

    for file in $scan_dir; 
       do
        # Remove comentários inline | Suprime espaços >> redireciona a saída.
        sed '/^\/.*[\/$]/d' "$file" | tr -s '[:space:]' ' ' >> $FILE_TMP;
        # Remove espaços entre caracteres comuns;
        sed -i -e \
        's/ {/{/g' -e \
        's/{ /{/g' -e \
        's/ } /}/g' -e \
        's/ }/}/g' -e \
        's/} /}/g' -e \
        's/: /:/g' -e \
        's/; /;/g' -e \
        's/, /,/g' -e \
        's/( /(/g' -e \
        's/ (/(/g' -e \
        's/ > />/g' -e \
        's/ < /</g' -e \
        's/ \/ /\//g' $FILE_TMP;
    done

    if [[ $FILE_TYPE = ".css" ]]; then
        minify_css "$FILE_TMP";
    fi
    
    if [[ $FILE_TYPE = ".js" ]]; then
        minify_js "$FILE_TMP";
    fi

};

# Minifica o CSS.
minify_css(){
    FILE_TMP=$1;
    sed -i -e \
        's/ # /#/g' -e \
        's/ \/ /\//g' $FILE_TMP;
};

# Minifica o JavaScript.
minify_js(){
    FILE_TMP=$1;
    sed -i -e \
        's/= /=/g' -e \
        's/ =/=/g' -e \
        's/== /==/g' -e \
        's/ ==/==/g' -e \
        's/=> /=>/g' -e \
        's/ =>/=>/g' -e \
        's/ +=/+=/g' -e \
        's/+= /+=/g' -e \
        's/-= /-=/g' -e \
        's/ -=/-=/g' $FILE_TMP;
}

# Verifica se já existe o mesmo arquivo minificado. Se sim, apaga.
verify_file_exist_and_remove(){
    if [ -f $1 ]; then
       rm -rf $1;
    fi
}

# Verifica se já existe o mesmo arquivo css minificado. Se sim, apaga.
if [[ $FILE_TYPE = ".css" ]]; then
    verify_file_exist_and_remove "$PATH_ABSOLUT/main.min.css";
    minify_general "$MIN_FILE_TMP_CSS";
fi

# Verifica se já existe o mesmo arquivo js minificado. Se sim, apaga.
if [[ $FILE_TYPE = ".js" ]]; then
    verify_file_exist_and_remove "$PATH_ABSOLUT/main.min.js";
    minify_general "$MIN_FILE_TMP_JS";
fi

# Verifica se é um caminho de arquivo e faz tratamento para arquivo;
if [ -f $PATH_ABSOLUT ]; then 

    if [[ $FLAG = "-r" ]]; then
       file_name=`printf "$PATH_ABSOLUT" | grep -o '[a-z/].*\.'`;
       min="min";
       mv $FILE_TMP $file_name$min$FILE_TYPE;
    fi  

    if [[ $FLAG = "-i" ]]; then
       mv $FILE_TMP $PATH_ABSOLUT;
    fi 
    
    if [[ $FLAG = "-o" ]]; then
       cat $FILE_TMP;
    fi

fi

# Verifica se é um diretório e faz tratamento para diretório;
if [ -d $PATH_ABSOLUT ]; then 

    if [[ $FLAG = "-r" ]]; then
       mv $FILE_TMP "$PATH_ABSOLUT/main.min$FILE_TYPE";
    fi  
    
    if [[ $FLAG = "-o" ]]; then
       cat $FILE_TMP;
    fi

fi
    
rm -rf $FILE_TMP;
unset PATH_ABSOLUT;
unset FILE_TYPE;
unset FILE_RESULT;