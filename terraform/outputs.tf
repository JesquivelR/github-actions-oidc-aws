output "arn_rol" {
  description = "ARN del rol que se pasa a role-to-assume en el workflow."
  value       = aws_iam_role.github_actions.arn
}

output "arn_proveedor_oidc" {
  description = "ARN del proveedor OIDC de GitHub creado en la cuenta."
  value       = aws_iam_openid_connect_provider.github.arn
}
