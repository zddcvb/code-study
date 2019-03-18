<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private String Module_Action_Add()
  {
    String tmpstr = "";
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
    if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
    //******************************************************************************************
    if (cls.isEmpty(tmpstr))
    {
      try
      {
        String tKey = cls.getString(conf.getRequestUsParameter("key"));
        tKey = new String(encode.base64decode(tKey));
        String tKeyT = cls.getParameter(tKey, "t");
        String tKeyK = cls.getParameter(tKey, "k");
        if (!tKeyK.equals(encode.md5(("jetiben-" + tKeyT).getBytes()))) tmpstr = conf.jt.itake("default.add-error-1", "lng");
        if (cls.isEmpty(tmpstr) && cls.getDate().equals(cls.getDate(tKeyT))) tmpstr = conf.jt.itake("default.add-error-2", "lng");
        if (cls.isEmpty(tmpstr))
        {
          long tNowUnixStamp = cls.getUnixStamp();
          long tReqUnixStamp = cls.getUnixStamp(tKeyT);
          if (tNowUnixStamp - tReqUnixStamp > 7200) tmpstr = conf.jt.itake("default.add-error-3", "lng");
        }
      }
      catch(Exception e) {}
    }
    //******************************************************************************************
    if (cls.isEmpty(tmpstr))
    {
      String tsqlstr = "insert into " + tdatabase + " (";
      tsqlstr += cls.cfnames(tfpre, "topic") + ",";
      tsqlstr += cls.cfnames(tfpre, "name") + ",";
      tsqlstr += cls.cfnames(tfpre, "face") + ",";
      tsqlstr += cls.cfnames(tfpre, "email") + ",";
      tsqlstr += cls.cfnames(tfpre, "content") + ",";
      tsqlstr += cls.cfnames(tfpre, "ip") + ",";
      tsqlstr += cls.cfnames(tfpre, "time");
      tsqlstr += ") values (";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("name")), 50) + "',";
      tsqlstr += cls.getNum(conf.getRequestUsParameter("face"), 0) + ",";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("email")), 50) + "',";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.common.repathencode(conf.getRequestUsParameter("content"))), 10000) + "',";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRemortIP()), 50) + "',";
      tsqlstr += "'" + cls.getDate() + "'";
      tsqlstr += ")";
      dbc tDbc = db.newInstance(conf);
      int tstateNum = tDbc.Executes(tsqlstr);
      if (tstateNum != -101) tmpstr = conf.jt.itake("default.add-succeed", "lng");
      else tmpstr = conf.jt.itake("default.add-failed", "lng");
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("add")) tmpstr = Module_Action_Add();
    return tmpstr;
  }

  public String getOutput()
  {
    PageInit();
    PageNoCache();

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestUsParameter("type"));
    if (tType.equals("action")) tmpstr = Module_Action();

    PageClose();
    return tmpstr;
  }
}
%>