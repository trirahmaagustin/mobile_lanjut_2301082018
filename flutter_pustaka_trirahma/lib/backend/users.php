<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Content-Type: application/json; charset=UTF-8");

$host = "localhost";
$username = "root";
$password = "";
$database = "pustaka_2018";

$conn = mysqli_connect($host, $username, $password, $database);

// Debug: Tulis semua input yang diterima
$input = file_get_contents('php://input');
error_log("Received input: " . $input);

$data = json_decode($input, true);

// Debug: Tulis data yang sudah di-decode
error_log("Decoded data: " . print_r($data, true));

if (!$data) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Data tidak lengkap'
    ]);
    exit;
}

$email = $data['email'];
$password = $data['password'];
$role = $data['role'];

// Debug: Tulis nilai yang akan digunakan untuk query
error_log("Email: " . $email);
error_log("Password: " . $password);
error_log("Role: " . $role);

// Query untuk mencari user
$query = "SELECT * FROM users WHERE email = ? AND role = ?";
$stmt = $conn->prepare($query);
$stmt->bind_param("ss", $email, $role);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    // Debug: Tulis password dari database
    error_log("Password from DB: " . $user['password']);
    error_log("Input password: " . $password);
    
    // Bandingkan password tanpa hash
    if ($password === $user['password']) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Login berhasil',
            'user' => [
                'id' => $user['id'],
                'email' => $user['email'],
                'role' => $user['role']
            ]
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Password salah',
            'debug' => [
                'input_password' => $password,
                'db_password' => $user['password']
            ]
        ]);
    }
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'User tidak ditemukan'
    ]);
}

$conn->close();
?>