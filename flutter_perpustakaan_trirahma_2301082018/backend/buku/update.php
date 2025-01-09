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
$judul = $data['judul'] ?? '';
$pengarang = $data['pengarang'] ?? '';
$penerbit = $data['penerbit'] ?? '';
$tahun_terbit = $data['tahun_terbit'] ?? null;

try {
    $sql = "UPDATE buku SET judul = ?, pengarang = ?, penerbit = ?, tahun_terbit = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssii", $judul, $pengarang, $penerbit, $tahun_terbit, $id);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Buku berhasil diupdate"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 