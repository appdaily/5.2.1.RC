<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/common/mms-taglibs.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3c.org/TR/1999/REC-html401-19991224/loose.dtd">
<html>
<head>
	<title>数据权限</title>
	<%@ include file="/common/mms-iframe-meta.jsp"%>
	
	<script type="text/javascript" src="${resourcesCtx }/widgets/jstree/jquery.jstree.js"></script>
	<script src="${resourcesCtx}/js/staff-tree.js" type="text/javascript"></script>
	<script src="${resourcesCtx}/js/custom.tree.js" type="text/javascript"></script>
	<link   type="text/css" rel="stylesheet" href="${mmsCtx}/css/custom.css" />

	
	<script type="text/javascript">
	function createPermission(){
		var menuId=$("#menuId").val();
		if(menuId!='' && typeof (menuId)!='undefined'){
			$("#entiyId").attr("value","");
			ajaxSubmit("defaultForm", "${mmsCtx}/authority/permission-input.htm", "pageTable",validatePermission);
		}else{
			alert("请选择对应的系统!");
		}
	}
	function validatePermission(){
		getContentHeight();
		$("#viewSaveForm").validate({
			submitHandler: function() {
			var checkedAuths=$("input[name='docAuthes']:checked");
				if(checkedAuths.length>0){
					var cansave=iMatrix.getFormGridDatas("viewSaveForm","childGridId");
					if(cansave){
						ajaxSubmit('viewSaveForm','${mmsCtx}/authority/permission-save.htm','pageTablelist',saveCallback);
					}
				}else{
					alert("请选择操作权限");
				}
			},
			rules: {
				code:"required",
				name:"required",
				dataRuleId:"required"
			},
			messages: {
				code:"必填",
				name:"必填",
				dataRuleId:"必填"
			}
		});
	}

	function saveCallback(){
		showMsg();
		validatePermission();
	}
	function updatePermission(){
		var boxes = jQuery("#page").jqGrid("getGridParam",'selarrrow');
		if(boxes.length<=0){
			alert("请选择记录");
			return;
		}else if(boxes.length>1){
			alert("只能选择一条记录");
			return;
		}else{
			$("#entiyId").attr("value",boxes[0]);
			ajaxSubmit("defaultForm", "${mmsCtx}/authority/permission-input.htm", "pageTable",validatePermission);
		}
	}
	function deletePermission(){
		var boxes = jQuery("#page").jqGrid("getGridParam",'selarrrow');
		if(boxes.length<=0){
			alert("请选择记录");
			return;
		}else{
			$("#ids").attr("value",boxes.join(','));
			ajaxSubmit("defaultForm", "${mmsCtx}/authority/permission-delete.htm", "pageTablelist",showMsg);
		}
	}
	function savePermission(){
		$("#viewSaveForm").submit();
	}

	function backPage(){
		setPageState();
		ajaxSubmit("viewSaveForm", "${mmsCtx}/authority/permission-data.htm", "pageTable");
	}

	function conditionNameClick(obj){
		var id = $("#_dataRuleId").attr("value");
		if(id==""){
			alert("先选择数据分类！");return;
		}
		var itemType=$("#"+obj.rowid+"_itemType").val();
		if(itemType==""){
			alert("先选择条件类型！");return;
		}
		$.colorbox({href:webRoot+"/authority/permission-item-tree-page.htm?id="+id+"&itemType="+itemType+"&rowId="+obj.rowid,iframe:true, innerWidth:600, innerHeight:400,overlayClose:false,title:"选择人员"});

	}
	function itemTypeChange(obj){
		$("#"+obj.rowid+"_conditionValue").attr("value","");
		$("#"+obj.rowid+"_conditionName").attr("value","");
	}

	function getUserInformation(obj){
		//$("#"+obj.rowid+"_conditionValue").attr("value",jstree.getLoginName());
		//$("#"+obj.currentInputId).attr("value",jstree.getName());
	}

	function getDepartInformation(obj){
		//$("#"+obj.rowid+"_conditionValue").attr("value",jstree.getName());
		//$("#"+obj.currentInputId).attr("value",jstree.getName());
	}
	function getWorkgroupInformation(obj){
		//$("#"+obj.rowid+"_conditionValue").attr("value",jstree.getName());
		//$("#"+obj.currentInputId).attr("value",jstree.getName());
	}

	function getRoleInformation(obj){
		var ids=getSelectNodeId();
		if(ids!=""&&ids.length>0){
			var id=ids[0];
			var roleCode=id.substring(id.indexOf("-")+1,id.lastIndexOf("-"));
			var roleName=id.substring(id.lastIndexOf("-")+1);
			$("#"+obj.rowid+"_conditionValue").attr("value",roleCode);
			$("#"+obj.currentInputId).attr("value",roleName);
		}else{
			alert("请选择角色");
		}
	}

	//全选
	function selectAll(obj, boxName){
		if($(obj).attr('checked')){
			$('input[name="'+boxName+'"]').attr('checked', 'checked');
		}else{
			$('input[name="'+boxName+'"]').attr('checked', '');
		}
	}

	function  validatePermissionSave(){
		var validateAuths="";
		var checkedAuths=$("input[name='docAuthes']:checked");
		for(var i=0;i<checkedAuths.length;i++){
			validateAuths=validateAuths+$(checkedAuths[i]).attr("code")+",";
		}
		savePermission();
		//查询
		//$.ajax({
		//	type : "post",
		//	dataType : "text",
		//	data : "validateAuths="+validateAuths+"&dataRuleId="+$("#_dataRuleId").val()+"&permissionId="+$("#permissionId").val(),
		//	url : "${mmsCtx}/authority/validate-permission.htm",
		//	success : function(data) {
		//		if(data=='true-保存'){
		//			savePermission();
		//	   }else{
		//		   var auth=data.substring(data.indexOf("-")+1);
		//		   if(confirm("该授权对应的数据表的【"+auth+"】权限有相同的优先级,确定保存吗?")){
		//			   savePermission();
		//		   }
		//	   }
	//		},
		//	error : function() {
		//		alert("服务器繁忙，请稍后再操作...");
		//	}
		//});
	}
	//选择数据分类
	function selectDataRule(){
		$.colorbox({href:webRoot+"/authority/data-rule-selectDataRule.htm?selectPageFlag="+true,iframe:true, innerWidth:600, innerHeight:400,overlayClose:false,title:"数据表"});
	}
	</script>
	<style type="text/css">
	.form-table-without-border td input{
		width:200px;
	}
	</style>
