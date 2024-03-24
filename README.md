# Minifica HTML | CSS | JS

*Este script usa três pacotes Linux: O tr, o sed e o grep. Adicionei alguma lógica e temos um minificador de texto eficiente e fácil de usar*.

Para tornar o script executável a partir de qualquer diretório, basta torná-lo um executável:

```
$ sudo chmod +x minify.sh
```

E depois copiá-lo para o diretório de binários do usuário:

```
$ sudo cp minify.sh /usr/local/bin/minify.sh && sudo ln -s /usr/local/bin/minify.sh /usr/local/bin/minify
```

Eu preferi criar também um link simbólico para chamar o script pelo comando **minify**.  

## Como usar?

O minify recebe até três opções de modo de operação:

* -r --read - *Somente ler e cria um novo arquivo tranformado*.
* -o --output - *Somente ler e mostra a saída transformada*.
* -i --in-replace - *Substitui o texto original pelo transformado*.

O minify recebe até três argumentos, sendo os dois primeiros obrigatórios: 

```
minify <modo-de-operação> <caminho-do-arquivo> <extensão-do-arquivo>
```

O último argumento é obrigatório quando o caminho é um diretório, assim o script precisa saber por qual tipo de arquivo buscar e minificar:

```
$ minify -r assets/ css
```

ou

```
$ minify -r assets/ js
```

**Atenção**: O minify ainda não suporta a opção -i para transformar todos os arquivos no nível do diretório, como no exemplo abaixo:

```
$ minify -i assets/ css
```

Então é isso. Espero que goste.
