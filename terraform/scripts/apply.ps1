Write-Host "Initializing Terraform..."
terraform init

Write-Host "Planning infrastructure changes..."
terraform plan -out=tfplan

Write-Host "Applying infrastructure..."
terraform apply tfplan

