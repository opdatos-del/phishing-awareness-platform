param(
    [string]$Context = 'jovy-dev',
    [string]$EnvFile = '.env.remote'
)

$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $EnvFile)) {
    throw "Missing $EnvFile. Copy .env.remote.example and configure it first."
}

docker --context $Context info --format '{{.Name}} {{.ServerVersion}}'
docker --context $Context compose `
    --env-file $EnvFile `
    -f docker-compose.remote.yml `
    -p paware-remote `
    up -d --build

docker --context $Context compose `
    --env-file $EnvFile `
    -f docker-compose.remote.yml `
    -p paware-remote `
    ps
