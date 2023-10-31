{{/*
Expand the name of the chart.
*/}}
{{/*{{- define "hdfs-k8s.name" -}}*/}}
{{/*{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}*/}}
{{/*{{- end -}}*/}}
{{- define "hdfs-k8s.name" -}}
hdfs
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hdfs-k8s.fullname" -}}
{{- if .Values.global.fullnameOverride -}}
{{- .Values.global.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "hdfs-k8s.name" . -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hdfs-k8s.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hdfs-k8s.labels" -}}
helm.sh/chart: {{ include "hdfs-k8s.chart" . }}
{{ include "hdfs-k8s.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hdfs-k8s.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hdfs-k8s.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hdfs-k8s.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hdfs-k8s.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "hdfs-k8s.config.fullname" -}}
{{- $fullname := include "hdfs-k8s.name" . -}}
{{- if contains "config" $fullname -}}
{{- printf "%s" $fullname -}}
{{- else -}}
{{- printf "%s-config" $fullname | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "svc-domain" -}}
{{- printf "%s.svc.cluster.local" .Release.Namespace -}}
{{- end -}}


{{- define "journalnode-quorum" -}}
{{- $service := include "hdfs-k8s.journalnode.fullname" . -}}
{{- $domain := include "svc-domain" . -}}
{{- $port := .Values.journalnode.service.port -}}
{{- $replicas := .Values.global.journalnodeQuorumSize | int -}}
{{- range $i, $e := until $replicas -}}
  {{- if ne $i 0 -}}
    {{- printf "%s-%d.%s.%s:%d;" $service $i $service $domain (int $port) -}}
  {{- end -}}
{{- end -}}
{{- range $i, $e := until $replicas -}}
  {{- if eq $i 0 -}}
    {{- printf "%s-%d.%s.%s:%d" $service $i $service $domain (int $port) -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Construct the name of the namenode pod 0.
*/}}
{{- define "namenode-pod-0" -}}
{{- template "hdfs-k8s.namenode.fullname" . -}}-0
{{- end -}}

{{/*
Construct the full name of the namenode statefulset member 0.
*/}}
{{- define "namenode-svc-0" -}}
{{- $pod := include "namenode-pod-0" . -}}
{{- $service := include "hdfs-k8s.namenode.fullname" . -}}
{{- $domain := include "svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}

{{/*
Construct the name of the namenode pod 1.
*/}}
{{- define "namenode-pod-1" -}}
{{- template "hdfs-k8s.namenode.fullname" . -}}-1
{{- end -}}

{{/*
Construct the full name of the namenode statefulset member 1.
*/}}
{{- define "namenode-svc-1" -}}
{{- $pod := include "namenode-pod-1" . -}}
{{- $service := include "hdfs-k8s.namenode.fullname" . -}}
{{- $domain := include "svc-domain" . -}}
{{- printf "%s.%s.%s" $pod $service $domain -}}
{{- end -}}
