<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('depart', function (Blueprint $table) {
            $table->id('IDDEPART');
            $table->unsignedBigInteger('IDLIGNETRANSPORT');
            $table->date('DateDepart');
            $table->time('HeureDepart');
            $table->decimal('Prix', 10, 2)->nullable();
            $table->integer('NbrPlace')->nullable();
            $table->timestamps();

            $table->foreign('IDLIGNETRANSPORT')->references('IDLIGNETRANSPORT')->on('lignetransport')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('depart');
    }
};
