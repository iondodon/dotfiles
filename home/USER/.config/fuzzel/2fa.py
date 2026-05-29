#!/usr/bin/env python3
import os
import shutil
import subprocess
import sys
import time


def have(cmd: str) -> bool:
    return shutil.which(cmd) is not None


def notify(message: str) -> None:
    if have("notify-send"):
        subprocess.Popen(
            ["notify-send", "2FA", message],
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


def load_accounts(yaml_path: str):
    try:
        import yaml  # type: ignore
    except Exception:
        return None

    try:
        with open(yaml_path, "r", encoding="utf-8") as handle:
            data = yaml.safe_load(handle) or []
    except FileNotFoundError:
        return []
    except Exception:
        return []

    entries = []
    if isinstance(data, list):
        for entry in data:
            if not isinstance(entry, dict):
                continue
            name = str(entry.get("name", "")).strip()
            secret = str(entry.get("secret", "")).strip()
            if name and secret:
                entries.append((name, secret))
    elif isinstance(data, dict):
        for name, entry in data.items():
            if not isinstance(entry, dict):
                continue
            secret = str(entry.get("secret", "")).strip()
            name = str(name).strip()
            if name and secret:
                entries.append((name, secret))
    return entries


def pick_selection(names):
    menu = "\n".join(names)
    proc = subprocess.run(
        ["fuzzel", "--dmenu"],
        input=menu,
        text=True,
        capture_output=True,
    )
    if proc.returncode != 0:
        return ""
    return proc.stdout.strip()


def generate_code(secret: str):
    try:
        proc = subprocess.run(
            ["oathtool", "--totp", "-b", secret],
            text=True,
            capture_output=True,
        )
    except FileNotFoundError:
        return None
    code = proc.stdout.strip()
    return code if code else None


def main() -> int:
    yaml_path = os.path.expanduser("~/.config/fuzzel/2fa.yml")
    entries = load_accounts(yaml_path)
    if entries is None:
        notify("Missing PyYAML (pip install pyyaml)")
        return 0
    if not entries:
        notify("No 2FA accounts found")
        return 0

    names = [name for name, _secret in entries]
    selection = pick_selection(names)
    if not selection:
        return 0

    selected_secret = ""
    for name, secret in entries:
        if name == selection:
            selected_secret = secret
            break

    if not selected_secret:
        notify(f"Unknown account: {selection}")
        return 0

    if not have("oathtool"):
        notify("Missing oathtool for OTP generation")
        return 0

    code = generate_code(selected_secret)
    if not code:
        notify(f"Failed to generate code for {selection}")
        return 0

    left = 30 - (int(time.time()) % 30)
    if copy_clipboard(code):
        notify(f"Copied {selection} ({left}s left)")
    else:
        notify(f"Failed to copy {selection} (clipboard helper missing)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
