<?php
require_once '../config/connection.php';

$sql = "SELECT p.*, pm.tanggal_pinjam, pm.tanggal_kembali,
        a.nama as nama_peminjam, b.judul as judul_buku
        FROM pengembalian p
        JOIN peminjaman pm ON p.peminjaman_id = pm.id
        JOIN anggota a ON pm.anggota_id = a.id
        JOIN buku b ON pm.buku_id = b.id";

$result = $conn->query($sql);

$data = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $data[] = $row;
    }
}

echo json_encode($data);
$conn->close();
?> 