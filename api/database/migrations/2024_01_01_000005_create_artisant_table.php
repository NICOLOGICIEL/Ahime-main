<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('artisant', function (Blueprint $table) {
            $table->id('IDARTISANT');
            $table->unsignedBigInteger('IDMETIER');
            $table->unsignedBigInteger('IDCATEGORIEMETIER')->nullable();
            $table->string('Nom', 255)->nullable();
            $table->string('Prenom', 255)->nullable();
            $table->string('Ville', 100)->nullable();
            $table->string('Commune', 100)->nullable();
            $table->string('Quartier', 100)->nullable();
            $table->string('Contact', 50)->nullable();
            $table->string('NumWhatApp', 50)->nullable();
            $table->text('Description')->nullable();
            $table->text('Image')->nullable();
            $table->decimal('Tnote', 3, 2)->nullable();
            $table->timestamps();

            $table->foreign('IDMETIER')->references('IDMETIER')->on('metier')->onDelete('cascade');
            $table->foreign('IDCATEGORIEMETIER')->references('IDCATEGORIEMETIER')->on('categoriemetier')->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('artisant');
    }
};
