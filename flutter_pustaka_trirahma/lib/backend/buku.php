<?php
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("Access-Control-Allow-Origin: *");
    header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
    header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
    exit(0);
}

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST, GET, OPTIONS, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

require 'config1.php';

$method = $_SERVER['REQUEST_METHOD'];
error_log("Request Method: " . $method);
$input = file_get_contents("php://input");
error_log("Raw Input: " . $input);

switch ($method) {
    case 'GET':
        $stmt = $pdo->query("SELECT * FROM buku");
        $buku = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($buku);
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);
        error_log("POST data received: " . print_r($data, true));

        if (!isset($data['judul'])) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "Judul harus diisi"
            ]);
            exit;
        }

        try {
            $stmt = $pdo->prepare(
                "INSERT INTO buku (judul, pengarang, penerbit, tahun_terbit) 
                 VALUES (?, ?, ?, ?)"
            );
            $result = $stmt->execute([
                $data['judul'],
                $data['pengarang'] ?? null,
                $data['penerbit'] ?? null,
                $data['tahun_terbit'] ?? null
            ]);
            
            if ($result) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Data berhasil disimpan",
                    "id" => $pdo->lastInsertId()
                ]);
            } else {
                throw new Exception("Gagal menyimpan data");
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Database error: " . $e->getMessage()
            ]);
        }
        break;

    case 'PUT':
        $data = json_decode(file_get_contents("php://input"), true);
        error_log("PUT data received: " . print_r($data, true));

        if (!isset($data['id']) || !isset($data['judul'])) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "ID dan judul harus diisi"
            ]);
            exit;
        }

        try {
            $stmt = $pdo->prepare(
                "UPDATE buku 
                 SET judul = ?, 
                     pengarang = ?, 
                     penerbit = ?, 
                     tahun_terbit = ?
                 WHERE id = ?"
            );
            
            $result = $stmt->execute([
                $data['judul'],
                $data['pengarang'] ?: null,
                $data['penerbit'] ?: null,
                $data['tahun_terbit'] ?: null,
                $data['id']
            ]);
            
            if ($result) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Data berhasil diperbarui"
                ]);
            } else {
                error_log("Update failed: " . print_r($stmt->errorInfo(), true));
                http_response_code(500);
                echo json_encode([
                    "status" => "error",
                    "message" => "Gagal memperbarui data",
                    "error_info" => $stmt->errorInfo()
                ]);
            }
        } catch (PDOException $e) {
            error_log("Database error: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Database error: " . $e->getMessage()
            ]);
        }
        break;

    case 'DELETE':
        $data = json_decode(file_get_contents("php://input"), true);
        error_log("DELETE data received: " . print_r($data, true));

        if (!isset($data['id'])) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "ID tidak ditemukan"
            ]);
            exit;
        }

        try {
            $stmt = $pdo->prepare("DELETE FROM buku WHERE id = ?");
            $result = $stmt->execute([$data['id']]);
            
            if ($result && $stmt->rowCount() > 0) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Data berhasil dihapus"
                ]);
            } else {
                http_response_code(404);
                echo json_encode([
                    "status" => "error",
                    "message" => "Data tidak ditemukan"
                ]);
            }
        } catch (PDOException $e) {
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Database error: " . $e->getMessage()
            ]);
        }
        break;
}
?>