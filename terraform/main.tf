provider "aws" {
  region = var.region
}

# Proveedor OIDC de GitHub Actions. AWS valida el certificado con su propia
# lista de CA, por lo que la huella no se usa; se deja la vigente por compatibilidad.
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "confianza" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Solo el repositorio y la rama indicados pueden asumir el rol.
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.repositorio}:ref:refs/heads/${var.rama}"]
    }
  }
}

resource "aws_iam_role" "github_actions" {
  name                 = var.nombre_rol
  assume_role_policy   = data.aws_iam_policy_document.confianza.json
  max_session_duration = 3600
}

# Minimo privilegio: solo lectura sobre un bucket concreto.
data "aws_iam_policy_document" "lectura_bucket" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_lectura}"]
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_lectura}/*"]
  }
}

resource "aws_iam_role_policy" "lectura_bucket" {
  name   = "lectura-bucket"
  role   = aws_iam_role.github_actions.id
  policy = data.aws_iam_policy_document.lectura_bucket.json
}
