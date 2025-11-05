# Development Environment Startup Script
# This script starts both the API and Frontend for local development

Write-Host "========================================" -ForegroundColor Green
Write-Host "STARTING DEVELOPMENT ENVIRONMENT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Check if Node.js is installed
Write-Host "Step 1: Checking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version 2>$null
    if ($nodeVersion) {
        Write-Host "✓ Node.js is installed: $nodeVersion" -ForegroundColor Green
    } else {
        Write-Host "✗ Node.js is not installed" -ForegroundColor Red
        Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "✗ Node.js is not installed" -ForegroundColor Red
    Write-Host "Please install Node.js from: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if .env file exists in API directory
Write-Host "Step 2: Checking API configuration..." -ForegroundColor Yellow
if (-not (Test-Path "api\.env")) {
    if (Test-Path "api\development.env") {
        Write-Host "⚠️  .env file not found, copying from development.env..." -ForegroundColor Yellow
        Copy-Item "api\development.env" "api\.env"
        Write-Host "✓ Created .env file from development.env" -ForegroundColor Green
    } else {
        Write-Host "✗ No environment configuration found" -ForegroundColor Red
        Write-Host "Please run: .\api\scripts\setup-local-db.ps1 first" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✓ API .env file found" -ForegroundColor Green
}

# Install dependencies if node_modules doesn't exist
Write-Host "Step 3: Checking dependencies..." -ForegroundColor Yellow

if (-not (Test-Path "api\node_modules")) {
    Write-Host "Installing API dependencies..." -ForegroundColor Yellow
    Set-Location "api"
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Failed to install API dependencies" -ForegroundColor Red
        Set-Location ".."
        exit 1
    }
    Set-Location ".."
    Write-Host "✓ API dependencies installed" -ForegroundColor Green
} else {
    Write-Host "✓ API dependencies found" -ForegroundColor Green
}

if (-not (Test-Path "frontend\node_modules")) {
    Write-Host "Installing Frontend dependencies..." -ForegroundColor Yellow
    Set-Location "frontend"
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "✗ Failed to install Frontend dependencies" -ForegroundColor Red
        Set-Location ".."
        exit 1
    }
    Set-Location ".."
    Write-Host "✓ Frontend dependencies installed" -ForegroundColor Green
} else {
    Write-Host "✓ Frontend dependencies found" -ForegroundColor Green
}

# Generate Prisma client
Write-Host "Step 4: Setting up database..." -ForegroundColor Yellow
Set-Location "api"
Write-Host "Generating Prisma client..." -ForegroundColor Yellow
npm run db:generate
if ($LASTEXITCODE -ne 0) {
    Write-Host "⚠️  Prisma client generation failed, but continuing..." -ForegroundColor Yellow
}
Set-Location ".."

# Start the development servers
Write-Host "Step 5: Starting development servers..." -ForegroundColor Yellow
Write-Host "Starting API server on http://localhost:3000..." -ForegroundColor Cyan
Write-Host "Starting Frontend server on http://localhost:3001..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Press Ctrl+C to stop both servers" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Green

# Start API server in background
$apiJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    Set-Location "api"
    npm run start:dev
}

# Start Frontend server in background
$frontendJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    Set-Location "frontend"
    npm run start:dev
}

# Wait for jobs to complete or user to interrupt
try {
    # Show status of both jobs
    while ($apiJob.State -eq "Running" -or $frontendJob.State -eq "Running") {
        Start-Sleep -Seconds 2
        
        # Check if API is ready
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:3000/api/v1" -TimeoutSec 2 -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200 -or $response.StatusCode -eq 404) {
                Write-Host "✓ API server is running on http://localhost:3000" -ForegroundColor Green
            }
        } catch {
            # API not ready yet
        }
        
        # Check if Frontend is ready
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:3001" -TimeoutSec 2 -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                Write-Host "✓ Frontend server is running on http://localhost:3001" -ForegroundColor Green
                break
            }
        } catch {
            # Frontend not ready yet
        }
    }
    
    # Keep the script running until user interrupts
    Write-Host ""
    Write-Host "🎉 Development environment is ready!" -ForegroundColor Green
    Write-Host "API: http://localhost:3000" -ForegroundColor Cyan
    Write-Host "Frontend: http://localhost:3001" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Press Ctrl+C to stop all servers" -ForegroundColor Yellow
    
    # Wait for user interrupt
    while ($true) {
        Start-Sleep -Seconds 1
    }
    
} catch {
    Write-Host ""
    Write-Host "Stopping development servers..." -ForegroundColor Yellow
} finally {
    # Clean up jobs
    if ($apiJob) {
        Stop-Job $apiJob -ErrorAction SilentlyContinue
        Remove-Job $apiJob -ErrorAction SilentlyContinue
    }
    if ($frontendJob) {
        Stop-Job $frontendJob -ErrorAction SilentlyContinue
        Remove-Job $frontendJob -ErrorAction SilentlyContinue
    }
    Write-Host "✓ Development servers stopped" -ForegroundColor Green
}
