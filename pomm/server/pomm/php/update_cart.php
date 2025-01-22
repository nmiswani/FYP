<?php
//error_reporting(0);

if (!isset($_POST['cart_id']) || !isset($_POST['cart_qty'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$cartId = $_POST['cart_id'];
$newQuantity = $_POST['cart_qty'];

$sqlupdate = "UPDATE `tbl_carts` SET `cart_qty` = '$newQuantity' WHERE `cart_id` = '$cartId'";

if ($conn->query($sqlupdate) === TRUE) {
    $response = array('status' => 'success', 'data' => $sqlupdate);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => $sqlupdate);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>