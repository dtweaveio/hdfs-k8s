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

{{/*
Create the datanode data dir list.  The below uses two loops to make sure the
last item does not have comma. It uses index 0 for the last item since that is
the only special index that helm template gives us.
*/}}
{{- define "datanode-data-dirs" -}}
{{- range $index, $path := .Values.global.dataNodeHostPath -}}
  {{- if ne $index 0 -}}
    /hadoop/dfs/data/{{ $index }},
  {{- end -}}
{{- end -}}
{{- range $index, $path := .Values.global.dataNodeHostPath -}}
  {{- if eq $index 0 -}}
    /hadoop/dfs/data/{{ $index }}
  {{- end -}}
{{- end -}}
{{- end -}}