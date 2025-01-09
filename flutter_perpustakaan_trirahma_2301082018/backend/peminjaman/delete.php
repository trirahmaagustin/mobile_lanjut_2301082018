<?php
require_once '../config/connection.php';

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['id'])) {
    die(json_encode([
        "status" => "error",
        "message" => "ID is required"
    ]));
}

$id = $data['id'];

try {
    $sql = "DELETE FROM peminjaman WHERE id = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $id);
    $stmt->execute();
    
    echo json_encode([
        "status" => "success",
        "message" => "Peminjaman berhasil dihapus"
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}

$conn->close();
?> 