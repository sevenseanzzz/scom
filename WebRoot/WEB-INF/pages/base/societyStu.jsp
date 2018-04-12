<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!-- 导入jquery核心类库 -->
    <script type="text/javascript"
            src="${pageContext.request.contextPath }/js/jquery-1.8.3.js"></script>
    <!-- 导入easyui类库 -->
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath }/js/easyui/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath }/js/easyui/themes/icon.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath }/css/default.css">
    <script type="text/javascript"
            src="${pageContext.request.contextPath }/js/easyui/jquery.easyui.min.js"></script>
    <script
            src="${pageContext.request.contextPath }/js/easyui/locale/easyui-lang-zh_CN.js"
            type="text/javascript"></script>
    <script src="${pageContext.request.contextPath }/js/form.js"
            type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $("#saveForm").click(function() {
                $.messager.progress(); // 显示进度条
                $('#editForm').form('submit',{
                    url : '${pageContext.request.contextPath}/collengtest_save.action',
                    onSubmit : function() {
                        var isValid = $(this).form('validate');
                        if (!isValid) {
                            $.messager.progress('close'); // 如果表单是无效的则隐藏进度条
                        }
                        return isValid; // 返回false终止表单提交
                    },
                    success : function(data) {
                        var data = eval('(' + data + ')');
                        $.messager.progress('close'); // 如果提交成功则隐藏进度条
                        if (data.success){
                            $("#editdialog").dialog('close');
                            $.messager.alert("系统提示",data.message, "info");
                        }else{
                            //1.清空表单
                            $("#editForm").get(0).reset();
                            $.messager.alert("系统提示",data.message, "wanning");
                        }
                    }
                });
            });

            //excel上传
            $("#btnUpload").bind("click", function() {
                $.ajax({
                    url:"society_upload.action",
                    type: 'POST',
                    cache: false,
                    data: new FormData($('#Excel')[0]),
                    processData: false,
                    contentType: false,
                    success:function(value)
                    {
                        var res = $.parseJSON(value);
                        if(res.success)
                        {
                            $('#Excel_dialog').dialog('close');
                            $('#Excel').form('clear');
                            $('#grid').datagrid('reload');
                        }
                        $.messager.alert('提示',res.message);
                    }
                });
            });

            $('#grid').datagrid({

                url: '',
                //datagrid的唯一辨识
                idField: 'grid',
                width: 'auto',
                height: 600,
                toolbar: [{
                    id: 'add',
                    iconCls: 'icon-add',
                    text: '增加',
                    handler: function () {
                        $('#editForm').form('clear');
                        $('#editdialog').window('open');
                    }
                }, {
                    id: 'all',
                    text: '从Excel中导入',
                    iconCls: 'icon-save',
                    handler: function () {
                        doOfExcel();
                    }
                },],

            });

        });
    </script>
</head>
<body>
<table id="grid"></table>
<div id="editdialog" class="easyui-dialog" closed="true"
     style="width:450px" modal="true" draggable="false" title="新增">
    <form id="editForm">
        <table border="0" width="400" height="80">
            <tr>
                <td style="text-align:center; width: 80px">社会实践名称</td>
                <td width="200"><input name="name" type="text"></td>
            </tr>
            <tr>
                <td style="text-align:center; width: 80px">加分</td>
                <td width="200"><input name="score" type="text"
                                       style="width:160px;"></td>
            </tr>
            <tr>
                <td style="text-align:center;">加分原因</td>
                <td width="200px"><textarea name="reason" cols="30" rows="5"></textarea>
                </td>
            </tr>
            <tr>
                <td style="text-align:center;">部门</td>
                <td><input id="deptname" url="" name="deptname"
                           valueField="deptname" class="easyui-combobox" style="width:160px;"
                           textField="text" multiple="true" panelHeight="auto"></td>
            </tr>

            <tr style="text-align: center">
                <td colspan="2">
                    <a id="saveForm" class="easyui-linkbutton">确定</a>
                    <a id="close" class="easyui-linkbutton" href="javascript:close('#editForm','#editdialog')">关闭</a>
            </tr>

        </table>
    </form>
</div>
<!-- 导入框 -->
<div id="Excel_dialog" class="easyui-dialog" title="批量导入"
     style="width: 460px;height: 230px" data-options="closed:true">
    <form id="Excel" method="post" enctype="multipart/form-data">
        <table>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            <tr>
                <td>下载模板文件：</td>
                <td><a href="${pageContext.request.contextPath }/download_excel.action?fid=2">【点此下载社会成绩加分模板
                    Excel模板文件】</a>
                </td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td width="100">请选择Excel文件:</td>
                <td><input type="file" name="upload" class="inputstyle"
                           style="width: 200px;"/></td>
            </tr>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td>时间：</td>
                <td><input class="easyui-combobox"
                           data-options="url:'${pageContext.request.contextPath }/term_list.action',
		valueField:'id',textField:'time'"
                           name="termid"/></td>
            <tr>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <button type="button" id="btnUpload">上传Excel文件</button>
                    <a class="easyui-linkbutton" href="javascript:close('#Excel','#Excel_dialog')">关闭</a></td>
        </table>
    </form>
</div>

</body>
</html>
