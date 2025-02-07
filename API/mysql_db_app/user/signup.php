<?php
include '../connection.php';

// Get the raw POST data
header('Content-Type: application/json');
$rawData = file_get_contents("php://input");

// Debugging: Check the raw POST data
// echo "rawData : " . $rawData;

// Decode the JSON data
$data = json_decode($rawData, true);

// Debugging: Check if data is being received
var_dump($data); // Check if data is being received

// Check if necessary data is provided
if (isset($data['user_name']) && isset($data['user_email']) && isset($data['user_password'])) {
    // Sanitize input values
    $userName = $connectNow->real_escape_string($data['user_name']);
    $userEmail = $connectNow->real_escape_string($data['user_email']);
    $userPassword = md5($data['user_password']);
    // $userPassword = password_hash($data['user_password'], PASSWORD_DEFAULT);
     

    // Prepare the SQL query with placeholders
    $sqlQuery = "INSERT INTO users_table (user_name, user_email, user_password) VALUES (?, ?, ?)";

    // Prepare the statement
    if ($stmt = $connectNow->prepare($sqlQuery)) {
        // Bind the parameters
        $stmt->bind_param("sss", $userName, $userEmail, $userPassword);
        
        // Execute the statement
        if ($stmt->execute()) {
            echo json_encode(array("success" => true, "message" => "Signup successful"));
        } else {
            echo json_encode(array("success" => false, "error" => "Database error: " . $stmt->error));
        }

        // Close the statement
        $stmt->close();
    } else {
        echo json_encode(array("success" => false, "error" => "Failed to prepare SQL query"));
    }
} else {
    // Ensure the response is properly wrapped in an array when there's an error
    echo json_encode(array("success" => false, "error" => "Missing form data"));
}
?>
