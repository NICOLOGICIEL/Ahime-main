<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('commoditehotel', function (Blueprint $table) {
            $table->id('IDCOMMODITEHOTEL');
            $table->unsignedBigInteger('IDHOTEL');
            $table->integer('NbrEtoile')->nullable();
            $table->boolean('Wifi')->nullable();
            $table->boolean('Piscine')->nullable();
            $table->boolean('Spa')->nullable();
            $table->boolean('Bar')->nullable();
            $table->boolean('RestoBar')->nullable();
            $table->boolean('Garage')->nullable();
            $table->boolean('Ventilateur')->nullable();
            $table->boolean('Climatiseur')->nullable();
            $table->boolean('EstResidence')->nullable();
            $table->boolean('EstHotel')->nullable();
            $table->timestamps();

            $table->foreign('IDHOTEL')->references('IDHOTEL')->on('hotel')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('commoditehotel');
    }
};
