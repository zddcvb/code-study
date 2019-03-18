<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
<link rel="StyleSheet" href="css/dtree.css" type="text/css" />
<script type="text/javascript" src="js/dtree.js"></script>
<script type="text/javascript">
	function init() {
		d = new dTree('d');
		d.add(id, pid, name, url, title, target, icon, iconOpen, open)
		d.add(0, -1, "计算机","","","right");//根节点
		d.add(1, 0, "disk c","","","right");
		d.add(2, 0, "disk d","","","right");
		d.add(3, 0, "disk e","","","right");
		d.add(4, 0, "disk f","","","right");
		d.add(5, 1, "Intel","http://www.baidu.com","","right");
		d.add(6, 1, "Windows","","","right");
		document.write(d);
	}
</script>
</head>
<body onload="init()">
	<div id="dtree"></div>
</body>
</html>