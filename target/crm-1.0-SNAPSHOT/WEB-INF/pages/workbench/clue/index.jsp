<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">

<link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" type="text/css" href="../../jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<script type="text/javascript" src="../../jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
	<script type="text/javascript" src="../../jquery/bs_pagination-master/localization/en.js"></script>
<script type="text/javascript">

	$(function(){
		queryClueByConditionFroPage(1,10);
		$("#qureyBtn").click(function (){
			queryClueByConditionFroPage(1,$("#cluepagediv").bs_pagination("getOption","rowsPerPage"));
		});
		$("#createBtn").click(function (){
			//初始化
			$("#createForm")[0].reset();
			$("#createClueModal").modal("show");
		});
		$("#saveCreateClue").click(function (){
			//收集参数

			var fullname=$.trim($("#create-fullname").val());
			var appellation=$("#create-appellation").val();
			var owner =$("#create-owner").val();
			var company=$.trim($("#create-company").val());
			var job=$.trim($("#create-job").val());
			var email=$.trim($("#create-email").val());
			var phone=$.trim($("#create-phone").val());
			var website=$.trim($("#create-website").val());
			var mphone=$.trim($("#create-mphone").val());
			var state=$("#create-state").val();
			var source=$("#create-source").val();
			var description=$.trim($("#create-description").val());
			var contactSummary=$.trim($("#create-contactSummary").val());
			var nextContactTime=$.trim($("#create-nextContactTime").val());
			var address=$.trim($("#create-address").val());
			//表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if (company==""){
				alert("公司名不能为空");
				return;
			}
			if(fullname==""){
				alert("名称不能为空");
				return;
			}
			if (!/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(email)){
					alert("邮箱格式不正确");
					return;
				}
			if (!/\d{3}-\d{8}|\d{4}-\d{7}/.test(phone)){
				alert("公司固话输入格式不正确");
					return;
			}
			if (!/^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$/.test(mphone)){
				alert("手机号输入不正确");
				return;
			}
			if (!/[^\s]*/.test(website)){
				alert("公司网址输入格式错误");
				return;
			}
			$.ajax({
				url:'http://localhost:8111/crm/workbench/clue/saveCreateClue.do',
				data:{
					fullname:fullname,
					appellation:appellation,
					owner:owner,
					company:company,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address

				},
				type:'post',
				dataType:'json',
				success:function (data){
					if (data.code=="1"){
						$("#createClueModal").modal("hide");
						//调用查询

					}else {
						alert(data.message);
						$("#createClueModal").modal("show");
					}
				}
			});

		});//给创建的模态窗口的保存按钮添加单击事件
			$("#editClueBtn").click(function (){
				var checked=$("#clueTbody input[type='checkbox']:checked");
				if (checked.size()==0){
					alert("请选择需要修改的线索");
					return;
				}if(checked.size()>1){
					alert("每次只能修改一个数据");
					return;
				}
				var id=checked.get(0).value;
				$.ajax({
					url:'http://localhost:8111/crm/workbench/clue/queryClueByIdFroEdit.do',
					data:{
						id:id
					},
					type:'post',
					dataType:'json',
					success:function (data){
						$("#edit-fullname").val(data.fullname);
						$("#edit-appellation1").val(data.appellation);
						alert($("#edit-appellation").val());
						$("#edit-owner             ").val(data.owner);
						alert($("#edit-owner             ").val());
						$("#edit-company           ").val(data.company);
						$("#edit-job               ").val(data.job);
						$("#edit-email             ").val(data.email);
						$("#edit-phone             ").val(data.phone);
						$("#edit-website           ").val(data.website);
						$("#edit-mphone            ").val(data.mphone);
						$("#edit-status").val(data.state);
						$("#edit-source").val(data.source);
						$("#edit-create_by         ").val(data.createBy);
						$("#edit-create_time       ").val(data.createTime);
						$("#edit-edit_by           ").val(data.editBy);
						$("#edit-edit_time         ").val(data.editTime);
						$("#edit-description       ").val(data.description);
						$("#edit-contactSummary ").val(data.contactSummary);
						$("#edit-nextContactTime ").val(data.nextContactTime);
						$("#edit-address           ").val(data.address);
						$("#editClueModal").modal("show");
					}
				});
			});//给修改按钮添加单击事件
		$("#edit1Btn").click(function (){
			var id=$("#clueTbody input[type='checkbox']:checked").get(0).value;
			var fullname=$.trim($("#edit-fullname").val());
			var appellation=$("#edit-appellation").val();//
			var owner=$("#edit-owner").val();
			var company=$.trim($("#edit-company").val());
			var job=$.trim($("#edit-job").val());
			var email=$.trim($("#edit-email").val());
			var phone=$.trim($("#edit-phone").val());
			var website=$.trim($("#edit-website").val());
			var mphone=$.trim($("#edit-mphone").val());
			var state=$("#edit-status").val();//
			var source=$("#edit-source").val();//
			var description=$.trim($("#edit-description").val());
			var contactSummary=$.trim($("#edit-contactSummary").val());
			var nextContactTime=$.trim($("#edit-nextContactTime").val());
			var address=$.trim($("#edit-address").val());
			//表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if (company==""){
				alert("公司名不能为空");
				return;
			}
			if(fullname==""){
				alert("名称不能为空");
				return;
			}
			if (!/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(email)){
				alert("邮箱格式不正确");
				return;
			}
			if (!/\d{3}-\d{8}|\d{4}-\d{7}/.test(phone)){
				alert("公司固话输入格式不正确");
				return;
			}
			if (!/^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$/.test(mphone)){
				alert("手机号输入不正确");
				return;
			}
			if (!/[^\s]*/.test(website)){
				alert("公司网址输入格式错误");
				return;
			}
			$.ajax({
				url:'http://localhost:8111/crm/workbench/clue/editClue.do',
				data:{
					id:id,
					fullname:fullname,
					appellation:appellation,
					owner:owner,
					company:company,
					job:job,
					email:email,
					phone:phone,
					website:website,
					mphone:mphone,
					state:state,
					source:source,
					description:description,
					contactSummary:contactSummary,
					nextContactTime:nextContactTime,
					address:address
				},
				type:'post',
				dataType:'json',
				success:function (data){
					if (data.code=="1"){
						$("#editClueModal").modal("hide");
						queryClueByConditionFroPage(1,$("#cluepagediv").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						$("#editClueModal").modal("show");
						alert(data.message);
					}
				}
			})
		});//绑定更新事件按钮
		$("#clueTbody").on("click","input[type='checkbox']",function (){
			if ($("#clueTbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
				$("#clueAllcheck").prop("checked",true);
			}else {
				$("#clueAllcheck").prop("checked",false);
			}
		});
		$("#delClueBtn").click(function (){
			var checkedids=$("#clueTbody input[type='checkbox']:checked");
			if (checkedids.size()==0){
				alert("请选择需要删除的数据");
				return;
			}
			if (window.confirm("是否确定想删除？")){
				var ids="";
				$.each(checkedids,function (){
					ids+="id="+this.value+"&";
				});
				ids=ids.substr(0,ids.length-1);
				$.ajax({
					url:'http://localhost:8111/crm/workbench/clue/deleteClueByIds.do',
					data:ids,
					type:'post',
					dataType:'json',
					success:function (data){
						if (data.code=="1"){
							queryClueByConditionFroPage(1,$("#cluepagediv").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert(data.message);
						}
					}
				});
			}
		});//给删除按钮绑定单击事件


	});

	function queryClueByConditionFroPage(pageNo,pageSize){
		//获取参数
		var fullname=$.trim($("#qurey-fullname").val());
		var company=$.trim($("#qurey-company").val());
		var phone=$.trim($("#qurey-phone").val());
		var mphone=$.trim($("#qurey-mphone").val());
		var state=$("#qurey-clueState").val();
		var owner=$.trim($("#qurey-ClueOwner").val());
		var source=$("#qurey-source").val();
		$.ajax({
			url:'http://localhost:8111/crm/workbench/clue/queryClueByConditionForPage.do',
			data: {
				fullname:fullname,
				company:company,
				phone:phone,
				mphone:mphone,
				state:state,
				owner:owner,
				source:source,
				state:state,
				pageNo:pageNo,
				pageSize:pageSize
			},
			type:'post',
			dataType: 'json',
			success:function (data){
				var strHtml="";
				$.each(data.clueList,function(index,obj){
					strHtml+="<tr>";
					strHtml+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					strHtml+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='http://localhost:8111/crm//workbench/clue/queryClueById.do?id="+obj.id+"';\">"+obj.fullname+""+obj.appellation+"</a></td>";
					strHtml+="<td>"+obj.company+"</td>";
					strHtml+="<td>"+obj.phone+"</td>";
					strHtml+="<td>"+obj.mphone+"</td>";
					strHtml+="<td>"+obj.source+"</td>";
					strHtml+="<td>"+obj.owner+"</td>";
					strHtml+="<td>"+obj.state+"</td>";
					strHtml+="</tr>";
				});
				$("#clueTbody").html(strHtml);
				var totalPages=1;
				if(data.c%pageSize==0){
					totalPages=data.c/pageSize;
				}else {
					totalPages=parseInt(data.c/pageSize)+1;
				}
				$("#cluepagediv").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.c,
					totalPages:totalPages,
					visiblePageLinks: 5,
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					onChangePage:function (event,pageObj){
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		})
	}
	
</script>
</head>
<body>

	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form  id="createForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <c:forEach items="${userList}" var="user">
									  <option value="${user.id}">${user.name}</option>
								  </c:forEach>
								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
								 <c:forEach items="${appellationList}" var="app">
									 <option value="${app.id}">${app.value}</option>
								 </c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
								 <c:forEach items="${clueStateList}" var="state">
									 <option value="${state.id}">${state.value}</option>
								 </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCreateClue">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation1" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation1">
									<c:forEach items="${appellationList}" var="app">
										<option value="${app.id}">${app.value}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
									<c:forEach items="${clueStateList}" var="state">
										<option value="${state.id}">${state.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
									<c:forEach items="${sourceList}" var="source">
										<option value="${source.id}">${source.value}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="edit1Btn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="qurey-fullname" >
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text"  id="qurey-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text"  id="qurey-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="qurey-source">
					  	  <option></option>
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text"  id="qurey-ClueOwner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text"  id="qurey-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="qurey-clueState">
					  	<option></option>
						  <c:forEach items="${clueStateList}" var="state">
							  <option value="${state.id}">${state.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="submit" class="btn btn-default" id="qureyBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editClueBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delClueBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="clueAllcheck" /></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueTbody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>

<%--                            <td>动力节点</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>12345678901</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>已联系</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="cluepagediv">

				</div>
			</div>

		</div>
		
	</div>
</body>
</html>