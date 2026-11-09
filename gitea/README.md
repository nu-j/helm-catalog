# gitea

Demo Gitea on the **management** cluster. Wraps the official [Gitea Helm chart](https://dl.gitea.com/charts/) with OpenShift Route support and a seed Job for API automation labs.

## What you get

| Item | Value |
|------|--------|
| Namespace | `gitea` |
| Route | `gitea.apps.org.internal` (edge TLS) — override host in platform-config if your apps domain differs |
| Admin | `gitea_admin` / `d1sney` |
| Orgs (groups) | `mice`, `ducks` |
| Users | `mickey`, `minnie` → mice; `donald`, `daisy` → ducks (password `d1sney`) |
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
- Seed Job uses Argo Sync hooks and is idempotent.
