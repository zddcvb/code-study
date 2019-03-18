package com.yanxi.linux.utils;

public class AnimResCatagorty {
	private String resCatagortyId;

	private String resCatagortyName;

	private String resCatagortyCreatetime;

	private String resCatagortyUpdatetime;

	private Boolean isdeleted;

	private String parentId;

	private AnimResCatagorty parent;

	public String getResCatagortyId() {
		return resCatagortyId;
	}

	public void setResCatagortyId(String resCatagortyId) {
		this.resCatagortyId = resCatagortyId == null ? null : resCatagortyId.trim();
	}

	public String getResCatagortyName() {
		return resCatagortyName;
	}

	public void setResCatagortyName(String resCatagortyName) {
		this.resCatagortyName = resCatagortyName == null ? null : resCatagortyName.trim();
	}

	public String getResCatagortyCreatetime() {
		return resCatagortyCreatetime;
	}

	public void setResCatagortyCreatetime(String resCatagortyCreatetime) {
		this.resCatagortyCreatetime = resCatagortyCreatetime == null ? null : resCatagortyCreatetime.trim();
	}

	public String getResCatagortyUpdatetime() {
		return resCatagortyUpdatetime;
	}

	public void setResCatagortyUpdatetime(String resCatagortyUpdatetime) {
		this.resCatagortyUpdatetime = resCatagortyUpdatetime == null ? null : resCatagortyUpdatetime.trim();
	}

	public Boolean getIsdeleted() {
		return isdeleted;
	}

	public void setIsdeleted(Boolean isdeleted) {
		this.isdeleted = isdeleted;
	}

	public String getParentId() {
		return parentId;
	}

	public void setParentId(String parentId) {
		this.parentId = parentId == null ? null : parentId.trim();
	}

	public AnimResCatagorty getParent() {
		return parent;
	}

	public void setParent(AnimResCatagorty parent) {
		this.parent = parent;
	}

	@Override
	public String toString() {
		return "AnimResCatagorty [resCatagortyId=" + resCatagortyId + ", resCatagortyName=" + resCatagortyName
				+ ", resCatagortyCreatetime=" + resCatagortyCreatetime + ", resCatagortyUpdatetime="
				+ resCatagortyUpdatetime + ", isdeleted=" + isdeleted + ", parentId=" + parentId + ", parent=" + parent
				+ "]";
	}

}