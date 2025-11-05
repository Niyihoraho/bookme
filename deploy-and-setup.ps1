# PowerShell Script - FULLY AUTOMATED DEPLOYMENT
# This script builds locally, uploads, and sets up everything on the server automatically

Write-Host "========================================" -ForegroundColor Green
Write-Host "FULLY AUTOMATED DEPLOYMENT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green

try {
    Write-Host "Step 1: Running local build and upload..." -ForegroundColor Yellow
    
    # Run the main deployment script
    & ".\deploy.ps1"
    
    if ($LASTEXITCODE -ne 0) {
        throw "Local deployment failed!"
    }
    
    Write-Host "Step 2: Setting up server automatically..." -ForegroundColor Yellow
    
    # Construct server commands
    $serverCommands = @"
unzip -o deployment.zip
pm2 stop all 2>/dev/null || true
pm2 delete all 2>/dev/null || true
cd app/api && sudo npm ci --production
cd app/api && npx prisma generate
cd app && pm2 start ecosystem.config.js
pm2 save
pm2 startup
pm2 status
"@
    
    Write-Host "Executing server setup commands..." -ForegroundColor Cyan
    
    # Execute commands on server
    ssh -i "key-booking-service.pem" "ec2-user@ec2-16-170-244-196.eu-north-1.compute.amazonaws.com" $serverCommands
    
    if ($LASTEXITCODE -ne 0) {
        throw "Server setup failed!"
    }
    
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "DEPLOYMENT COMPLETE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Your application is now running at:" -ForegroundColor Cyan
    Write-Host "Frontend: http://ec2-16-170-244-196.eu-north-1.compute.amazonaws.com:3001" -ForegroundColor White
    Write-Host "API: http://ec2-16-170-244-196.eu-north-1.compute.amazonaws.com:3000" -ForegroundColor White
    Write-Host "========================================" -ForegroundColor Green

} catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Automated deployment failed. Please check the error and try again." -ForegroundColor Red
    Write-Host "You can still run the server commands manually:" -ForegroundColor Yellow
    Write-Host "ssh -i `"key-booking-service.pem`" ec2-user@ec2-16-170-244-196.eu-north-1.compute.amazonaws.com" -ForegroundColor White
    Write-Host "unzip -o deployment.zip" -ForegroundColor White
    Write-Host "cd app/api && sudo npm ci --production" -ForegroundColor White
    Write-Host "cd app/api && npx prisma generate" -ForegroundColor White
    Write-Host "cd app && pm2 start ecosystem.config.js" -ForegroundColor White
    Write-Host "pm2 save" -ForegroundColor White
    exit 1
}