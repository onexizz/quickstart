#!/bin/bash

# === by onexizz ===
# Полный установщик для Python, Node.js, MongoDB и Nginx

# Цвета для оформления
GREEN="\033[1;32m"
RED="\033[1;31m"
CYAN="\033[1;36m"
YELLOW="\033[1;33m"
RESET="\033[0m"

# Функция красивого вывода
print_message() {
    echo -e "\n${CYAN}──────────────────────────────────────────────────────────────${RESET}"
    echo -e "${GREEN}⚙️  $1${RESET}"
    echo -e "${CYAN}──────────────────────────────────────────────────────────────${RESET}\n"
}

check_status() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Ошибка: $1${RESET}"
        exit 1
    fi
}

clear
echo -e "${YELLOW}
███    ███  █████  ███    ██ ███████ ██   ██ ██ ███████ ███████ 
████  ████ ██   ██ ████   ██ ██      ██   ██ ██ ██      ██      
██ ████ ██ ███████ ██ ██  ██ ███████ ███████ ██ ███████ ███████ 
██  ██  ██ ██   ██ ██  ██ ██      ██ ██   ██ ██      ██      ██ 
██      ██ ██   ██ ██   ████ ███████ ██   ██ ██ ███████ ███████ 
${RESET}"
echo -e "${CYAN}        🚀 Auto Setup Script by onexizz${RESET}\n"

# -----------------------------
# Обновление системы
# -----------------------------
print_message "Обновление системы..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y sudo curl gpg lsb-release build-essential unzip software-properties-common
check_status "Не удалось обновить систему"

# -----------------------------
# Python
# -----------------------------
print_message "Установка Python 3.12 и инструментов..."
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update -y
sudo apt install -y python3.12 python3.12-venv python3.12-dev python3-pip
check_status "Не удалось установить Python"

python3.12 -m pip install --upgrade pip setuptools wheel

# -----------------------------
# MongoDB
# -----------------------------
print_message "Установка MongoDB..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] http://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
sudo apt update
sudo apt install -y mongodb-org
check_status "Не удалось установить MongoDB"
sudo systemctl enable --now mongod

# -----------------------------
# Nginx
# -----------------------------
print_message "Установка и запуск Nginx..."
sudo apt install -y nginx
sudo systemctl enable --now nginx
check_status "Не удалось установить Nginx"

# -----------------------------
# Node.js / NVM
# -----------------------------
print_message "Установка NVM и Node.js 20..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
check_status "Не удалось установить NVM"
export NVM_DIR="$HOME/.nvm"
source "$NVM_DIR/nvm.sh"
nvm install 20
nvm use 20

# -----------------------------
# TypeScript, PM2, Bun
# -----------------------------
print_message "Установка TypeScript, PM2 и Bun..."
npm install -g typescript pm2
check_status "Не удалось установить npm-пакеты"
curl -fsSL https://bun.sh/install | bash
check_status "Не удалось установить Bun"

# -----------------------------
# Проверка
# -----------------------------
print_message "Проверка установленных компонентов:"
echo -e "${YELLOW}MongoDB:${RESET} $(mongod --version | grep 'db version' | cut -d ' ' -f 3)"
echo -e "${YELLOW}Python:${RESET} $(python3.12 --version)"
echo -e "${YELLOW}Node.js:${RESET} $(node -v)"
echo -e "${YELLOW}PM2:${RESET} $(pm2 -v)"
echo -e "${YELLOW}Bun:${RESET} $(~/.bun/bin/bun --version)"

# -----------------------------
# Финал
# -----------------------------
echo -e "\n${GREEN}
╔═══════════════════════════════════════════════════╗
║                                                   ║
║   🎉 Установка завершена успешно!                 ║
║   💡 Автор скрипта: ${YELLOW}onexizz${GREEN}                    ║
║   🚀 Система готова для Python и Node.js          ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
${RESET}"
