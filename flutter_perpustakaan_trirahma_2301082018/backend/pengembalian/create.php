<?php
require_once '../config/connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    die(json_encode([
        "status" => "error",
        "message" => "No data received"
    ]));
}

$tanggal_dikembalikan = $data['tanggal_dikembalikan'] ?? '';
$terlambat = $data['terlambat'] ?? false;
$denda = $data['denda'] ?? 0;
$peminjaman_id = $data['peminjaman_id'] ?? null;

try {
    $sql = "INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, peminjaman_id) 
            VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sidi", $tanggal_dikembalikan, $terlambat, $denda, $peminjaman_id);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Pengembalian berhasil ditambahkan"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 