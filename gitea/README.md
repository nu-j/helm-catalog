# gitea

Demo Gitea on the **management** cluster. Wraps the official [Gitea Helm chart](https://dl.gitea.com/charts/) with OpenShift Route support and a seed Job for API automation labs.

## What you get

| Item | Value |
|------|--------|
| Namespace | `gitea` (labelled `argocd.argoproj.io/managed-by: openshift-gitops` so the platform Argo SA can sync) |
| Route | `gitea.apps.org.internal` (edge TLS) — override host in platform-config if your apps domain differs |
| Admin | `gitea_admin` / `d1sney` |
| Orgs (groups) | `mice`, `ducks` |
| Users | `mickey`, `minnie` → mice; `donald`, `daisy` → ducks (password `d1sney`) |
| Password policy | `PASSWORD_COMPLEXITY: off` (demo) — otherwise Gitea API returns misleading `PasswordIsRequired` for simple passwords |
| DB | SQLite (demo profile; no Postgres/Valkey) |

## Wiring

1. Chart: this folder (`helm-catalog/gitea`)
2. Application: `platform-apps/templates/management/gitea-app.yaml` (`clusterType=management`)
3. Toggle: `platform.argocdApps.gitea` — `false` in `default.yaml`, `true` in `clusters/management/common.yaml`

## Local render

```bash
helm dependency update .
helm template gitea . -n gitea
```

## Notes

- **DEMO ONLY** — passwords are in Git on purpose.
- Gitea models “groups” as **organizations**; the seed Job creates orgs and adds users to a `Members` team.
- Usernames are lowercase (`donald`, `daisy`); display names keep Donald/Daisy.
- Seed Job is a normal Argo-managed Job (sync-wave 5, Replace on re-sync); the script is idempotent.
