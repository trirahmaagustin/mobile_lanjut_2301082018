<?php
$host = 'localhost';
$user = 'root';  // sesuaikan dengan username database Anda
$pass = '';      // sesuaikan dengan password database Anda
$db   = 'pustaka_2018';  // sesuaikan dengan nama database Anda

$koneksi = new mysqli($host, $user, $pass, $db);

if ($koneksi->connect_error) {
    die("Koneksi gagal: " . $koneksi->connect_error);
}

// Set karakter encoding
$koneksi->set_charset("utf8");
?> 