<?php
require __DIR__.'/../vendor/autoload.php';
$app = require __DIR__.'/../bootstrap/app.php';
$app->boot();

$app->router->post('/test-request', function (Illuminate\Http\Request $request) {
    header('Content-Type: application/json');
    return response()->json([
        'content_type' => $_SERVER['CONTENT_TYPE'] ?? 'not set',
        'input' => file_get_contents('php://input'),
        'all' => $request->all(),
        'json' => $request->json()->all(),
    ]);
});

$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$status = $kernel->handle(
    $input = new Symfony\Component\Console\Input\ArgvInput,
    new Symfony\Component\Console\Output\ConsoleOutput
);
exit($status);
