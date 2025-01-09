<?php
require_once '../config/connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    die(json_encode([
        "status" => "error",
        "message" => "No data received"
    ]));
}

$tanggal_pinjam = $data['tanggal_pinjam'] ?? '';
$tanggal_kembali = $data['tanggal_kembali'] ?? '';
$anggota_id = $data['anggota_id'] ?? null;
$buku_id = $data['buku_id'] ?? null;

try {
    $sql = "INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, anggota_id, buku_id) 
            VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssii", $tanggal_pinjam, $tanggal_kembali, $anggota_id, $buku_id);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Peminjaman berhasil ditambahkan"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 