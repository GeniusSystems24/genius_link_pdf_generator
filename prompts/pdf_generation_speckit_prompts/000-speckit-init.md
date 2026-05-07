# 000 — Spec Kit Init

## Purpose

Initialize Spec Kit inside the existing PDF generation library project.

## Command

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init .
```

## If the project already contains files and Spec Kit needs to be initialized forcefully

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init . --force
```

## If you use PowerShell explicitly

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init . --script ps
```

## If you use POSIX shell explicitly

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init . --script sh
```

## If you want Codex Skills integration

```bash
uvx --from git+https://github.com/github/spec-kit.git specify init . --integration codex --integration-options="--skills"
```

## Notes

- Run this from the root of the library project.
- Commit your current work before running initialization.
- Do not start implementation from this step.
- This step only prepares the project for the Spec Kit workflow.
