#!/usr/bin/env python3
"""Check local Markdown links and GitHub-style heading anchors."""

from __future__ import annotations

import re
import sys
from collections import Counter
from pathlib import Path
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
LINK_PATTERN = re.compile(r"(?<!!)(?<![\w])\[([^\]]+)\]\(([^)]+)\)")
HEADING_PATTERN = re.compile(r"^#{1,6}\s+(.+?)\s*#*\s*$")


def github_slug(value: str) -> str:
    value = re.sub(r"<[^>]+>", "", value)
    value = value.lower()
    value = re.sub(r"[^\w\- ]", "", value)
    return re.sub(r"\s+", "-", value.strip())


def anchors_for(path: Path) -> set[str]:
    counts: Counter[str] = Counter()
    anchors: set[str] = set()
    for line in path.read_text(encoding="utf-8").splitlines():
        match = HEADING_PATTERN.match(line)
        if not match:
            continue
        slug = github_slug(match.group(1))
        suffix = counts[slug]
        counts[slug] += 1
        anchors.add(slug if suffix == 0 else f"{slug}-{suffix}")
    return anchors


def main() -> int:
    failures: list[str] = []
    markdown_files = sorted(ROOT.rglob("*.md"))
    for source in markdown_files:
        if ".git" in source.parts:
            continue
        for line_number, line in enumerate(source.read_text(encoding="utf-8").splitlines(), start=1):
            for match in LINK_PATTERN.finditer(line):
                target = match.group(2).strip().strip("<>")
                parsed = urlsplit(target)
                if parsed.scheme or target.startswith("//"):
                    continue
                path_part = unquote(parsed.path)
                target_path = (source.parent / path_part).resolve() if path_part else source.resolve()
                try:
                    target_path.relative_to(ROOT.resolve())
                except ValueError:
                    failures.append(f"{source.relative_to(ROOT)}:{line_number}: link escapes repository: {target}")
                    continue
                if not target_path.exists():
                    failures.append(f"{source.relative_to(ROOT)}:{line_number}: missing local target: {target}")
                    continue
                if parsed.fragment and target_path.is_file():
                    if parsed.fragment not in anchors_for(target_path):
                        failures.append(
                            f"{source.relative_to(ROOT)}:{line_number}: missing anchor #{parsed.fragment} in {target}"
                        )

    if failures:
        for failure in failures:
            print(f"FAILED: {failure}")
        print(f"Checked {len(markdown_files)} Markdown file(s); {len(failures)} broken link(s) found.")
        return 1

    print(f"Checked {len(markdown_files)} Markdown file(s); all local links resolve.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
