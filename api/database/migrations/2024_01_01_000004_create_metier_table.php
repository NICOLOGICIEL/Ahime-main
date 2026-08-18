<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('metier', function (Blueprint $table) {
            $table->id('IDMETIER');
            $table->unsignedBigInteger('IDCATEGORIEMETIER');
            $table->string('Libelle', 255);
            $table->timestamps();

            $table->foreign('IDCATEGORIEMETIER')->references('IDCATEGORIEMETIER')->on('categoriemetier')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('metier');
    }
};
