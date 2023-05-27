<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$productId= $_POST['product_id'];
$userId= $_POST['user_id'];
$productName= ucwords(addslashes($_POST['product_name']));
$productDesc= ucfirst(addslashes($_POST['product_desc']));
$productPrice= $_POST['product_price'];
$productQty= $_POST['product_qty'];
$productType= $_POST['product_type'];

$sqlupdate = "UPDATE `tbl_assets` SET `product_name`='$productName',`product_desc`='$productDesc',`product_price`='$productPrice',`product_qty`='$productQty',`product_type`='$productType' WHERE `product_id`='$productId'AND `user_id`='$userId'";

try{
    if($conn->query($sqlupdate) === TRUE){
        $response = array('status' => 'success', 'data' => null);
        sendJsonResponse($response);
    }else{
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}
catch (Exception $e){
    $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
}
$conn->close();

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>