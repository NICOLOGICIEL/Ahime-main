<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('commoditetransport', function (Blueprint $table) {
            $table->id('IDCOMMODITETRANSPORT');
            $table->unsignedBigInteger('IDDEPART');
            $table->boolean('Wifi')->nullable();
            $table->boolean('Climatiseur')->nullable();
            $table->boolean('Prises')->nullable();
            $table->boolean('Toilette')->nullable();
            $table->text('Description')->nullable();
            $table->timestamps();

            $table->foreign('IDDEPART')->references('IDDEPART')->on('depart')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('commoditetransport');
    }
};
