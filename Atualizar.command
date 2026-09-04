#!/bin/bash
# Duplo clique neste arquivo para gerar a copia privada e publicar.
cd "$(dirname "$0")" || exit 1
clear
echo "================================================"
echo "  London 2026, atualizar a copia privada"
echo "================================================"
echo

fim() { echo; read -n 1 -s -r -p "Aperte qualquer tecla para fechar."; echo; exit "$1"; }

if ! command -v node >/dev/null 2>&1; then
  echo "O Node nao esta instalado neste Mac e o script precisa dele."
  echo
  echo "  Instala com:  brew install node"
  echo "  Ou baixa em:  https://nodejs.org"
  echo
  echo "Depois e so dar duplo clique aqui de novo."
  fim 1
fi

if [ ! -f _fonte-privada.html ]; then
  echo "Falta o arquivo _fonte-privada.html nesta pasta."
  echo "E a copia completa, com a aba Papers. Sem ela nao da para gerar nada."
  fim 1
fi

if [ ! -f node_modules/.bin/staticrypt ]; then
  echo "Instalando o staticrypt, so na primeira vez..."
  npm install --no-save --silent staticrypt || { echo "Falhou a instalacao."; fim 1; }
  echo "Instalado."
  echo
fi

echo "Escolhe a senha. Use uma frase, nao uma palavra. Minimo de 16 caracteres."
echo
echo "Nada vai aparecer na tela enquanto voce digita. Isso e normal."
echo
read -rsp "Senha: " P1; echo
read -rsp "Digita de novo: " P2; echo
echo
if [ "$P1" != "$P2" ]; then echo "As senhas nao batem. Da duplo clique de novo."; fim 1; fi
if [ ${#P1} -lt 16 ]; then echo "Curta demais, tem ${#P1} caracteres e precisa de 16."; fim 1; fi

echo "Criptografando, demora uns segundos..."
rm -rf encrypted
STATICRYPT_PASSWORD="$P1" node_modules/.bin/staticrypt _fonte-privada.html \
  --short --remember 30 -d encrypted \
  --template-title "London 2026, private" \
  --template-instructions "Documents and bookings." \
  --template-button "Open" >/dev/null 2>&1 || { echo "A criptografia falhou."; unset P1 P2; fim 1; }
unset P1 P2
mv encrypted/_fonte-privada.html privado.html
rm -rf encrypted

echo "Conferindo se sobrou alguma coisa em texto claro..."
FALHOU=0
for t in GJ296434 Staverton Z8ZDQN 1JDSN6GK CKSJZ68B ROBERTA ADAMO "application/pdf"; do
  if grep -q "$t" privado.html; then echo "  FALHOU, '$t' aparece em texto claro"; FALHOU=1; fi
done
if [ $FALHOU -eq 1 ]; then rm -f privado.html; echo; echo "Apaguei o arquivo. Nada foi publicado."; fim 1; fi
echo "  Tudo limpo, $(du -h privado.html | cut -f1)."
echo

echo "Salvando no git..."
GITID=()
if [ -z "$(git config user.email)" ] && [ -z "$(git config --global user.email)" ]; then
  GITID=(-c user.name="betstg" -c user.email="roberta@kolabs.tech")
fi
git add -A
if git diff --cached --quiet; then
  echo "  Nada mudou desde a ultima vez."
elif git "${GITID[@]}" commit -q -m "Atualiza a copia privada criptografada"; then
  echo "  Commit feito."
else
  echo "  O commit falhou. Abre o GitHub Desktop e faz por la."
  fim 1
fi

echo "Publicando..."
if git push origin main 2>/dev/null; then
  echo "  Push feito."
  echo
  echo "================================================"
  echo "  Pronto."
  echo
  echo "  https://betstg.github.io/london-trip-page/privado.html"
  echo
  echo "  Leva um ou dois minutos para o GitHub atualizar."
  echo "================================================"
else
  echo "  O push automatico nao funcionou, faltou a credencial."
  echo
  echo "  Abre o GitHub Desktop, o commit ja esta feito la."
  echo "  E so clicar em Push origin no topo."
fi
fim 0
