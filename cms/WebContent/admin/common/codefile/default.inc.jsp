<%@ page import = "jtbc.*" %>
<%
class module extends jpage
{
  public String getOutput()
  {
    PageInit();
    String tmpstr = "";
    tmpstr = conf.jt.itake("default.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    PageClose();
    return tmpstr;
  }
}
%>