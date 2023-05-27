<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}

    include_once("dbconnect.php");
    $userId= $_POST['user_id'];
  	$productName= ucwords(addslashes($_POST['product_name']));
	$productDesc= ucwords(addslashes($_POST['product_desc']));
	$productPrice= $_POST['product_price'];
  	$productQty= $_POST['product_qty'];
  	$productType= $_POST['product_type'];
    $tenderId= $_POST['tender_id'];
	$productId= $_POST['product_id'];

    $sqlinsert = "INSERT INTO `tbl_tender`(`user_id`, `product_name`, `product_desc`, `product_price`, `product_qty`, `product_type`, `tender_id`,`product_id`) VALUES ('$userId','$productName','$productDesc','$productPrice','$productQty','$productType', '$tenderId','$productId')";

	try {
		if ($conn->query($sqlinsert) === TRUE) {
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
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}

?>