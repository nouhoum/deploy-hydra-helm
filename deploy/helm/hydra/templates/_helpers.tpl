{{/*
Expand the name of the chart.
*/}}
{{- define "hydra.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "hydra.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hydra.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hydra.labels" -}}
helm.sh/chart: {{ include "hydra.chart" . }}
{{ include "hydra.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hydra.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hydra.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hydra.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hydra.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Generate the dsn value
*/}}
{{- define "hydra.dsn" -}}
{{- if .Values.demo -}}
memory
{{- else if .Values.hydra.config.dsn -}}
{{- .Values.hydra.config.dsn }}
{{- end -}}
{{- end -}}

{{/*
Generate the name of the secret resource containing secrets
*/}}
{{- define "hydra.secretname" -}}
{{ include "hydra.fullname" . }}
{{- end -}}

{{/*
Generate the configmap data, redacting secrets
*/}}
{{- define "hydra.configmap" -}}
{{- $config := omit .Values.hydra.config "dsn" "secrets" -}}
{{- toYaml $config -}}
{{- end -}}
