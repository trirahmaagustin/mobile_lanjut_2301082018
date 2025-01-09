<?php
header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

include_once '../config/connection.php';

$query = "SELECT * FROM anggota";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $anggota = array();
    while($row = $result->fetch_assoc()) {
        array_push($anggota, $row);
    }
    echo json_encode($anggota);
} else {
    echo json_encode([]);
}
?> 