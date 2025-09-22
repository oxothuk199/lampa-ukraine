FROM immisterio/lampac:northflank

# Копіювання ваших модулів
COPY AnimeON /app/modules/AnimeON
COPY Cikavaldeya /app/modules/Cikavaldeya  
COPY Уафликс /app/modules/Уафликс
COPY Unimay /app/modules/Unimay

# Створення конфігурації
COPY lampac-config.json /app/init.conf

# Встановлення дозволів
RUN chmod -R 755 /app/modules

EXPOSE 9118
CMD ["/app/lampac"]
