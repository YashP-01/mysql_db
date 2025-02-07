<?php
include '../connection.php';  // Make sure to include the database connection file

// Set content type for JSON response
header('Content-Type: application/json');

// Get the raw POST data
$rawData = file_get_contents("php://input");

// Decode the JSON data
$data = json_decode($rawData, true);

// Check if necessary data is provided (email is mandatory)
if (isset($data['user_email'])) {
    // Sanitize the input email value
    $userEmail = $connectNow->real_escape_string($data['user_email']);

    // SQL query to fetch user details from the user_info table based on user_email
    $sqlQuery = "SELECT id, name, email, phone, address, age FROM user_info WHERE email = ?";

    // Prepare the SQL query
    if ($stmt = $connectNow->prepare($sqlQuery)) {
        // Bind the parameters
        $stmt->bind_param("s", $userEmail);

        // Execute the statement
        if ($stmt->execute()) {
            // Get the result
            $resultOfQuery = $stmt->get_result();

            // Check if the user exists
            if ($resultOfQuery->num_rows > 0) {
                // User found, fetch the data
                $userRecord = array();
                while ($rowFound = $resultOfQuery->fetch_assoc()) {
                    $userRecord[] = $rowFound;
                }

                // Return the user data as a JSON response
                echo json_encode(
                    array(
                        "success" => true, 
                        "userData" => $userRecord[0],  // We return the first (and only) record
                        "message" => "User data fetched successfully"
                    )
                );
            } else {
                // User not found
                echo json_encode(array("success" => false, "error" => "User not found"));
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
    // Missing form data (user_email)
    echo json_encode(array("success" => false, "error" => "Missing user_email"));
}
?>
