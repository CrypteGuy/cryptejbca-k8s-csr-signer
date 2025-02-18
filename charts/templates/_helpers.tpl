{{/*
Expand the name of the chart.
*/}}
{{- define "ejbca-csr-signer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ejbca-csr-signer.fullname" -}}
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
{{- define "ejbca-csr-signer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ejbca-csr-signer.labels" -}}
helm.sh/chart: {{ include "ejbca-csr-signer.chart" . }}
{{ include "ejbca-csr-signer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ejbca-csr-signer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ejbca-csr-signer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ejbca-csr-signer.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- if .Values.ejbca.vault.enabled}}
{{- .Values.ejbca.vault.roleName }}
{{- else }}
{{- default (include "ejbca-csr-signer.fullname" .) .Values.serviceAccount.name }}
{{- end }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the cluster role binding
*/}}
{{- define "ejbca-csr-signer.clusterRole" -}}
{{- .Values.serviceAccount.name }}-cluster-role
{{- end }}

{{/*
Create the name of the role binding
*/}}
{{- define "ejbca-csr-signer.role" -}}
{{- .Values.serviceAccount.name }}-role
{{- end }}