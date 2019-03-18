<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>dept_list_page</title>
</head>
<link href="css/bootstrap.min.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(document).ready(function() {
		alert("ok");
		/* $('#btn').on('click', function() {
			alert("click")
		}) */
	})
</script>
</head>
<body>
	<br>
	<div style="margin: 10px;">
		<a class="btn btn-default btn-sm" role="button"
			href="${pageContext.request.contextPath }/dept/save?pageNum=${pageInfo.pageNum}&parentId=${parentId}"><span>添加部门</span></a>
		<%-- <a class="btn btn-default btn-sm" role="button"
			href="${pageContext.request.contextPath }/dept/deleteAll?parentId=${parentId}"><span>删除所有部门</span></a> --%>
		<a class="btn btn-default btn-sm" role="button"
			href="${pageContext.request.contextPath }/dept/batchAll?parentId=${parentId}"><span>批量更新部门</span></a>
	</div>
	<form>
		<a><span>${parent.deptName }</span></a> <input type="hidden"
			name="parentId" value="${parent.deptId }"> <input
			type="hidden" name="pageNum" value="${pageNum }">
		<table class="table table-striped">
			<thead>
				<tr>
					<!-- <th>部门id</th> -->
					<th>部门名称</th>
					<th>部门描述</th>
					<th>创建时间</th>
					<th>更新时间</th>
					<th>是否存在</th>
					<!-- 					<th>上级部门</th>
					<th>下级部门</th>
 -->
					<th>功能</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${pageInfo.list}" var="animDept">
					<tr>
						<%-- <td>${animDept.deptId }</td> --%>
						<td><a
							href="
							${pageContext.request.contextPath }/dept/list/${animDept.deptId}">${animDept.deptName }</a></td>
						<td>${animDept.deptDesc }</td>
						<td>${animDept.deptCreatetime }</td>
						<td>${animDept.deptUpdatetime }</td>
						<td><c:choose>
								<c:when test="${animDept.isdeleted==false }">
									<span>是</span>
								</c:when>
								<c:otherwise>
									<span>否</span>
								</c:otherwise>
							</c:choose></td>
						<%-- <td>${animDept.parent.deptName}</td>
						<td><c:forEach items="${animDept.children }" var="childDept">
								${childDept.deptName} 
							</c:forEach></td> --%>
						<td><a
							href="${pageContext.request.contextPath }/dept/modify/${animDept.deptId}?pageNum=${pageInfo.pageNum}">隐藏</a>
							<a
							href="${pageContext.request.contextPath }/dept/edit/${animDept.deptId}?pageNum=${pageInfo.pageNum}">修改</a>
							<a
							href="${pageContext.request.contextPath }/dept/delete/${animDept.deptId}?pageNum=${pageInfo.pageNum}">删除</a>

						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</form>
	<!-- 分页功能 -->
	<div style="margin: 10px;">
		<div>
			<span> <a
				href="${pageContext.request.contextPath }/dept/list/${parent.deptId }?pageNum=1">首页</a></span>
			<span><a
				href="${pageContext.request.contextPath }/dept/list/${parent.deptId }?pageNum=${pageInfo.prePage}">上一页</a></span>
			<c:forEach begin="1" end="${pageInfo.pages }" step="1" var="num">
				<span><a
					href="${pageContext.request.contextPath }/dept/list/${parent.deptId }?pageNum=${num}"><c:choose>
							<c:when test="${pageInfo.pageNum==num}">
								<span><u>${num }</u></span>
							</c:when>
							<c:otherwise>
								<span>${num }</span>
							</c:otherwise>
						</c:choose></a></span>
			</c:forEach>
			<select id="page" name="pageNum" onchange="changed()">
				<option selected>${pageInfo.pageNum }</option>
				<c:forEach begin="1" end="${pageInfo.pages }" step="1" var="num">
					<c:if test="${pageInfo.pageNum!=num }">
						<option value="${num }">${num}</option>
					</c:if>
				</c:forEach>
			</select> <span><a
				href="${pageContext.request.contextPath }/dept/list/${parent.deptId }?pageNum=${pageInfo.nextPage}">下一页</a></span>
			<span><a
				href="${pageContext.request.contextPath }/dept/list/${parent.deptId }?pageNum=${pageInfo.lastPage}">尾页</a></span>
		</div>
		<!-- 返回功能 -->
		<div>
			<c:if test="${parent.deptId!='0' }">
				<%-- 返回上一級，但是他是返回到上一个目录，暂未实现一级一级跳转		--%>
				<span><a
					href="${pageContext.request.contextPath }/dept/back/${parent.deptId}?pageNum=${pageInfo.pageNum}">返回上一级</a></span>
			</c:if>
		</div>
	</div>
</body>
<script type="text/javascript">
	function changed() {
		var select = document.getElementById("page");
		var value = select.value;
		value.selected = true;
		var serverName = "${pageContext.request.serverName}";
		var serverPort = "${pageContext.request.serverPort}";
		var contextPath = "${pageContext.request.contextPath }";
		window.location.href = "http://" + serverName + ":" + serverPort + "/"
				+ contextPath + "/dept/list/${parent.deptId }?pageNum=" + value;

	}
	//返回上一级
	function back() {
		window.history.back(-1);
	}
	//前进
	function next() {
		window.history.back(1);
	}
</script>
</html>