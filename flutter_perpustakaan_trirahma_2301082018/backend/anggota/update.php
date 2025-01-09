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
$nim = $data['nim'] ?? '';
$nama = $data['nama'] ?? '';
$alamat = $data['alamat'] ?? '';
$jenis_kelamin = $data['jenis_kelamin'] ?? '';

try {
    $sql = "UPDATE anggota SET nim = ?, nama = ?, alamat = ?, jenis_kelamin = ? WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ssssi", $nim, $nama, $alamat, $jenis_kelamin, $id);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Anggota berhasil diupdate"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 