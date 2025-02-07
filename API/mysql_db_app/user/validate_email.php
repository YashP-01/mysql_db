<?php

include '../connection.php';

// Get the raw POST data
$data = json_decode(file_get_contents('php://input'), true);

// Check if 'user_email' is set and not empty
if (isset($data['user_email']) && !empty($data['user_email'])) {
    // Sanitize the email
    $userEmail = filter_var($data['user_email'], FILTER_SANITIZE_EMAIL);

    // Validate the email format
    if (filter_var($userEmail, FILTER_VALIDATE_EMAIL)) {
        // Prepare the SQL query using prepared statements
        $sqlQuery = "SELECT * FROM users_table WHERE user_email = ?";

        // Prepare the statement
        if ($stmt = $connectNow->prepare($sqlQuery)) {
            // Bind the parameter to the prepared statement
            $stmt->bind_param("s", $userEmail);

            // Execute the statement
            $stmt->execute();

            // Get the result
            $resultOfQuery = $stmt->get_result();

            // Check if any user with the provided email exists
            if ($resultOfQuery->num_rows > 0) {
                echo json_encode(array("emailFound" => true));
            } else {
                echo json_encode(array("emailFound" => false));
            }

            // Close the prepared statement
            $stmt->close();
        } else {
            echo json_encode(array("emailFound" => false, "error" => "Failed to prepare the SQL query."));
        }
    } else {
        echo json_encode(array("emailFound" => false, "error" => "Invalid email format."));
    }
} else {
    // Handle missing or empty 'user_email' field in POST
    echo json_encode(array("emailFound" => false, "error" => "Missing or empty 'user_email'"));
}
?>








<!-- <?php

// include '../connection.php';

// // Check if 'user_email' is set in the POST request
// if (isset($_POST['user_email']) && !empty($_POST['user_email'])) {
//     // Retrieve the email from POST
//     $userEmail = $_POST['user_email'];

//     // Prepare the SQL query
//     $sqlQuery = "SELECT * FROM users_table WHERE user_email='$userEmail'";

//     // Execute the query
//     $resultOfQuery = $connectNow->query($sqlQuery);

//     // Check if any user with the provided email exists
//     if ($resultOfQuery->num_rows > 0) {
//         echo json_encode(array("emailFound" => true));
//     } else {
//         echo json_encode(array("emailFound" => false));
//     }
// } else {
//     // Handle missing or empty 'user_email' field in POST
//     echo json_encode(array("success" => false, "error" => "Missing or empty 'user_email'"));
// }
?> -->
