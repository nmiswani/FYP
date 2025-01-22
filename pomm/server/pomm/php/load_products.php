<?php
//error_reporting(0);
include_once("dbconnect.php");
$title = $_GET['title'];

//step 1
$results_per_page = 10;
//step 2
if (isset($_GET['pageno'])){
	$pageno = (int)$_GET['pageno'];
}else{
	$pageno = 1;
}
//step 3
$page_first_result = ($pageno - 1) * $results_per_page;

//step 4
$sqlloadproducts = "SELECT * FROM `tbl_products` WHERE `product_title` LIKE '%$title%'";
$result = $conn->query($sqlloadproducts);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);

//step 5
$sqlloadproducts = $sqlloadproducts . " LIMIT $page_first_result , $results_per_page";

$result = $conn->query($sqlloadproducts);
if ($result->num_rows > 0) {
    $productlist["products"] = array();
    while ($row = $result->fetch_assoc()) {
        $product = array();
        $product['product_id'] = $row['product_id'];
        $product['product_title'] = $row['product_title'];
        $product['product_desc'] = $row['product_desc'];
        $product['product_price'] = $row['product_price'];
        $product['product_qty'] = $row['product_qty'];
        array_push( $productlist["products"],$product);
    }
    $response = array('status' => 'success', 'data' => $productlist, 'numofpage'=>$number_of_page,'numberofresult'=>$number_of_result);
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