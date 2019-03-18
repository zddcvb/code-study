<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private account account;

  private String PP_CheckManager(String argManagers)
  {
    String tManager = "0";
    String tManagers = argManagers;
    String tUserGroup = cls.toString(account.getUserInfo("group"));
    if (tUserGroup.equals("999")) tManager = "999";
    else
    {
      if (cls.cinstr(tManagers, account.nusername, ",")) tManager = "1";
    }
    return tManager;
  }

  private String Module_Action_Switch()
  {
    String tmpstr = "200";
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    String tswcolor = cls.getString(conf.getRequestUsParameter("swcolor"));
    String tswstrong = cls.getString(conf.getRequestUsParameter("swstrong"));
    Integer tClass = cls.getNum(conf.getRequestParameter("class"), -1);
    if (account.checkUserLogin())
    {
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      dbc tDbc = db.newInstance(conf);
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tClass;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
        String tCheckManager = PP_CheckManager(tForumManager);
        if (!tCheckManager.equals("0"))
        {
          Integer tstateNum = 0;
          tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
          tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
          tidfield = cls.cfnames(tfpre, "id");
          if (tswtype.equals("htop"))
          {
            if (tCheckManager.equals("999")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "htop"), tidfield, tids, " and " + cls.cfnames(tfpre, "class") + "=" + tClass);
          }
          else if (tswtype.equals("top")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "top"), tidfield, tids, " and " + cls.cfnames(tfpre, "class") + "=" + tClass);
          else if (tswtype.equals("elite")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "elite"), tidfield, tids, " and " + cls.cfnames(tfpre, "class") + "=" + tClass);
          else if (tswtype.equals("lock")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "lock"), tidfield, tids, " and " + cls.cfnames(tfpre, "class") + "=" + tClass);
          else if (tswtype.equals("hidden")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "hidden"), tidfield, tids, " and " + cls.cfnames(tfpre, "class") + "=" + tClass);
          if (tstateNum == -101) tmpstr = "-101";
          else
          {
            if (cls.cidary(tids))
            {
              tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "strong") + "=" + cls.getNum(tswstrong, 0) + " where " + cls.cfnames(tfpre, "class") + "=" + tClass + " and " + tidfield + " in (" + tids + ")");
              tDbc.Execute("update " + tdatabase + " set " + cls.cfnames(tfpre, "color") + "='" + cls.getLeft(encode.addslashes(tswcolor), 50) + "' where " + cls.cfnames(tfpre, "class") + "=" + tClass + " and " + tidfield + " in (" + tids + ")");
            }
          }
        }
      }
    }
    return tmpstr;
  }

  private String Module_Action_Switch2()
  {
    String tmpstr = "200";
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    Integer tClass = cls.getNum(conf.getRequestParameter("class"), -1);
    if (account.checkUserLogin())
    {
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      dbc tDbc = db.newInstance(conf);
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tClass;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
        String tCheckManager = PP_CheckManager(tForumManager);
        if (!tCheckManager.equals("0"))
        {
          Integer tstateNum = 0;
          tdatabase = cls.getString(conf.jt.itake("config.ndatabase-topic", "cfg"));
          tfpre = cls.getString(conf.jt.itake("config.nfpre-topic", "cfg"));
          tidfield = cls.cfnames(tfpre, "id");
          if (tswtype.equals("hidden")) tstateNum = conf.common.dataSwitch(tdatabase, cls.cfnames(tfpre, "hidden"), tidfield, tids, " and " + cls.cfnames(tfpre, "class") + "=" + tClass);
          if (tstateNum == -101) tmpstr = "-101";
        }
      }
    }
    return tmpstr;
  }

  private String Module_Action_Blacklist_Add()
  {
    String tmpstr = "";
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    Integer tFid = cls.getNum(conf.getRequestParameter("fid"), -1);
    if (account.checkUserLogin())
    {
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      dbc tDbc = db.newInstance(conf);
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tFid;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
        String tCheckManager = PP_CheckManager(tForumManager);
        if (!tCheckManager.equals("0"))
        {
          tdatabase = cls.getString(conf.jt.itake("config.ndatabase-blacklist", "cfg"));
          tfpre = cls.getString(conf.jt.itake("config.nfpre-blacklist", "cfg"));
          tidfield = cls.cfnames(tfpre, "id");
          String tBLUsername = cls.getString(conf.getRequestUsParameter("username"));
          Integer tBLUid = account.getUserID(tBLUsername);
          String tBLRemark = cls.getString(conf.getRequestUsParameter("remark"));
          if (tBLUid == 0) tmpstr = conf.jt.itake("manager.blacklist-add-error-1", "lng");
          if (cls.isEmpty(tmpstr) && cls.isEmpty(tBLRemark)) tmpstr = conf.jt.itake("manager.blacklist-add-error-2", "lng");
          if (cls.isEmpty(tmpstr))
          {
            tsqlstr = "insert into " + tdatabase + " (";
            tsqlstr += cls.cfnames(tfpre, "username") + ",";
            tsqlstr += cls.cfnames(tfpre, "uid") + ",";
            tsqlstr += cls.cfnames(tfpre, "fid") + ",";
            tsqlstr += cls.cfnames(tfpre, "manager") + ",";
            tsqlstr += cls.cfnames(tfpre, "time") + ",";
            tsqlstr += cls.cfnames(tfpre, "remark");
            tsqlstr += ") values (";
            tsqlstr += "'" + cls.getLeft(encode.addslashes(tBLUsername), 50) + "',";
            tsqlstr += tBLUid + ",";
            tsqlstr += tFid + ",";
            tsqlstr += "'" + cls.getLeft(encode.addslashes(account.nusername), 50) + "',";
            tsqlstr += "'" + cls.getDate() + "',";
            tsqlstr += "'" + cls.getLeft(encode.addslashes(conf.getRequestUsParameter("remark")), 255) + "'";
            tsqlstr += ")";
            int tstateNum = tDbc.Executes(tsqlstr);
            if (tstateNum != -101) tmpstr = conf.jt.itake("manager.blacklist-add-succeed", "lng");
            else tmpstr = conf.jt.itake("manager.blacklist-add-failed", "lng");
          }
        }
        else tmpstr = conf.jt.itake("manager.popedom-error-1", "lng");
      }
      else tmpstr = conf.jt.itake("manager.notexist-error-1", "lng");
    }
    else tmpstr = conf.jt.itake("manager.login-error-1", "lng");
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action_Blacklist_Switch()
  {
    String tmpstr = "200";
    String tNLng = conf.getNLng();
    String tNGenre = conf.getNGenre();
    String tids = cls.getString(conf.getRequestUsParameter("ids"));
    String tswtype = cls.getString(conf.getRequestUsParameter("swtype"));
    Integer tFid = cls.getNum(conf.getRequestParameter("class"), -1);
    if (account.checkUserLogin())
    {
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase-category", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre-category", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      dbc tDbc = db.newInstance(conf);
      String tsqlstr = "select * from " + tdatabase + " where " + cls.cfnames(tfpre, "hidden") + "=0 and " + cls.cfnames(tfpre, "fid") + "<>0 and " + cls.cfnames(tfpre, "lng") + "=" + tNLng + " and " + tidfield + "=" + tFid;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        String tForumManager = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "manager")));
        String tCheckManager = PP_CheckManager(tForumManager);
        if (!tCheckManager.equals("0"))
        {
          Integer tstateNum = 0;
          tdatabase = cls.getString(conf.jt.itake("config.ndatabase-blacklist", "cfg"));
          tfpre = cls.getString(conf.jt.itake("config.nfpre-blacklist", "cfg"));
          tidfield = cls.cfnames(tfpre, "id");
          if (tswtype.equals("delete")) tstateNum = conf.common.dataDelete(tdatabase, tidfield, tids, " and " + cls.cfnames(tfpre, "fid") + "=" + tFid);
          if (tstateNum == -101) tmpstr = "-101";
        }
      }
    }
    return tmpstr;
  }

  private String Module_Action_Blacklist()
  {
    String tmpstr = "";
    String tBtype = cls.getString(conf.getRequestUsParameter("btype"));
    if (tBtype.equals("add")) tmpstr = Module_Action_Blacklist_Add();
    else if (tBtype.equals("switch")) tmpstr = Module_Action_Blacklist_Switch();
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("switch")) tmpstr = Module_Action_Switch();
    else if (tAtype.equals("switch2")) tmpstr = Module_Action_Switch2();
    else if (tAtype.equals("blacklist")) tmpstr = Module_Action_Blacklist();
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