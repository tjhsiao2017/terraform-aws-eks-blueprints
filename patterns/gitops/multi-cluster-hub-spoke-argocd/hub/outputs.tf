output "configure_kubectl" {
  description = "Configure kubectl: make sure you're logged in with the correct AWS profile and run the following command to update your kubeconfig"
  value       = <<-EOT
    export KUBECONFIG="/tmp/hub-spoke"
    aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name} --alias hub
  EOT
}


output "configure_argocd" {
  description = "Terminal Setup"
  value       = <<-EOT
    export KUBECONFIG="/tmp/hub-spoke"
    aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name} --alias hub
    export ARGOCD_OPTS="--port-forward --port-forward-namespace argocd --grpc-web"
    kubectl --context hub config set-context --current --namespace argocd
    argocd login --port-forward --username admin --password $(argocd admin initial-password | head -1)
    echo "ArgoCD Username: admin"
    echo "ArgoCD Password: $(kubectl get secrets argocd-initial-admin-secret -n argocd --template="{{index .data.password | base64decode}}")"
    echo Port Forward: http://localhost:8080
    kubectl port-forward -n argocd svc/argo-cd-argocd-server 8080:80
    EOT
}

output "access_argocd" {
  description = "ArgoCD Access"
  value       = <<-EOT
    export KUBECONFIG="/tmp/hub-spoke"
    aws eks --region ${local.region} update-kubeconfig --name ${module.eks.cluster_name} --alias hub
    echo "ArgoCD Username: admin"
    echo "ArgoCD Password: $(kubectl --context hub get secrets argocd-initial-admin-secret -n argocd --template="{{index .data.password | base64decode}}")"
    echo "ArgoCD URL: https://$(kubectl --context hub get svc -n argocd argo-cd-argocd-server -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')"
    EOT
}


output "cluster_name" {
  description = "Cluster Hub name"
  value       = module.eks.cluster_name
}
output "cluster_endpoint" {
  description = "Cluster Hub endpoint"
  value       = module.eks.cluster_endpoint
}
output "cluster_certificate_authority_data" {
  description = "Cluster Hub certificate_authority_data"
  value       = module.eks.cluster_certificate_authority_data
}
output "cluster_region" {
  description = "Cluster Hub region"
  value       = local.region
}
