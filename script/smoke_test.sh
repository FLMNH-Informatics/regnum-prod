#!/usr/bin/env bash
# Smoke test: request a few public pages and check the app answers them.
#
#   script/smoke_test.sh https://www.phyloregnum.org   # production baseline
#   script/smoke_test.sh http://localhost:3000         # local container
#
# Every page must return its expected status, and no page may contain a Rails
# error page. This catches a container that boots but can't load gems, reach
# the database, or render views; it is not a functional test of the app.
set -u

base="${1:?usage: $0 BASE_URL}"
base="${base%/}"
failures=0

# path  expected-status
checks=(
  "/                          200"
  "/search                    200"
  "/login                     200"
  "/signup                    200"
  "/javascripts/global.js     200"
  "/search_res                302"
  "/submissions               302"
)

for check in "${checks[@]}"; do
  read -r path expected <<<"$check"
  body="$(mktemp)"
  status="$(curl -s -o "$body" -w '%{http_code}' --max-time 30 "$base$path")"
  problem=""
  if [[ "$status" != "$expected" ]]; then
    problem="expected $expected"
  elif grep -qiE "We're sorry, but something went wrong|Action Controller: Exception caught|Internal Server Error" "$body"; then
    problem="error page in body"
  fi
  rm -f "$body"
  if [[ -n "$problem" ]]; then
    printf 'FAIL %s %s (%s)\n' "$status" "$path" "$problem"
    failures=$((failures + 1))
  else
    printf 'ok   %s %s\n' "$status" "$path"
  fi
done

if (( failures > 0 )); then
  echo "$failures check(s) failed against $base"
  exit 1
fi
echo "all checks passed against $base"
