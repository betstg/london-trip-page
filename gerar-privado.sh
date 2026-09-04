#!/bin/bash
# Gera privado.html criptografado a partir de _fonte-privada.html.
# A senha nunca e salva em lugar nenhum. Ela e a chave.
set -e
cd "$(dirname "$0")"

if [ ! -f _fonte-privada.html ]; then
  echo "Falta o _fonte-privada.html nesta pasta."; exit 1
fi
if [ ! -x node_modules/.bin/staticrypt ]; then
  echo "Instalando staticrypt..."; npm install --no-save --silent staticrypt
fi

read -rsp "Senha (frase longa, minimo 16 caracteres): " P1; echo
read -rsp "Digita de novo: " P2; echo
if [ "$P1" != "$P2" ]; then echo "As senhas nao batem."; exit 1; fi
if [ ${#P1} -lt 16 ]; then echo "Curta demais. Use uma frase de pelo menos 16 caracteres."; exit 1; fi

rm -rf encrypted
STATICRYPT_PASSWORD="$P1" node_modules/.bin/staticrypt _fonte-privada.html \
  --short --remember 30 -d encrypted \
  --template-title "London 2026, private" \
  --template-instructions "Documents and bookings." \
  --template-button "Open" >/dev/null
unset P1 P2

mv encrypted/_fonte-privada.html privado.html
rm -rf encrypted

FALHOU=0
for t in GJ296434 Staverton Z8ZDQN 1JDSN6GK CKSJZ68B ROBERTA ADAMO "application/pdf"; do
  if grep -q "$t" privado.html; then echo "FALHOU: '$t' aparece em texto claro"; FALHOU=1; fi
done
if [ $FALHOU -eq 1 ]; then rm -f privado.html; echo "Nada foi gerado."; exit 1; fi

echo
echo "Pronto. privado.html gerado e verificado, $(du -h privado.html | cut -f1)."
echo "Agora abre o GitHub Desktop, faz commit e push."
echo "Depois fica em https://betstg.github.io/london-trip-page/privado.html"
