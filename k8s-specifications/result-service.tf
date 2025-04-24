resource "kubernetes_service" "result" {
  metadata {
    name = "result"
    labels = {
      app = "result"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "result"
    }

    port {
      name       = "result-service"
      port       = 80
      target_port = 80
      node_port   = 31249
    }
  }
}