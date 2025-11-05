# PowerShell Script - SMART DEPLOYMENT
# This script detects changes and chooses the appropriate deployment method

Write-Host "========================================" -ForegroundColor Green
Write-Host "SMART DEPLOYMENT - AUTO DETECT CHANGES" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Check what type of changes were made
$hasApiCodeChanges = $false
$hasFrontendCodeChanges = $false
$hasConfigChanges = $false
$hasDependencyChanges = $false

Write-Host "Step 1: Analyzing changes..." -ForegroundColor Yellow

# Check for API code changes (api/src)
$apiCodeFiles = Get-ChildItem -Path "api/src" -Recurse -File -ErrorAction SilentlyContinue
if ($apiCodeFiles) {
    $hasApiCodeChanges = $true
    Write-Host "✓ API code changes detected" -ForegroundColor Green
}

# Check for Frontend code changes (frontend/src)
$frontendCodeFiles = Get-ChildItem -Path "frontend/src" -Recurse -File -ErrorAction SilentlyContinue
if ($frontendCodeFiles) {
    $hasFrontendCodeChanges = $true
    Write-Host "✓ Frontend code changes detected" -ForegroundColor Green
}

# Check for config changes
$configFiles = @("api/package.json", "frontend/package.json", "ecosystem.config.js", "api/prisma/schema.prisma")
foreach ($file in $configFiles) {
    if (Test-Path $file) {
        $hasConfigChanges = $true
        Write-Host "✓ Config changes detected: $file" -ForegroundColor Green
        break
    }
}

# Check for dependency changes
if (Test-Path "api/package.json") {
    $apiPackageJson = Get-Content "api/package.json" -Raw
    if ($apiPackageJson -match '"dependencies"' -or $apiPackageJson -match '"devDependencies"') {
        $hasDependencyChanges = $true
        Write-Host "✓ API dependency changes detected" -ForegroundColor Green
    }
}

if (Test-Path "frontend/package.json") {
    $frontendPackageJson = Get-Content "frontend/package.json" -Raw
    if ($frontendPackageJson -match '"dependencies"' -or $frontendPackageJson -match '"devDependencies"') {
        $hasDependencyChanges = $true
        Write-Host "✓ Frontend dependency changes detected" -ForegroundColor Green
    }
}

Write-Host "Step 2: Choosing deployment strategy..." -ForegroundColor Yellow

if ($hasConfigChanges -or $hasDependencyChanges) {
    Write-Host "🔄 FULL DEPLOYMENT required (config/dependency changes)" -ForegroundColor Yellow
    Write-Host "Running full deployment..." -ForegroundColor Yellow
    
    # Run full deployment
    & ".\deploy.ps1"
} elseif ($hasApiCodeChanges -or $hasFrontendCodeChanges) {
    Write-Host "⚡ INCREMENTAL UPDATE possible (code changes only)" -ForegroundColor Yellow
    Write-Host "Running incremental update..." -ForegroundColor Yellow
    
    # Run incremental update
    & ".\deploy-update.ps1"
} else {
    Write-Host "ℹ️  No significant changes detected" -ForegroundColor Yellow
    Write-Host "Skipping deployment..." -ForegroundColor Yellow
}

Write-Host "========================================" -ForegroundColor Green
Write-Host "SMART DEPLOYMENT COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
