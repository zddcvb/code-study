<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<table>
		<tr>
			<td>用户名</td>
			<td>密码</td>
		</tr>
		<!-- 不写value，默认遍历栈顶元素 -->
		<s:iterator value="#persons" var="p" status="st">

			<tr>
				<td><s:property value="#p.value.username"></s:property></td>
				<td><s:property value="#p.value.password"></s:property></td>
			</tr>
			<s:property value="#st.getCount()" />
			<br />
			<s:property value="#st.getIndex()" />
			<br />
			<s:property value="#st.isEven()" />
			<br />
			<s:property value="#st.isOdd()" />
			<br />
			<s:property value="#st.isFirst()" />
			<br />
			<s:property value="#st.isLast()" />
			<br />

		</s:iterator>

	</table>

</body>
</html>