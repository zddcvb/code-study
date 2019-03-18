package com.yanxi.activemq.main;

import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Destination;
import javax.jms.MessageProducer;
import javax.jms.Session;
import javax.jms.TextMessage;
import org.apache.activemq.ActiveMQConnectionFactory;
import org.apache.activemq.command.ActiveMQTextMessage;

public class ActivemqPublishrMain {
	public static void main(String[] args) throws Exception {
		ConnectionFactory factory = new ActiveMQConnectionFactory();
		Connection connection = factory.createConnection();
		connection.start();
		Session session = connection.createSession(Boolean.TRUE, Session.AUTO_ACKNOWLEDGE);
		Destination destination = session.createTopic("my-topic");
		MessageProducer producer = session.createProducer(destination);
		for (int i = 0; i < 10; i++) {
			TextMessage textMessage = new ActiveMQTextMessage();
			textMessage.setText("topic_" + i);
			producer.send(textMessage);
			System.out.println(textMessage.getText());
		}
		session.commit();
		session.close();
		connection.close();
	}
}
