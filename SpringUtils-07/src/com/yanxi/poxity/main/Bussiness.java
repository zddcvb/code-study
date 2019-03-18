package com.yanxi.poxity.main;

public class Bussiness implements Sell {
	private boolean flag = true;
	private Factory factory = new Factory();

	@Override
	public void sell() {
		if (flag) {
			factory.sell();
		}
	}

	@Override
	public void buy() {
		
	}
}
