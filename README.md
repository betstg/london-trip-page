# London, 26 to 29 October 2026

Public copy of the trip page. One self-contained HTML file, no build step, no dependencies.

## What is not in here

The private copy has a Papers tab with passport details, booking references and the flat's
address. None of that is in this repository, on purpose. Keep the private copy as a file on
your phone and never commit it.

`.gitignore` blocks the private filename so it cannot be added by accident.

## Publishing

Settings, Pages, Deploy from a branch, main, root. The page is then at
`https://<user>.github.io/<repo>/`.

## Photos

The photos are Wikimedia Commons files embedded in the page. The 15 on the Freebies tab are
credited in the Photo credits block at the foot of that tab, which is what CC BY-SA requires.

The other 48 photos elsewhere in the page were embedded before this repository existed and
their sources are not recorded. They need the same credit before this page is made public,
or they need replacing with photos whose source is known.

## Copia privada com senha

`_fonte-privada.html` e a copia completa, com a aba Papers, os PDFs e o passaporte.
Ela nunca vai para o git, o `.gitignore` bloqueia pelo nome.

Para publicar uma versao dela protegida por senha:

```
./gerar-privado.sh
```

O script pede a senha duas vezes, criptografa a pagina inteira com AES e gera
`privado.html`. Antes de terminar ele confere que nada aparece em texto claro no
resultado, e apaga o arquivo se encontrar qualquer coisa.

O que vai para o GitHub e so o bloco criptografado. A senha nao fica em lugar nenhum,
nem no repositorio, nem no script, nem no seu computador. Se perder a senha, a unica
saida e rodar o script de novo com uma nova.

Trocar a senha e so rodar o script outra vez e dar push.
