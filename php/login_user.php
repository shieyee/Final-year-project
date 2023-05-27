<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("dbconnect.php");
$username = $_POST['username'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM tbl_users WHERE user_username = '$username' AND user_password = '$password'";
$result = $conn->query($sqllogin);

if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
		$userlist = array();
		$userlist['id'] = $row['user_id'];
        $userlist['email'] = $row['user_email'];
		$userlist['username'] = $row['user_username'];
        $userlist['contactno'] = $row['user_contactno'];
        $userlist['regdate'] = $row['user_datereg'];
        $userlist['otp'] = $row['otp'];
        // $userlist['credit'] = $row['user_credit'];
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