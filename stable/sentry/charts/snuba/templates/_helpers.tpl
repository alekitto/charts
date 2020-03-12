{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "snuba.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "snuba.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "snuba.environment" -}}
- name: SNUBA_SETTINGS
  value: docker
- name: CLICKHOUSE_HOST
  value: {{ include "clickhouse.fullname" . }}
{{- if or .Values.kafka.enabled .Values.global.kafka.enabled .Values.global.kafka.host }}
- name: DEFAULT_BROKERS
  value: {{ printf "%s:%s" (include "sentry.kafka.host" .) ((default 2181 .Values.kafka.service.port) | toString) }}
{{- end }}
- name: REDIS_HOST
  value: {{ include "sentry.redis.host" . }}
{{- if or (.Values.global.redis.enabled) (.Values.redis.password) (.Values.global.redis.existingSecret) }}
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
    {{- if .Values.global.redis.existingSecret }}
      name: {{ .Values.global.redis.existingSecret }}
    {{- else }}
      name: {{ template "sentry.redis.secret" . }}
    {{- end }}
      key: {{ template "sentry.redis.secretKey" . }}
{{- end }}
- name: UWSGI_MAX_REQUESTS
  value: '10000'
- name: UWSGI_DISABLE_LOGGING
  value: 'true'
- name: UWSGI_ENABLE_THREADS
  value: 'true'
- name: UWSGI_DIE_ON_TERM
  value: 'true'
- name: UWSGI_NEED_APP
  value: 'true'
- name: UWSGI_IGNORE_SIGPIPE
  value: 'true'
- name: UWSGI_IGNORE_WRITE_ERRORS
  value: 'true'
- name: UWSGI_DISABLE_WRITE_EXCEPTION
  value: 'true'
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "clickhouse.name" -}}
{{- default "clickhouse" .Values.global.clickhouse.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "clickhouse.fullname" -}}
{{- if .Values.global.clickhouse.fullnameOverride -}}
{{- .Values.global.clickhouse.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "clickhouse" .Values.global.clickhouse.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
