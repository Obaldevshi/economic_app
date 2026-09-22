#!/usr/bin/env python3
"""
Small HTTP smoke checker for local API endpoints.

Usage:
  python scripts/smoke_http.py --base-url http://localhost:8000
"""

from __future__ import annotations

import argparse
import json
import sys
import urllib.error
import urllib.request


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Run lightweight API smoke checks.")
    parser.add_argument("--base-url", required=True, help="API base URL, e.g. https://srv.example.com")
    parser.add_argument("--timeout", type=float, default=8.0, help="Request timeout in seconds")
    return parser.parse_args()


def check_get(url: str, timeout: float) -> tuple[bool, str]:
    req = urllib.request.Request(url=url, method="GET")
    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:  # noqa: S310
            status = resp.status
            body = resp.read().decode("utf-8", errors="replace")
            if status >= 400:
                return False, f"HTTP {status}"
            # Validate JSON when possible to catch obvious gateway/html errors.
            try:
                json.loads(body)
            except json.JSONDecodeError:
                return False, "Non-JSON response"
            return True, f"HTTP {status}"
    except urllib.error.HTTPError as exc:
        return False, f"HTTPError {exc.code}"
    except urllib.error.URLError as exc:
        return False, f"URLError {exc.reason}"
    except Exception as exc:  # defensive
        return False, f"{type(exc).__name__}: {exc}"


def main() -> int:
    args = parse_args()
    base = args.base_url.rstrip("/")

    checks = [
        ("/health", "liveness"),
        ("/ready", "readiness"),
    ]

    failed = False
    print(f"Smoke check base URL: {base}")
    for path, label in checks:
        ok, msg = check_get(f"{base}{path}", timeout=args.timeout)
        mark = "PASS" if ok else "FAIL"
        print(f"[{mark}] {path:<16} ({label}) -> {msg}")
        failed = failed or not ok

    return 1 if failed else 0


if __name__ == "__main__":
    raise SystemExit(main())
