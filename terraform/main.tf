terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.37.0"
    }
  }
}

provider "kubernetes" {
  config_path    = pathexpand("~/.kube/config")
  config_context = "kind-notes-api"
}

resource "kubernetes_deployment_v1" "notes_api" {
  wait_for_rollout = false
  metadata {
    name      = "notes-api"
    namespace = "default"
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "notes-api"
      }
    }

    template {
      metadata {
        labels = {
          app = "notes-api"
        }
      }

      spec {
        automount_service_account_token = false
	enable_service_links            = false
        container {
          
          name              = "notes-api"
          image             = "notes-api:metrics"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 5000
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "notes_api" {
  wait_for_load_balancer = false
  metadata {
    name      = "notes-api"
    namespace = "default"
  }

  spec {
    selector = {
      app = "notes-api"
    }

    port {
      port        = 5000
      target_port = 5000
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
} 