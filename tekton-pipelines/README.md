# tekton-pipelines

Platform-owned Tekton pipelines on the **management** cluster, namespace `self-service`.

App teams **consume** these pipelines (start PipelineRuns). The platform team owns this chart.

Requires the **OpenShift Pipelines** operator (Pipeline CRDs). That operator is
GitOps-installed on **management** and **all dev** clusters via
`operators.openshiftPipelinesOperator` in platform-config.

## Pipelines

| Name | Folder | Purpose |
|------|--------|---------|
| `team-onboarding` | `templates/team-onboarding/` | Create Gitea org/repo from `my-team-gitops` skeleton, PR into `platform-config`, poll until merged |

### team-onboarding params

| Param | Default | Notes |
|-------|---------|--------|
| `TEAM_NAME` | (required) | `teams:` map key |
| `CLUSTER_NAME` | `digital` | → `clusters/dev/<CLUSTER_NAME>/clusterdef.yaml` |
| `GIT_GROUP` | `""` → `TEAM_NAME` | Gitea org |
| `GITHUB_USER` | (required) | GitHub username |
| `GITHUB_TOKEN` | (required) | **DEMO:** PAT as param (visible on PipelineRun) — needs `repo` on `nu-j/platform-config` |
| `CLUSTER_TYPE` | `dev` | Hardcoded for this demo |

Success = **PR merged**. Logs then remind you that digital Argo should create `team-argocd-<TEAM>`, `team-bootstrap-<TEAM>`, and namespace `<TEAM>-ci-cd`.

## Prerequisites

```bash
# 1. Wait for OpenShift Pipelines operator (GitOps: operators.openshiftPipelinesOperator)
#    oc get csv -n openshift-operators | grep pipelines

# 2. Gitea credentials Secret (not in Git)
oc -n self-service create secret generic gitea-platform-credentials \
  --from-literal=username=gitea_admin \
  --from-literal=password=d1sney
```

## Start a run

```bash
tkn pipeline start team-onboarding -n self-service \
  --use-param-defaults \
  -p TEAM_NAME=acme \
  -p CLUSTER_NAME=digital \
  -p GIT_GROUP=acme \
  -p GITHUB_USER=<you> \
  -p GITHUB_TOKEN=<pat> \
  -w name=work,emptyDir="" \
  --serviceaccount pipeline
```

Or from the OpenShift Pipelines UI: open pipeline `team-onboarding` in project `self-service`, fill the form, use workspace emptyDir / volume claim.

## Wiring

- Chart: `helm-catalog/tekton-pipelines`
- Application: `platform-apps/templates/management/tekton-pipelines-app.yaml`
- Toggle: `platform.argocdApps.tektonPipelines` — enabled in `clusters/management/common.yaml`
