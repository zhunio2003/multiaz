# Contributing to MultIAZ

Thank you for your interest in contributing to MultIAZ. Please read this guide
before submitting any contribution.

---

## Getting Started

1. Clone the repository
```bash
   git clone https://github.com/zhunio2003/multiaz.git
   cd multiaz
```

2. Make sure you have installed:
   - Docker Desktop
   - Java 21
   - Python 3.11+
   - Flutter 3.41.6
   - Node.js 18+

3. Start the infrastructure:
```bash
   docker compose -f docker/docker-compose.yml up -d
```

---

## Branch Naming
```<type>/<ID>-<short-description>```

| Type | When to use |
|---|---|
| `feature/` | New feature |
| `fix/` | Bug fix |
| `chore/` | Maintenance tasks |
| `hotfix/` | Urgent production fix |

Examples:
```
feature/TS-02.1-prediction-orchestrator
fix/DT-005-http-403-login
chore/ia-services-directory-structure
```

---

## Commit Messages

This project follows [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

```
<type>(<scope>): <short description>

detail 1
detail 2
```

| Type | When to use |
|---|---|
| `feat` | New feature or infrastructure addition |
| `fix` | Bug fix |
| `chore` | Maintenance, structure, config |
| `test` | Adding or updating tests |
| `docs` | Documentation only |
| `refactor` | Code restructure without behavior change |

Examples:
```
feat(auth-service): add JWT refresh token rotation
fix(api-gateway): resolve HTTP 403 on POST /auth/login
chore(ia-services): scaffold directory structure for all AI service modules
```

---

## Pull Requests

- One PR per backlog item
- PR title must follow the commit message format
- PR must include:
  - Description of what was done and why
  - Reference to the backlog item (e.g. `Closes TS-02.1`)
  - Evidence of manual testing or passing CI

---

## Code Style

| Language | Convention |
|---|---|
| Java | Google Java Style Guide |
| Python | PEP 8 |
| TypeScript | ESLint + Prettier |
| Dart | Dart Style Guide (`dart format`) |

---

## Reporting Bugs

Open a GitHub Issue with:
- Clear title describing the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment (OS, Docker version, service affected)

---

## Suggesting Features

Open a GitHub Issue with:
- Clear title
- Problem it solves
- Proposed solution
- Which layer or service it affects---

## Pull Requests

- One PR per backlog item
- PR title must follow the commit message format
- PR must include:
  - Description of what was done and why
  - Reference to the backlog item (e.g. `Closes TS-02.1`)
  - Evidence of manual testing or passing CI

---

## Code Style

| Language | Convention |
|---|---|
| Java | Google Java Style Guide |
| Python | PEP 8 |
| TypeScript | ESLint + Prettier |
| Dart | Dart Style Guide (`dart format`) |

---

## Reporting Bugs

Open a GitHub Issue with:
- Clear title describing the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment (OS, Docker version, service affected)

---

## Suggesting Features

Open a GitHub Issue with:
- Clear title
- Problem it solves
- Proposed solution
- Which layer or service it affects