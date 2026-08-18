<?php
error_reporting(E_ALL);
ini_set('display_errors', '1');

require __DIR__.'/../vendor/autoload.php';
$app = require __DIR__.'/../bootstrap/app.php';
$app->boot();

header('Content-Type: application/json');

$input = file_get_contents('php://input');
$data = json_decode($input, true);

try {
    $controller = new App\Http\Controllers\ApiController();
    $request = Illuminate\Http\Request::create('/api/action', 'POST', $data);
    $request->headers->set('Content-Type', 'application/json');
    $response = $controller->action($request);
    echo $response->getContent();
} catch (Throwable $e) {
    http_response_code(500);
    echo json_encode([
        'error' => $e->getMessage(),
        'file' => $e->getFile(),
        'line' => $e->getLine(),
        'trace' => $e->getTraceAsString(),
    ]);
}
