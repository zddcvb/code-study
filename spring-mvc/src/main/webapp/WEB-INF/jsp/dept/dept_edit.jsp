<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编辑页面</title>
<link
	href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css"
	rel="stylesheet">
<script src="https://cdn.bootcss.com/jquery/2.1.1/jquery.min.js"></script>
<script
	src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
	<br>
	<div>
		<form action="${pageContext.request.contextPath }/dept/editDept"
			method="post" class="form-horizontal " role="form">
			<input type="hidden" name="pageNum" value="${pageNum }"> <input
				type="hidden" name="deptId" value="${animDept.deptId }">

			<div class="form-group">
				<label for="deptName" class="col-sm-2 control-label">部门名称</label> <input
					type="text" name="deptName" value="${animDept.deptName }">
			</div>

			<div class="form-group">
				<label for="deptDesc" class="col-sm-2 control-label">部门描述</label>
				<textarea rows="5px" cols="20px" id="deptDesc" name="deptDesc">${animDept.deptDesc}</textarea>
			</div>
			<div class="form-group">
				<label for="parent" class="col-sm-2 control-label">上级部门</label> <select
					name="parentId">
					<!-- 当传递的parentI为null时，则显示默认的选项，如果不为空，则显示传递的上级部门名称  -->
					<c:choose>
						<c:when test="${animDept.parentId==null }">
							<option value="0">请选择</option>
						</c:when>
						<c:otherwise>
							<option value="${animDept.parentId}">${animDept.parent.deptName }</option>
						</c:otherwise>
					</c:choose>
					<!--当循环的部门id不等于传递的部门id时，继续循环，保证不重复循环部门  -->
					<c:forEach items="${parents }" var="parent">
						<c:if test="${animDept.parentId!=parent.deptId }">
							<option value="${parent.deptId }">${parent.deptName }</option>
						</c:if>
					</c:forEach>
				</select>
			</div>
			<div class="form-group">
				<c:if test="${animDept.children!=null }">
					<label for="child" class="col-sm-2 control-label">下级部门</label>
					<select name="childId" multiple="multiple" size="5px"
						style="width: 150px;" disabled="disabled">
						<c:forEach items="${animDept.children }" var="dept">
							<option value="${dept.deptId}">${dept.deptName }</option>
						</c:forEach>
					</select>
				</c:if>
			</div>
			<div class="col-sm-offset-2 col-sm-10">
				<input type="submit" name="submit" value="提交" class="btn btn-primary"> <input
					type="button" class="btn btn-primary"
					onclick="window.history.back(-1);" value="返回">
			</div>
		</form>
	</div>
</body>

</html>