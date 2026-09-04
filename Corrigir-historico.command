#!/bin/bash
# Junta as versoes antigas do privado.html numa so e reescreve o historico no GitHub.
cd "$(dirname "$0")" || exit 1
clear
echo "================================================"
echo "  Limpar as versoes antigas do privado.html"
echo "================================================"
echo
fim() { echo; read -n 1 -s -r -p "Aperte qualquer tecla para fechar."; echo; exit "$1"; }

BASE=7933dcf
if ! git cat-file -e "$BASE" 2>/dev/null; then echo "Nao achei o commit base. Me avisa."; fim 1; fi

N=$(git log --oneline "$BASE"..HEAD -- privado.html | wc -l | tr -d ' ')
echo "Versoes do privado.html no historico agora: $N"
if [ "$N" -lt 2 ]; then echo; echo "So tem uma. Nao precisa fazer nada."; fim 0; fi
echo
echo "Vou juntar todas numa unica versao, a mais recente,"
echo "e apagar as anteriores do GitHub."
echo
echo "A pagina no ar nao muda. A senha atual continua a mesma."
echo
read -rp "Digita  sim  para continuar: " OK
[ "$OK" != "sim" ] && { echo "Cancelado, nada foi alterado."; fim 0; }
echo

git reset --soft "$BASE" || { echo "Falhou o reset."; fim 1; }
GITID=()
[ -z "$(git config user.email)" ] && [ -z "$(git config --global user.email)" ] && GITID=(-c user.name="betstg" -c user.email="roberta@kolabs.tech")
git add -A
git "${GITID[@]}" commit -q -m "Copia privada criptografada" || { echo "Falhou o commit."; fim 1; }
echo "Historico local reescrito."

echo "Enviando para o GitHub..."
if git push --force origin main 2>/dev/null; then
  echo "  Feito."
  git reflog expire --expire=now --all 2>/dev/null
  git gc --prune=now -q 2>/dev/null
  echo "  Limpei as copias locais tambem."
  echo
  echo "================================================"
  echo "  Pronto. Agora existe uma versao so,"
  echo "  com a senha que voce escolheu no fim."
  echo "================================================"
else
  echo "  O push nao passou. Me avisa que eu vejo outro caminho."
  fim 1
fi
fim 0
