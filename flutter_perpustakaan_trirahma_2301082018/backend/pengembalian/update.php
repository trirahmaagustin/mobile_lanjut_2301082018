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
$tanggal_dikembalikan = $data['tanggal_dikembalikan'] ?? '';
$terlambat = $data['terlambat'] ?? false;
$denda = $data['denda'] ?? 0;
$peminjaman_id = $data['peminjaman_id'] ?? null;

try {
    $sql = "UPDATE pengembalian SET 
            tanggal_dikembalikan = ?,
            terlambat = ?,
            denda = ?,
            peminjaman_id = ?
            WHERE id = ?";
            
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sidii", 
        $tanggal_dikembalikan,
        $terlambat,
        $denda,
        $peminjaman_id,
        $id
    );
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Pengembalian berhasil diupdate"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 