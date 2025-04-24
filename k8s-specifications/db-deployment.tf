resource "kubernetes_deployment" "db" {
  metadata {
    name = "db"
    labels = {
      app = "db"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "db"
      }
    }

    template {
      metadata {
        labels = {
          app = "db"
        }
      }

      spec {
        container {
          image = "postgres:15-alpine"
          name  = "postgres"

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "256Mi"
            }
          }

          env {
            name  = "POSTGRES_USER"
            value = "postgres"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "postgres"
          }

          port {
            container_port = 5432
            name           = "postgres"
          }

          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "db-data"
          }
        }

        volume {
          name = "db-data"

          empty_dir {}
        }
      }
    }
  }
}