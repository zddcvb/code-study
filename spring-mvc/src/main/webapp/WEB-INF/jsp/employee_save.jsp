<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

</head>
<body>
	<br>
	<div>
		<form
			action="${pageContext.request.contextPath }/employee/save_employee"
			class="form-horizontal " role="form">
			<div class="form-group">
				<label for="title" class="col-sm-2 control-label"><span>新增员工</span></label>
			</div>
			<input type="hidden" name="pageNum" value="${pageNum}"><input
				type="hidden" name="employeeNameQuery" value="${employeeNameQuery}">
			<input type="hidden" name="roleNameQuery" value="${roleNameQuery}">
			<input type="hidden" name="deptNameQuery" value="${deptNameQuery}">
			<div class="form-group">
				<label for="name" class="col-sm-2 control-label">员工姓名</label> <input
					type="text" name="employeeName">
			</div>
			<div class="form-group">
				<label for="sex" class="col-sm-2 control-label">员工性别</label> <input
					type="radio" name="employeeSex" value="男">男 <input
					type="radio" name="employeeSex" value="女">女
			</div>
			<div class="form-group">
				<label for="born" class="col-sm-2 control-label"> 出生年月</label> <input
					type="text" name="employeeBorn">
			</div>
			<div class="form-group">
				<label for="card" class="col-sm-2 control-label"> 身份证号</label> <input
					type="text" name="employeeCardnum">
			</div>
			<div class="form-group">
				<label for="school" class="col-sm-2 control-label"> 毕业院校</label> <input
					type="text" name="employeeSchool">
			</div>
			<div class="form-group">
				<label for="major" class="col-sm-2 control-label"> 所学专业</label> <input
					type="text" name="employeeMajor">
			</div>
			<div class="form-group">
				<label for="edu" class="col-sm-2 control-label"> 最高学历</label> <input
					type="text" name="employeeEducation">
			</div>
			<div class="form-group">
				<label for="family" class="col-sm-2 control-label"> 家庭住址</label> <input
					type="text" name="employeeFamilyAddress">
			</div>
			<div class="form-group">
				<label for="now" class="col-sm-2 control-label"> 现住址</label> <input
					type="text" name="employeeNowAddress">
			</div>
			<div class="form-group">
				<label for="telephone" class="col-sm-2 control-label"> 电话号码</label>
				<input type="text" name="employeeTelephone">
			</div>
			<div class="form-group">
				<label for="wechant" class="col-sm-2 control-label"> 微信号</label> <input
					type="text" name="employeeWechant">
			</div>
			<div class="form-group">
				<label for="qq" class="col-sm-2 control-label"> qq号</label> <input
					type="text" name="employeeQq">
			</div>
			<div class="form-group">
				<label for="work" class="col-sm-2 control-label"> 入职日期</label> <input
					type="text" name="employeeWorkedTime">
			</div>
			<div class="form-group">
				<label for="role" class="col-sm-2 control-label"> 现任岗位</label> <select
					name="roleId">
					<option value="0">请选择岗位</option>
					<c:forEach items="${roleList }" var="role">
						<option value="${role.roleId }">${role.roleName }</option>
					</c:forEach>
				</select>
			</div>
			<div class="col-sm-offset-2 col-sm-10">
				<input type="submit" name="submit" value="提交"
					class="btn btn-primary"> <a class="btn btn-primary"
					href="${pageContext.request.contextPath }/employee/view/back?pageNum=${pageNum}&employeeNameQuery=${employeeNameQuery}&roleNameQuery=${roleNameQuery}&deptNameQuery=${deptNameQuery}">返回上一级</a>
			</div>
		</form>
	</div>
</body>
</html>