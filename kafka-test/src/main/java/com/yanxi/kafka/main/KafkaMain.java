package com.yanxi.kafka.main;

public class KafkaMain {
	public static void main(String[] args) {
		JProducer pro = new JProducer(KafkaConfiguration.TOPIC);
		pro.start();

		JConsumer con = new JConsumer(KafkaConfiguration.TOPIC);
		con.start();
	}
}
