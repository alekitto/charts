{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "sentry.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "sentry.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name "sentry" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "sentry.postgresql.fullname" -}}
{{- template "sentry.fullname" . -}}-postgresql
{{- end -}}

{{- define "sentry.redis.fullname" -}}
{{- template "sentry.fullname" . -}}-redis
{{- end -}}

{{- define "sentry.smtp.fullname" -}}
{{- printf "%s-%s" .Release.Name "sentry-smtp" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Set postgres host
*/}}
{{- define "sentry.postgresql.host" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "sentry.postgresql.fullname" . -}}
{{- else -}}
{{- .Values.postgresql.postgresqlHost | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secret
*/}}
{{- define "sentry.postgresql.secret" -}}
{{- if .Values.postgresql.enabled -}}
{{- template "sentry.postgresql.fullname" . -}}
{{- else -}}
{{- template "sentry.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres secretKey
*/}}
{{- define "sentry.postgresql.secretKey" -}}
{{- if .Values.postgresql.enabled -}}
"postgresql-password"
{{- else -}}
{{- default "postgresql-password" .Values.postgresql.existingSecretKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set postgres port
*/}}
{{- define "sentry.postgresql.port" -}}
{{- if .Values.postgresql.enabled -}}
    "5432"
{{- else -}}
{{- default "5432" .Values.postgresql.postgresqlPort | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set kafka host
*/}}
{{- define "sentry.kafka.host" -}}
{{- if .Values.global.kafka.enabled -}}
{{- template "kafka.fullname" . -}}
{{- else -}}
{{- .Values.global.kafka.host | quote -}}
{{- end -}}
{{- end -}}

{{- define "kafka.fullname" -}}
{{- template "sentry.fullname" . -}}-kafka
{{- end -}}

{{/*
Set redis host
*/}}
{{- define "sentry.redis.host" -}}
{{- if .Values.global.redis.enabled -}}
{{- template "sentry.redis.fullname" . -}}
{{- else -}}
{{- .Values.global.redis.host | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set redis secret
*/}}
{{- define "sentry.redis.secret" -}}
{{- if .Values.global.redis.enabled -}}
{{- template "sentry.redis.fullname" . -}}
{{- else -}}
{{- template "sentry.fullname" . -}}
{{- end -}}
{{- end -}}

{{/*
Set redis secretKey
*/}}
{{- define "sentry.redis.secretKey" -}}
{{- if .Values.global.redis.enabled -}}
"redis-password"
{{- else -}}
{{- default "redis-password" .Values.global.redis.existingSecretKey | quote -}}
{{- end -}}
{{- end -}}

{{/*
Set redis port
*/}}
{{- define "sentry.redis.port" -}}
{{- if .Values.redis.enabled -}}
    "6379"
{{- else -}}
{{- default "6379" .Values.global.redis.port | quote -}}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "sentry.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "sentry.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "kafka-manager.fullname" -}}
{{ (include "sentry.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "snuba.name" -}}
{{- default "snuba" .Values.global.snuba.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "snuba.fullname" -}}
{{- if .Values.global.snuba.fullnameOverride -}}
{{- .Values.global.snuba.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "snuba" .Values.global.snuba.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "symbolicator.name" -}}
{{- default "symbolicator" .Values.global.symbolicator.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "symbolicator.fullname" -}}
{{- if .Values.global.symbolicator.fullnameOverride -}}
{{- .Values.global.symbolicator.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "symbolicator" .Values.global.symbolicator.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}
