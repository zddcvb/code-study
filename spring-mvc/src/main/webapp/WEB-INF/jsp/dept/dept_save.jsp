<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link
	href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
<script
	src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
	<br>
	<div style="align-items: center;">
		<form
			action="${pageContext.request.contextPath }/dept/saveDept?pageNum=${pageNum }"
			class="form-horizontal " role="form">
			<input type="hidden" name="pageNum" value="${pageNum}"> <input
				type="hidden" name="parentId" value="${parentId}">
			<div class="form-group">
				<label for="firstname" class="col-sm-2 control-label">部门名称</label>
				<div class="col-sm-10">
					<input type="text" name="deptName" placeholder="请输入部门">
				</div>
			</div>
			<div class="form-group">
				<label for="lastname" class="col-sm-2 control-label">部门创建时间</label>
				<div class="col-sm-10">
					<input type="text" name="deptCreatetime" placeholder="请输入时间">
				</div>
			</div>
			<div class="form-group">
				<label for="deptDesc" class="col-sm-2 control-label">部门描述</label>
				<div class="col-sm-10">
					<textarea rows="5" cols="20" name="deptDesc" placeholder="请输入部门描述"></textarea>
				</div>
			</div>
			<div class="form-group">
				<label for="paernt" class="col-sm-2 control-label">上级部门</label>
				<div class="col-sm-10">
					<select name="parentId">
						<option value="null">请选择上级部门</option>
						<c:forEach items="${parents }" var="parent">
							<option value="${parent.deptId }">${parent.deptName }</option>
						</c:forEach>
					</select>
				</div>
			</div>
			<div class="col-sm-offset-2 col-sm-10">
				<input type="submit" name="submit" value="提交"
					class="btn btn-primary"> <input type="button"
					class="btn btn-primary" onclick="window.history.back(-1);"
					value="返回">
			</div>

		</form>
	</div>
</body>
</html>