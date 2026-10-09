#!/bin/bash

# Colores para hacer la terminal más legible
VERDE='\033[0;32m'
AZUL='\033[0;34m'
ROJO='\033[0;31m'
NC='\033[0m' # Sin color

echo -e "${AZUL}=== STACK AUTOMÁTICO DE N8N PRO VIA GITHUB ===${NC}\n"

# 1. Verificar e instalar Git si falta
if ! command -v git &> /dev/null; then
    echo -e "${VERDE}[+] Instalando Git...${NC}"
    dnf install -y git
fi

# 2. Verificar e instalar Docker si falta
if ! command -v docker &> /dev/null; then
    echo -e "${VERDE}[+] Instalando Docker y dependencias...${NC}"
    dnf install -y yum-utils
    yum-config-manager --add-repo https://docker.com
    dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    systemctl start docker
    systemctl enable docker
else
    echo -e "${VERDE}[✓] Docker ya está instalado en el sistema.${NC}"
fi

# 3. Configurar el archivo .env de producción basado en la plantilla
if [ ! -f .env ]; then
    echo -e "\n${AZUL}[!] Configurando credenciales del servidor...${NC}"
    
    # Solicitar subdominio
    read -p "Introduce tu subdominio (ej: ://tudominio.com): " sub
    while [ -z "$sub" ]; do
        echo -e "${ROJO}El subdominio no puede estar vacío.${NC}"
        read -p "Introduce tu subdominio: " sub
    done
    
    # Solicitar contraseña de Base de Datos
    read -s -p "Introduce una contraseña segura para PostgreSQL: " pass
    echo ""
    while [ -z "$pass" ]; do
        echo -e "${ROJO}La contraseña no puede estar vacía.${NC}"
        read -s -p "Introduce una contraseña segura para PostgreSQL: " pass
        echo ""
    done
    
    # Generar el archivo .env real mapeando las variables de docker-compose
    echo "SUBDOMINIO=$sub" > .env
    echo "POSTGRES_USER=n8n_user" >> .env
    echo "POSTGRES_PASSWORD=$pass" >> .env
    echo "POSTGRES_DB=n8n_db" >> .env
    
    echo -e "${VERDE}[✓] Archivo .env configurado correctamente.${NC}"
else
    echo -e "${VERDE}[✓] El archivo de configuración .env ya existe en este servidor.${NC}"
fi

# 4. Lanzar Docker Compose
echo -e "\n${AZUL}[+] Desplegando contenedores en segundo plano...${NC}"
docker compose up -d

echo -e "\n${VERDE}=== ¡PROCESO FINALIZADO CON ÉXITO! ===${NC}"
echo -e "Tus contenedores se están ejecutando."
echo -e "Recuerda abrir los accesos en tu Nginx Proxy Manager en el puerto 81.\n"
