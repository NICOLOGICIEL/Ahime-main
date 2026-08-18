<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('lignetransport', function (Blueprint $table) {
            $table->id('IDLIGNETRANSPORT');
            $table->unsignedBigInteger('IDCOMPAGNIE');
            $table->string('VilleDepart', 100);
            $table->string('VilleArrivee', 100);
            $table->decimal('LongitudeDepart', 12, 8)->nullable();
            $table->decimal('LatitudeDepart', 12, 8)->nullable();
            $table->decimal('LongitudeArrivee', 12, 8)->nullable();
            $table->decimal('LatitudeArrivee', 12, 8)->nullable();
            $table->timestamps();

            $table->foreign('IDCOMPAGNIE')->references('IDCOMPAGNIE')->on('compagnie')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lignetransport');
    }
};
