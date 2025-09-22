# Використовуємо базовий образ Lampac
FROM immisterio/lampac:northflank

USER root

# Встановлення додаткових утиліт
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# Створення директорій
RUN mkdir -p /var/www/html \
    && mkdir -p /app/modules \
    && mkdir -p /etc/nginx/sites-enabled

# Копіювання модулів у веб директорію
COPY AnimeON /var/www/html/AnimeON
COPY CikavaIdeya /var/www/html/CikavaIdeya
COPY Uaflix /var/www/html/Uaflix 
COPY Unimay /var/www/html/Unimay

# Створення головного index.php файлу
RUN cat > /var/www/html/index.php << 'EOF'
<?php
$modules = [
    'animeon' => ['name' => 'AnimeON 🇺🇦', 'path' => 'AnimeON/'],
    'cikavaIdeya' => ['name' => 'CikavaIdeya ✨', 'path' => 'CikavaIdeya/'],
    'Uaflix' => ['name' => 'Uaflix 🎥', 'path' => 'Uaflix/'],
    'unimay' => ['name' => 'Unimay 📱', 'path' => 'Unimay/']
];

$current_module = $_GET['module'] ?? null;
?>
<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🇺🇦 Лампа Україна</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; margin: 0; padding: 20px; }
        .container { max-width: 1200px; margin: 0 auto; }
        .header { text-align: center; margin-bottom: 40px; }
        .header h1 { font-size: 3rem; margin: 0; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .modules-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 20px; }
        .module-card { background: rgba(255,255,255,0.1); border-radius: 15px; padding: 25px; text-decoration: none; color: white; transition: all 0.3s ease; border: 1px solid rgba(255,255,255,0.2); }
        .module-card:hover { background: rgba(255,255,255,0.2); transform: translateY(-5px); box-shadow: 0 10px 30px rgba(0,0,0,0.3); }
        .module-name { font-size: 1.5rem; font-weight: bold; margin-bottom: 10px; }
        .back-button { display: inline-block; background: rgba(255,255,255,0.2); color: white; padding: 12px 24px; border-radius: 25px; text-decoration: none; margin-bottom: 20px; }
        iframe { width: 100%; height: 80vh; border: none; border-radius: 10px; background: white; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🇺🇦 Лампа Україна</h1>
            <p>Українська медіа платформа</p>
        </div>
        
        <?php if (!$current_module): ?>
            <div class="modules-grid">
                <?php foreach ($modules as $key => $module): ?>
                    <a href="?module=<?= $key ?>" class="module-card">
                        <div class="module-name"><?= $module['name'] ?></div>
                    </a>
                <?php endforeach; ?>
            </div>
        <?php elseif (isset($modules[$current_module])): ?>
            <a href="/" class="back-button">← Назад</a>
            <h2><?= $modules[$current_module]['name'] ?></h2>
            <iframe src="<?= $modules[$current_module]['path'] ?>"></iframe>
        <?php endif; ?>
    </div>
</body>
</html>
EOF

# Налаштування Nginx
RUN cat > /etc/nginx/sites-enabled/default << 'EOF'
server {
    listen 80;
    server_name _;
    root /var/www/html;
    index index.php index.html;
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }
    
    location ~ \.php$ {
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }
    
    # Проксирование запросов к Lampac API
    location /api/ {
        proxy_pass http://127.0.0.1:9118;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
    
    location /lampac/ {
        proxy_pass http://127.0.0.1:9118/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
EOF

# Встановлення PHP-FPM
RUN apt-get update && apt-get install -y php-fpm && rm -rf /var/lib/apt/lists/*

# Створення startup скрипта
RUN cat > /app/start.sh << 'EOF'
#!/bin/bash

echo "🇺🇦 Запуск Лампа Україна..."

# Запуск PHP-FPM
service php7.4-fpm start || service php8.1-fpm start || service php-fpm start

# Запуск Nginx
nginx -g "daemon off;" &

# Запуск Lampac в фоновому режимі
/app/lampac &

# Очікування
wait
EOF

# Встановлення дозволів
RUN chmod +x /app/start.sh
RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

# Експорт портів
EXPOSE 80
EXPOSE 9118

# Запуск через startup скрипт
CMD ["/app/start.sh"]
