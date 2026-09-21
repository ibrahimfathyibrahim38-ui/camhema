<?php

# ip.php by Daxxtropezz - hardened version
# ALWAYS logs IP + device info first (never blocked by the geo API), geo lookup is optional
# Author   : Daxxtropezz
# Github   : https://github.com/Daxxtropezz
# Email    : miraflores.john@gmail.com
# Date     : 7-12-2024 (hardened 21-09-2026)

error_reporting(E_ERROR | E_PARSE);

function get_client_ip()
{
    $ipaddress = '';
    if (isset($_SERVER['HTTP_CLIENT_IP'])) {
        $ipaddress = $_SERVER['HTTP_CLIENT_IP'];
    } else if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $ipaddress = $_SERVER['HTTP_X_FORWARDED_FOR'];
    } else if (isset($_SERVER['HTTP_X_FORWARDED'])) {
        $ipaddress = $_SERVER['HTTP_X_FORWARDED'];
    } else if (isset($_SERVER['HTTP_FORWARDED_FOR'])) {
        $ipaddress = $_SERVER['HTTP_FORWARDED_FOR'];
    } else if (isset($_SERVER['HTTP_FORWARDED'])) {
        $ipaddress = $_SERVER['HTTP_FORWARDED'];
    } else if (isset($_SERVER['REMOTE_ADDR'])) {
        $ipaddress = $_SERVER['REMOTE_ADDR'];
    } else {
        $ipaddress = 'UNKNOWN';
    }

    return $ipaddress;
}
$user_agent = isset($_SERVER['HTTP_USER_AGENT']) ? $_SERVER['HTTP_USER_AGENT'] : 'Unknown';

function getOS()
{
    global $user_agent;
    $os_platform  = "Unknown OS Platform";
    $os_array     = array(
        '/windows nt 10/i'      =>  'Windows 10',
        '/windows nt 6.3/i'     =>  'Windows 8.1',
        '/windows nt 6.2/i'     =>  'Windows 8',
        '/windows nt 6.1/i'     =>  'Windows 7',
        '/windows nt 6.0/i'     =>  'Windows Vista',
        '/windows nt 5.2/i'     =>  'Windows Server 2003/XP x64',
        '/windows nt 5.1/i'     =>  'Windows XP',
        '/windows xp/i'         =>  'Windows XP',
        '/windows nt 5.0/i'     =>  'Windows 2000',
        '/windows me/i'         =>  'Windows ME',
        '/win98/i'              =>  'Windows 98',
        '/win95/i'              =>  'Windows 95',
        '/win16/i'              =>  'Windows 3.11',
        '/macintosh|mac os x/i' =>  'Mac OS X',
        '/mac_powerpc/i'        =>  'Mac OS 9',
        '/linux/i'              =>  'Linux',
        '/ubuntu/i'             =>  'Ubuntu',
        '/iphone/i'             =>  'iPhone',
        '/ipod/i'               =>  'iPod',
        '/ipad/i'               =>  'iPad',
        '/android/i'            =>  'Android',
        '/blackberry/i'         =>  'BlackBerry',
        '/webos/i'              =>  'Mobile'
    );

    foreach ($os_array as $regex => $value)
        if (preg_match($regex, $user_agent))
            $os_platform = $value;

    return $os_platform;
}

function getBrowser()
{
    global $user_agent;
    $browser        = "Unknown Browser";
    $browser_array = array(
        '/msie/i'      => 'Internet Explorer',
        '/firefox/i'   => 'Firefox',
        '/safari/i'    => 'Safari',
        '/chrome/i'    => 'Chrome',
        '/edge/i'      => 'Edge',
        '/opera/i'     => 'Opera',
        '/netscape/i'  => 'Netscape',
        '/maxthon/i'   => 'Maxthon',
        '/konqueror/i' => 'Konqueror',
        '/mobile/i'    => 'Handheld Browser'
    );

    foreach ($browser_array as $regex => $value)
        if (preg_match($regex, $user_agent))
            $browser = $value;

    return $browser;
}


$user_os        = getOS();
$user_browser   = getBrowser();

$PublicIP = get_client_ip();
if (strpos($PublicIP, ',') !== false) {
    $PublicIP = explode(",", $PublicIP)[0];
}
$PublicIP = trim($PublicIP);

$file       = 'ip.txt';
$ip         = "IP                   : " . $PublicIP;
$uaget      = "User Agent           : " . $user_agent;
$bsr        = "Browser              : " . $user_browser;
$uos        = "User OS              : " . $user_os;
$ust = explode(" ", $user_agent);
$ver = isset($ust[3]) ? str_replace(")", "", $ust[3]) : "?";
$version   = "Version              : " . $ver;

$fp = fopen($file, 'a');
if (!$fp) {
    exit();
}

// 1) ALWAYS write the essential info first - never wait for the geo API
fwrite($fp, $ip . "\n");
fwrite($fp, $uos . "\n");
fwrite($fp, $version . "\n");
fwrite($fp, $uaget . "\n");
fwrite($fp, $bsr . "\n");

// 2) Geo lookup (optional, short timeout; a failure never blocks the log above)
$details = false;
if ($PublicIP !== 'UNKNOWN' && $PublicIP !== '127.0.0.1' && $PublicIP !== '') {
    $ctx = stream_context_create(array('http' => array('timeout' => 6)));
    $raw = @file_get_contents("https://ipwhois.app/json/" . $PublicIP, false, $ctx);
    $details = json_decode($raw, true);
}

if (is_array($details) && isset($details['success'])) {
    if ($details['success'] == true) {
        $country    = isset($details['country'])    ? $details['country']    : '?';
        $city       = isset($details['city'])       ? $details['city']       : '?';
        $continent  = isset($details['continent'])  ? $details['continent']  : '?';
        $tp         = isset($details['type'])       ? $details['type']       : '?';
        $latitude   = isset($details['latitude'])   ? $details['latitude']   : '?';
        $longitude  = isset($details['longitude'])  ? $details['longitude']  : '?';
        $crn        = isset($details['currency'])   ? $details['currency']   : '?';
        fwrite($fp, "IP Type              : " . $tp . "\n");
        fwrite($fp, "Location             : " . $city . ", " . $country . ", " . $continent . "\n");
        fwrite($fp, "GeoLocation(lat, lon): " . $latitude . ", " . $longitude . "\n");
        fwrite($fp, "Currency             : " . $crn . "\n");
    } else {
        fwrite($fp, "Status               : geo lookup unavailable\n");
    }
} else {
    fwrite($fp, "Status               : geo lookup failed (IP/device info saved)\n");
}
fclose($fp);