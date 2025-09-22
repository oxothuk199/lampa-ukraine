# Використовуємо оригінальний Lampac образ
FROM immisterio/lampac:northflank

# Копіювання конфігураційного файлу
COPY init.conf /app/init.conf

# Копіювання модулів як плагіни
COPY AnimeON /app/plugins/AnimeON
COPY CikavaIdeya /app/plugins/CikavaIdeya
COPY Uaflix /app/plugins/Uaflix 
COPY Unimay /app/plugins/Unimay

# Створення startup скрипта з конфігурацією
RUN cat > /app/start-with-modules.sh << 'EOF'
#!/bin/bash

echo "🇺🇦 Запуск Lampac з українськими модулями..."

# Виведення інформації про модулі
echo "Доступні модулі:"
ls -la /app/plugins/ | grep -E "(AnimeON|CikavaIdeya|Uaflix|Unimay)" || echo "Модулі не знайдено"

# Запуск Lampac з конфігурацією
if [ -f "/app/init.conf" ]; then
    echo "Використовується конфігурація: /app/init.conf"
    exec /app/lampac --init /app/init.conf
else
    echo "Конфігурація не знайдена, запуск з стандартними налаштуваннями"
    exec /app/lampac
fi
EOF

# Встановлення дозволів
RUN chmod +x /app/start-with-modules.sh
RUN chmod -R 755 /app/plugins
RUN chmod 644 /app/init.conf

# Експорт порту
EXPOSE 9118

# Запуск через скрипт
CMD ["/app/start-with-modules.sh"]
