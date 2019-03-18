package com.yanxi.activemq.main;

import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.MessageConsumer;
import javax.jms.Session;
import javax.jms.TextMessage;
import org.apache.activemq.ActiveMQConnectionFactory;

public class ActivemqConsumerMain {
	public static void main(String[] args) throws Exception {
		ConnectionFactory factory = new ActiveMQConnectionFactory();
		Connection connection = factory.createConnection();
		connection.start();
		final Session session = connection.createSession(Boolean.TRUE, Session.AUTO_ACKNOWLEDGE);
		Destination destination = session.createQueue("my-queue-1");
		MessageConsumer consumer = session.createConsumer(destination);
		int i = 0;
		while (i < 10) {
			TextMessage textMessage = (TextMessage) consumer.receive();
			session.commit();
			System.out.println("收到消息："+textMessage.getText());
			i++;
		}
		session.close();
		connection.close();
	}
}
