<?php
//error_reporting(0);
if (!isset($_POST['email']) && !isset($_POST['password'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqllogin = "SELECT * FROM `tbl_clerks` WHERE `clerk_email` = '$email' AND `clerk_password` = '$password'";
$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    $userlist = array();
    while ($row = $result->fetch_assoc()) {
        $userlist['clerkid'] = $row['clerk_id'];
        $userlist['clerkemail'] = $row['clerk_email'];
        $userlist['clerkpassword'] = $_POST['password'];
    }
    $response = array('status' => 'success', 'data' => $userlist);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>