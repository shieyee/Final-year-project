<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$productId = $_POST['product_id'];
$sqldelete = "DELETE FROM `tbl_assets` WHERE product_id ='$productId'";

try{
	if ($conn->query($sqldelete) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
		   sendJsonResponse($response);
	}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
	}
}
catch(Exception $e) {
 $response = array('status' => 'failed', 'data' => null);
       sendJsonResponse($response);
}
$conn->close();

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>