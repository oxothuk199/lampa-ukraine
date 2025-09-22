# Використовуємо PHP з Apache
FROM php:8.1-apache

# Встановлення PHP розширень
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Копіювання модулів
COPY . /var/www/html/

# Створення головного index.php
COPY <<EOF /var/www/html/index.php
<?php
\$modules = [
    'animeon' => ['name' => 'AnimeON 🇺🇦', 'path' => 'AnimeON/'],
    'cikavaIdeya' => ['name' => 'CikavaIdeya ✨', 'path' => 'CikavaIdeya/'],  
    'Uaflix' => ['name' => 'Uaflix 🎥', 'path' => 'Uaflix/'],
    'unimay' => ['name' => 'Unimay 📱', 'path' => 'Unimay/']
];

\$current_module = \$_GET['module'] ?? null;
?>
<!DOCTYPE html>
<html lang="uk">
<head>
    <meta charset="UTF-8">
    <title>🇺🇦 Лампа Україна</title>
    <style>
        body { font-family: Arial, sans-serif; background: linear-gradient(135deg, #667eea, #764ba2); color: white; margin: 0; padding: 20px; }
        .container { max-width: 800px; margin: 0 auto; text-align: center; }
        .header h1 { font-size: 3rem; margin: 20px 0; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .modules { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 40px 0; }
        .module { background: rgba(255,255,255,0.1); border-radius: 15px; padding: 25px; text-decoration: none; color: white; transition: all 0.3s ease; display: block; }
        .module:hover { background: rgba(255,255,255,0.2); transform: translateY(-5px); }
        .back { background: rgba(255,255,255,0.2); color: white; padding: 10px 20px; border-radius: 20px; text-decoration: none; display: inline-block; margin: 20px 0; }
        iframe { width: 100%; height: 80vh; border: none; border-radius: 10px; background: white; }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🇺🇦 Лампа Україна</h1>
        </div>
        
        <?php if (!\$current_module): ?>
            <div class="modules">
                <?php foreach (\$modules as \$key => \$module): ?>
                    <a href="?module=<?= \$key ?>" class="module">
                        <h3><?= \$module['name'] ?></h3>
                    </a>
                <?php endforeach; ?>
            </div>
        <?php elseif (isset(\$modules[\$current_module])): ?>
            <a href="/" class="back">← Назад до модулів</a>
            <h2><?= \$modules[\$current_module]['name'] ?></h2>
            <iframe src="<?= \$modules[\$current_module]['path'] ?>"></iframe>
        <?php endif; ?>
    </div>
</body>
</html>
EOF

# Увімкнення mod_rewrite
RUN a2enmod rewrite

# Встановлення дозволів
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

EXPOSE 80
CMD ["apache2-foreground"]
