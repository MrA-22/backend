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
        Schema::create('siswa', function (Blueprint $table) {
            Schema::create('siswa', function (Blueprint $table) {
                $table->id('id_siswa');
                $table->string('nisn', 20)->nullable()->unique();
                $table->string('nama_siswa', 100)->nullable();
                $table->date('tgll_siswa')->nullable();
                $table->text('alamat')->nullable();
                $table->string('nohp_ortu', 15)->nullable();
                $table->string('foto_siswa', 255)->nullable();
                $table->integer('id_kelas')->nullable();
            });
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('siswa');
    }
};
