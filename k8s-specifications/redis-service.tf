resource "kubernetes_service" "redis" {
  metadata {
    name = "redis"
    labels = {
      app = "redis"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "redis"
    }

    port {
      name       = "redis-service"
      port       = 6379
      target_port = 6379
    }
  }
}