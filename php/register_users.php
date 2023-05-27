<?php
if (!isset($_POST['register'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$username = $_POST['username'];
$email = $_POST['email'];
$contactno = $_POST['contactno'];
$password = sha1($_POST['password']);
$otp = rand(10000,99999);

$sqlregister = "INSERT INTO `tbl_users`(`user_username`, `user_email`, `user_contactno`, `user_password`,`otp`) VALUES ('$username','$email','$contactno','$password','$otp')";

try{
if ($conn->query($sqlregister) === TRUE) {
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