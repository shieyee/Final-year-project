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
 	$_image= $_POST['image'];

    $sqlinsert = "INSERT INTO `tbl_assets`(`user_id`, `product_name`, `product_desc`, `product_price`, `product_qty`, `product_type`) VALUES ('$userId','$productName','$productDesc','$productPrice','$productQty','$productType')";

	try {
		if ($conn->query($sqlinsert) === TRUE) {
			$decoded_string = base64_decode($_image);
			$filename = mysqli_insert_id($conn);
			$path = '../assets/assetsimages/'.$filename.'.png';
			file_put_contents($path, $decoded_string);
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