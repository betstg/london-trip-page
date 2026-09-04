#!/bin/bash
# Duplo clique para enviar o que ja esta commitado para o GitHub.
cd "$(dirname "$0")" || exit 1
clear
echo "================================================"
echo "  Publicar no GitHub"
echo "================================================"
echo
fim() { echo; read -n 1 -s -r -p "Aperte qualquer tecla para fechar."; echo; exit "$1"; }

if [ -n "$(git status --porcelain)" ]; then
  echo "Tem coisa nao salva ainda. Salvando..."
  GITID=()
  [ -z "$(git config user.email)" ] && [ -z "$(git config --global user.email)" ] && GITID=(-c user.name="betstg" -c user.email="roberta@kolabs.tech")
  git add -A
  git "${GITID[@]}" commit -q -m "Atualizacao" && echo "  Salvo."
  echo
fi

PEND=$(git log origin/main..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ "$PEND" = "0" ]; then
  echo "Nao tem nada esperando para subir. Ja esta tudo no GitHub."
  fim 0
fi
echo "Esperando para subir: $PEND alteracao(oes)"
git log origin/main..HEAD --oneline | sed 's/^/   /'
echo
echo "Enviando..."
if git push origin main 2>&1 | sed 's/^/   /'; then
  echo
  echo "================================================"
  echo "  Pronto."
  echo
  echo "  https://betstg.github.io/london-trip-page/"
  echo "  https://betstg.github.io/london-trip-page/privado.html"
  echo
  echo "  Leva um ou dois minutos para o GitHub atualizar."
  echo "================================================"
else
  echo
  echo "  Nao consegui enviar. Copia a mensagem acima e me manda."
  fim 1
fi
fim 0
