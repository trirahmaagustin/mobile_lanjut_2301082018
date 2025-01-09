<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include_once 'config/connection.php';

try {
    // Get total anggota
    $query_anggota = "SELECT COUNT(*) as total FROM anggota";
    $result_anggota = $conn->query($query_anggota);
    $total_anggota = $result_anggota->fetch_assoc()['total'];

    // Get total buku
    $query_buku = "SELECT COUNT(*) as total FROM buku";
    $result_buku = $conn->query($query_buku);
    $total_buku = $result_buku->fetch_assoc()['total'];

    // Get total peminjaman
    $query_peminjaman = "SELECT COUNT(*) as total FROM peminjaman";
    $result_peminjaman = $conn->query($query_peminjaman);
    $total_peminjaman = $result_peminjaman->fetch_assoc()['total'];

    // Get total pengembalian
    $query_pengembalian = "SELECT COUNT(*) as total FROM pengembalian";
    $result_pengembalian = $conn->query($query_pengembalian);
    $total_pengembalian = $result_pengembalian->fetch_assoc()['total'];

    echo json_encode([
        'anggota' => (int)$total_anggota,
        'buku' => (int)$total_buku,
        'peminjaman' => (int)$total_peminjaman,
        'pengembalian' => (int)$total_pengembalian
    ]);

} catch(Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
} 