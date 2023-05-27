<?php
error_reporting(0);
if (!isset($_GET['user_id'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

$userid = $_GET['user_id'];
include_once("dbconnect.php");
$sqlloadopentender = "SELECT * FROM tbl_tender WHERE user_id = '$userid'AND (tender_status = 'Open')";
$result = $conn->query($sqlloadopentender);
if ($result->num_rows > 0) {
    $opentenderarray["opentender"] = array();
    while ($row = $result->fetch_assoc()) {
        $opentenderlist = array();
        $opentenderlist['product_id'] = $row['product_id'];
        $opentenderlist['product_name'] = $row['product_name'];
        $opentenderlist['product_desc'] = $row['product_desc'];
        $opentenderlist['product_price'] = $row['product_price'];
        $opentenderlist['product_qty'] = $row['product_qty'];
        $opentenderlist['product_type'] = $row['product_type'];
        $opentenderlist['tender_id'] = $row['tender_id'];
        $opentenderlist['tender_status'] = $row['tender_status'];
        array_push($opentenderarray["opentender"],$opentenderlist);
    }
    $response = array('status' => 'success', 'data' => $opentenderarray);
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