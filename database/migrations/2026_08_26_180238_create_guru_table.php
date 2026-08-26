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
        Schema::create('guru', function (Blueprint $table) {
            $table->id('id_guru');
            $table->string('foto_guru', 225)->unique();
            $table->string('nuptk', 30)->nullable();
            $table->string('jabatan', 180);
            $table->string('nama_guru', 80);
            $table->date('tgll_guru');
            $table->string('mengajar', 110);
            $table->text('alamat_guru');
            $table->string('nohp_guru', 20)->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('guru');
    }
};
