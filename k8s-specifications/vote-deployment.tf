resource "kubernetes_deployment" "vote" {
  metadata {
    name = "vote"
    labels = {
      app = "vote"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app