# Використовуємо PHP з Apache
FROM php:8.1-apache

# Встановлення PHP розширень
RUN docker-php-ext-install pdo pdo_mysql mysqli

# Копіювання всіх файлів з репозиторію
COPY . /var/www/html/

# Створення головного index.php через RUN команду
RUN cat > /var/www/html/index.php << 'EOF'
<?php
$modules = [
    'animeon' => ['name' => 'AnimeON 🇺🇦', 'path' => 'AnimeON/'],
    'cikavaIdeya' => ['name' => 'CikavaIdeya ✨', 'path' => 'CikavaIdeya/'],
    'uaflix' => ['name' => 'Uaflix 🎥', 'path' => 'Uaflix/'],
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
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1000px;
            margin: 0 auto;
            text-align: center;
        }
        
        .header {
            margin-bottom: 50px;
        }
        
        .header h1 {
            font-size: 3.5rem;
            margin-bottom: 10px;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.4);
            background: linear-gradient(45deg, #FFD700, #FFA500);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .header p {
            font-size: 1.3rem;
            opacity: 0.9;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
        }
        
        .modules-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 25px;
            margin: 40px 0;
        }
        
        .module-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 20px;
            padding: 30px 20px;
            text-decoration: none;
            color: white;
            transition: all 0.4s ease;
            border: 2px solid rgba(255, 255, 255, 0.2);
            display: block;
        }
        
        .module-card:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 40px rgba(0,0,0,0.3);
            border-color: rgba(255, 255, 255, 0.4);
        }
        
        .module-name {
            font-size: 1.8rem;
            font-weight: bold;
            margin-bottom: 15px;
            text-shadow: 1px 1px 3px rgba(0,0,0,0.3);
        }
        
        .back-button {
            display: inline-block;
            background: linear-gradient(45deg, #FF6B6B, #4ECDC4);
            color: white;
            padding: 15px 30px;
            border-radius: 30px;
            text-decoration: none;
            margin: 20px 0;
            font-weight: bold;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
        }
        
        .back-button:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
        }
        
        .module-frame {
            width: 100%;
            height: 80vh;
            border: none;
            border-radius: 15px;
            margin-top: 20px;
            background: rgba(255, 255, 255, 0.95);
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        
        .loading {
            text-align: center;
            padding: 50px;
            font-size: 1.2rem;
        }
        
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2.5rem;
            }
            
            .modules-grid {
                grid-template-columns: 1fr;
                gap: 20px;
            }
            
            .module-card {
                padding: 25px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🇺🇦 Лампа Україна</h1>
            <p>Українська медіа платформа - всі ваші улюблені сервіси в одному місці</p>
        </div>
        
        <?php if (!$current_module): ?>
            <div class="modules-grid">
                <?php foreach ($modules as $key => $module): ?>
                    <a href="?module=<?= $key ?>" class="module-card">
                        <div class="module-name"><?= $module['name'] ?></div>
                        <p>Натисніть для переходу</p>
                    </a>
                <?php endforeach; ?>
            </div>
        <?php elseif (isset($modules[$current_module])): ?>
            <a href="/" class="back-button">← Назад до модулів</a>
            <h2 style="margin: 20px 0; font-size: 2rem;"><?= $modules[$current_module]['name'] ?></h2>
            
            <?php 
            $module_path = $modules[$current_module]['path'];
            if (is_dir('/var/www/html/' . $module_path)): ?>
                <iframe src="<?= $module_path ?>" class="module-frame"></iframe>
            <?php else: ?>
                <div class="loading">
                    <h3>Модуль готується до запуску...</h3>
                    <p>Модуль "<?= $modules[$current_module]['name'] ?>" буде доступний незабаром.</p>
                    <p style="margin-top: 15px; opacity: 0.7;">Шлях: <?= $module_path ?></p>
                </div>
            <?php endif; ?>
        <?php else: ?>
            <div class="loading">
                <h3>❌ Модуль не знайдено</h3>
                <a href="/" class="back-button" style="margin-top: 20px;">Повернутися до головної</a>
            </div>
        <?php endif; ?>
    </div>
</body>
</html>
EOF

# Увімкнення mod_rewrite
RUN a2enmod rewrite

# Створення .htaccess для beautiful URLs
RUN cat > /var/www/html/.htaccess << 'EOF'
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php [QSA,L]
Options -Indexes
EOF

# Встановлення дозволів
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Експорт порту
EXPOSE 80

# Запуск Apache
CMD ["apache2-foreground"]
