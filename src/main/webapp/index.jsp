<%--
  Created by IntelliJ IDEA.
  User: xiaowu
  Date: 2018/7/18
  Time: 12:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page isELIgnored="false" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>员工列表</title>
    <%--设置当前项目路径--%>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
        System.out.println(pageContext.getAttribute("APP_PATH") + "=====");
    %>
    <%--
    web路径：
        不以/开始的相对路径，找资源，以当前资源的路径为基准，经常容易出问题。
以/开始的相对路径，找资源，以服务器的路径为标准(http://localhost:3306)；需要加上项目名
		http://localhost:3306/crud(项目路径)
    --%>
    <script src="${APP_PATH}/static/js/jquery-3.3.1.min.js" type="text/javascript"></script>
    <link rel="stylesheet" href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css">
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js" type="text/javascript"></script>
    <style type="text/css">
        #page_nav_area li{
            cursor: pointer;
        }
    </style>
</head>
<body>
<%----------------------------------员工修改的模态框---------------------%>
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >员工修改</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">

                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                           <p class="form-control-static" id="empName_update_static"></p>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email_update_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>

                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--部门提交部门id即可--%>
                            <select class="form-control" name="dId" id="dept_update_select"></select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">Save</button>
            </div>
        </div>
    </div>
</div>
<%---------------------------员工新增的模态框------------------------------%>
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">员工添加</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">

                    <div class="form-group">
                        <label for="empName_add_input" class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="email_add_input" class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@atguigu.com">
                            <span class="help-block"></span>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>

                        </div>
                    </div>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%--部门提交部门id即可--%>
                            <select class="form-control" name="dId" id="dept_add_select"></select>
                        </div>
                    </div>

                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">Save</button>
            </div>
        </div>
    </div>
</div>

