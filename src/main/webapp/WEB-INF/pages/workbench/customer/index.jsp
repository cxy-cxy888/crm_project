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

		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });
		$("#customerTbody").on("click","input[type='checkbox']",function (){
			if ($("#customerTbody input[type='checkbox']").size()==$("#customerTbody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked",true);
			}else {
				$("#checkAll").prop("checked",false);
			}
		});
		queryCustomerLimitForPage(1,10);
		$("#queryCustomerBtn1").click(function (){
			queryCustomerLimitForPage(1,$("#pagediv").bs_pagination('getOption', 'rowsPerPage'));
		});
		$("#createCustomerBtn").click(function (){
			$("#createfrom").get(0).reset();
				$("#createCustomerModal").modal("show");

		});//创建按钮完成客户创建


		$("#saveCustomerBtn").click(function (){
			var owner=$("#create-customerOwner").val();
			var name=$.trim($("#create-customerName").val());
			var website=$.trim($("#create-website").val());
			var phone=$.trim($("#create-phone").val());
			var contactSummary=$.trim($("#create-contactSummary").val());
			var nextContactTime=$.trim($("#create-nextContactTime").val());
			var description=$.trim($("#create-describe").val());
			var address=$.trim($("#create-address1").val());
			$.ajax({
				url:'http://localhost:8111/crm/workbench/customer/createCustomer.do',
				data:{
					owner:owner,name:name,website:website,phone:phone,contactSummary:contactSummary,nextContactTime:nextContactTime
					,description:description,address:address
				},
				type: 'post',
				datatype: 'json',
				success:function (data){
					if (data.code=='1'){
						$("#createCustomerModal").modal("hide");
						queryCustomerLimitForPage(1,$("#pagediv").bs_pagination('getOption', 'rowsPerPage'));
					}else {
						alert(data.message);
					}
				}
			})
		});//保存新建客户信息按钮单击事件
        $("#editCustomerBtn").click(function (){
			var checked=$("#customerTbody input[type='checkbox']:checked");
           if ( checked.size()==0){
               alert("请选择需要修改的数据");
           }
		   if ( checked.size()>1){
			   alert("每次只能修改一个数据" );
		   }
		   var id = checked.get(0).value;
		   $.ajax({
			   url:'http://localhost:8111/crm/workbench/customer/queryCustomerById.do',
			   data:{id:id},
			   type:'post',
			   datatype:'json',
			   success:function (data){
					$("#edit-id").val(data.id);
					$("#edit-customerOwner").val(data.owner);
					$("#edit-customerName").val(data.name);
					$("#edit-website").val(data.website);
					$("#edit-phone").val(data.phone);
					$("#edit-describe").val(data.description);
					$("#edit-contactSummary").val(data.contactSummary);
					$("#edit-nextContactTime").val(data.nextContactTime);
					$("#edit-address").val(data.address);
					$("#editCustomerModal").modal("show");
			   }
		   })
        });//给修改按钮添加单击事件
			$("#edit-gengxinBtn").click(function (){
				var id=$("#edit-id").val();
				var owner=$("#edit-customerOwner").val();
				var name=$("#edit-customerName").val();
				var website=$("#edit-website").val();
				var phone=$("#edit-phone").val();
				var description=$("#edit-describe").val();
				var contactSummary=$("#edit-contactSummary").val();
				var nextContactTime=$("#edit-nextContactTime").val();
				var address=$("#edit-address").val();
				if (owner==''){
					alert("所有者不能为空");
					return;
				}
				if (name==''){
					alert("名称不能为空");
					return;
				}
				$.ajax({
						url:'http://localhost:8111/crm/workbench/customer/saveEditCustomer.do',
						data:{
							id:id,
							owner:owner,
							name:name,
							website:website,
							phone:phone,
							description:description,
							contactSummary:contactSummary,
							nextContactTime:nextContactTime,
							address:address
						},
						type:'post',
						datatype:'json',
					success:function (data){
							if (data.code=='1'){
								$("#editCustomerModal").modal('hide');
								queryCustomerLimitForPage(1,$("#pagediv").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert(data.message);
								$("#editCustomerModal").modal('show');
							}
					}
				})
			});//给修改模态窗口中的更新按钮添加单击事件
		$("#deleteCustomerBtn").click(function (){
			var checkedids=$("#customerTbody input[type='checkbox']:checked");
			alert(checkedids.size());
			if (checkedids.size()==0){
				alert("请选择需要删除的客户信息");
				return;
			}
			if (window.confirm("是否要删除所选择的数据")){
				var ids="";
				$.each(checkedids,function (){
					ids+="id="+this.value+"&";
				});
				ids=ids.substr(0,ids.length-1);
				$.ajax({
					url:'http://localhost:8111/crm/workbench/customer/deleteCustomerByIds.do',
					data:ids,
					type:'post',
					datatype:'json',
					success:function (data){
						if (data.code=='1'){
							queryCustomerLimitForPage(1,$("#pagediv").bs_pagination('getOption', 'rowsPerPage'));
						}else {
							alert(data.message);
						}
					}
				})
			}

		});//给删除客户信息绑定单击事件

	});

	function queryCustomerLimitForPage(pageNo,pageSize){
				var name=$.trim($("#queryCustomerName").val());
				var owner=$.trim($("#queryCustomerOwner").val());
				var phone=$.trim($("#queryCustomerPhone").val());
				var website=$.trim($("#queryCustomerWebsite").val());
		$.ajax({
			url:'http://localhost:8111/crm/workbench/customer/queryCustomerForPage.do',
			data:{
				pageNo:pageNo,
				pageSize:pageSize,
				name:name,
				phone:phone,
				owner:owner,
				website:website
			},
			type:'post',
			datatype:'json',
			success:function (data){
				var htmlStr="";
				$.each(data.customerList,function (index,obj){
					htmlStr+="<tr class=\"active\">";
					htmlStr+="	<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="	<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='';\">"+obj.name+"</a></td>";
					htmlStr+="	<td>"+obj.owner+"</td>";
					htmlStr+="	<td>"+obj.phone+"</td>";
					htmlStr+="	<td>"+obj.website+"</td>";
					htmlStr+="</tr>";
				});
				$("#customerTbody").html(htmlStr);
				$("#checkAll").prop("checked",false);
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
						queryCustomerLimitForPage(pageObj.currentPage,pageObj.rowsPerPage);
					}
				});
			}
		});
	}

