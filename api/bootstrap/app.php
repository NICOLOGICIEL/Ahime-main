<?php

require_once __DIR__.'/../vendor/autoload.php';

try {
    $dotenv = Dotenv\Dotenv::createUnsafeMutable(__DIR__.'/../');
    $dotenv->load();
} catch (Dotenv\Exception\InvalidPathException $e) {
    //
}

$app = new Laravel\Lumen\Application(
    dirname(__DIR__)
);

$app->withFacades(true);

$app->withEloquent();

$app->configure('app');
$app->configure('database');
$app->configure('logging');

$app->singleton('response', function ($app) {
    return $app['Illuminate\Contracts\Routing\ResponseFactory'];
});

$app->singleton(
    Illuminate\Contracts\Debug\ExceptionHandler::class,
    App\Exceptions\Handler::class
);

$app->singleton(
    Illuminate\Contracts\Console\Kernel::class,
    App\Console\Kernel::class
);

$app->middleware([
    // Fruitcake\Cors\HandleCors::class,
]);

$app->routeMiddleware([
    'auth' => App\Http\Middleware\Authenticate::class,
    // 'cors' => Fruitcake\Cors\HandleCors::class,
]);

$app->router->group([
    'namespace' => 'App\Http\Controllers',
], function ($router) {
    require __DIR__.'/../routes/web.php';
});

return $app;
