# PowerShell Script to Setup Local MySQL Database
# This script helps set up a local MySQL database for development

Write-Host "========================================" -ForegroundColor Green
Write-Host "LOCAL DATABASE SETUP" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

# Check if MySQL is installed
Write-Host "Step 1: Checking MySQL installation..." -ForegroundColor Yellow

try {
    $mysqlVersion = mysql --version 2>$null
    if ($mysqlVersion) {
        Write-Host "✓ MySQL is installed: $mysqlVersion" -ForegroundColor Green
    } else {
        Write-Host "✗ MySQL is not installed or not in PATH" -ForegroundColor Red
        Write-Host "Please install MySQL and add it to your PATH" -ForegroundColor Yellow
        Write-Host "Download from: https://dev.mysql.com/downloads/mysql/" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "✗ MySQL is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install MySQL and add it to your PATH" -ForegroundColor Yellow
    Write-Host "Download from: https://dev.mysql.com/downloads/mysql/" -ForegroundColor Yellow
    exit 1
}

# Prompt for MySQL root password
Write-Host "Step 2: Database setup..." -ForegroundColor Yellow
$mysqlPassword = Read-Host "Enter MySQL root password (or press Enter if no password)"

# Set up database
Write-Host "Creating local database..." -ForegroundColor Yellow

if ($mysqlPassword) {
    mysql -u root -p$mysqlPassword -e "CREATE DATABASE IF NOT EXISTS booking_service_local;"
} else {
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS booking_service_local;"
}

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Database 'booking_service_local' created successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to create database. Please check your MySQL credentials." -ForegroundColor Red
    exit 1
}

# Update development.env with the correct database URL
Write-Host "Step 3: Updating configuration..." -ForegroundColor Yellow

$envFile = "development.env"
if (Test-Path $envFile) {
    if ($mysqlPassword) {
        $databaseUrl = "mysql://root:$mysqlPassword@localhost:3306/booking_service_local"
    } else {
        $databaseUrl = "mysql://root@localhost:3306/booking_service_local"
    }
    
    # Update the DATABASE_URL in development.env
    $content = Get-Content $envFile
    $newContent = $content -replace 'DATABASE_URL=".*"', "DATABASE_URL=`"$databaseUrl`""
    $newContent | Set-Content $envFile
    
    Write-Host "✓ Updated DATABASE_URL in $envFile" -ForegroundColor Green
} else {
    Write-Host "✗ development.env file not found" -ForegroundColor Red
}

Write-Host "Step 4: Next steps..." -ForegroundColor Yellow
Write-Host "1. Copy development.env to .env: cp development.env .env" -ForegroundColor Cyan
Write-Host "2. Install dependencies: npm install" -ForegroundColor Cyan
Write-Host "3. Generate Prisma client: npm run db:generate" -ForegroundColor Cyan
Write-Host "4. Push database schema: npm run db:push" -ForegroundColor Cyan
Write-Host "5. Start development server: npm run start:local" -ForegroundColor Cyan

Write-Host "========================================" -ForegroundColor Green
Write-Host "DATABASE SETUP COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
