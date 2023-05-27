<?php
error_reporting(0);
if (!isset($_GET['user_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_GET['user_id'];
include_once("dbconnect.php");
$sqlloadpendingtender = "SELECT * FROM tbl_tender WHERE user_id = '$userid'AND (tender_pending = 'Pending' OR tender_pending = 'Approve' OR tender_pending = 'Reject')";
$result = $conn->query($sqlloadpendingtender);
if ($result->num_rows > 0) {
    $pendingtenderarray["pendingtender"] = array();
    while ($row = $result->fetch_assoc()) {
        $pendingtenderlist = array();
        $pendingtenderlist['product_id'] = $row['product_id'];
        $pendingtenderlist['product_name'] = $row['product_name'];
        $pendingtenderlist['product_desc'] = $row['product_desc'];
        $pendingtenderlist['product_price'] = $row['product_price'];
        $pendingtenderlist['product_qty'] = $row['product_qty'];
        $pendingtenderlist['product_type'] = $row['product_type'];
        $pendingtenderlist['tender_id'] = $row['tender_id'];
        $pendingtenderlist['tender_status'] = $row['tender_status'];
        $pendingtenderlist['tender_pending'] = $row['tender_pending'];
        array_push($pendingtenderarray["pendingtender"],$pendingtenderlist);
    }
    $response = array('status' => 'success', 'data' => $pendingtenderarray);
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