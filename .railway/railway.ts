import { defineRailway, github, image, preserve, project, service, volume } from "railway/iac";

export default defineRailway(() => {
  const mysqlData = volume("mysql-data", { region: "iad", sizeMB: 500 });
  const gophishData = volume("gophish-data", { region: "iad", sizeMB: 256 });

  const frontend = service("frontend", {
    source: github("opdatos-del/phishing-awareness-platform", { checkSuites: false, rootDirectory: "frontend" }),
    build: { buildEnvironment: "V3", builder: "DOCKERFILE", dockerfilePath: "Dockerfile" },
    replicas: { "iad": 1 },
    env: {
      BACKEND_HOST: "phishing-awareness-platform.railway.internal",
      BACKEND_URL: "http://phishing-awareness-platform.railway.internal:8080",
    },
  });

  const phishingAwarenessPlatform = service("phishing-awareness-platform", {
    source: github("opdatos-del/phishing-awareness-platform", { checkSuites: false, rootDirectory: "backend" }),
    build: { buildEnvironment: "V3", builder: "DOCKERFILE", dockerfilePath: "Dockerfile" },
    healthcheck: "/actuator/health",
    healthcheckTimeout: 300,
    replicas: { "iad": 1 },
    deploy: { restartPolicyMaxRetries: 3 },
    env: {
      DB_HOST: "db-mysql.railway.internal",
      DB_NAME: "phishing_awareness",
      DB_PASSWORD: preserve(),
      DB_PORT: "3306",
      DB_USERNAME: "phishing_app",
      GOPHISH_API_KEY: "75ce3fd2903b280d5c0461e984e1f30dea95254d13584c0a8899fb0fd87d750a",
      GOPHISH_API_URL: "http://gophish.railway.internal:3333",
      GOPHISH_FROM_ADDRESS: "avisosjovycandy@gmail.com",
      GOPHISH_URL: "http://gophish.railway.internal:3333",
      JWT_SECRET: preserve(),
      SMTP_HOST: "smtp.gmail.com",
      SMTP_PASSWORD: preserve(),
      SMTP_PORT: "587",
      SMTP_USERNAME: preserve(),
    },
  });

  const gophish = service("gophish", {
    source: github("opdatos-del/phishing-awareness-platform", { checkSuites: false, rootDirectory: "infrastructure/gophish" }),
    build: { buildEnvironment: "V3", builder: "DOCKERFILE", dockerfilePath: "Dockerfile.railway" },
    replicas: { "iad": 1 },
    deploy: { restartPolicyMaxRetries: 3 },
    volumeMounts: { "/opt/gophish/data": gophishData },
  });

  const mysqlApp = service("db-mysql", {
    source: image("mysql:8.0"),
    replicas: { "iad": 1 },
    deploy: { startCommand: "mysqld --bind-address=::" },
    env: {
      MYSQL_DATABASE: "phishing_awareness",
      MYSQL_PASSWORD: preserve(),
      MYSQL_ROOT_PASSWORD: preserve(),
      MYSQL_USER: "phishing_app",
    },
    volumeMounts: { "/var/lib/mysql": mysqlData },
  });

  return project("resplendent-appreciation", {
    resources: [frontend, phishingAwarenessPlatform, gophish, mysqlApp, mysqlData, gophishData],
  });
});