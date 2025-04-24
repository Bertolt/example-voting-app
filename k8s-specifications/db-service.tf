resource "kubernetes_service" "db" {
  metadata {
    name = "db"
    labels = {
      app = "db"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "db"
    }

    port {
      name       = "db-service"
      port       = 5432
      target_port = 5432
    }
  }
}