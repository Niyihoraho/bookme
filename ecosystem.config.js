module.exports = {
  apps: [
    {
      name: "booking-service-api",
      script: "api/dist/main.js",
      instances: 1,
      exec_mode: "fork",
      watch: false,
      max_memory_restart: "1G",
      env: {
        "NODE_ENV": "production",
        "PORT": 3000,
        "DATABASE_URL": "mysql://admin:Niyihoraho@db-booking-service.cvs80y8yoox1.eu-north-1.rds.amazonaws.com:3306/db-booking-service",
        "SESSION_SECRET": "mNaqPepJ3tW182v7LcMMsOUiVQrZHykvmqBpw5Ya98M="
      },
      error_file: "./logs/api-error.log",
      out_file: "./logs/api-out.log",
      log_file: "./logs/api-combined.log",
      time: true
    },
    {
      name: "booking-service-frontend",
      script: "npx",
      args: ["serve", "-s", "frontend/build", "-p", "3001"],
      instances: 1,
      exec_mode: "fork",
      watch: false,
      max_memory_restart: "512M",
      env: {
        "NODE_ENV": "production",
        "PORT": 3001
      },
      error_file: "./logs/frontend-error.log",
      out_file: "./logs/frontend-out.log",
      log_file: "./logs/frontend-combined.log",
      time: true
    }
  ]
};

