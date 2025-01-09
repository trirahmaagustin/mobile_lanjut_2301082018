<?php
require_once 'config/connection.php';

try {
    $sql = "SHOW TABLES";
    $result = $conn->query($sql);
    
    $tables = [];
    while($row = $result->fetch_array()) {
        $tables[] = $row[0];
    }
    
    echo json_encode([
        "status" => "success",
        "message" => "Database connection successful",
        "tables" => $tables
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
}
?> 