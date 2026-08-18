<?php
require __DIR__.'/../vendor/autoload.php';
$app = require __DIR__.'/../bootstrap/app.php';
$app->boot();

header('Content-Type: application/json');

$input = file_get_contents('php://input');
$data = json_decode($input, true);

echo json_encode([
    'data_action' => $data['data_action'] ?? null,
    'Requete' => $data['Requete'] ?? null,
]);