</head>
<body >
<div class="ui-layout-center">
<div class="opt-body">
	<form id="defaultForm" name="defaultForm"action="" method="post" >
			<input type="hidden" id="menuId"  name="menuId" value="${menuId }"/>
			<input type="hidden" id="entiyId"  name="permissionId" />
			<input type="hidden" id="ids"  name="ids" />
		</form>
	<aa:zone name="pageTable">
		<div class="opt-btn">
			<button class="btn" onclick="iMatrix.showSearchDIV(this);"><span><span>查询</span></span></button>
			<button class="btn" onclick='createPermission();' id="create"><span><span >新建</span></span></button>
			<button class="btn" onclick="updatePermission();"><span><span >修改</span></span></button>
			<button class="btn" onclick="deletePermission();"><span><span >删除</span></span></button>
		</div>
		<aa:zone name="pageTablelist">
			<div id="opt-content">
				<div id="message" style="display:none;"><s:actionmessage theme="mytheme" /></div>
				<form action="${mmsCtx}/authority/permission-data.htm" name="pageForm" id="pageForm" method="post">
					<view:jqGrid url="${mmsCtx}/authority/permission-data.htm?menuId=${menuId }" code="MMS_PERMISSION" subGrid="childId" gridId="page" pageName="page"></view:jqGrid>
					<div style="height: 8px;"></div>
					<view:subGrid gridId="childId" url="${mmsCtx}/authority/permission-item-list.htm" code="MMS_PERMISSION_ITEM" pageName="itemPage"></view:subGrid>
				</form>
			</div>
		</aa:zone>
	</aa:zone>
</div>
</div>
</body>
<script type="text/javascript" src="${resourcesCtx}/widgets/validation/validate-all-1.0.js"></script>
</html>
