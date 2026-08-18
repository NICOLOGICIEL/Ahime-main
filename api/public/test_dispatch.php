<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

require __DIR__.'/../vendor/autoload.php';

try {
    $dotenv = Dotenv\Dotenv::createUnsafeMutable(__DIR__.'/../');
    $dotenv->load();
} catch (Dotenv\Exception\InvalidPathException $e) {
    //
}

$app = require __DIR__.'/../bootstrap/app.php';
$app->boot();

$request = Illuminate\Http\Request::create('/api/action', 'POST', [
    'data_action' => 'ReqExec',
    'Requete' => 'SELECT * FROM hotel LIMIT 1',
]);

$request->headers->set('Content-Type', 'application/json');

try {
    $response = $app->dispatch($request);
    echo "Status: " . $response->getStatusCode() . "\n";
    echo "Content: " . $response->getContent() . "\n";
} catch (\Throwable $e) {
    echo "Error: " . $e->getMessage() . "\n";
    echo "File: " . $e->getFile() . "\n";
    echo "Line: " . $e->getLine() . "\n";
    echo "Trace:\n" . $e->getTraceAsString() . "\n";
}
