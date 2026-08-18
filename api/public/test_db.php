<?php
require __DIR__.'/../vendor/autoload.php';
$app = require __DIR__.'/../bootstrap/app.php';
$app->boot();

echo "DB_CONNECTION env: " . env('DB_CONNECTION') . "\n";
echo "DB_HOST config: " . $app->make('config')->get('database.connections.mysql.host') . "\n";
echo "DB_DATABASE config: " . $app->make('config')->get('database.connections.mysql.database') . "\n";

try {
    DB::connection()->getPdo();
    echo "Database connection OK!\n";
    
    $count = DB::table('hotel')->count();
    echo "Hotel count: $count\n";
    
    $sample = DB::table('hotel')->first();
    echo "Sample hotel: " . ($sample ? json_encode($sample) : 'none') . "\n";
} catch (Exception $e) {
    echo "Database error: " . $e->getMessage() . "\n";
}
