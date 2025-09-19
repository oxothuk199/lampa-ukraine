# Використовуємо офіційний образ .NET
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Встановлюємо робочу директорію
WORKDIR /app

# Завантажуємо Lampac з GitHub
RUN apt-get update && apt-get install -y wget unzip \
    && wget https://github.com/immisterio/Lampac/releases/latest/download/publish.zip \
    && unzip publish.zip -d /app \
    && rm publish.zip \
    && chmod +x /app/Lampac

# Створюємо директорії для модулів
RUN mkdir -p /app/modules

# Копіюємо ваші модулі в правильні директорії
COPY AnimeON/ /app/modules/AnimeON/
COPY Cikavadeya/ /app/modules/Cikavadeya/
COPY Uaflix/ /app/modules/Uaflix/
COPY Unimay/ /app/modules/Unimay/

# Встановлюємо правильні дозволи
RUN chmod -R 755 /app/modules/

# Перевіримо, що модулі скопіювалися (опціонально для дебага)
RUN ls -la /app/modules/

# Відкриваємо стандартний порт Lampac
EXPOSE 80

# Встановлюємо змінні середовища
ENV ASPNETCORE_URLS=http://*:80

# Точка входу для запуску Lampac
ENTRYPOINT ["dotnet", "/app/Lampac.dll"]
