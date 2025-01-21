<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

if (isset($_POST['image'])) {
    $image = $_POST['image'];
    $customerid = $_POST['customerid'];
    
    $decoded_string = base64_decode($image);
	$path = '../assets/profileimages/'.$customerid.'.jpg';
	file_put_contents($path, $decoded_string);
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
    // $decoded_string = base64_decode($encoded_string);
    // $path = '../assets/profileimages/' . $userid . '.png';
    // if (file_put_contents($path, $decoded_string)){
    //     $response = array('status' => 'success', 'data' => null);
    //     sendJsonResponse($response);
    // }else{
    //     $response = array('status' => 'failed', 'data' => null);
    //     sendJsonResponse($response);
    // }
    die();
}

if (isset($_POST['newname'])) {
    $name = $_POST['newname'];
    $customerid = $_POST['customerid'];
    $sqlupdate = "UPDATE tbl_customers SET customer_name ='$name' WHERE customer_id = '$customerid'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_POST['newemail'])) {
    $email = $_POST['newemail'];
    $customerid = $_POST['customerid'];
    $sqlupdate = "UPDATE tbl_customers SET customer_email ='$email' WHERE customer_id = '$customerid'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_POST['newphone'])) {
    $phone = $_POST['newphone'];
    $customerid = $_POST['customerid'];
    $sqlupdate = "UPDATE tbl_customers SET customer_phone ='$phone' WHERE customer_id = '$customerid'";
    databaseUpdate($sqlupdate);
    die();
}

if (isset($_POST['oldpass'])) {
    $oldpass = sha1($_POST['oldpass']);
    $newpass = sha1($_POST['newpass']);
    $customerid = $_POST['customerid'];
    include_once("dbconnect.php");
    $sqllogin = "SELECT * FROM tbl_customers WHERE customer_id = '$customerid' AND customer_password = '$oldpass'";
    $result = $conn->query($sqllogin);
    if ($result->num_rows > 0) {
    	$sqlupdate = "UPDATE tbl_customers SET customer_password ='$newpass' WHERE customer_id = '$customerid'";
            if ($conn->query($sqlupdate) === TRUE) {
                $response = array('status' => 'success', 'data' => null);
                sendJsonResponse($response);
            } else {
                $response = array('status' => 'failed', 'data' => null);
                sendJsonResponse($response);
            }
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function databaseUpdate($sql){
    include_once("dbconnect.php");
    if ($conn->query($sql) === TRUE) {
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>