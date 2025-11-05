import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { NestExpressApplication } from '@nestjs/platform-express';
import { join } from 'path';
import * as session from 'express-session';
import * as express from 'express';
import * as fs from 'fs';
import * as dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    cors: {
      origin: [
        process.env.CORS_ORIGIN || 'http://localhost:3001', // React app URL/port
        'http://16.170.244.196:3001', // Production frontend
        'http://localhost:3001', // Local development
      ],
      credentials: true,
    },
  });

  // Ensure uploads directory exists for invoices/media
  const uploadsDir = join(__dirname, '..', 'uploads');
  if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
  }

  // Enable express-session middleware
  app.use(
    session({
      secret: process.env.SESSION_SECRET || 'your-strong-secret-key-change-in-production',
      resave: false,
      saveUninitialized: false,
      cookie: {
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000, // 1 day
        secure: false, // Set to true if using HTTPS
        sameSite: 'lax', // CSRF protection
      },
      name: 'booking-service-session', // Custom session name
    }),
  );

  app.setGlobalPrefix('api/v1');
  app.useGlobalPipes(new ValidationPipe());

  // Serve /uploads as static for PDF/media access (for WhatsApp/email)
  app.use('/uploads', express.static(uploadsDir));
  app.useStaticAssets(uploadsDir, { prefix: '/uploads/' });

  const port = process.env.PORT || 3000;
  await app.listen(port);
  console.log(`🚀 Application is running on: http://localhost:${port}`);
}
bootstrap();
