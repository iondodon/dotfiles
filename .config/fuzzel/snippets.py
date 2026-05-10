#!/usr/bin/env python3
import os
import shutil
import subprocess
import sys


def have(cmd: str) -> bool:
    return shutil.which(cmd) is not None


def notify(message: str) -> None:
    if have("notify-send"):
        subprocess.Popen(
            ["notify-send", "Snippets", message],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def copy_clipboard(text: str) -> bool:
    ok = False
    if have("wl-copy"):
        try:
            subprocess.run(["wl-copy"], input=text, text=True, check=True)
            ok = True
        except subprocess.SubprocessError:
            pass
    if have("xclip"):
        subprocess.run(
            ["xclip", "-selection", "clipboard", "-in"],
            input=text,
            text=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    elif have("xsel"):
        subprocess.run(
            ["xsel", "-b", "-i"],
            input=text,
            text=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    return ok


def load_snippets(paths):
    try:
        import yaml  # type: ignore
    except Exception:
        return None

    merged = []

    def parse_data(data):
        items = []
        if isinstance(data, list):
            entries = data
        elif isinstance(data, dict):
            entries = data.items()
        else:
            return items

        if isinstance(data, list):
            for entry in entries:
                if not isinstance(entry, dict):
                    continue
                name = str(entry.get("name", "")).strip()
                desc = str(entry.get("desc", "") or "").strip()
                value = entry.get("value", "")
                if isinstance(value, str) and value.startswith("\n"):
                    value = value[1:]
                if name and value is not None:
                    items.append((name, desc, str(value)))
        else:
            for name, entry in entries:
                if not isinstance(entry, dict):
                    continue
                desc = str(entry.get("desc", "") or "").strip()
                value = entry.get("value", "")
                if isinstance(value, str) and value.startswith("\n"):
                    value = value[1:]
                name = str(name).strip()
                if name and value is not None:
                    items.append((name, desc, str(value)))
        return items

    for path in paths:
        if not os.path.exists(path):
            continue
        try:
            with open(path, "r", encoding="utf-8") as handle:
                data = yaml.safe_load(handle) or []
        except Exception:
            continue
        merged.extend(parse_data(data))

    return merged


def build_display(name: str, desc: str) -> str:
    if desc:
        return f"{name} - {desc}"
    return name


def pick_selection(items):
    menu = "\n".join(build_display(name, desc) for name, desc, _val in items)
    proc = subprocess.run(
        ["fuzzel", "--dmenu"],
        input=menu,
        text=True,
        capture_output=True,
    )
    if proc.returncode != 0:
        return ""
    return proc.stdout.strip()


def lookup_value(items, selection: str):
    for name, desc, value in items:
        if build_display(name, desc) == selection:
            return value
    return None


def main() -> int:
    cfg_dir = os.path.expanduser("~/.config/fuzzel")
    paths = [
        os.path.join(cfg_dir, "snippets_open.yml"),
        os.path.join(cfg_dir, "snippets_closed.yml"),
    ]

    items = load_snippets(paths)
    if items is None:
        notify("Missing PyYAML (pip install pyyaml)")
        return 0

    if not items:
        notify("No snippets found")
        return 0

    selection = pick_selection(items)
    if not selection:
        return 0

    value = lookup_value(items, selection)
    if value is None:
        notify("No value found for selection")
        return 0

    if copy_clipboard(value):
        notify("Copied snippet")
    else:
        notify("Failed to copy snippet (clipboard helper missing)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
