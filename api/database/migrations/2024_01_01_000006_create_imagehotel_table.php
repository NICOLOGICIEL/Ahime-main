<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('imagehotel', function (Blueprint $table) {
            $table->id('IDIMAGEHOTEL');
            $table->unsignedBigInteger('IDHOTEL');
            $table->longText('Image')->nullable();
            $table->timestamps();

            $table->foreign('IDHOTEL')->references('IDHOTEL')->on('hotel')->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('imagehotel');
    }
};
