# Використовуємо базовий образ Lampac
FROM immisterio/lampac:northflank

# Встановлення додаткових утиліт
USER root
RUN apt-get update && apt-get install -y curl wget unzip && rm -rf /var/lib/apt/lists/*

# Створення директорій
RUN mkdir -p /app/modules /app/config

# Копіювання модулів
COPY AnimeON /app/modules/AnimeON
COPY CikavaIdeya /app/modules/CikavaIdeya
COPY Uaflix /app/modules/Uaflix 
COPY Unimay /app/modules/Unimay

# Створення простого startup скрипта
RUN echo '#!/bin/bash\necho "🇺🇦 Запуск Лампа Україна..."\necho "Модулі завантажено:"\nls -la /app/modules/\nexec /app/lampac' > /app/startup.sh

# Встановлення дозволів
RUN chmod +x /app/startup.sh
RUN chmod -R 755 /app/modules

# Експорт портів
EXPOSE 9118
EXPOSE 80

# Запуск
CMD ["/app/startup.sh"]
