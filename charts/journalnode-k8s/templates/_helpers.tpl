{{- define "hdfs-k8s.journalnode.name" -}}
{{- template "hdfs-k8s.name" . -}}-journalnode
{{- end -}}

{{- define "hdfs-k8s.journalnode.fullname" -}}
{{- $fullname := include "hdfs-k8s.fullname" . -}}
{{- if contains "journalnode" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-journalnode" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
