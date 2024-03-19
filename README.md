# Minifica CSS e JavaScript
<hr>

Para tornar o script executável a partir de qualquer diretório, basta torná-lo um executável:

```
$ sudo chmod +x minify.sh
```

E depois copiá-lo para o diretório de binários do usuário:

```
$ sudo cp minify.sh /usr/local/bin/minify.sh && sudo ln -s /usr/local/bin/minify.sh /usr/local/bin/minify
```

Eu preferi criar também um link simbólico para chamar o script pelo camando **minify**.  

## Como usar?

O minify recebe até três opções de modo de operação:

* -r --read - *Somente ler e cria um novo arquivo tranformado*.
* -o --output - *Somente ler e mostra a saída transformada*.
* -i --in-replace - *Substitui o texto original pelo transformado*.

```
$ minify -r assets/test.css
```

O minify recebe até três argumentos; os dois primeiros são obrigatórios: 

```
minify <modo-de-operação> <caminho-do-arquivo> <extensão-do-arquivo>
```

O último argumento é obrigatório quando o caminho é um diretório, assim o script precisa saber por qual tipo de arquivo buscar e minificar.

```
$ minify -r assets css
```

Então faça bom uso.