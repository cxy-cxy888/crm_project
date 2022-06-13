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

		queryAllTranFroPage(1,10);
		
	});

	function queryAllTranFroPage(pageNo,pageSize){
		var name=$.trim($("#queryName").val());
		var owner=$("#queryOwner").val();
		var customerName=$.trim($("#queryCustomerName").val());
		var stage=$("#queryStage").val();
		var type=$("#queryType").val();
		var source=$("#querySource").val();
		var contactsName=$.trim($("#queryContactsName").val());
		$.ajax({
			url:'http://localhost:8111/crm/workbench/transaction/queryAllTranForPage.do',
			data:{
				name:name,
				owner:owner,
				customerName:customerName,
				stage:stage,
				type:type,
				source:source,
				contactsName:contactsName,
				pageNo:pageNo,
				pageSize:pageSize,
			},
			type:'post',
			datatype:'json',
			success:function (data){
				var htmlstr="";
				$.each(data,function (index,obj){
					htmlstr+="<tr class=\"active\">";
					htmlstr+="<td><input type=\"checkbox\" value=\""+obj.id+"\" /></td>";
					htmlstr+="<td><a style=\"text-decoration: none; cursor: pointer;\">"+obj.customerName+"-"+obj.name+"</a></td>";
					htmlstr+="<td>"+obj.customerName+"</td>";
					htmlstr+="<td>"+obj.stage+"</td>";
					htmlstr+="<td>"+obj.type+"</td>";
					htmlstr+="<td>"+obj.owner+"</td>";
					htmlstr+="<td>"+obj.source+"</td>";
					htmlstr +="<td>"+obj.contactsName+"</td>";
					htmlstr +="</tr>";
				});
				$("#queryTranTbody").html(htmlstr);
				var totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else {
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}
				$("#pagediv").bs_pagination({
					currentPage:pageNo,
					rowsPerPage:pageSize,
					totalRows:data.totalRows,
					totalPages:totalPages,
					visiblePageLinks: 5,
					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					onChangePage:function (event,pageObj){
						queryAllTranFroPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
		$("#queryTranTbody").on("click","a",function (){
			var id=$("#queryTranTbody input[type='checkbox']").val();
			window.location.href='http://localhost:8111/crm/workbench/transaction/detailTran.do?id='+id;
		});
	}
	
</script>
</head>
<body>

	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="queryOwner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="queryName">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="queryCustomerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="queryStage">
							<c:forEach items="${stageList}" var="stage">
								<option value="${stage.id}">${stage.value}</option>
							</c:forEach>

					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="queryType">
						  <c:forEach items="${transactionTypeList}" var="transactionType">
							  <option value="${transactionType.id}">${transactionType.value}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="querySource">
						  <c:forEach items="${sourceList}" var="source">
							  <option value="${source.id}">${source.value}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="queryContactsName">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='http://localhost:8111/crm//workbench/transaction/toSave.do';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" /></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="queryTranTbody">


					</tbody>
				</table>
				<div id="pagediv">

				</div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 20px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
<%--			</div>--%>
			
		</div>
		
	</div>
</body>
</html>