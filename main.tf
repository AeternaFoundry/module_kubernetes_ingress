resource "kubernetes_ingress" "ingresses" {
  for_each = var.ingresses

  wait_for_load_balancer = each.value.wait_for_load_balancer

  metadata {
    annotations   = each.value.metadata.annotations
    generate_name = each.value.metadata.generate_name
    labels        = each.value.metadata.labels
    name          = each.value.metadata.name
    namespace     = each.value.metadata.namespace
  }

  spec {
    dynamic "backend" {
      for_each = each.value.spec.backend != null ? [each.value.spec.backend] : []
      content {
        service_name = backend.value.service_name
        service_port = backend.value.service_port
      }
    }
    ingress_class_name = each.value.spec.ingress_class_name
    dynamic "rule" {
      for_each = each.value.spec.rule != null ? each.value.spec.rule : []
      content {
        host = rule.value.host
        http {
          dynamic "path" {
            for_each = rule.value.http.path
            content {
              dynamic "backend" {
                for_each = path.value.backend != null ? [path.value.backend] : []
                content {
                  service_name = backend.value.service_name
                  service_port = backend.value.service_port
                }
              }
              path = path.value.path
            }
          }
        }
      }
    }
    dynamic "tls" {
      for_each = each.value.spec.tls != null ? each.value.spec.tls : []
      content {
        hosts       = tls.value.hosts
        secret_name = tls.value.secret_name
      }
    }
  }
}

