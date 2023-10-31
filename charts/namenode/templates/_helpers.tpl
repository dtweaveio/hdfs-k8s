{{- define "hdfs-k8s.namenode.name" -}}
{{- template "hdfs-k8s.name" . -}}-namenode
{{- end -}}

{{- define "hdfs-k8s.namenode.fullname" -}}
{{- $fullname := include "hdfs-k8s.fullname" . -}}
{{- if contains "namenode" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-namenode" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}