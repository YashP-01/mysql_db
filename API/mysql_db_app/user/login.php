<?php
include '../connection.php';

// Get the raw POST data
header('Content-Type: application/json');
$rawData = file_get_contents("php://input");

// Decode the JSON data
$data = json_decode($rawData, true);

// Check if necessary data is provided
if (isset($data['user_email']) && isset($data['user_password'])) {
    // Sanitize input values
    $userEmail = $connectNow->real_escape_string($data['user_email']);
    $userPassword = $connectNow->real_escape_string($data['user_password']);

    // Prepare the SQL query with placeholders
    $sqlQuery = "SELECT * FROM users_table WHERE user_email = ? AND user_password = ?";

    // Prepare the statement
    if ($stmt = $connectNow->prepare($sqlQuery)) {
        // Bind the parameters
        $stmt->bind_param("ss", $userEmail, $userPassword);

        // Execute the statement
        if ($stmt->execute()) {
            // Get the result
            $resultOfQuery = $stmt->get_result();


            // Check if the user exists
            if ($resultOfQuery->num_rows > 0) {
            
                // User exists, return the user data
                $userRecord = array();
                while($rowFound = $resultOfQuery->fetch_assoc())
                {
                    $userRecord[] = $rowFound;
                }

                // User exists
                echo json_encode(
                    array(
                        "success" => true, 
                        "userData"=>$userRecord[0], 
                        "message" => "Email exists in database"
                    ));
            } else {
                // User not found
                echo json_encode(array("success" => false, "error" => "Email does not exist in database"));
            }

        } else {
            // Database error
            echo json_encode(array("success" => false, "error" => "Database error: " . $stmt->error));
        }

        // Close the statement
        $stmt->close();
    } else {
        // Failed to prepare SQL query
        echo json_encode(array("success" => false, "error" => "Failed to prepare SQL query"));
    }
} else {
    // Missing form data
    echo json_encode(array("success" => false, "error" => "Missing form data"));
}