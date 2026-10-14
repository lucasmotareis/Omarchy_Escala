#!/usr/bin/env bash
set -euo pipefail

source_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
target_dir="$HOME/.config/omarchy/plugins/lucas.calendar"
config_file="$HOME/.config/omarchy/shell.json"

[[ -f "$config_file" ]] || { echo "Configuração não encontrada: $config_file" >&2; exit 1; }
[[ ! -e "$target_dir" ]] || { echo "Plugin já existe: $target_dir" >&2; exit 1; }
omarchy plugin validate "$source_dir"

backup="$config_file.bak-escala-combinada-$(date +%Y%m%d-%H%M%S)"
cp -- "$config_file" "$backup"

stage=$(mktemp -d "$HOME/.config/omarchy/plugins/.lucas.calendar.XXXXXX")
rsync -a \
  --exclude='.git' --exclude='docs/' --exclude='tests/' --exclude='preview.png' \
  --exclude='install.sh' --exclude='migrate_config.py' --exclude='test-model.js' \
  "$source_dir/" "$stage/"
omarchy plugin validate "$stage"

temp_file=$(mktemp "$config_file.XXXXXX")
python3 "$source_dir/migrate_config.py" "$config_file" "$temp_file"
chmod --reference="$config_file" "$temp_file"
mv -- "$stage" "$target_dir"
mv -- "$temp_file" "$config_file"

echo "Calendário combinado instalado em $target_dir"
echo "Backup da configuração: $backup"
