Write-Host "Cleaning Terraform state files..."
Remove-Item -Path .terraform -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path terraform.tfstate* -Force -ErrorAction SilentlyContinue
Remove-Item -Path tfplan -Force -ErrorAction SilentlyContinue
Write-Host "Terraform state cleaned."
