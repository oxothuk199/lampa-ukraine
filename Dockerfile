# Використовуємо офіційний образ .NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0

# Встановлюємо робочу директорію
WORKDIR /app

# Встановлюємо необхідні пакети
RUN apt-get update && apt-get install -y curl wget

# Завантажуємо готову збірку Lampac
RUN wget -O lampac.tar.gz https://github.com/immisterio/Lampac/releases/download/1.40.892/linux-x64.tar.gz \
    && tar -xzf lampac.tar.gz \
    && rm lampac.tar.gz \
    && chmod +x Lampac

# Створюємо директорії для конфігурації та модулів
RUN mkdir -p /app/wwwroot \
    && mkdir -p /app/plugins

# Копіюємо ваші модулі як плагіни
COPY AnimeON/ /app/plugins/AnimeON/
COPY CikavaIdeya/ /app/plugins/CikavaIdeya/
COPY Uaflix/ /app/plugins/Uaflix/
COPY Unimay/ /app/plugins/Unimay/

# Встановлюємо дозволи
RUN chmod -R 755 /app/plugins/

# Створюємо базовий конфігураційний файл
RUN echo '{"listenport": 80, "timeoutms": 8000}' > /app/appsettings.json

# Відкриваємо порт
EXPOSE 80

# Запускаємо Lampac
CMD ["./Lampac"]
