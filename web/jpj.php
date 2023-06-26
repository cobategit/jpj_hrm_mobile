<!DOCTYPE html>
<html>

<?php
  function getIPAddress() {  
    //whether ip is from the share internet  
     if(!empty($_SERVER['HTTP_CLIENT_IP'])) {  
                $ip = $_SERVER['HTTP_CLIENT_IP'];  
        }  
    //whether ip is from the proxy  
    elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {  
                $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];  
     }  
//whether ip is from the remote address  
    else{  
             $ip = $_SERVER['REMOTE_ADDR'];  
     }  
     return $ip;  
}  
$ip = getIPAddress();
$cip = substr($ip, 0, 8);

if ($ip=='10.15.14.1') {
  Header("Location: http://10.15.14.243/non/index.html");
} else {
  if ($cip=='10.15.14') {
  Header("Location: index.html?ip-local=".$ip);
  } else {
  Header("Location: http://10.15.14.243/non/index.html");
  }
}
?>

</html>