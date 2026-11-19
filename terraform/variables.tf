variable "region" {
  description = "Región de AWS donde se crean los recursos."
  type        = string
  default     = "us-east-1"
}

variable "repositorio" {
  description = "Repositorio de GitHub autorizado a asumir el rol, con el formato propietario/nombre."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9-]+/[A-Za-z0-9._-]+$", var.repositorio))
    error_message = "El repositorio debe tener el formato propietario/nombre."
  }
}

variable "rama" {
  description = "Rama del repositorio autorizada a asumir el rol."
  type        = string
  default     = "main"
}

variable "nombre_rol" {
  description = "Nombre del rol IAM que asumen los workflows."
  type        = string
  default     = "github-actions-lectura-s3"
}

variable "bucket_lectura" {
  description = "Nombre del bucket de S3 sobre el que el rol tiene permiso de solo lectura."
  type        = string
}
