-- Local Database Setup Script
-- This script creates the local development database

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS booking_service_local;

-- Use the database
USE booking_service_local;

-- Create a local development user (optional)
-- CREATE USER IF NOT EXISTS 'booking_dev'@'localhost' IDENTIFIED BY 'dev_password';
-- GRANT ALL PRIVILEGES ON booking_service_local.* TO 'booking_dev'@'localhost';
-- FLUSH PRIVILEGES;

-- Note: The actual tables will be created by Prisma migrations
-- Run: npm run db:push or npm run db:migrate after setting up the database
