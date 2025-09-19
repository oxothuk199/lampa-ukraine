# Використовуємо офіційний образ .NET
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Встановлюємо робочу директорію
WORKDIR /app

# Встановлюємо необхідні пакети
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Завантажуємо та встановлюємо Lampac
RUN wget -O lampac.zip https://github.com/immisterio/Lampac/releases/download/1.40.892/publish.zip \
    && unzip lampac.zip \
    && rm lampac.zip \
    && chmod +x Lampac

# Створюємо директорію для модулів
RUN mkdir -p modules

# Копіюємо ваші модулі
COPY AnimeON/ ./modules/AnimeON/
COPY Cikavadeya/ ./modules/Cikavadeya/
COPY Uaflix/ ./modules/Uaflix/
COPY Unimay/ ./modules/Unimay/

# Встановлюємо дозволи
RUN chmod -R 755 ./modules/

# Відкриваємо порт
EXPOSE 80

# Змінні середовища
ENV ASPNETCORE_URLS=http://*:80

# Запускаємо Lampac
ENTRYPOINT ["dotnet", "Lampac.dll"]
