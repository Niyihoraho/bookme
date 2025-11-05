# PowerShell Script - INCREMENTAL UPDATE DEPLOYMENT
# This script only uploads changed files without rebuilding everything

Write-Host "========================================" -ForegroundColor Green
Write-Host "INCREMENTAL UPDATE DEPLOYMENT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

try {
    Write-Host "Step 1: Preparing for incremental update..." -ForegroundColor Yellow
    
    # Stop any running Node processes that might lock files
    Write-Host "Stopping any running Node processes..." -ForegroundColor Cyan
    Get-Process -Name "node" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    
    Write-Host "Step 2: Building only changed files..." -ForegroundColor Yellow
    
    # Check if API has changes and build if needed
    $hasApiChanges = $false
    $apiCodeFiles = Get-ChildItem -Path "api/src" -Recurse -File -ErrorAction SilentlyContinue
    if ($apiCodeFiles) {
        $hasApiChanges = $true
        Write-Host "Building API..." -ForegroundColor Cyan
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
        
        # Generate Prisma client
        Write-Host "Generating Prisma client..." -ForegroundColor Cyan
        npx prisma generate
        if ($LASTEXITCODE -ne 0) {
            throw "Prisma client generation failed!"
        }
        
        # Build the API
        npm run build
        if ($LASTEXITCODE -ne 0) {
            throw "API build failed! Please fix errors and try again."
        }
        Set-Location ".."
    }
    
    # Check if Frontend has changes and build if needed
    $hasFrontendChanges = $false
    $frontendCodeFiles = Get-ChildItem -Path "frontend/src" -Recurse -File -ErrorAction SilentlyContinue
    if ($frontendCodeFiles) {
        $hasFrontendChanges = $true
        Write-Host "Building Frontend..." -ForegroundColor Cyan
        Set-Location "frontend"
        
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
        
        # Build the Frontend
        npm run build
        if ($LASTEXITCODE -ne 0) {
            throw "Frontend build failed! Please fix errors and try again."
        }
        Set-Location ".."
    }

    if (-not $hasApiChanges -and -not $hasFrontendChanges) {
        Write-Host "No code changes detected. Nothing to update." -ForegroundColor Yellow
        exit 0
    }

    Write-Host "Step 3: Creating incremental update package..." -ForegroundColor Yellow
    
    # Clean up any existing temp directory
    if (Test-Path "temp_update") {
        Remove-Item -Recurse -Force "temp_update"
    }
    New-Item -ItemType Directory -Name "temp_update" | Out-Null

    # Copy only the updated API build files if API changed
    if ($hasApiChanges) {
        Write-Host "Copying updated API files..." -ForegroundColor Cyan
        Copy-Item -Recurse "api/dist" "temp_update/app/api/dist"
        Copy-Item "api/package.json" "temp_update/app/api/"
        Copy-Item "api/package-lock.json" "temp_update/app/api/"
        Copy-Item -Recurse "api/prisma" "temp_update/app/api/prisma"
    }
    
    # Copy only the updated Frontend build files if Frontend changed
    if ($hasFrontendChanges) {
        Write-Host "Copying updated Frontend files..." -ForegroundColor Cyan
        Copy-Item -Recurse "frontend/build" "temp_update/app/frontend/build"
        Copy-Item "frontend/package.json" "temp_update/app/frontend/"
    }
    
    # Copy updated ecosystem config (if changed)
    Copy-Item "ecosystem.config.js" "temp_update/app/"
    
    # Create logs directory
    New-Item -ItemType Directory -Name "temp_update/app/logs" | Out-Null

    Write-Host "Step 4: Creating update package..." -ForegroundColor Yellow
    Compress-Archive -Path "temp_update\*" -DestinationPath "update.zip" -Force

    Write-Host "Step 5: Uploading update to server..." -ForegroundColor Yellow
    scp -i "key-booking-service.pem" update.zip "ec2-user@ec2-16-170-244-196.eu-north-1.compute.amazonaws.com:~/"

    Write-Host "Step 6: Cleaning up local files..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "temp_update"
    Write-Host "Note: update.zip is kept for manual upload if needed" -ForegroundColor Green

    Write-Host "========================================" -ForegroundColor Green
    Write-Host "UPDATE PACKAGE READY!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Now run these SERVER UPDATE COMMANDS:" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "ssh -i `"key-booking-service.pem`" ec2-user@ec2-16-170-244-196.eu-north-1.compute.amazonaws.com" -ForegroundColor White
    Write-Host "unzip -o update.zip" -ForegroundColor White
    if ($hasApiChanges) {
        Write-Host "cd app/api && sudo npm ci --production" -ForegroundColor White
        Write-Host "cd app/api && npx prisma generate" -ForegroundColor White
        Write-Host "cd app && pm2 restart booking-service-api" -ForegroundColor White
    }
    if ($hasFrontendChanges) {
        Write-Host "cd app && pm2 restart booking-service-frontend" -ForegroundColor White
    }
    Write-Host "pm2 save" -ForegroundColor White
    Write-Host "pm2 status" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green

} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Update deployment failed. Please check the error and try again." -ForegroundColor Red
    exit 1
}