<%-------------------------------------搭建显示页面----------------------------------%>
<div class="container">
    <%--标题--%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%--按钮--%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <%--显示表格数据--%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%--显示分页信息--%>
    <div class="row">
        <%--分页信息--%>
        <div class="col-md-6" id="page_info_area"></div>
        <%--=================分页条=====================--%>
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>
<script type="text/javascript">

    // 总记录数
    var totalRecord;

    // 1.页面加载完成以后，直接去发送一个ajax请求，得到分页数据
    $(function () {
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url: "${APP_PATH}/emps",
            data: "pn="+pn,
            type: "get",
            success: function (result) {
                // console.log(result);
                // 1.解析json显示员工数据
                build_emps_table(result);
                // 2.解析json显示分页信息
                build_page_info(result);
                // 2.解析json显示分页条
                build_page_nav(result);
            }
        });
    }

    // 1.解析json显示员工数据
    function build_emps_table(result) {
        $("#emps_table tbody").empty();
        var emps = result.extend.pageInfo.list;
        $.each(emps, function (index, item) {
            // alert(item.empName);
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender == 'M'?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);
            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("编辑");
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm del_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
            // append()方法执行完后还是返回原来的元素
            $("<tr></tr>").append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");

        });
    }



    // 2.解析json显示分页信息
    function build_page_info(result) {
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+result.extend.pageInfo.pageNum+"页，总"+result.extend.pageInfo.pages+"页，总"+result.extend.pageInfo.total+"条记录");
        totalRecord = result.extend.pageInfo.total;
    }

    // 3.解析json显示分页条,添加点击事件
    function build_page_nav(result) {
        $("#page_nav_area").empty();
        var ul = $("<ul></ul>").addClass("pagination");
        //构建元素
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if (result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("disabled");
        }else {
            // 为元素添加点击事件
            // 首页
            firstPageLi.click(function () {
                to_page(1);
            });
            // 上一页
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum - 1);
            });
        }
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if (result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("disabled");
            lastPageLi.addClass("disabled");
        }else {
            // 下一页
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum + 1);
            });
            // 末页
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });

        }


        ul.append(firstPageLi).append(prePageLi);
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if (result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            ul.append(numLi);
        });
        //添加下一页和末页 的提示
        ul.append(nextPageLi).append(lastPageLi);
        //把ul加入到nav
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    function reset_form(ele){
        $(ele)[0].reset();
        // 清空表单样式，
        $(ele).find("*").removeClass("has-error has-success");
        $(ele).find(".help-block").text("");
    }
    /*员工添加事件*/
   $("#emp_add_modal_btn").click(function(){
        //清除表单数据（表单完整重置（表单的数据，表单的样式））
       reset_form("#empAddModal form");
        //发送ajax请求，查出部门信息，显示在下拉列表中
       getDepts("#empAddModal select");
        //弹出模态框
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });


    // 发送ajax请求，查出部门信息显示在部门下拉框中
    function getDepts(ele){
        $(ele).empty();
        $.ajax({
            url: "${APP_PATH}/depts",
            type: "get",
            success: function (result) {
                // console.log(result);
                // 显示部门信息在下拉列表中
                $.each(result.extend.depts,function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo($("#dept_add_select"));
                });
            }
        });
    }

    // 校验表单数据
    function validate_add_form(){
        // 1.拿到需要校验的数据，使用正则表达式
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})|(^[\u2E80-\u9FFF_a-zA-Z0-9_-]{4,8}$)/;
        // alert(regName.test(empName));
        if (!regName.test(empName)){
            // alert("用户名可以是2-5位中文或者6-16位英文和数字的组合");
            show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或者6-16位英文和数字的组合");
            return false;
        } else {
            if ("用户名已存在" == empNameVa_msg){
                show_validate_msg("#empName_add_input","error",empNameVa_msg);
            } else {
                show_validate_msg("#empName_add_input","success",empNameVa_msg);
            }
        }
        // 2.校验邮箱信息
        var email = $("#email_add_input").val();
        var regEmail = /^([a-zA-Z0-9_\.-]+)@([\da-zA-Z\.-]+)\.([a-zA-Z\.]{2,6})$/;;
        if (!regEmail.test(email)){
            // alert("邮箱格式不正确。")
            show_validate_msg("#email_add_input","error","邮箱格式不正确");
            return false;
        }else {
            show_validate_msg("#email_add_input","success","");
        }
        return true;
    }

    // 显示校验结果
    function show_validate_msg(ele,status,msg){
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if ("success" == status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        }else if ("error" == status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    var empNameVa_msg;
    function empName_add_inputChange(){
        var empName = $("#empName_add_input").val();
        $.ajax({
            url:"${APP_PATH}/checkEmpName",
            data:"empName="+empName,
            type:"get",
            success:function (result) {
                empNameVa_msg = result.extend.va_msg;
                // alert(result.code);
                if (result.code == 100){
                    show_validate_msg("#empName_add_input","success",result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va","success");
                } else {
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
    }
    $("#empName_add_input").blur(function () {
        // 当用户名输入框内容发生改变时发送ajax请求校验该用户名是否已存在
        empName_add_inputChange();
    });
    $("#email_add_input").blur(function () {
        validate_add_form();
    });


    // 员工新增保存事件
    $("#emp_save_btn").click(function () {
        // 1.模态框中填写的表单数据提交给服务器进行保存
        // 提交数据给服务器之前进行数据校验,通过校验才可添加

        if (!validate_add_form()){
            return false;
        }
        empName_add_inputChange();
        if ($(this).attr("ajax-va") == "error"){
            return false;
        }

        // 2.发送ajax post请求保存
       // alert( $("#empAddModal form").serialize()); // 将input中数据序列化提取为字符串用作ajax请求
        console.log($("#empAddModal form").serialize());
        $.ajax({
             url: "${APP_PATH}/emp",
             type: "post",
             data:$("#empAddModal form").serialize(),
             success: function(result) {
                 if (result.code == 100){
                     // alert(result.msg);
                     // 员工添加保存成功，1.关闭模态框 2.跳转到最后一页显示新添加员工信息
                     $("#empAddModal").modal("hide");
                     // 发送一个ajax请求，获取到最新的页数信息
                     to_page(totalRecord);
                 } else {
                    // console.log(result);
                     // 显示失败信息
                     // 只显示错误字段错误信息
                     if (undefined != result.extend.errorFields.email){
                        // 显示邮箱错误信息
                         show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                     }
                     if (undefined != result.extend.errorFields.empName){
                         // 显示用户名错误信息
                         show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                     }
                 }
            }
        });
    });

    // 编辑事件
    // 我们是在按钮创建之前绑定了click，所以绑定不上
    // 1.我们可以在创建的时候绑定，2.绑定点击.live()
    // jq新版没有live()方法，可以用on()替代
    $(document).on("click",".edit_btn",function () {
        // 查出员工信息显示
        getDepts("#empUpdateModal select");

        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });
</script>
</body>
</html>
