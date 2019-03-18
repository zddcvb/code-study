package com.yanxi.linux.utils;

public class AnimRes {
	private String resId;

	private String resName;

	private String resUrl;

	private Integer resSize;

	private String resCreatetime;

	private String resUpdatetime;

	private Boolean isdeleted;

	private String resCatagortyId;

	private AnimResCatagorty animResCatagorty;

	public String getResId() {
		return resId;
	}

	public void setResId(String resId) {
		this.resId = resId == null ? null : resId.trim();
	}

	public String getResName() {
		return resName;
	}

	public void setResName(String resName) {
		this.resName = resName == null ? null : resName.trim();
	}

	public String getResUrl() {
		return resUrl;
	}

	public void setResUrl(String resUrl) {
		this.resUrl = resUrl == null ? null : resUrl.trim();
	}

	public Integer getResSize() {
		return resSize;
	}

	public void setResSize(Integer resSize) {
		this.resSize = resSize;
	}

	public String getResCreatetime() {
		return resCreatetime;
	}

	public void setResCreatetime(String resCreatetime) {
		this.resCreatetime = resCreatetime == null ? null : resCreatetime.trim();
	}

	public String getResUpdatetime() {
		return resUpdatetime;
	}

	public void setResUpdatetime(String resUpdatetime) {
		this.resUpdatetime = resUpdatetime == null ? null : resUpdatetime.trim();
	}

	public Boolean getIsdeleted() {
		return isdeleted;
	}

	public void setIsdeleted(Boolean isdeleted) {
		this.isdeleted = isdeleted;
	}

	public String getResCatagortyId() {
		return resCatagortyId;
	}

	public void setResCatagortyId(String resCatagortyId) {
		this.resCatagortyId = resCatagortyId == null ? null : resCatagortyId.trim();
	}

	public AnimResCatagorty getAnimResCatagorty() {
		return animResCatagorty;
	}

	public void setAnimResCatagorty(AnimResCatagorty animResCatagorty) {
		this.animResCatagorty = animResCatagorty;
	}

	@Override
	public String toString() {
		return "AnimRes [resId=" + resId + ", resName=" + resName + ", resUrl=" + resUrl + ", resSize=" + resSize
				+ ", resCreatetime=" + resCreatetime + ", resUpdatetime=" + resUpdatetime + ", isdeleted=" + isdeleted
				+ ", resCatagortyId=" + resCatagortyId + ", animResCatagorty=" + animResCatagorty + "]";
	}

}