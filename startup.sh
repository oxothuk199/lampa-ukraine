#!/bin/bash

echo "🇺🇦 Запуск Лампа Україна..."
echo "========================================="

# Перевірка наявності модулів
echo "📁 Перевірка модулів:"
if [ -d "/app/modules/AnimeON" ]; then
    echo "✅ AnimeON - знайдено"
else
    echo "❌ AnimeON - не знайдено"
fi

if [ -d "/app/modules/CikavaIdeya" ]; then
    echo "✅ CikavaIdeya - знайдено"
else
    echo "❌ CikavaIdeya - не знайдено"
fi

if [ -d "/app/modules/Uaflix" ]; then
    echo "✅ Uaflix - знайдено"
else
    echo "❌ Uaflix - не знайдено"
fi

if [ -d "/app/modules/Unimay" ]; then
    echo "✅ Unimay - знайдено"
else
    echo "❌ Unimay - не знайдено"
fi

# Виведення інформації про конфігурацію
echo ""
echo "🔧 Конфігурація:"
echo "   Config file: /app/init.conf"
echo "   Modules path: /app/modules"
echo "   Listen port: 9118"

# Перевірка конфігураційного файлу
if [ -f "/app/init.conf" ]; then
    echo "✅ Конфігураційний файл знайдено"
else
    echo "❌ Конфігураційний файл не знайдено"
fi

# Створення логів директорії
mkdir -p /app/logs

# Встановлення дозволів
chmod -R 755 /app/modules
chmod -R 755 /app/logs

echo ""
echo "🚀 Запуск Lampac сервера..."
echo "========================================="

# Запуск Lampac з конфігурацією
if [ -f "/app/init.conf" ]; then
    exec /app/lampac --init /app/init.conf
else
    exec /app/lampac
fi
