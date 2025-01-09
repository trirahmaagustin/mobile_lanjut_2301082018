<?php
require_once '../config/connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    die(json_encode([
        "status" => "error",
        "message" => "No data received"
    ]));
}

$nim = $data['nim'] ?? '';
$nama = $data['nama'] ?? '';
$alamat = $data['alamat'] ?? '';
$jenis_kelamin = $data['jenis_kelamin'] ?? '';

try {
    $sql = "INSERT INTO anggota (nim, nama, alamat, jenis_kelamin) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssi", $nim, $nama, $alamat, $jenis_kelamin);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Anggota berhasil ditambahkan"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?>