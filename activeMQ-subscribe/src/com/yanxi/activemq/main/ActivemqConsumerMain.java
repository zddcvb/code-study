package com.yanxi.activemq.main;

import javax.jms.Connection;
import javax.jms.ConnectionFactory;
import javax.jms.Message;
import javax.jms.MessageConsumer;
import javax.jms.Session;
import javax.jms.TextMessage;
import javax.jms.Topic;

import org.apache.activemq.ActiveMQConnectionFactory;

public class ActivemqConsumerMain {
	public static void main(String[] args) throws Exception {
		ConnectionFactory factory = new ActiveMQConnectionFactory();
		Connection connection = factory.createConnection();
		connection.setClientID("tt2");
		
		final Session session = connection.createSession(Boolean.TRUE, Session.AUTO_ACKNOWLEDGE);
		Topic destination = session.createTopic("my-topic");
		MessageConsumer subscriber = session.createDurableSubscriber(destination, "t2");
		connection.start();
		Message message = subscriber.receive();
		while(message!=null){
			TextMessage textMessage = (TextMessage) message;
			session.commit();
			System.out.println("收到消息："+textMessage.getText());
			message=subscriber.receive();
		}
		session.close();
		connection.close();
	}
}
