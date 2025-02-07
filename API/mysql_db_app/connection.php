<?php
$serverHost = 'localhost';
$user = 'root';
$password = 'mysql';
$database = 'mydb_app';

try {
    // Attempt to establish a connection
    $connectNow = new mysqli($serverHost, $user, $password, $database);
    
    // If connection is successful, this message will be displayed
} catch (mysqli_sql_exception $e) {
    // If an error occurs, display the error message
    echo "Connection failed: " . $e->getMessage();
}
?>
