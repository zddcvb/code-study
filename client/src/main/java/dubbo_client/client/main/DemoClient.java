package dubbo_client.client.main;

import java.nio.channels.NonWritableChannelException;

import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * Hello world!
 *
 */
public class DemoClient 
{
    public static void main( String[] args )
    {
        System.out.println( "Hello World!" );
        ClassPathXmlApplicationContext context=new ClassPathXmlApplicationContext("application-context.xml");
       
    }
}
