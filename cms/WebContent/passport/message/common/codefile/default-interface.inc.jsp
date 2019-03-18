<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private String Module_Action_Manage_Add()
  {
    String tmpstr = "";
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tnusername = cls.getString(account.nusername);
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    String truusername = cls.getString(conf.getRequestUsParameter("ruusername"));
    String tvalcode = cls.getString(conf.getRequestUsParameter("valcode"));
    if (!conf.common.ckValcodes(tvalcode)) tmpstr = conf.jt.itake("global.lng_common.valcode-error-1", "lng");
    Integer truid = account.getUserID(truusername);
    if (truid == 0) tmpstr = conf.jt.itake("default.add-error-1", "lng");
    Integer tnmaxmessage = cls.getNum(conf.jt.itake("config.nmaxmessage", "cfg"), 0);
    String tsqlstr = "select count(*) from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + " = 0 and " + cls.cfnames(tfpre, "ruid") + "=" + truid;
    dbc tDbc = db.newInstance(conf);
    Object[] tArys = tDbc.getDataAry(tsqlstr);
    if (tArys != null)
    {
      Object[][] tAry = (Object[][])tArys[0];
      Long trscount = cls.getNum64(cls.toString(tDbc.getValue(tAry, 0)));
      if (trscount >= tnmaxmessage) tmpstr = conf.jt.itake("default.add-error-2", "lng");
    }
    if (cls.isEmpty(tmpstr) && tnuserid != 0)
    {
      tsqlstr = "insert into " + tdatabase + " (";
      tsqlstr += cls.cfnames(tfpre, "topic") + ",";
      tsqlstr += cls.cfnames(tfpre, "content") + ",";
      tsqlstr += cls.cfnames(tfpre, "auid") + ",";
      tsqlstr += cls.cfnames(tfpre, "auusername") + ",";
      tsqlstr += cls.cfnames(tfpre, "ruid") + ",";
      tsqlstr += cls.cfnames(tfpre, "ruusername") + ",";
      tsqlstr += cls.cfnames(tfpre, "time");
      tsqlstr += ") values (";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("topic")), 50) + "',";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.common.repathdecode(conf.getRequestUsParameter("content"))), 10000) + "',";
      tsqlstr += tnuserid + ",";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(tnusername), 50) + "',";
      tsqlstr += truid + ",";
      tsqlstr += "'" + cls.getLeft(encode.addslashes(truusername), 50) + "',";
      tsqlstr += "'" + cls.getDate() + "'";
      tsqlstr += ")";
      int tstateNum = tDbc.Executes(tsqlstr);
      if (tstateNum != -101) tmpstr = conf.jt.itake("default.add-succeed", "lng");
      else tmpstr = conf.jt.itake("default.add-failed", "lng");
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Manage_Delete()
  {
    String tmpstr = "";
    String tstate = "200";
    Integer tnuserid = cls.getNum(account.nuserid, 0);
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
    String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
    String tidfield = cls.cfnames(tfpre, "id");
    int tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids, " and " + cls.cfnames(tfpre, "ruid") + "=" + tnuserid);
    if (tstateNum == -101) tstate = "-101";
    tmpstr = conf.ajaxPreContent + tstate;
    return tmpstr;
  }

  private String Module_Action_Manage()
  {
    String tmpstr = "";
    String tMtype = cls.getString(conf.getRequestUsParameter("mtype"));
    if (tMtype.equals("add")) tmpstr = Module_Action_Manage_Add();
    else if (tMtype.equals("delete")) tmpstr = Module_Action_Manage_Delete();
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("manage")) tmpstr = Module_Action_Manage();
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