<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>部门查看</title>
</head>
<body>
	<form action="${pageContext.request.contextPath }/dept/saveDept"
		class="form-horizontal " role="form">

		<div class="form-group">
			<label class="col-sm-2 control-label">部门名称 </label>
			<div class="col-sm-10">
				<span>${animDept.deptName }</span>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">部门创建时间</label>
			<div class="col-sm-10">
				<span class="form-control-static">${animDept.deptCreatetime }</span>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">部门更新时间 </label>
			<div class="col-sm-10">
				<span>${animDept.deptUpdatetime }</span>
			</div>
		</div>

		<div class="form-group">
			<label class="col-sm-2 control-label">部门描述 </label>
			<div class="col-sm-10">
				<span>${animDept.deptDesc }</span>
			</div>
		</div>

		<c:if test="${animDept.parent!=null }">

			<div class="form-group">
				<label class="col-sm-2 control-label">上级部门 </label>
				<div class="col-sm-10">
					<span>${animDept.parent.deptName }</span>
				</div>
			</div>

		</c:if>
		<c:if test="${animDept.children!=null }">

			<div class="form-group">
				<label class="col-sm-2 control-label">下级部门</label>

				<c:forEach items="${animDept.children }" var="dept">
					<span>${dept.deptName }</span>
				</c:forEach>
			</div>

		</c:if>

		<div class="form-group">
			<a href="${pageContext.request.contextPath }/dept/deptList"
				class="btn btn-primary">返回上一级</a>
		</div>
	</form>
</body>
</html>