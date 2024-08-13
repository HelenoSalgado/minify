#! /bin/bash

FLAG=$1;
PATH_ABSOLUT=$PWD/$2;
FILE_TYPE=$3;
FILE_TMP='';
#Verifica se é uma flag (opção) válida.
if [ `printf \/$FLAG | grep -v '[rio]'` ] || [[ $# < 2 ]]; then
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
if [ -d $PATH_ABSOLUT ]; then
    if [[ -z $FILE_TYPE ]]; then
    printf '
    css | js | html\n
    Você deve passar a extensão do tipo de arquivo a ser minificado:\n
    $ minify -r dist/css ? \n
';
    exit 1;
    fi
    FILE_TYPE=".$FILE_TYPE";
else
   FILE_TYPE=`printf "$PATH_ABSOLUT" | grep -o '[.].*'`;
fi
# Verifica se o arquivo minificado já existe, e o apaga.
if [ -f "$PATH_ABSOLUT/main.min$FILE_TYPE" ]; then
    rm -rf "$PATH_ABSOLUT/main.min$FILE_TYPE";
fi
# Remove espaços entre caracteres comuns.
minify_general(){
    FILE_TMP=$1;
    sed -i -e 's/ {/{/g' -e 's/{ /{/g' -e 's/ }/}/g' -e 's/} /}/g' -e 's/: /:/g' -e \
    's/ :/:/g' -e 's/; /;/g' -e 's/ ;/;/g' -e 's/# /#/g' -e 's/ #/#/g' -e 's/, /,/g' -e \
    's/ ,/,/g' -e 's/( /(/g' -e 's/ (/(/g' -e 's/) /)/g' -e 's/ )/)/g' -e 's/> />/g' -e \
    's/ >/>/g' -e 's/ </</g' -e 's/< /</g' -e 's/ \//\//g' -e 's/\/ /\//g' -e 's/" /"/g' -e \
    "s/' /'/g" -e "s/ '/'/g" -e 's/= /=/g' -e 's/ =/=/g' -e 's/= /=/g' -e 's/== /==/g' -e \
    's/ ==/==/g' -e 's/=> /=>/g' -e 's/ =>/=>/g' -e 's/ +=/+=/g' -e 's/+= /+=/g' -e \
    's/-= /-=/g' -e 's/ -=/-=/g' -e 's/ -/-/g' -e 's/- /-/g' -e 's/+ /+/g' -e 's/ +/+/g' -e 's/ ?/?/g' -e 's/? /?/g' 's/\[ /\[/g' -e 's/ \]/]/g' -e 's/ \&\&/\&\&/g' -e 's/\&\& /\&\&/g' $FILE_TMP;
}
# Suprime todos os espaços redundantes.
suprime_spaces(){
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
    # Remove comentários inline | Suprime espaços >> redireciona a saída.
    for file in $scan_dir; 
       do
        sed -e '/^\/.*[\/$]/d' -e '/<!-.*->$/d' "$file" | tr -s '[:space:]' ' ' >> $FILE_TMP;
    done
    minify_general "$FILE_TMP";
};
# Inicia o processo de minificação e cria um arquivo temporário para manipulação.
suprime_spaces "/tmp/main.min$FILE_TYPE";
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
# Apaga arquivo temporário.  
rm -rf $FILE_TMP;
# Limpa variáveis.
unset PATH_ABSOLUT;
unset FILE_TYPE;
unset FILE_RESULT;