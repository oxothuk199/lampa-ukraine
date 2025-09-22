<?php
echo "<h1>🇺🇦 Тест Лампа Україна</h1>";
echo "<p>Сервіс працює!</p>";

// Перевірка модулів
$modules = ['AnimeON', 'CikavaIdeya', 'Uaflix', 'Unimay'];
foreach($modules as $module) {
    if(is_dir($module)) {
        echo "<p>✅ $module - знайдено</p>";
    } else {
        echo "<p>❌ $module - не знайдено</p>";
    }
}
?>
