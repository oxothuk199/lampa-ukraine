# Використовуємо офіційний образ Lampac
FROM immisterio/lampac:latest

# Створюємо директорію для додаткових модулів
RUN mkdir -p /app/modules

# Копіюємо конфігурацію
COPY appsettings.json /app/appsettings.json

# Копіюємо ваші модулі
COPY AnimeON/ /app/modules/AnimeON/
COPY CikavaIdeya/ /app/modules/CikavaIdeya/
COPY Uaflix/ /app/modules/Uaflix/
COPY Unimay/ /app/modules/Unimay/

# Встановлюємо дозволи
RUN chmod -R 755 /app/modules/

# Відкриваємо порт
EXPOSE 80

# Змінні середовища
ENV ASPNETCORE_URLS=http://*:80
