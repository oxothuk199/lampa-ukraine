# Використовуємо образ з підтримкою .NET
FROM mcr.microsoft.com/dotnet/runtime:6.0

WORKDIR /app

# Копіюємо ваші модулі
COPY AnimeON/ /app/AnimeON/
COPY CikavaIdeya/ /app/CikavaIdeya/
COPY Uaflix/ /app/Uaflix/
COPY Unimay/ /app/Unimay/

# Створюємо простий індексний файл
RUN echo '<html><head><title>Lampac Ukraine</title></head><body>' > index.html \
    && echo '<h1>Lampac Ukraine Modules</h1>' >> index.html \
    && echo '<ul>' >> index.html \
    && echo '<li><a href="AnimeON/">AnimeON</a></li>' >> index.html \
    && echo '<li><a href="CikavaIdeya/">CikavaIdeya</a></li>' >> index.html \
    && echo '<li><a href="Uaflix/">Uaflix</a></li>' >> index.html \
    && echo '<li><a href="Unimay/">Unimay</a></li>' >> index.html \
    && echo '</ul></body></html>' >> index.html

EXPOSE 8080

# Простий HTTP сервер на Python
RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*
CMD ["python3", "-m", "http.server", "8080"]
