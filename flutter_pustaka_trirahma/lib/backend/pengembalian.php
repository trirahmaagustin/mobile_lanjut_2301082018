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
            $stmt = $pdo->prepare("SELECT p.*, pm.tanggal_pinjam, pm.tanggal_kembali, a.nama as nama_anggota, b.judul as judul_buku 
                                 FROM pengembalian p 
                                 JOIN peminjaman pm ON p.peminjaman = pm.id
                                 JOIN anggota a ON pm.anggota = a.id 
                                 JOIN buku b ON pm.buku = b.id 
                                 WHERE p.id = ?");
            $stmt->execute([$id]);
            $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($pengembalian) {
                echo json_encode($pengembalian);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Pengembalian tidak ditemukan"]);
            }
        } else {
            $stmt = $pdo->query("SELECT p.*, pm.tanggal_pinjam, pm.tanggal_kembali, a.nama as nama_anggota, b.judul as judul_buku 
                               FROM pengembalian p 
                               JOIN peminjaman pm ON p.peminjaman = pm.id
                               JOIN anggota a ON pm.anggota = a.id 
                               JOIN buku b ON pm.buku = b.id");
            $pengembalian = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode($pengembalian);
        }
        break;

    case 'POST':
        $data = json_decode(file_get_contents("php://input"), true);

        if (!empty($data['tanggal_dikembalikan']) && !empty($data['peminjaman'])) {
            $stmt = $pdo->prepare("INSERT INTO pengembalian (tanggal_dikembalikan, terlambat, denda, peminjaman) VALUES (?, ?, ?, ?)");
            $terlambat = $data['terlambat'] ?? 0;
            $denda = $data['denda'] ?? 0;
            $stmt->execute([$data['tanggal_dikembalikan'], $terlambat, $denda, $data['peminjaman']]);
            echo json_encode(["message" => "Pengembalian berhasil dibuat", "id" => $pdo->lastInsertId()]);
        } else {
            http_response_code(400);
            echo json_encode(["message" => "Data tidak valid"]);
        }
        break;

    case 'PUT':
        if ($id) {
            $data = json_decode(file_get_contents("php://input"), true);
            $stmt = $pdo->prepare("SELECT * FROM pengembalian WHERE id = ?");
            $stmt->execute([$id]);
            $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($pengembalian) {
                $tanggal_dikembalikan = $data['tanggal_dikembalikan'] ?? $pengembalian['tanggal_dikembalikan'];
                $terlambat = $data['terlambat'] ?? $pengembalian['terlambat'];
                $denda = $data['denda'] ?? $pengembalian['denda'];
                $peminjaman = $data['peminjaman'] ?? $pengembalian['peminjaman'];

                $stmt = $pdo->prepare("UPDATE pengembalian SET tanggal_dikembalikan = ?, terlambat = ?, denda = ?, peminjaman = ? WHERE id = ?");
                $stmt->execute([$tanggal_dikembalikan, $terlambat, $denda, $peminjaman, $id]);
                echo json_encode(["message" => "Pengembalian berhasil diperbarui"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Pengembalian tidak ditemukan"]);
            }
        } else {
            http_response_code(400);
            echo json_encode(["message" => "ID tidak diberikan"]);
        }
        break;

    case 'DELETE':
        if ($id) {
            $stmt = $pdo->prepare("SELECT * FROM pengembalian WHERE id = ?");
            $stmt->execute([$id]);
            $pengembalian = $stmt->fetch(PDO::FETCH_ASSOC);

            if ($pengembalian) {
                $stmt = $pdo->prepare("DELETE FROM pengembalian WHERE id = ?");
                $stmt->execute([$id]);
                echo json_encode(["message" => "Pengembalian berhasil dihapus"]);
            } else {
                http_response_code(404);
                echo json_encode(["message" => "Pengembalian tidak ditemukan"]);
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