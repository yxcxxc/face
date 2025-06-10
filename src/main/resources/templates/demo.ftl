<!DOCTYPE html >
<html>
<head>
    <meta charset="utf-8">
    <title>Re-Yxc</title>

    <link rel="stylesheet" href="../static/layui/css/layui.css">

    <script src="../static/jquery/jquery-3.3.1.min.js"></script>
    <script src="../static/layui/layui.js"></script>

</head>
<body style="background-image: url('../static/images/bg.jpg'); background-size: cover; background-position: center; background-attachment: fixed;">
<div class="layui-tab">
    <ul class="layui-tab-title" style="margin: 0; padding: 0 20px;  color: white;">
        <li>人脸注册</li>
        <li class="layui-this">人脸登录</li>
    </ul>
    <div style="position: absolute; left: 0; margin-left: 0; padding: 10px;">
        <style type="text/css">
            table.hovertable {
                font-family: verdana,arial,sans-serif;
                font-size:11px;
                color:rgb(0, 0, 0);
                border-collapse: collapse;
                border: none;
                background: none;
            }
            table.hovertable th {
                background: none;
                padding: 8px;
                border: none;
                color:rgb(0, 0, 0);
            }
            table.hovertable tr, table.hovertable td {
                background: none;
                border: none;
                padding: 8px;
            }
        </style>

    <table class="hovertable" id="userTable">
            <tr id="firstTr">
                <th>用户姓名</th><th>注册时间</th>
            </tr>
        </table>
    </div>
    <div class="layui-tab-content" style="margin-left: 0;">
        <div class="layui-tab-item"><#include "face_registration.ftl"></div>
        <div class="layui-tab-item layui-show"><#include "face_search.ftl"></div>
    </div>
</div>

<script>
    //注意：选项卡 依赖 element 模块，否则无法进行功能性操作
    layui.use('element', function(){
        var element = layui.element;

    });
    $(function () {
       f();
    })
    function f() {
        $.ajax({
            type:"get",
            url:"/userInfo",
            success:function (userList) {
                if(userList.length == 0)
                {
                    let addElement = "<h2>暂无用户</h2>";
                    $("#userTable").append(addElement);
                }
                for (let i = 0; i < userList.length; i++) {
                    let userName = userList[i].name;
                    let createTime = userList[i].createTime.toString().slice(0,10);
                    let addElement = "<tr><td>"+userName+"</td><td>"+createTime+"</td></tr>"; // 去掉悬停效果
                    $("#userTable").append(addElement);
                }
            },
            dataType:"json",
            error: function (error) {
                alert(JSON.stringify(error))
            }
        });
    }

</script>
</html>