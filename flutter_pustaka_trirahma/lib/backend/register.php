<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$username = "root";
$password = "";
$database = "pustaka_2018";

$conn = mysqli_connect($host, $username, $password, $database);

if (!$conn) {
    $response = [
        'status' => 'error',
        'message' => 'Koneksi database gagal: ' . mysqli_connect_error()
    ];
    echo json_encode($response);
    exit();
}

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (!$data) {
    $response = [
        'status' => 'error',
        'message' => 'Data tidak diterima'
    ];
    echo json_encode($response);
    exit();
}

$email = isset($data['email']) ? $data['email'] : '';
$password = isset($data['password']) ? password_hash($data['password'], PASSWORD_DEFAULT) : '';
$role = isset($data['role']) ? $data['role'] : 'user';

try {
    // Cek apakah email sudah terdaftar
    $check_query = "SELECT * FROM users WHERE email = ?";
    $check_stmt = $conn->prepare($check_query);
    $check_stmt->bind_param("s", $email);
    $check_stmt->execute();
    $result = $check_stmt->get_result();

    if ($result->num_rows > 0) {
        $response = [
            'status' => 'error',
            'message' => 'Email sudah terdaftar'
        ];
    } else {
        // Insert user baru
        $query = "INSERT INTO users (email, password, role) VALUES (?, ?, ?)";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("sss", $email, $password, $role);

        if ($stmt->execute()) {
            $response = [
                'status' => 'success',
                'message' => 'Registrasi berhasil'
            ];
        } else {
            throw new Exception("Error saat menyimpan data: " . $stmt->error);
        }
    }
} catch (Exception $e) {
    $response = [
        'status' => 'error',
        'message' => 'Error: ' . $e->getMessage()
    ];
}

echo json_encode($response);
$conn->close();
?>