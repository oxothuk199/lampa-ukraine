FROM immisterio/lampac:northflank

# Копіювання ваших модулів
COPY AnimeON /app/modules/AnimeON
COPY CikavaIdeya /app/modules/CikavaIdeya  
COPY Уафликс /app/modules/Uaflix
COPY Unimay /app/modules/Unimay

# Створення конфігурації
COPY lampac-config.json /app/init.conf

# Встановлення дозволів
RUN chmod -R 755 /app/modules

EXPOSE 9118
CMD ["/app/lampac"]
