<?php
require_once '../config/connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!$data) {
    die(json_encode([
        "status" => "error",
        "message" => "No data received"
    ]));
}

$judul = $data['judul'] ?? '';
$pengarang = $data['pengarang'] ?? '';
$penerbit = $data['penerbit'] ?? '';
$tahun_terbit = $data['tahun_terbit'] ?? null;

try {
    $sql = "INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit) VALUES (?, ?, ?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("sssi", $judul, $pengarang, $penerbit, $tahun_terbit);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Buku berhasil ditambahkan"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 