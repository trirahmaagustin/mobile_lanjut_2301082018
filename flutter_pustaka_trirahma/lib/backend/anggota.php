<?php
// Tambahkan ini di awal file
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

// Tambahkan logging untuk debug
error_log("Request Method: " . $_SERVER['REQUEST_METHOD']);
$input = file_get_contents("php://input");
error_log("Raw Input: " . $input);

$method = $_SERVER['REQUEST_METHOD'];
$path_info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER['ORIG_PATH_INFO'] : '');
$request = explode('/', trim($path_info, '/'));
$id = isset($request[1]) ? (int)$request[1] : null;

// Tambahkan ini di awal file untuk logging
ini_set('display_errors', 1);
ini_set('log_errors', 1);
error_reporting(E_ALL);

switch ($method) {
    case 'GET':
        if ($id) {
            // Get anggota by ID
            $stmt = $pdo->prepare("SELECT * FROM anggota WHERE id = ?");
            $stmt->execute([$id]);
            $anggota = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($anggota) {
                echo json_encode($anggota);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "anggota not found"]);
            }
        } else {
            // Get all anggota
            $stmt = $pdo->query("SELECT * FROM anggota");
            $anggota = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($anggota);
        }
        break;

    case 'POST':
        // Log raw input
        error_log("Raw input: " . file_get_contents("php://input"));
        
        $data = json_decode(file_get_contents("php://input"), true);
        error_log("Decoded data: " . print_r($data, true));

        // Validasi data yang diterima
        if (!isset($data['nim']) || !isset($data['nama']) || !isset($data['jenis_kelamin'])) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "Data tidak lengkap",
                "received_data" => $data
            ]);
            exit;
        }

        try {
            $stmt = $pdo->prepare("INSERT INTO anggota (nim, nama, alamat, jenis_kelamin) VALUES (?, ?, ?, ?)");
            $result = $stmt->execute([
                $data['nim'],
                $data['nama'],
                $data['alamat'] ?? '',
                $data['jenis_kelamin']
            ]);
            
            if ($result) {
                $newId = $pdo->lastInsertId();
                echo json_encode([
                    "status" => "success",
                    "message" => "Data berhasil disimpan",
                    "id" => $newId
                ]);
            } else {
                error_log("Database error: " . print_r($stmt->errorInfo(), true));
                http_response_code(500);
                echo json_encode([
                    "status" => "error",
                    "message" => "Gagal menyimpan ke database",
                    "error_info" => $stmt->errorInfo()
                ]);
            }
        } catch (PDOException $e) {
            error_log("PDO Exception: " . $e->getMessage());
            http_response_code(500);
            echo json_encode([
                "status" => "error",
                "message" => "Database error: " . $e->getMessage()
            ]);
        }
        break;

    case 'PUT':
        // Decode JSON data
        $data = json_decode(file_get_contents("php://input"), true);
        error_log("PUT data received: " . print_r($data, true));
        
        // Validate required fields
        if (!isset($data['id']) || !isset($data['nim']) || !isset($data['nama']) || !isset($data['jenis_kelamin'])) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "Data tidak lengkap",
                "received_data" => $data
            ]);
            exit;
        }

        try {
            // Prepare update statement
            $stmt = $pdo->prepare(
                "UPDATE anggota 
                 SET nim = ?, nama = ?, alamat = ?, jenis_kelamin = ? 
                 WHERE id = ?"
            );

            // Execute update
            $result = $stmt->execute([
                $data['nim'],
                $data['nama'],
                $data['alamat'] ?? '',
                $data['jenis_kelamin'],
                $data['id']
            ]);
            
            if ($result) {
                // Check if any row was actually updated
                if ($stmt->rowCount() > 0) {
                    echo json_encode([
                        "status" => "success",
                        "message" => "Data berhasil diperbarui"
                    ]);
                } else {
                    http_response_code(404);
                    echo json_encode([
                        "status" => "error",
                        "message" => "Data tidak ditemukan"
                    ]);
                }
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
        // Decode JSON data
        $data = json_decode(file_get_contents("php://input"), true);
        error_log("DELETE data received: " . print_r($data, true));
        
        if (!isset($data['id'])) {
            http_response_code(400);
            echo json_encode([
                "status" => "error",
                "message" => "ID tidak ditemukan",
                "received_data" => $data
            ]);
            exit;
        }

        try {
            // Check if record exists
            $checkStmt = $pdo->prepare("SELECT id FROM anggota WHERE id = ?");
            $checkStmt->execute([$data['id']]);
            
            if ($checkStmt->rowCount() === 0) {
                http_response_code(404);
                echo json_encode([
                    "status" => "error",
                    "message" => "Data tidak ditemukan"
                ]);
                exit;
            }

            // Delete record
            $stmt = $pdo->prepare("DELETE FROM anggota WHERE id = ?");
            $result = $stmt->execute([$data['id']]);
            
            if ($result) {
                echo json_encode([
                    "status" => "success",
                    "message" => "Data berhasil dihapus"
                ]);
            } else {
                error_log("Delete failed: " . print_r($stmt->errorInfo(), true));
                http_response_code(500);
                echo json_encode([
                    "status" => "error",
                    "message" => "Gagal menghapus data",
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

    default:
        http_response_code(405);
        echo json_encode(["message" => "Method not allowed"]);
        break;
}
?>