<div class="layui-row">
    <div class="layui-col-xs7 layui-col-md-offset3" align="center">
        <div class="card" style="margin-bottom: 30px;">
            <h1 style="font-size: 28px; font-weight: 500; color: var(--apple-text); margin: 20px 0;">人脸注册</h1>
            
            <div style="margin: 30px auto; max-width: 500px;">
                <div style="display: flex; align-items: center; margin-bottom: 20px;">
                    <label style="font-size: 16px; color: var(--apple-gray); width: 80px; text-align: right; margin-right: 15px;">姓名：</label>
                    <input class="apple-input" placeholder="在此输入姓名" type="text" name="userName" id="userName">
                </div>

                <div id="mainDiv" style="min-height: 300px;"></div>

                <div style="display: flex; justify-content: center; gap: 20px; margin-top: 30px;">
                    <button class="apple-button" onclick="getMedia()">摄像头注册</button>
                    <button class="apple-button" onclick="imageRecog()">照片注册</button>
                </div>
                <div style="text-align: center; margin-top: 20px;">
                    <button class="apple-button primary" onclick="takePhoto()" style="width: 120px;">提交</button>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    body {
        font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
        background-color: var(--apple-bg);
        color: var(--apple-text);
        margin: 0;
        padding: 0;
        background-image: url('../static/images/bg.jpg');
        background-size: cover;
        background-position: center;
        background-attachment: fixed;
        height: 100vh;
        overflow: hidden;
    }
    .container {
        height: 100vh;
        display: flex;
        align-items: flex-start; 
        justify-content: center;
        padding-top: 20px;
    
    }
    .card {
        background: rgba(255, 255, 255, 0.5);
        backdrop-filter: blur(10px);
        border-radius: 10px;
        box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
        padding: 24px;
        margin: 0px;
        max-width: 800px;
        max-height: 90vh;
        overflow-y: auto;
    }
    .apple-input {
        flex: 1;
        height: 44px;
        padding: 0 15px;
        font-size: 16px;
        border: 1px solid rgba(0, 0, 0, 0.1);
        border-radius: 8px;
        background-color: white;
        transition: border 0.2s ease;
    }
    .apple-input:focus {
        outline: none;
        border-color: var(--apple-blue);
    }
    .apple-button {
        height: 40px;
        padding: 0 24px;
        font-size: 14px;
        font-weight: 500;
        color: var(--apple-blue);
        background-color: white;
        border: 1px solid rgba(0, 113, 227, 0.3);
        border-radius: 20px;
        cursor: pointer;
        transition: all 0.2s ease;
    }
    .apple-button:hover {
        background-color: rgba(0, 113, 227, 0.05);
    }
    .apple-button.primary {
        color: white;
        background-color: var(--apple-blue);
        border-color: var(--apple-blue);
    }
    .apple-button.primary:hover {
        background-color:rgb(62, 91, 150);
    }
</style>

