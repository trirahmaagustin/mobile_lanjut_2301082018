<?php
require_once '../config/connection.php';

$sql = "SELECT p.*, a.nama as nama_peminjam, b.judul as judul_buku 
        FROM peminjaman p
        JOIN anggota a ON p.anggota_id = a.id
        JOIN buku b ON p.buku_id = b.id";
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