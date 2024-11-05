<?php
require 'config1.php';

// Set headers to allow API access from outside
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

$method = $_SERVER['REQUEST_METHOD'];
$path_info = isset($_SERVER['PATH_INFO']) ? $_SERVER['PATH_INFO'] : (isset($_SERVER['ORIG_PATH_INFO']) ? $_SERVER['ORIG_PATH_INFO'] : '');
$request = explode('/', trim($path_info, '/'));
$id = isset($request[1]) ? (int)$request[1] : null;

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
        // Create new anggota
        $data = json_decode(file_get_contents("php://input"), true);

        if (!empty($data['nama']) && !empty($data['kode']) && !empty($data['jekel']) && !empty($data['alamat']) ) {
            $stmt = $pdo->prepare("INSERT INTO anggota (nama, kode, jekel, alamat) VALUES (?, ?, ?, ?)");
            $stmt->execute([$data['nama'], $data['kode'], $data['jekel'],$data['alamat']]);
            echo json_encode(["message" => "anggota created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(["message" => "Invalid data"]);
        }
        break;

    case 'PUT':
        // Update anggota by ID
        if ($id) {
            $data = json_decode(file_get_contents("php://input"), true);

            $stmt = $pdo->prepare("SELECT * FROM anggota WHERE id = ?");
            $stmt->execute([$id]);
            $anggota = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($anggota) {
                $name = $data['nama'] ?? $anggota['nama'];
                $age = $data['kode'] ?? $anggota['kode'];
                $major = $data['jekel'] ?? $anggota['jekel'];
                $major = $data['alamat'] ?? $anggota['alamat'];

                $stmt = $pdo->prepare("UPDATE anggota SET nama = ?, kode = ?, jekel = ?, alamat = ? WHERE id = ?");
                $stmt->execute([$nama, $kode, $jekel, $alamat, $id]);
                echo json_encode(["message" => "anggota updated"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "anggota not found"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID not provided"]);
        }
        break;

    case 'DELETE':
        // Delete anggota by ID
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM anggota WHERE id = ?");
            $stmt->execute([$id]);
            $anggota = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($anggota) {
                $stmt = $pdo->prepare("DELETE FROM anggota WHERE id = ?");
                $stmt->execute([$id]);
                echo json_encode(["message" => "anggota deleted"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "anggota not found"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID not provided"]);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Method not allowed"]);
        break;
}
?>