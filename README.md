# Análisis de seguridad IaC en el pipeline

Práctica de ciberseguridad sobre un fork de OWASP Juice Shop. GitHub Actions analiza Terraform y el Dockerfile con Checkov antes de fusionar cambios a `master`. La práctica se limita al análisis estático.

- [Informe final en PDF](docs/informe.pdf)
- [Workflow de seguridad IaC](.github/workflows/iac-security.yml) y [ejecuciones en GitHub Actions](https://github.com/LilyAguilar/juice-shop-iac/actions/workflows/iac-security.yml)
- [PR de prueba del bloqueo](https://github.com/LilyAguilar/juice-shop-iac/pull/5) y [PR de remediación final](https://github.com/LilyAguilar/juice-shop-iac/pull/6)

## Estructura del repositorio

| Ruta                                                                       | Contenido                                                                                                                                                                                                                          |
| -------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [`.github/workflows/iac-security.yml`](.github/workflows/iac-security.yml) | Job **Escaneo IaC**, pruebas de la política, publicación del SARIF y gate de Checkov.                                                                                                                                              |
| [`terraform/`](terraform/)                                                 | Configuración de AWS. Incluye [ECS](terraform/main.tf), [red y balanceador](terraform/networking.tf), [subredes privadas](terraform/private_networking.tf), [WAF](terraform/waf.tf) y [registros y cifrado](terraform/logging.tf). |
| [`Dockerfile`](Dockerfile)                                                 | Definición de la imagen de la aplicación. Checkov la analiza junto con Terraform.                                                                                                                                                  |
| [`politicas/log_retention.yml`](politicas/log_retention.yml)               | Política `CKV2_ORG_1`, que exige al menos 30 días de retención para los grupos de logs de CloudWatch.                                                                                                                              |
| [`docs/informe.pdf`](docs/informe.pdf)                                     | Línea base, evidencias del pipeline, remediación y excepción documentada.                                                                                                                                                          |
| [`infrastructure/`](infrastructure/)                                       | Archivos de los retos originales de OWASP Juice Shop. El pipeline del laboratorio analiza el módulo de `terraform/`.                                                                                                               |
| [`README-OWASP.md`](README-OWASP.md)                                       | Documentación original de OWASP Juice Shop.                                                                                                                                                                                        |

## Cómo funciona el pipeline

**Seguridad IaC** se ejecuta en cada pull request y en los pushes a `master`. Usa Checkov 3.2.495 y verifica la política propia con dos casos de retención: 30 días deben pasar y 7 días deben fallar.

En **Actions → Seguridad IaC → ejecución → Artifacts** se puede descargar `checkov-sarif`. El workflow publica el reporte antes de aplicar el gate. Si Checkov devuelve un error, falla el check obligatorio **Escaneo IaC** y GitHub bloquea la fusión a `master`.
