// API Configuration
// This file centralizes API endpoint configuration for different environments

const API_CONFIG = {
  development: {
    baseURL: 'http://localhost:3000/api/v1',
    uploadURL: 'http://localhost:3000/uploads',
  },
  production: {
    baseURL: 'http://16.170.244.196:3000/api/v1', // Your production API server
    uploadURL: 'http://16.170.244.196:3000/uploads', // Your production upload server
  },
  staging: {
    baseURL: 'https://your-staging-server.com/api/v1',
    uploadURL: 'https://your-staging-server.com/uploads',
  }
};

// Get current environment
const getEnvironment = () => {
  // Check if we're in development mode
  if (process.env.NODE_ENV === 'development') {
    return 'development';
  }
  
  // Check for custom environment variable
  if (process.env.REACT_APP_ENV) {
    return process.env.REACT_APP_ENV;
  }
  
  // Default to production
  return 'production';
};

const currentEnv = getEnvironment();
const config = API_CONFIG[currentEnv];

// Export API configuration
export const API_BASE_URL = config.baseURL;
export const API_UPLOAD_URL = config.uploadURL;

// Helper function to build full API URLs
export const buildApiUrl = (endpoint) => {
  return `${API_BASE_URL}${endpoint.startsWith('/') ? endpoint : `/${endpoint}`}`;
};

// Helper function to build upload URLs
export const buildUploadUrl = (filename) => {
  if (!filename) return '/default-user-icon.png';
  
  // If it's already a full URL, return as is
  if (filename.startsWith('http')) {
    return filename;
  }
  
  return `${API_UPLOAD_URL}/${filename}`;
};

// Export current environment for debugging
export const CURRENT_ENV = currentEnv;

console.log(`🌍 API Configuration loaded for environment: ${currentEnv}`);
console.log(`📡 API Base URL: ${API_BASE_URL}`);
console.log(`📁 Upload URL: ${API_UPLOAD_URL}`);
