<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('identitas_sekolah', function (Blueprint $table) {
            $table->id();
            $table->string('nama_sekolah', 255);
            $table->string('namakp_sekolah', 220);
            $table->integer('nuptkkp');
            $table->text('alamat_sekolah');
            $table->string('email', 255);
            $table->string('noponsel', 20)->nullable();
            $table->string('tahun_ajaran', 20)->nullable();
            $table->string('semester', 20)->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('identitas_sekolah');
    }
};
