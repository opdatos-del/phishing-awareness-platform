# Plataforma de Concienciación Anti-Phishing

Plataforma interna de simulación de phishing para la formación en seguridad de los empleados.

## Arquitectura

```
                       USUARIO ADMIN
                            │
                            ▼
                         CADDY
                            │
              ┌─────────────┴─────────────┐
              │                           │
              ▼                           ▼
           React                      Spring Boot
                                        │
                                        ▼
                                   MySQL local


                         GoPhish
                            │
                            ▼
                          SMTP
                            │
                            ▼
                         Mailpit
                            │
                            ▼
                     Emails de prueba
```

## Stack

### Backend
- Java 21 LTS / Spring Boot 4.1.1
- Gradle 8.14 (Kotlin DSL)
- Spring Security + JWT (jjwt 0.13.0)
- Spring Data JPA + Hibernate
- Flyway (migraciones de esquema)
- MySQL

### Frontend
- React 19.2 + TypeScript 5.8
- Vite 8.2
- Tailwind CSS 4.3
- React Router 8.3
- TanStack Query 5.102
- Recharts 3.10

### Infraestructura
- Docker + Docker Compose
- GoPhish (motor de campañas)
- Mailpit (receptor SMTP de desarrollo)
- Caddy (proxy inverso)

## Requisitos

- Java 21+
- Node.js 24+
- pnpm
- Gradle 8.14+ (o usar el wrapper)
- Docker + Docker Compose
- MySQL 8.0+ (instalado en el host)

## Configuración de MySQL

```sql
CREATE DATABASE phishing_awareness
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

CREATE USER 'phishing_app'@'%' IDENTIFIED BY 'CHANGE_ME';
GRANT ALL PRIVILEGES ON phishing_awareness.* TO 'phishing_app'@'%';
FLUSH PRIVILEGES;
```

## Configuración

```bash
cp .env.example .env
# Edita .env con tus credenciales de MySQL y secretos
```

## Inicio rápido

```bash
# Inicia todos los servicios
./scripts/dev-up.sh

# O manualmente
docker compose up -d --build

# Ver logs
docker compose logs -f
```

### URLs

| Servicio | URL                          |
|----------|------------------------------|
| App      | http://localhost:3000        |
| API      | http://localhost:8080/api/v1 |
| GoPhish  | http://localhost:3333        |
| Mailpit  | http://localhost:8025        |

> **Nota sobre puertos:** el puerto 80 del host no es Caddy. Una aplicación local
> puede ocuparlo, así que la URL pública de la app apunta a `http://localhost:3000`
> (el nginx del contenedor frontend proxya `/api`, `/t`, `/landing`, `/training`).

### Credenciales por defecto

| Usuario | Contraseña |
|---------|------------|
| admin   | admin123   |

La UI de GoPhish (`http://localhost:3333`) requiere login. La contraseña inicial
del admin de GoPhish se muestra en la consola del contenedor al primer arranque
(`docker logs gophish`, línea "Please login with the username admin and the
password ..."). La API key se genera desde Settings → API Keys en la UI.

## Migraciones Flyway

Los cambios de esquema se gestionan con Flyway en:

```
backend/src/main/resources/db/migration/
```

Ejecuta `./gradlew flywayMigrate` o deja que Spring Boot lo haga al arrancar.

## GoPhish

GoPhish actúa como motor de campañas. El backend aprovisiona plantillas, páginas
de aterrizaje seguras, perfiles SMTP, grupos y campañas a través de su API. Los
tokens de seguimiento permanecen locales a Paware y se transportan en el campo
`position` del target; la página de GoPhish redirige al flujo de formación local.
Configuración:

```
infrastructure/gophish/config.json
```

**Sincronización de eventos:** GoPhish no publica webhooks para aperturas (opens)
ni clics. Para llenar el embudo local, el componente `GophishResultsPoller`
(registrado cada 30 s, configurable con `GOPHISH_RESULTS_POLL_DELAY_MS`) lee
`GET /api/campaigns/{id}` y registra los eventos `EMAIL_OPENED` y `LINK_CLICKED`
en la base local. El webhook (`/api/v1/integrations/gophish/webhook`) queda como
respaldo para eventos externos si se añadieran.

## Mailpit

Mailpit captura todos los emails SMTP en desarrollo. Míralos en http://localhost:8025.

No se envían emails reales en modo dev.

## Seguridad

- Hash de contraseñas con BCrypt
- Autenticación JWT para el panel
- Esquema gestionado por Flyway (sin auto-DDL de Hibernate)
- Sin captura de credenciales en las simulaciones
- Tokens de seguimiento por UUID (sin IDs secuenciales)
- Sin emails en las URLs
- CORS limitado
- Cabeceras de seguridad vía Caddy
- Sin stack traces expuestos

## Desarrollo

```bash
# Sólo backend (requiere MySQL corriendo en el host)
cd backend
./gradlew bootRun

# Sólo frontend
cd frontend
pnpm install
pnpm dev
```

## Testing

```bash
# Tests backend
cd backend
./gradlew test

# Tests frontend
cd frontend
pnpm test
```

## Roadmap

- [x] Fase 0: Infraestructura (GoPhish, Mailpit, Caddy, Docker)
- [x] Fase 1: Base backend (Spring Boot, MySQL, Flyway, Seguridad, Entidades)
- [x] Fase 2: Tracking (tokens, pixel de apertura, clic, landing, submit, training)
- [x] Fase 3: Integración GoPhish (aprovisionamiento API, programación, sincronización de resultados)
- [x] Fase 4: Frontend (login, layout admin, CRUD, campañas y embudo)
- [x] Fase 5: Plantillas (5 plantillas de email + 5 landings de ejemplo)
- [x] Fase 6: Analítica (embudo del dashboard, tasas de campaña, timeline y export CSV)
- [x] Fase 7: Concienciación (contenido de training, quiz y `TRAINING_COMPLETED`)

### Decisiones de arquitectura

- GoPhish envía emails con el perfil SMTP configurado. Mailpit es el destino SMTP
  de desarrollo. Spring Mail no se usa mientras GoPhish esté habilitado.
- Define `GOPHISH_API_KEY` para habilitar el lanzamiento de campañas. Sin ella,
  el CRUD y el tracking local siguen disponibles, pero el lanzamiento devuelve
  un error de configuración claro.
- La consola de GoPhish se expone en `3333`; su servidor de phishing en `8081`.
- La apertura/clic se sincronizan por sondeo (poller), no por webhook, porque
  GoPhish no emite esos eventos.

## Licencia

Uso interno únicamente.
