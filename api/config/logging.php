<?php

return [

    'default' => env('LOG_CHANNEL', 'stack'),

    'channels' => [
        'stack' => [
            'driver' => 'stack',
            'channels' => ['single'],
        ],

        'single' => [
            'driver' => 'single',
            'path' => storage_path('logs/lumen.log'),
            'level' => env('LOG_LEVEL', 'debug'),
        ],

        'deprecations' => [
            'driver' => 'single',
            'path' => storage_path('logs/deprecations.log'),
            'level' => 'debug',
        ],
    ],

];