</script>
</head>
<body>

	<!-- 创建客户的模态窗口 -->
	<div class="modal fade" id="createCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" id="createfrom" role="form">
					
						<div class="form-group">
							<label for="create-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-customerOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-website">
                            </div>
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-describe"></textarea>
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
                                <label for="create-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address1"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveCustomerBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
	<div class="modal fade" id="editCustomerModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改客户</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-customerOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-customerOwner">
									<c:forEach items="${userList}" var="user">
										<option value="${user.id}">${user.name}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-customerName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website" >
                            </div>
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                                <div class="col-sm-10" style="width: 300px;">
                                    <input type="text" class="form-control" id="edit-nextContactTime">
                                </div>
                            </div>
                        </div>

                        <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="edit-gengxinBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>客户列表</h3>
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
				      <input class="form-control" id="queryCustomerName" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" id="queryCustomerOwner" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control"  id="queryCustomerPhone" type="text">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司网站</div>
				      <input class="form-control" id="queryCustomerWebsite" type="text">
				    </div>
				  </div>
				  
				  <button type="submit" class="btn btn-default" id="queryCustomerBtn1">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createCustomerBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default"id="editCustomerBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
							<td>所有者</td>
							<td>公司座机</td>
							<td>公司网站</td>
						</tr>
					</thead>
					<tbody id="customerTbody">


					</tbody>
				</table>
				<div id="pagediv">

				</div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
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
<%--			--%>
<%--		</div>--%>
		
	</div>
</body>
</html>