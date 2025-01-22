<?php
//error_reporting(0);
include_once("dbconnect.php");
$customerid = $_GET['customerid'];
$sqlloadcart = "SELECT * FROM `tbl_carts` INNER JOIN tbl_products ON tbl_carts.product_id = tbl_products.product_id WHERE tbl_carts.buyer_id = '$customerid' AND tbl_carts.cart_status = 'New'";
$result = $conn->query($sqlloadcart);

if ($result->num_rows > 0) {
    $cartlist["carts"] = array();
    while ($row = $result->fetch_assoc()) {
        $cart = array();
        $cart['cart_id'] = $row['cart_id'];
        $cart['product_id'] = $row['product_id'];
        $cart['cart_qty'] = $row['cart_qty'];
        $cart['cart_status'] = $row['cart_status'];
        $cart['cart_date'] = $row['cart_date'];
        $cart['product_title'] = $row['product_title'];
        $cart['product_price'] = $row['product_price'];
        $cart['product_qty'] = $row['product_qty'];
        array_push( $cartlist["carts"],$cart);
    }
    $response = array('status' => 'success', 'data' => $cartlist);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>