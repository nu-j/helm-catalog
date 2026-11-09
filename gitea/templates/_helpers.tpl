{{/*
Wrapper helpers — kept minimal; upstream chart brings its own.
*/}}
{{- define "gitea-wrapper.namespace" -}}
{{- .Values.namespace | default "gitea" -}}
{{- end -}}
