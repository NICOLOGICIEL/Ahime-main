<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('escale', function (Blueprint $table) {
            $table->id('IDESCALE');
            $table->unsignedBigInteger('IDDEPART');
            $table->string('Localite', 255);
            $table->time('HeureArrivee')->nullable();
            $table->time('HeureDepart')->nullable();
            $table->timestamps();

            $table->foreign('IDDEPART')->references('IDDEPART')->on('depart')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('escale');
    }
};
