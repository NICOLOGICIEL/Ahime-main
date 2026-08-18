<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('hotel', function (Blueprint $table) {
            $table->id('IDHOTEL');
            $table->string('NomEtab', 255);
            $table->string('Ville', 100);
            $table->string('Commune', 100);
            $table->string('Quartier', 100);
            $table->decimal('Longitude', 12, 8)->nullable();
            $table->decimal('Latitude', 12, 8)->nullable();
            $table->string('PrixMini', 50)->nullable();
            $table->longText('Image')->nullable();
            $table->string('Contact', 50)->nullable();
            $table->string('NumWhatApp', 50)->nullable();
            $table->text('Situation')->nullable();
            $table->text('Description')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('hotel');
    }
};
