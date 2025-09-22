# Використовуємо базовий образ Lampac
FROM immisterio/lampac:northflank

# Встановлення додаткових утиліт
USER root
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Створення директорій для модулів
RUN mkdir -p /app/modules \
    && mkdir -p /app/config \
    && mkdir -p /app/plugins

# Копіювання ваших модулів
COPY AnimeON /app/modules/AnimeON
COPY CikavaIdeya /app/modules/CikavaIdeya  
COPY Uaflix /app/modules/Uaflix 
COPY Unimay /app/modules/Unimay

# Копіювання конфігураційних файлів
COPY lampac-config.json /app/init.conf
COPY startup.sh /app/startup.sh

# Встановлення правильних дозволів
RUN chmod -R 755 /app/modules \
    && chmod +x /app/startup.sh \
    && chmod 644 /app/init.conf

# Створення symbolic links для легшого доступу
RUN ln -s /app/modules/AnimeON /app/AnimeON \
    && ln -s /app/modules/CikavaIdeya /app/CikavaIdeya \
    && ln -s /app/modules/Uaflix /app/Uaflix \
    && ln -s /app/modules/Unimay /app/Unimay

# Встановлення робочої директорії
WORKDIR /app

# Експорт портів
EXPOSE 9118
EXPOSE 8080

# Environment variables
ENV LAMPAC_CUSTOM_MODULES=true
ENV LAMPAC_CONFIG_PATH=/app/init.conf
ENV ASPNETCORE_URLS=http://+:9118

# Запуск через startup скрипт
CMD ["/app/startup.sh"]
