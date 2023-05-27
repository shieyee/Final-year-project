<?php
error_reporting(0);
if (!isset($_GET['user_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_GET['user_id'];
include_once("dbconnect.php");
$sqlloadtender = "SELECT * FROM tbl_tender WHERE user_id = '$userid'AND (tender_status = 'Open' OR tender_status = 'Close') ORDER BY product_date DESC";
$result = $conn->query($sqlloadtender);
if ($result->num_rows > 0) {
    $tenderarray["tender"] = array();
    while ($row = $result->fetch_assoc()) {
        $tenderlist = array();
        $tenderlist['product_id'] = $row['product_id'];
        $tenderlist['product_name'] = $row['product_name'];
        $tenderlist['product_desc'] = $row['product_desc'];
        $tenderlist['product_price'] = $row['product_price'];
        $tenderlist['product_qty'] = $row['product_qty'];
        $tenderlist['product_type'] = $row['product_type'];
        $tenderlist['tender_id'] = $row['tender_id'];
        $tenderlist['tender_status'] = $row['tender_status'];
        $tenderlist['tender_pending'] = $row['tender_pending'];
        array_push($tenderarray["tender"],$tenderlist);
    }
    $response = array('status' => 'success', 'data' => $tenderarray);
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