# GitHub Action: Credo with reviewdog

[![Docker Image CI](https://github.com/red-shirts/reviewdog-action-credo/workflows/Docker%20Image%20CI/badge.svg)](https://github.com/red-shirts/reviewdog-action-credo/actions)

> Supports the latest Elixir version

This action runs [credo](https://github.com/rrrene/credo) with
[reviewdog](https://github.com/reviewdog/reviewdog) on pull requests to improve
code review experience.

## Inputs

### `github_token`

**Required**. Must be in form of `github_token: ${{ secrets.github_token }}`'.

### `level`

Optional. Report level for reviewdog [info,warning,error].
It's same as `-level` flag of reviewdog.

### `reporter`

Reporter of reviewdog command [github-pr-check,github-pr-review].
Default is github-pr-check.
github-pr-review can use Markdown and add a link to rule page in reviewdog reports.

## Example usage

### [.github/workflows/reviewdog.yml](.github/workflows/reviewdog.yml)

```yml
name: Reviewdog

on: [pull_request]

jobs:
  credo:
    name: Credo
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Setup Elixir
        uses: erlef/setup-beam@v1
        with:
          otp-version: '24'
          elixir-version: '1.12'
      - name: Install Dependencies
        run: |
          mix local.rebar --force
          mix local.hex --force
          mix deps.get
      - name: Git configuration
        run: git config --global --add safe.directory ${{ github.workspace }}
      - name: Run Credo
        run: mix credo --format=flycheck --all --strict
      - name: Credo reviewdog
        uses: yevh/reviewdog-action-credo@1d68a8bc263b3c09fc6db61641f4ba9aa0c3c027 #v1.3
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
```
