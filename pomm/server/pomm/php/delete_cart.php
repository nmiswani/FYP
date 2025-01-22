<?php
//error_reporting(0);  // Consider removing this line in a production environment to enable error reporting

include_once("dbconnect.php");

// Check for required POST parameter
if (!isset($_POST['cart_id'])) {
    $response = array('status' => 'failed', 'data' => 'Missing cart_id parameter');
    sendJsonResponse($response);
    die();
}

$cart_id = $_POST['cart_id'];

// Prepare SQL statement with prepared statement for security
$sqldelete = "DELETE FROM tbl_carts WHERE cart_id = ?";
$stmt = $conn->prepare($sqldelete);
$stmt->bind_param("i", $cart_id);

// Execute the query
if ($stmt->execute()) {
    $response = array('status' => 'success', 'data' => 'Cart item deleted successfully');
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => 'Failed to delete cart item');
    sendJsonResponse($response);
}

$stmt->close();  // Close the prepared statement
$conn->close();  // Close the database connection

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>