<script>


    function getMedia() {
        $("#mainDiv").empty();
        let videoComp = " <video id='video' width='300px' height='300px' autoplay='autoplay' style='margin-top: 20px; border-radius: 8px;'></video><canvas id='canvas' width='400px' height='400px' style='display: none'></canvas>";
        $("#mainDiv").append(videoComp);

        let constraints = {
            video: {width: 500, height: 500},
            audio: true
        };
        //获得video摄像头区域
        let video = document.getElementById("video");
        //这里介绍新的方法，返回一个 Promise对象
        // 这个Promise对象返回成功后的回调函数带一个 MediaStream 对象作为其参数
        // then()是Promise对象里的方法
        // then()方法是异步执行，当then()前的方法执行完后再执行then()内部的程序
        // 避免数据没有获取到
        let promise = navigator.mediaDevices.getUserMedia(constraints);
        promise.then(function (MediaStream) {
            video.srcObject = MediaStream;
            video.play();
        });

        // var t1 = window.setTimeout(function() {
        //     takePhoto();
        // },2000)
    }
    //拍照事件
    function takePhoto() {
        let mainComp = $("#mainDiv");
        if(mainComp.has('video').length)
        {
            let userNameInput = $("#userName").val();
            if(userNameInput == "")
            {
                alert("姓名不能为空!");
                return false;
            }
            //获得Canvas对象
            let video = document.getElementById("video");
            let canvas = document.getElementById("canvas");
            let ctx = canvas.getContext('2d');
            ctx.drawImage(video, 0, 0, 500, 500);
            var formData = new FormData();
            var base64File = canvas.toDataURL();
            var userName = $("#userName").val();
            formData.append("file", base64File);
            formData.append("name", userName);
            formData.append("groupId", "101");
            $.ajax({
                type: "post",
                url: "/faceAdd",
                data: formData,
                contentType: false,
                processData: false,
                async: false,
                success: function (text) {
                    var res = JSON.stringify(text)
                    if (text.code == 0) {
                        alert("注册成功")
                    } else {
                        alert(text.message)
                    }
                },
                error: function (error) {
                    alert(JSON.stringify(error))
                }
            });
        }
        else{
            var formData = new FormData();
            let userName = $("#userName").val();
            formData.append("groupId", "101");
            var file = $("#file0")[0].files[0];
            var reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = function () {
            var base64 = reader.result;
            formData.append("file", base64);
            formData.append("name",userName);
                $.ajax({
                    type: "post",
                    url: "/faceAdd",
                    data: formData,
                    contentType: false,
                    processData: false,
                    async: false,
                    success: function (text) {
                        var res = JSON.stringify(text)
                        if (text.code == 0) {
                            alert("注册成功")
                        } else {
                            alert(text.message)
                        }
                    },
                    error: function (error) {
                        alert(JSON.stringify(error))
                    }
                });
                location.reload();
            }
        }

    }

    function imageRecog() {
        let imageInput = " <h2 style='font-size: 16px; margin-bottom: 15px;'>点击图片区域上传文件</h2><input style='display: none' type='file' name='file0' id='file0' multiple='multiple' /><br><img src='images/shibie.jpg' id='img0' onclick='toChooseFile()' style='width: 400px; height: 300px; border-radius: 8px; object-fit: cover;'>";
        $("#mainDiv").empty();
        $("#mainDiv").append(imageInput);
    }

    function toChooseFile()
    {
        $("#file0").trigger('click');
    }
    $(document).on("change","#file0",function(){
        var objUrl = getObjectURL(this.files[0]) ;//获取文件信息
        console.log("objUrl = "+objUrl);
        if (objUrl) {
            $("#img0").attr("src", objUrl);
        }
    });

    function getObjectURL(file) {
        var url = null;
        if (window.createObjectURL!=undefined) {
            url = window.createObjectURL(file) ;
        } else if (window.URL!=undefined) { // mozilla(firefox)
            url = window.URL.createObjectURL(file) ;
        } else if (window.webkitURL!=undefined) { // webkit or chrome
            url = window.webkitURL.createObjectURL(file) ;
        }
        return url ;
    }


</script>

<body>
<div class="container">
    <div class="layui-row">
        <div class="layui-col-xs7 layui-col-md-offset3" align="center">
            <div class="card" style="margin-bottom: 30px;">
                <h1 style="font-size: 28px; font-weight: 500; color: var(--apple-text); margin: 20px 0;">人脸注册</h1>
                
                <div style="margin: 30px auto; max-width: 500px;">
                    <div style="display: flex; align-items: center; margin-bottom: 20px;">
                        <label style="font-size: 16px; color: var(--apple-gray); width: 80px; text-align: right; margin-right: 15px;">姓名：</label>
                        <input class="apple-input" placeholder="在此输入姓名" type="text" name="userName" id="userName">
                    </div>
    
                    <div id="mainDiv" style="min-height: 300px;"></div>
    
                    <div style="display: flex; justify-content: center; gap: 20px; margin-top: 30px;">
                        <button class="apple-button" onclick="getMedia()">摄像头注册</button>
                        <button class="apple-button" onclick="imageRecog()">照片注册</button>
                    </div>
                    <div style="text-align: center; margin-top: 20px;">
                        <button class="apple-button primary" onclick="takePhoto()" style="width: 120px;">提交</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
