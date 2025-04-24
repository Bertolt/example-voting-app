resource "kubernetes_service" "vote" {
  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "vote"
    }

    port {
      name       = "vote-service"
      port       = 80
      target_port = 80
      node_port   = 30487
    }
  }
}