package com.yanxi.poxity.main;

public class Factory implements Sell {

	@Override
	public void sell() {
		System.out.println("factory sell");
	}

	@Override
	public void buy() {
		System.out.println("factory buy");
		
	}


}
