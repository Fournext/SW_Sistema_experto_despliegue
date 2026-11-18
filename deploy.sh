#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-all}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
BRANCH="${DEPLOY_BRANCH:-main}"

pull_repo() {
  local repo_name="$1"
  local repo_path="$BASE_DIR/$repo_name"

  if [ ! -d "$repo_path/.git" ]; then
    echo "Error: no se encontró el repositorio git en $repo_path" >&2
    exit 1
  fi

  echo "==> Actualizando $repo_name (rama $BRANCH)..."
  git -C "$repo_path" fetch origin "$BRANCH"
  git -C "$repo_path" checkout "$BRANCH"
  git -C "$repo_path" pull --ff-only origin "$BRANCH"
}

cd "$SCRIPT_DIR"

case "$TARGET" in
  front)
    pull_repo "SW_Sistema_experto_front"
    echo "==> Reconstruyendo y reiniciando servicio front..."
    docker compose up -d --build front
    ;;
  back)
    pull_repo "SW_Sistema_experto_back"
    echo "==> Reconstruyendo y reiniciando servicio back..."
    docker compose up -d --build back
    ;;
  despliegue)
    pull_repo "SW_Sistema_experto_despliegue"
    echo "==> Aplicando cambios de despliegue..."
    docker compose up -d --build
    ;;
  all)
    pull_repo "SW_Sistema_experto_despliegue"
    pull_repo "SW_Sistema_experto_back"
    pull_repo "SW_Sistema_experto_front"
    echo "==> Reconstruyendo y reiniciando todos los servicios..."
    docker compose up -d --build
    ;;
  *)
    echo "Uso: $0 {front|back|despliegue|all}" >&2
    exit 1
    ;;
esac

echo "==> Limpiando imágenes Docker huérfanas..."
docker image prune -f

echo "==> Despliegue ($TARGET) completado."
