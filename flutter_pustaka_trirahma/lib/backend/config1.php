<?php
try {
    $pdo = new PDO(
        "mysql:host=localhost;dbname=pustaka_2018",
        "root",  // sesuaikan dengan username MySQL Anda
        "",      // sesuaikan dengan password MySQL Anda
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
        ]
    );
} catch(PDOException $e) {
    error_log("Connection failed: " . $e->getMessage());
    die("Connection failed: " . $e->getMessage());
}
?>