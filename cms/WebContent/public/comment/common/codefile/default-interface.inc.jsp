<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private String Module_Action_Add()
  {
    String tmpstr = "";
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
    if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tnusername = cls.getString(account.nusername);
    if (tnuserid == 0) tnusername = conf.jt.itake("config.dfmuusername", "lng");
    if (cls.isEmpty(tmpstr))
    {
      String tsqlstr = "insert into " + tdatabase + " (";
      tsqlstr += cls.cfnames(tfpre, "muusername") + ",";
      tsqlstr += cls.cfnames(tfpre, "muid") + ",";
      tsqlstr += cls.cfnames(tfpre, "ip") + ",";
      tsqlstr += cls.cfnames(tfpre, "content") + ",";
      tsqlstr += cls.cfnames(tfpre, "keyword") + ",";
      tsqlstr += cls.cfnames(tfpre, "fid") + ",";
      tsqlstr += cls.cfnames(tfpre, "time");
      tsqlstr += ") values (";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(tnusername), 50) + "',";
      tsqlstr += tnuserid + ",";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRemortIP()), 50) + "',";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("content")), 1000) + "',";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("keyword")), 50) + "',";
      tsqlstr += cls.getNum(conf.getRequestUsParameter("fid"), 0) + ",";
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
    account = new account(conf);
    account.Init(conf.jt.itake("config.naccount", "cfg"));
    account.UserInit();

    String tmpstr = "";
    String tType = cls.getString(conf.getRequestUsParameter("type"));
    if (tType.equals("action")) tmpstr = Module_Action();

    PageClose();
    return tmpstr;
  }
}
%>