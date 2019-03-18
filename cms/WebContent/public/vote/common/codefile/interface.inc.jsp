<%@ page import = "jtbc.*" %>
<%@ page import = "jtbc.dbc.*" %>
<%
class module extends jpage
{
  private String Module_Action_Vote()
  {
    String tmpstr = "";
    Integer tVoteErrorState = 0;
    dbc tDbc = db.newInstance(conf);
    Integer tVoteId = cls.getNum(conf.getRequestParameter("id"), 0);
    Integer tCookiesVoteData = cls.getNum(cookies.getAttribute(conf, conf.getAppKey("vote-id-" + tVoteId)), 0);
    String tClientIP = cls.getSafeString(conf.getRemortIP());
    String tVoteData = cls.getSafeString(conf.getRequestUsParameters("vote_options_" + tVoteId));
    if (tVoteErrorState.equals(0))
    {
      if (tCookiesVoteData.equals(1))
      {
        tVoteErrorState = 1;
        tmpstr = conf.jt.itake("interface.vote-error-0", "lng");
      }
    }
    if (tVoteErrorState.equals(0))
    {
      if (cls.isEmpty(tVoteData))
      {
        tVoteErrorState = 1;
        tmpstr = conf.jt.itake("interface.vote-error-1", "lng");
      }
    }
    if (tVoteErrorState.equals(0))
    {
      String tdatabase = cls.getString(conf.jt.itake("config.ndatabase", "cfg"));
      String tfpre = cls.getString(conf.jt.itake("config.nfpre", "cfg"));
      String tidfield = cls.cfnames(tfpre, "id");
      String tsqlstr = "select * from " + tdatabase + " where " + tidfield + "=" + tVoteId;
      Object[] tArys = tDbc.getDataAry(tsqlstr);
      if (tArys != null)
      {
        Object[][] tAry = (Object[][])tArys[0];
        long tNowUnixStamp = cls.getUnixStamp();
        Integer tRsVType = cls.getNum(cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "vtype"))));
        String tRsStarttime = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "starttime")));
        String tRsEndtime = cls.toString(tDbc.getValue(tAry, cls.cfnames(tfpre, "endtime")));
        if (tRsVType.equals(0)) tVoteData = cls.toString(cls.getNum(tVoteData, 0));
        long tRsStarttimeUnixStamp = cls.getUnixStamp(tRsStarttime);
        long tRsEndtimeUnixStamp = cls.getUnixStamp(tRsEndtime);
        if (tRsEndtimeUnixStamp < tNowUnixStamp)
        {
          tVoteErrorState = 1;
          tmpstr = conf.jt.itake("interface.vote-error-2-1", "lng");
        }
        if (tRsStarttimeUnixStamp > tNowUnixStamp)
        {
          tVoteErrorState = 1;
          tmpstr = conf.jt.itake("interface.vote-error-2-2", "lng");
        }
      }
      else
      {
        tVoteErrorState = 1;
        tmpstr = conf.jt.itake("interface.vote-error-3", "lng");
      }
    }
    if (tVoteErrorState.equals(0))
    {
      String tdatabaseVoter = cls.getString(conf.jt.itake("config.ndatabase-voter", "cfg"));
      String tfpreVoter = cls.getString(conf.jt.itake("config.nfpre-voter", "cfg"));
      String tsqlstrVoter = "select * from " + tdatabaseVoter + " where " + cls.cfnames(tfpreVoter, "vote_id") + "=" + tVoteId + " and " + cls.cfnames(tfpreVoter, "voter_ip") + "='" + tClientIP + "'";
      Object[] tArysVoter = tDbc.getDataAry(tsqlstrVoter);
      if (tArysVoter != null) tmpstr = conf.jt.itake("interface.vote-error-4", "lng");
      else
      {
        if (cls.cidary(tVoteData))
        {
          cookies.setAttribute(conf, conf.getAppKey("vote-id-" + tVoteId), "1");
          String tdatabaseOptions = cls.getString(conf.jt.itake("config.ndatabase-options", "cfg"));
          String tfpreOptions = cls.getString(conf.jt.itake("config.nfpre-options", "cfg"));
          tDbc.Execute("update " + tdatabaseOptions + " set " + cls.cfnames(tfpreOptions, "vote_count") + "=" + cls.cfnames(tfpreOptions, "vote_count") + "+1 where " + cls.cfnames(tfpreOptions, "vote_id") + "=" + tVoteId + " and " + cls.cfnames(tfpreOptions, "id") + " in (" + tVoteData + ")");
          tDbc.Execute("insert into " + tdatabaseVoter + " (" + cls.cfnames(tfpreVoter, "vote_id") + "," + cls.cfnames(tfpreVoter, "voter_ip") + "," + cls.cfnames(tfpreVoter, "data") + "," + cls.cfnames(tfpreVoter, "time") + ") values (" + tVoteId + ",'" + cls.getLeft(encode.addslashes(tClientIP), 50) + "','" + cls.getLeft(encode.addslashes(tVoteData), 255) + "','" + cls.getDate() + "')");
          tmpstr = conf.jt.itake("interface.vote-done", "lng");
        }
      }
    }
    tmpstr = conf.ajaxPreContent + tmpstr;
    return tmpstr;
  }

  private String Module_Action()
  {
    String tmpstr = "";
    String tAtype = cls.getString(conf.getRequestUsParameter("atype"));
    if (tAtype.equals("vote")) tmpstr = Module_Action_Vote();
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