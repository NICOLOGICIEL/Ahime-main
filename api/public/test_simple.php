<?php
echo "Starting test...\n";
require __DIR__.'/../vendor/autoload.php';
echo "Autoload OK\n";
$app = require __DIR__.'/../bootstrap/app.php';
echo "Bootstrap OK\n";
$app->boot();
echo "Boot OK\n";
echo "DB_CONNECTION env: " . env('DB_CONNECTION') . "\n";
echo "DB config: " . $app->make('config')->get('database.connections.mysql.host') . "\n";
try {
    DB::connection()->getPdo();
    echo "Database connection OK!\n";
} catch (Exception $e) {
    echo "Database error: " . $e->getMessage() . "\n";
}
