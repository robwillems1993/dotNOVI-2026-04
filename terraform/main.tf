terraform {
  required_version = ">= 1.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_namespace" "dotnovi" {
  metadata {
    name = "dotnovi"
  }
}

resource "kubernetes_deployment" "dotnovi" {
  metadata {
    name      = "dotnovi"
    namespace = kubernetes_namespace.dotnovi.metadata[0].name

    labels = {
      app = "dotnovi"
    }
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "dotnovi"
      }
    }

    template {
      metadata {
        labels = {
          app = "dotnovi"
        }
      }

      spec {
        container {
          name              = "dotnovi"
          image             = "dotnovi:latest"
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "dotnovi" {
  metadata {
    name      = "dotnovi"
    namespace = kubernetes_namespace.dotnovi.metadata[0].name
  }

  spec {
    selector = {
      app = "dotnovi"
    }

    port {
      port        = 3000
      target_port = 3000
      node_port   = 30080
    }

    type = "NodePort"
  }
}