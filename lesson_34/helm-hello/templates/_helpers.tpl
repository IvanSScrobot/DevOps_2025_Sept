{{- define "helm-hello.name" -}}
helm-hello
{{- end -}}

{{- define "helm-hello.fullname" -}}
{{ .Release.Name }}-{{ include "helm-hello.name" . }}
{{- end -}}