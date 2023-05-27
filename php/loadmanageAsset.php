<?php
error_reporting(0);
if (!isset($_GET['user_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_GET['user_id'];
include_once("dbconnect.php");
$sqlloadasset = "SELECT * FROM tbl_assets WHERE user_id = '$userid'ORDER BY product_date DESC";
$result = $conn->query($sqlloadasset);
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
    $response = array('status' => 'success', 'data' => $assetarray);
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