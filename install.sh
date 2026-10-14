#!/usr/bin/env bash
set -euo pipefail

source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
target_dir="$HOME/.config/omarchy/plugins/lucas.clock"
config_file="$HOME/.config/omarchy/shell.json"

[[ -f "$config_file" ]] || { echo "Configuração não encontrada: $config_file" >&2; exit 1; }
[[ ! -e "$target_dir" ]] || { echo "Plugin já existe: $target_dir" >&2; exit 1; }
omarchy plugin validate "$source_dir"
jq -e 'any(.bar.layout[][]; .id == "omarchy.clock")' "$config_file" >/dev/null \
  || { echo 'Relógio omarchy.clock não está na barra.' >&2; exit 1; }

backup="$config_file.bak-escala-$(date +%Y%m%d-%H%M%S)"
cp -- "$config_file" "$backup"
mkdir -p -- "$target_dir"
cp -- "$source_dir"/{manifest.json,Model.js,Panel.qml,BarWidget.qml} "$target_dir/"

temp_file=$(mktemp "$config_file.XXXXXX")
trap 'rm -f -- "$temp_file"' EXIT
jq '
  .bar.layout |= with_entries(
    .value |= map(if .id == "omarchy.clock" then .id = "lucas.clock" else . end)
  ) |
  .cloneSourceRestores = ((.cloneSourceRestores // []) + ["lucas.clock"] | unique)
' "$config_file" > "$temp_file"
chmod --reference="$config_file" "$temp_file"
mv -- "$temp_file" "$config_file"
trap - EXIT

echo "Plugin instalado em $target_dir"
echo "Backup da configuração: $backup"
