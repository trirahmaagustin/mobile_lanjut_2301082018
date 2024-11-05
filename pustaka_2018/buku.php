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
            // Get buku by ID
            $stmt = $pdo->prepare("SELECT * FROM buku WHERE id = ?");
            $stmt->execute([$id]);
            $buku = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($buku) {
                echo json_encode($buku);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "buku not found"]);
            }
        } else {
            // Get all buku
            $stmt = $pdo->query("SELECT * FROM buku");
            $buku = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($buku);
        }
        break;

    case 'POST':
        // Create new buku
        $data = json_decode(file_get_contents("php://input"), true);

        if (!empty($data['kode']) && !empty($data['judul']) && !empty($data['pengarang']) && !empty($data['penerbit']) && !empty($data['tahun_terbit'])) {
            $stmt = $pdo->prepare("INSERT INTO buku (kode, judul, pengarang, penerbit, tahun_terbit) VALUES (?, ?, ?, ?, ?)");
            $stmt->execute([$data['kode'], $data['judul'], $data['pengarang'],$data['penerbit'],$data['tahun_terbit']]);
            echo json_encode(["message" => "buku created", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(["message" => "Invalid data"]);
        }
        break;

    case 'PUT':
        // Update buku by ID
        if ($id) {
            $data = json_decode(file_get_contents("php://input"), true);

            $stmt = $pdo->prepare("SELECT * FROM buku WHERE id = ?");
            $stmt->execute([$id]);
            $buku = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($buku) {
                $name = $data['kode'] ?? $buku['kode'];
                $age = $data['judul'] ?? $buku['judul'];
                $major = $data['pengarang'] ?? $buku['pengarang'];
                $major = $data['penerbit'] ?? $buku['penerbit'];
                $major = $data['tahun_terbit'] ?? $buku['tahun_terbit'];

                $stmt = $pdo->prepare("UPDATE buku SET kode = ?, judul = ?, pengarang = ?, penerbit = ?, tahun_terbit = ? WHERE id = ?");
                $stmt->execute([$kode, $judul, $pengarang, $penerbit, $tahun_terbit, $id]);
                echo json_encode(["message" => "buku updated"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "buku not found"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID not provided"]);
        }
        break;

    case 'DELETE':
        // Delete buku by ID
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM buku WHERE id = ?");
            $stmt->execute([$id]);
            $buku = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($buku) {
                $stmt = $pdo->prepare("DELETE FROM buku WHERE id = ?");
                $stmt->execute([$id]);
                echo json_encode(["message" => "buku deleted"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "buku not found"]);
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