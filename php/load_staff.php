<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$staffid = $_POST['staffid'];
$sqlloadstaff = "SELECT * FROM tbl_users WHERE user_id = '$staffid'";
$result = $conn->query($sqlloadstaff);

if ($result->num_rows > 0) {
	while ($row = $result->fetch_assoc()) {
	$userlist = array();
	$userlist['id'] = $row['user_id'];
    $userlist['email'] = $row['user_email'];
    $userlist['username'] = $row['user_username'];
    $userlist['contactno'] = $row['user_contactno'];
    $userlist['datereg'] = $row['user_datereg'];
    $response = array('status' => 'success', 'data' => $userlist);
    sendJsonResponse($response);
	}

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