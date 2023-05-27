<?php
error_reporting(0);
include_once("dbconnect.php");
$search  = $_GET["search"];
$results_per_page = 4;
$pageno = (int)$_GET['pageno'];
$page_first_result = ($pageno - 1) * $results_per_page;

if ($search =="all"){
	$sqlloadsearchAsset = "SELECT * FROM tbl_assets ORDER BY product_date DESC";
}else{
$sqlloadsearchAsset = "SELECT * FROM tbl_assets WHERE product_id LIKE '$search' ORDER BY product_date DESC";
}

$result = $conn->query($sqlloadsearchAsset);
	$number_of_result = $result->num_rows;
	$number_of_page = ceil($number_of_result / $results_per_page);
	$sqlloadsearchAsset = $sqlloadsearchAsset . " LIMIT $page_first_result , $results_per_page";
	$result = $conn->query($sqlloadsearchAsset);

    if ($result->num_rows > 0) {
		$assetarray["asset"] = array();
		while ($row = $result->fetch_assoc()) {
			$malist = array();
		$malist['product_id'] = $row['product_id'];
        $malist['product_name'] = $row['product_name'];
        $malist['product_desc'] = $row['product_desc'];
        $malist['product_price'] = $row['product_price'];
        $malist['product_qty'] = $row['product_qty'];
        $malist['product_type'] = $row['product_type'];
        $malist['product_date'] = $row['product_date'];
			array_push($assetarray["asset"],$malist);
		}
        $response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $assetarray);
        sendJsonResponse($response);
		}else{
        $response = array('status' => 'failed', 'numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
        sendJsonResponse($response);
        }
    
        function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}