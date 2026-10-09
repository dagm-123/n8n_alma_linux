# Stack Automático de n8n Pro + Nginx Proxy Manager en Docker

Este repositorio contiene la arquitectura modular para desplegar **n8n** con una base de datos externa **PostgreSQL** y el administrador web **Nginx Proxy Manager** en un servidor con AlmaLinux o Ubuntu, conviviendo de forma segura con servicios preexistentes como Vicidial.

## 📁 Estructura del Proyecto

- `docker-compose.yml`: Define los contenedores, puertos y volúmenes persistentes.
- `.env.example`: Plantilla con las variables de entorno necesarias para el despliegue.
- `instalar.sh`: Script automatizado encargado de validar dependencias, crear credenciales locales y encender el stack.

## 🚀 Instalación Rápida en un Servidor Nuevo

Para clonar y desplegar este entorno de forma automática, ejecuta el siguiente bloque de comandos en tu terminal como usuario `root`:

```bash
# 1. Instalar Git si no está presente
dnf install -y git || apt install -y git

# 2. Clonar este repositorio privado
git clone https://github.com
cd vici-n8n-stack

# 3. Dar permisos de ejecución e iniciar el script
chmod +x instalar.sh && ./instalar.sh
```

## ⚙️ Puertos Utilizados en el Host

Para evitar conflictos con puertos web estándar (como los que utiliza Vicidial), este stack mapea los servicios externos en puertos alternativos:

- **Puerto 81**: Panel de administración visual de Nginx Proxy Manager.
- **Puerto 5678**: Interfaz local y Webhooks internos de n8n.
- **Puerto 8080 / 8443**: Puertos HTTP/HTTPS alternativos expuestos por el Proxy.

## 🔒 Seguridad e Historial

El archivo `.env` local generado por el script contiene contraseñas de producción reales y está explícitamente excluido del control de versiones mediante `.gitignore` para prevenir fugas de credenciales en GitHub.
