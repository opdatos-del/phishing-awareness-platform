import { defineRailway, github, mysql, project, service, volume } from "railway/iac";

export default defineRailway(() => {
  const mysqlDb = mysql("MySQL", { region: "iad" });
  mysqlDb.deploy = { startCommand: "docker-entrypoint.sh mysqld --innodb-use-native-aio=0 --disable-log-bin --performance_schema=0 --innodb-buffer-pool-size=1G" };
  mysqlDb.networking = { privateNetworkEndpoint: "mysql" };
  const mysqlVolume = volume("mysql-volume", { allowOnlineResize: true, region: "iad", sizeMB: 500 });

  const backend = service("phishing-awareness-platform", {
    source: github("opdatos-del/phishing-awareness-platform", {
      branch: "main",
      checkSuites: false,
      rootDirectory: "backend",
    }),
    replicas: { "iad": 1 },
    build: {
      builder: "DOCKERFILE",
      dockerfilePath: "Dockerfile",
    },
    deploy: {
      healthcheckPath: "/actuator/health",
      healthcheckTimeout: 300,
      restartPolicyType: "ON_FAILURE",
      restartPolicyMaxRetries: 3,
    },
    env: {
      DB_HOST: mysqlDb.env.MYSQLHOST,
      DB_PORT: mysqlDb.env.MYSQLPORT,
      DB_NAME: mysqlDb.env.MYSQLDATABASE,
      DB_USERNAME: mysqlDb.env.MYSQLUSER,
      DB_PASSWORD: mysqlDb.env.MYSQLPASSWORD,
      SMTP_HOST: "smtp.gmail.com",
      SMTP_PORT: "587",
      GOPHISH_URL: "http://gophish.railway.internal:3333",
      GOPHISH_API_URL: "http://gophish.railway.internal:3333",
      GOPHISH_API_KEY: "75ce3fd2903b280d5c0461e984e1f30dea95254d13584c0a8899fb0fd87d750a",
      GOPHISH_FROM_ADDRESS: "avisosjovycandy@gmail.com",
    },
  });

  const frontend = service("frontend", {
    source: github("opdatos-del/phishing-awareness-platform", {
      branch: "main",
      checkSuites: false,
      rootDirectory: "frontend",
    }),
    replicas: { "iad": 1 },
    build: {
      builder: "DOCKERFILE",
      dockerfilePath: "Dockerfile",
    },
    env: {
      BACKEND_URL: `http://${backend.env.RAILWAY_PRIVATE_DOMAIN}:8080`,
    },
  });

  const gophish = service("gophish", {
    source: github("opdatos-del/phishing-awareness-platform", {
      branch: "main",
      checkSuites: false,
      rootDirectory: "infrastructure/gophish",
    }),
    replicas: { "iad": 1 },
    build: {
      builder: "DOCKERFILE",
      dockerfilePath: "Dockerfile.railway",
    },
    deploy: {
      restartPolicyType: "ON_FAILURE",
      restartPolicyMaxRetries: 3,
    },
  });

  return project("resplendent-appreciation", {
    resources: [mysqlDb, frontend, backend, gophish, mysqlVolume],
  });
});