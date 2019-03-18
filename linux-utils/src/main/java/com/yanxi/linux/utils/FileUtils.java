package com.yanxi.linux.utils;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class FileUtils {
	public List<AnimRes> getAnimRes(File file) {
		List<AnimRes> res=new ArrayList<AnimRes>();
		if (file.exists()) {
			File[] listFiles = file.listFiles();
			for (File listFile : listFiles) {
				AnimRes animRes = new AnimRes();
				if (listFile.isFile()) {
					String resName = listFile.getName();
					long resSize =listFile.getFreeSpace();
					String resUpdatetime = CommonUtil.formatTime(listFile.lastModified());
					String resCreatetime = CommonUtil.getCreateTime(listFile);
					String resUrl = FastdfsUtils.uploadFile(listFile);
					String parentName = listFile.getParentFile().getName();
					animRes.setResName(resName);
					animRes.setIsdeleted(false);
					animRes.setResCreatetime(resCreatetime);
					animRes.setResUpdatetime(resUpdatetime);
					animRes.setResUrl(resUrl);
					animRes.setResSize((int) resSize);
					AnimResCatagorty resCatagorty=new AnimResCatagorty();
					resCatagorty.setResCatagortyName(parentName);
					animRes.setAnimResCatagorty(resCatagorty);
					res.add(animRes);
				} else {
					getAnimRes(listFile);
				}
			}
		}
		return res;
	}
}
