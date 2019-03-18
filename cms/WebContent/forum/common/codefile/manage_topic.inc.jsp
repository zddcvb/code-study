<%@ page import = "jtbc.*" %>
<%
class module extends jpage
{
  public String getOutput()
  {
    PageInit();
    String tmpstr = "";
    tmpstr = conf.jt.itake("manage_topic.default", "tpl");
    tmpstr = conf.jt.creplace(tmpstr);
    PageClose();
    return tmpstr;
  }
}
%>