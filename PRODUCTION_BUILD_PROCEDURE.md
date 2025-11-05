# Production Build & Deployment Procedure

## Overview
This document outlines the complete procedure for building and deploying the Booking Service System (React Frontend + NestJS API) to production.

## Project Structure
```
booking_service_system/
├── api/                    # NestJS Backend API
│   ├── src/               # Source code
│   ├── dist/              # Built JavaScript files
│   ├── package.json       # API dependencies
│   └── prisma/            # Database schema
├── frontend/              # React Frontend
│   ├── src/               # Source code
│   ├── build/             # Built static files
│   └── package.json       # Frontend dependencies
├── ecosystem.config.js    # PM2 configuration
├── deploy.ps1            # Full deployment script
├── deploy-smart.ps1      # Smart deployment (auto-detect changes)
├── deploy-update.ps1     # Incremental update script
└── PRODUCTION_BUILD_PROCEDURE.md
```

## Prerequisites

### Local Development Machine
- Node.js (v18 or higher)
- npm
- PowerShell (Windows)
- SSH access to production server
- AWS EC2 key pair file

### Production Server
- Node.js (v18 or higher)
- npm
- PM2 (Process Manager)
- serve (for serving React build)
- MySQL database access

## Deployment Scripts

### 1. Smart Deployment (Recommended)
```powershell
.\deploy-smart.ps1
```
**What it does:**
- Automatically detects changes in your codebase
- Chooses between full deployment or incremental update
- Full deployment: Config/dependency changes
- Incremental update: Code changes only

### 2. Full Deployment
```powershell
.\deploy.ps1
```
**What it does:**
- Installs all dependencies (API + Frontend)
- Builds both API and Frontend
- Creates complete deployment package
- Uploads to server

### 3. Incremental Update
```powershell
.\deploy-update.ps1
```
**What it does:**
- Only builds changed components
- Creates smaller update package
- Faster deployment for code-only changes

## Manual Build Process

### API Build
```bash
cd api
npm ci --production=false
npm run build
```

### Frontend Build
```bash
cd frontend
npm ci --production=false
npm run build
```

## Server Configuration

### PM2 Ecosystem Configuration
The `ecosystem.config.js` file configures two applications:

1. **booking-service-api** (Port 3000)
   - Runs the NestJS API
   - Serves API endpoints at `/api/v1/*`
   - Handles database connections
   - Manages file uploads

2. **booking-service-frontend** (Port 3001)
   - Serves the React build files
   - Static file serving
   - Client-side routing

### Environment Variables
```javascript
// API Environment
NODE_ENV: "production"
PORT: 3000
DATABASE_URL: "mysql://adminMinistry:Niyihoraho@db-system-ministry.corcwyqkieso.us-east-1.rds.amazonaws.com:3306/db-system-ministry"
SESSION_SECRET: "mNaqPepJ3tW182v7LcMMsOUiVQrZHykvmqBpw5Ya98M="

// Frontend Environment
NODE_ENV: "production"
PORT: 3001
```

## Server Deployment Commands

### After Uploading Deployment Package
```bash
# Connect to server
ssh -i "C:\Users\user\Music\github\m-system\m-system-WebServer-1.pem" ec2-user@ec2-98-90-202-108.compute-1.amazonaws.com

# Extract deployment
unzip -o deployment.zip

# Stop existing processes
pm2 stop all
pm2 delete all

# Start new processes
pm2 start ecosystem.config.js

# Save PM2 configuration
pm2 save

# Setup PM2 startup (run once)
pm2 startup
```

### For Incremental Updates
```bash
# Extract update
unzip -o update.zip

# Restart specific services
pm2 restart booking-service-api      # If API changed
pm2 restart booking-service-frontend # If Frontend changed
```

## Monitoring & Logs

### PM2 Commands
```bash
pm2 status                    # Check process status
pm2 logs                      # View all logs
pm2 logs booking-service-api  # View API logs
pm2 logs booking-service-frontend # View Frontend logs
pm2 monit                     # Real-time monitoring
```

### Log Files
- `./logs/api-error.log` - API error logs
- `./logs/api-out.log` - API output logs
- `./logs/frontend-error.log` - Frontend error logs
- `./logs/frontend-out.log` - Frontend output logs

## Database Setup

### Prisma Migration (if needed)
```bash
cd api
npx prisma migrate deploy
npx prisma generate
```

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Node.js version compatibility
   - Clear node_modules and reinstall: `rm -rf node_modules && npm ci`
   - Check for TypeScript errors in API

2. **PM2 Issues**
   - Check PM2 status: `pm2 status`
   - View logs: `pm2 logs`
   - Restart services: `pm2 restart all`

3. **Database Connection Issues**
   - Verify DATABASE_URL in ecosystem.config.js
   - Check AWS RDS security groups
   - Test connection from server

4. **Frontend Not Loading**
   - Check if serve is installed: `npm list -g serve`
   - Verify build files exist in frontend/build
   - Check PM2 logs for frontend service

### Performance Optimization

1. **Memory Management**
   - API: 1GB max memory restart
   - Frontend: 512MB max memory restart

2. **Process Management**
   - Fork mode for better stability
   - Single instance per service
   - Auto-restart on crashes

## Security Considerations

1. **Environment Variables**
   - Never commit .env files
   - Use strong session secrets
   - Secure database credentials

2. **File Permissions**
   - Restrict upload directory permissions
   - Validate file types and sizes
   - Implement proper CORS settings

3. **Network Security**
   - Configure AWS Security Groups
   - Use HTTPS in production
   - Implement rate limiting

## Backup & Recovery

### Database Backup
```bash
# Create backup
mysqldump -h db-system-ministry.corcwyqkieso.us-east-1.rds.amazonaws.com -u adminMinistry -p db-system-ministry > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Application Backup
```bash
# Backup current deployment
cp -r /path/to/current/deployment /path/to/backup/$(date +%Y%m%d_%H%M%S)
```

## Rollback Procedure

1. **Stop current services**
   ```bash
   pm2 stop all
   ```

2. **Restore previous version**
   ```bash
   # Extract previous deployment
   unzip -o previous_deployment.zip
   ```

3. **Restart services**
   ```bash
   pm2 start ecosystem.config.js
   ```

## Maintenance

### Regular Tasks
- Monitor PM2 logs for errors
- Check disk space usage
- Update dependencies monthly
- Backup database weekly
- Review security logs

### Updates
- Test changes in development first
- Use incremental updates for small changes
- Use full deployment for major updates
- Always backup before deployment
