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

$sqllogin = "SELECT * FROM `tbl_admins` WHERE `admin_email` = '$email' AND `admin_password` = '$password'";
$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    $userlist = array();
    while ($row = $result->fetch_assoc()) {
        $userlist['adminid'] = $row['admin_id'];
        $userlist['adminemail'] = $row['admin_email'];
        $userlist['adminpassword'] = $_POST['password'];
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