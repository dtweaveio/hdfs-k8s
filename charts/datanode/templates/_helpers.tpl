{{- define "hdfs-k8s.datanode.name" -}}
{{- template "hdfs-k8s.name" . -}}-datanode
{{- end -}}

{{- define "hdfs-k8s.datanode.fullname" -}}
{{- $fullname := include "hdfs-k8s.fullname" . -}}
{{- if contains "datanode" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-datanode" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
