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

$sqllogin = "SELECT * FROM `tbl_customers` WHERE `customer_email` = '$email' AND `customer_password` = '$password'";
$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    $userlist = array();
    while ($row = $result->fetch_assoc()) {
        $userlist['customerid'] = $row['customer_id'];
        $userlist['customeremail'] = $row['customer_email'];
        $userlist['customername'] = $row['customer_name'];
        $userlist['customerphone'] = $row['customer_phone'];
        $userlist['customerpassword'] = $_POST['password'];
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