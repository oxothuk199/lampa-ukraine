# Використовуємо готовий образ Lampac
FROM imitsterio/lampac:latest

# Створюємо директорії для модулів
RUN mkdir -p /home/module/modules

# Копіюємо ваші модулі в правильні директорії
COPY AnimeON/ /home/module/modules/AnimeON/
COPY Cikavadeya/ /home/module/modules/Cikavadeya/
COPY Uaflix/ /home/module/modules/Uaflix/
COPY Unimay/ /home/module/modules/Unimay/

# Встановлюємо правильні дозволи
RUN chmod -R 755 /home/module/modules/

# Перевіримо, що модулі скопіювалися (опціонально для дебага)
RUN ls -la /home/module/modules/

# Відкриваємо стандартний порт Lampac
EXPOSE 80

# Встановлюємо змінні середовища
ENV ASPNETCORE_URLS=http://*:80

# Використовуємо стандартну точку входу з базового образу
# (базовий образ вже має правильний ENTRYPOINT)
