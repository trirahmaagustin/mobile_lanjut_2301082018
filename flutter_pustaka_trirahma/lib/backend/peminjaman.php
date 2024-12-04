<?php
require 'config1.php';

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
            $stmt = $pdo->prepare("SELECT p.*, a.nama as nama_anggota, b.judul as judul_buku 
                                 FROM peminjaman p 
                                 JOIN anggota a ON p.anggota = a.id 
                                 JOIN buku b ON p.buku = b.id 
                                 WHERE p.id = ?");
            $stmt->execute([$id]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($peminjaman) {
                echo json_encode($peminjaman);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Peminjaman tidak ditemukan"]);
            }
        } else {
            $stmt = $pdo->query("SELECT p.*, a.nama as nama_anggota, b.judul as judul_buku 
                               FROM peminjaman p 
                               JOIN anggota a ON p.anggota = a.id 
                               JOIN buku b ON p.buku = b.id");
            $peminjaman = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($peminjaman);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);

        if (!empty($data['tanggal_pinjam']) && !empty($data['tanggal_kembali']) && !empty($data['anggota']) && !empty($data['buku'])) {
            $stmt = $pdo->prepare("INSERT INTO peminjaman (tanggal_pinjam, tanggal_kembali, anggota, buku) VALUES (?, ?, ?, ?)");
            $stmt->execute([$data['tanggal_pinjam'], $data['tanggal_kembali'], $data['anggota'], $data['buku']]);
            echo json_encode(["message" => "Peminjaman berhasil dibuat", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(["message" => "Data tidak valid"]);
        }
        break;

    case 'PUT':
        if ($id) {
            $data = json_decode(file_get_contents("php://input"), true);
            $stmt = $pdo->prepare("SELECT * FROM peminjaman WHERE id = ?");
            $stmt->execute([$id]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($peminjaman) {
                $tanggal_pinjam = $data['tanggal_pinjam'] ?? $peminjaman['tanggal_pinjam'];
                $tanggal_kembali = $data['tanggal_kembali'] ?? $peminjaman['tanggal_kembali'];
                $anggota = $data['anggota'] ?? $peminjaman['anggota'];
                $buku = $data['buku'] ?? $peminjaman['buku'];

                $stmt = $pdo->prepare("UPDATE peminjaman SET tanggal_pinjam = ?, tanggal_kembali = ?, anggota = ?, buku = ? WHERE id = ?");
                $stmt->execute([$tanggal_pinjam, $tanggal_kembali, $anggota, $buku, $id]);
                echo json_encode(["message" => "Peminjaman berhasil diperbarui"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Peminjaman tidak ditemukan"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID tidak diberikan"]);
        }
        break;

    case 'DELETE':
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM peminjaman WHERE id = ?");
            $stmt->execute([$id]);
            $peminjaman = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($peminjaman) {
                $stmt = $pdo->prepare("DELETE FROM peminjaman WHERE id = ?");
                $stmt->execute([$id]);
                echo json_encode(["message" => "Peminjaman berhasil dihapus"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Peminjaman tidak ditemukan"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID tidak diberikan"]);
        }
        break;

    default:
        http_response_code(405);
        echo json_encode(["message" => "Metode tidak diizinkan"]);
        break;
}
?> 