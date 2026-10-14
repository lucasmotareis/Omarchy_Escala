#!/usr/bin/env python3
"""Replace the two clock widgets with one combined calendar widget."""

import json
import sys
from pathlib import Path


OLD_SHIFT = "lucas.clock"
OLD_CALENDAR = "tmn73.calendar"
BUILTIN = "omarchy.clock"
COMBINED = "lucas.calendar"
SECTIONS = ("left", "center", "right")
SHIFT_KEYS = ("shiftAnchor", "serviceDays", "offDays", "shiftOverrides")


def migrate(config):
    layout = config["bar"]["layout"]
    entries = [entry for section in SECTIONS for entry in layout.get(section, [])]
    shift = next((entry for entry in entries if entry.get("id") == OLD_SHIFT), {})
    calendar = next((entry for entry in entries if entry.get("id") == OLD_CALENDAR), {})
    builtin = next((entry for entry in entries if entry.get("id") == BUILTIN), {})
    existing = next((entry for entry in entries if entry.get("id") == COMBINED), {})

    if not any((shift, calendar, builtin, existing)):
        raise ValueError("Nenhum relógio ou calendário encontrado na barra")

    combined = dict(calendar or existing or shift or builtin)
    for key, value in shift.items():
        if key != "id" and (key in SHIFT_KEYS or key not in combined):
            combined[key] = value
    combined["id"] = COMBINED

    preferred = OLD_SHIFT if shift else OLD_CALENDAR if calendar else COMBINED if existing else BUILTIN
    inserted = False
    for section in SECTIONS:
        updated = []
        for entry in layout.get(section, []):
            widget_id = entry.get("id")
            if widget_id in (OLD_SHIFT, OLD_CALENDAR, BUILTIN, COMBINED):
                if widget_id == preferred and not inserted:
                    updated.append(combined)
                    inserted = True
            else:
                updated.append(entry)
        layout[section] = updated

    config["bar"]["centerAnchor"] = COMBINED
    config["plugins"] = [
        entry for entry in config.get("plugins", [])
        if entry.get("id") not in (OLD_SHIFT, OLD_CALENDAR, COMBINED)
    ]
    restores = [
        widget_id for widget_id in config.get("cloneSourceRestores", [])
        if widget_id not in (OLD_SHIFT, OLD_CALENDAR, COMBINED)
    ]
    restores.append(COMBINED)
    config["cloneSourceRestores"] = restores
    return config


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit("Uso: migrate_config.py entrada.json saida.json")
    source, target = map(Path, sys.argv[1:])
    data = json.loads(source.read_text(encoding="utf-8"))
    migrated = migrate(data)
    target.write_text(json.dumps(migrated, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
