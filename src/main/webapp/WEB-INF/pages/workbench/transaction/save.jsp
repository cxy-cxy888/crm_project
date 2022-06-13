<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">

<link href="../../jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="../../jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../../jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="../../jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="../../jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
<script type="text/javascript">


	$(function (){

		$("#queryActivityBtn").click(function (){
			$("#findMarketActivity").modal("show");
		});//点击查询按钮唤起查询市场活动的模态窗口
		$("#queryContactsBtn").click(function (){
			$("#findContacts").modal("show");
		});
		$("#queryActivityInput").keyup(function (){
			var activityName=$("#queryActivityInput").val();
			$.ajax({
				url:'http://localhost:8111/crm/workbench/transaction/findActivityAll.do',
				data:{activityName:activityName},
				type:'post',
				datatype:'json',
				success:function (data){
					var htmlstr="";
					$.each(data,function (index,obj){
								htmlstr+="<tr>";
						htmlstr+="<td><input type=\"radio\" value=\""+obj.id+"\" activityName=\""+obj.name+"\"name=\"activity\"/></td>";
						htmlstr+="<td>"+obj.name+"</td>";
						htmlstr+="<td>"+obj.startDate+"</td>";
						htmlstr+="<td>"+obj.endDate+"/td>";
						htmlstr+="<td>"+obj.owner+"</td>";
						htmlstr+="</tr>";
					});
					$("#queryActivityTbody").html(htmlstr);
				}

			})
		});
		$("#queryActivityTbody").on("click","input[type='radio']",function (){
				var activityId=this.value;
				var activityName=$(this).attr("activityName");
				$("#create-activitySrc").val(activityName);
				$("#create_activityId").val(activityId);
				$("#findMarketActivity").modal("hide");
		});
		$("#queryContactsInput").keyup(function (){
			var contactsName=$("#queryContactsInput").val();
			$.ajax({
				url: 'http://localhost:8111/crm/workbench/transaction/findContactsAll.do',
				data: {contactsName:contactsName},
				type: 'post',
				datatype: 'json',
				success:function (data){
					var htmlstr='';
					$.each(data,function (index,obj){
													htmlstr+="<tr>";
						htmlstr+="<td><input type=\"radio\" value=\""+obj.id+"\" contactsName=\""+obj.fullname+"\" name=\"activity\"/></td>";
						htmlstr+="<td>"+obj.fullname+"</td>";
						htmlstr+="<td>"+obj.email+"</td>";
						htmlstr+="<td>"+obj.mphone+"</td>";
						htmlstr+="</tr>";
					});
					$("#queryContactsTbody").html(htmlstr);
				}
			})
		});
		$("#create-transactionStage").change(function (){

			var stageValue=$(this).find("option:selected").text();
			alert(stageValue);
			if (stageValue==""){
				$("#create-possibility").val("");
				return;
			}
			$.ajax({
				url:'http://localhost:8111/crm/workbench/transaction/getPossibilityByStage.do',
				data:{
					stageValue:stageValue
			},
				type:'post',
				datatype:'json',
				success:function (data){
					$("#create-possibility").val(data);
				}
			})
		})
		$("#queryContactsTbody").on("click","input[type='radio']",function (){
			var contactsId=this.value;
			var contactsName=$(this).attr("contactsName");
			$("#create-contactsId").val(contactsId);
			$("#create-contactsName").val(contactsName);
			$("#findContacts").model("hide");
		});
		$("#create-accountName").typeahead({
			source:function (jquery,process){
				$.ajax({
					url:'http://localhost:8111/crm//workbench/transaction/queryCustomerAllByLikeName.do',
					type:'post',
					datatype:'json',
					success:function (data){
						process(data);
					}
				})
			}
		})

		$("#saveTranBtn").click(function (){
			var owner            =$("#create-transactionOwner").val();
			var money            =$.trim($("#create-amountOfMoney").val());
			var name             =$.trim($("#create-transactionName").val());
			var expectedDate    =$("#create-expectedClosingDate").val();
			var customerName      =$.trim($("#create-accountName").val());
			var stage            =$("#create-transactionStage").val();
			var type             =$("#create-transactionType").val();
			var source           =$("#create-clueSource").val();
			var activityId      =$("#create_activityId").val();
			var contactsId      =$("#create-contactsId").val();
			var description      =$.trim($("#create-description").val());
			var contactSummary  =$.trim($("#create-contactSummary").val());
			var nextContactTime=$("#create-nextContactTime").val();
			//表单验证
			$.ajax({
				url:'http://localhost:8111/crm/workbench/transaction/saveCreateTran.do',
				data:{
					owner:owner          ,
					money:money          ,
					name:name           ,
					expectedDate:expectedDate   ,
					customerName:customerName   ,
					stage:stage          ,
					type:type           ,
					source:source         ,
					activityId:activityId     ,
					contactsId:contactsId     ,
					description:description    ,
					contactSummary:contactSummary ,
					nextContactTime:nextContactTime
				},
				type:'post',
				datatype:"json",
				success:function (data){
					if(data.code=='1'){
						window.location.href='http://localhost:8111/crm/workbench/transaction/index.do';
					}else {
						alert(data.message);
					}
				}
			})
		});



	})
</script>
</head>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" id="xuanzeactivity">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="queryActivityInput" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="queryActivityTbody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>发传单</td>--%>
<%--								<td>2020-10-10</td>--%>
<%--								<td>2020-10-20</td>--%>
<%--								<td>zhangsan</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" >
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="queryContactsInput" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="queryContactsTbody">
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
<%--							<tr>--%>
<%--								<td><input type="radio" name="activity"/></td>--%>
<%--								<td>李四</td>--%>
<%--								<td>lisi@bjpowernode.com</td>--%>
<%--								<td>12345678901</td>--%>
<%--							</tr>--%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="saveTranBtn">保存</button>
			<button type="button" class="btn btn-default" id="quitBtn">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionOwner">
				 <c:forEach items="${userList}" var="user">
					 <option value="${user.id}">${user.name}</option>
				 </c:forEach>
				</select>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-amountOfMoney">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-transactionName">
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-expectedClosingDate">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-accountName" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="create-transactionStage">
			  	<option></option>
			  <c:forEach items="${stageList}" var="stage">
				  <option value="${stage.id}">${stage.value}</option>
			  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-transactionType">
				  <option></option>
				  <c:forEach items="${transactionTypeList}" var="transaction">
					  <option value="${transaction.id}">${transaction.value}</option>
				  </c:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-possibility">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="create-clueSource">
				  <option></option>
				 	<c:forEach items="${sourceList}" var="source">
						<option value="${source.id}">${source.value}</option>
					</c:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="queryActivityBtn" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create_activityId">
				<input type="text" class="form-control" id="create-activitySrc">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="queryContactsBtn" ><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="hidden" id="create-contactsId">
				<input type="text" class="form-control" id="create-contactsName">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="create-nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>