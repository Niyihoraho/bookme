# PowerShell Script - FULL DEPLOYMENT
# This script builds and deploys both frontend and API to production

Write-Host "========================================" -ForegroundColor Green
Write-Host "FULL DEPLOYMENT - REACT + NESTJS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

try {
    Write-Host "Step 1: Preparing for deployment..." -ForegroundColor Yellow
    
    # Stop any running Node processes that might lock files
    Write-Host "Stopping any running Node processes..." -ForegroundColor Cyan
    Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    
    Write-Host "Step 2: Installing dependencies..." -ForegroundColor Yellow
    
    # Install API dependencies
    Write-Host "Installing API dependencies..." -ForegroundColor Cyan
    Set-Location "api"
    
    # Clean up node_modules completely to avoid permission issues
    if (Test-Path "node_modules") {
        Write-Host "Cleaning up API node_modules..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force "node_modules" -ErrorAction SilentlyContinue
    }
    if (Test-Path "package-lock.json") {
        Remove-Item -Force "package-lock.json" -ErrorAction SilentlyContinue
    }
    
    # Install dependencies
    npm install
    if ($LASTEXITCODE -ne 0) {
        throw "API dependency installation failed!"
    }
    
    # Install Frontend dependencies
    Write-Host "Installing Frontend dependencies..." -ForegroundColor Cyan
    Set-Location "../frontend"
    
    # Clean up node_modules completely to avoid permission issues
    if (Test-Path "node_modules") {
        Write-Host "Cleaning up Frontend node_modules..." -ForegroundColor Cyan
        Remove-Item -Recurse -Force "node_modules" -ErrorAction SilentlyContinue
    }
    if (Test-Path "package-lock.json") {
        Remove-Item -Force "package-lock.json" -ErrorAction SilentlyContinue
    }
    
    # Install dependencies
    npm install
    if ($LASTEXITCODE -ne 0) {
        throw "Frontend dependency installation failed!"
    }
    
    # Install global serve for frontend
    Write-Host "Installing serve globally..." -ForegroundColor Cyan
    npm install -g serve
    if ($LASTEXITCODE -ne 0) {
        throw "Serve installation failed!"
    }
    
    Set-Location ".."

    Write-Host "Step 3: Building API..." -ForegroundColor Yellow
    Set-Location "api"
    
    # Generate Prisma client
    Write-Host "Generating Prisma client..." -ForegroundColor Cyan
    npx prisma generate
    if ($LASTEXITCODE -ne 0) {
        throw "Prisma client generation failed!"
    }
    
    # Build the API
    npm run build
    if ($LASTEXITCODE -ne 0) {
        throw "API build failed!"
    }
    Set-Location ".."

    Write-Host "Step 4: Building Frontend..." -ForegroundColor Yellow
    Set-Location "frontend"
    npm run build
    if ($LASTEXITCODE -ne 0) {
        throw "Frontend build failed!"
    }
    Set-Location ".."

    Write-Host "Step 5: Creating deployment package..." -ForegroundColor Yellow
    
    # Clean up any existing temp directory
    if (Test-Path "temp_deploy") {
        Remove-Item -Recurse -Force "temp_deploy"
    }
    New-Item -ItemType Directory -Name "temp_deploy" | Out-Null

    # Copy API build files (without node_modules - will install on server)
    Write-Host "Copying API files..." -ForegroundColor Cyan
    Copy-Item -Recurse "api/dist" "temp_deploy/app/api/dist"
    Copy-Item "api/package.json" "temp_deploy/app/api/"
    Copy-Item "api/package-lock.json" "temp_deploy/app/api/"
    Copy-Item -Recurse "api/prisma" "temp_deploy/app/api/prisma"
    
    # Copy Frontend build files
    Write-Host "Copying Frontend files..." -ForegroundColor Cyan
    Copy-Item -Recurse "frontend/build" "temp_deploy/app/frontend/build"
    Copy-Item "frontend/package.json" "temp_deploy/app/frontend/"
    
    # Copy ecosystem config
    Copy-Item "ecosystem.config.js" "temp_deploy/app/"
    
    # Create logs directory
    New-Item -ItemType Directory -Name "temp_deploy/app/logs" | Out-Null

    Write-Host "Step 6: Creating deployment archive..." -ForegroundColor Yellow
    Compress-Archive -Path "temp_deploy\*" -DestinationPath "deployment.zip" -Force

    Write-Host "Step 7: Uploading to server..." -ForegroundColor Yellow
    scp -i "key-booking-service.pem" deployment.zip "ec2-user@ec2-16-170-244-196.eu-north-1.compute.amazonaws.com:~/"

    Write-Host "Step 8: Cleaning up local files..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "temp_deploy"
    Write-Host "Note: deployment.zip is kept for manual upload if needed" -ForegroundColor Green

    Write-Host "========================================" -ForegroundColor Green
    Write-Host "DEPLOYMENT PACKAGE READY!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Now run these SERVER DEPLOYMENT COMMANDS:" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "ssh -i `"key-booking-service.pem`" ec2-user@ec2-16-170-244-196.eu-north-1.compute.amazonaws.com" -ForegroundColor White
    Write-Host "unzip -o deployment.zip" -ForegroundColor White
    Write-Host "pm2 stop all" -ForegroundColor White
    Write-Host "pm2 delete all" -ForegroundColor White
    Write-Host "cd app/api && sudo npm ci --production" -ForegroundColor White
    Write-Host "cd app/api && npx prisma generate" -ForegroundColor White
    Write-Host "cd app && pm2 start ecosystem.config.js" -ForegroundColor White
    Write-Host "pm2 save" -ForegroundColor White
    Write-Host "pm2 startup" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green

} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Deployment failed. Please check the error and try again." -ForegroundColor Red
    exit 1
}
