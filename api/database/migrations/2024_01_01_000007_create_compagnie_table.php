<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('compagnie', function (Blueprint $table) {
            $table->id('IDCOMPAGNIE');
            $table->string('Nom', 255);
            $table->string('Ville', 100)->nullable();
            $table->string('Contact', 50)->nullable();
            $table->string('NumWhatApp', 50)->nullable();
            $table->text('Description')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('compagnie');
    }
};
