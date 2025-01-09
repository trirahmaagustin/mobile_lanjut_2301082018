<?php
require_once '../config/connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data || !isset($data['id'])) {
    die(json_encode([
        "status" => "error",
        "message" => "Invalid data received"
    ]));
}

$id = $data['id'];
$tanggal_pinjam = $data['tanggal_pinjam'] ?? '';
$tanggal_kembali = $data['tanggal_kembali'] ?? '';
$anggota_id = $data['anggota_id'] ?? null;
$buku_id = $data['buku_id'] ?? null;

try {
    $sql = "UPDATE peminjaman SET tanggal_pinjam = ?, tanggal_kembali = ?, 
            anggota_id = ?, buku_id = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssiii", $tanggal_pinjam, $tanggal_kembali, $anggota_id, $buku_id, $id);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Peminjaman berhasil diupdate"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 