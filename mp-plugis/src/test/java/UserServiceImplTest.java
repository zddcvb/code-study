
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.yanxi.mp.service.UserService;

public class UserServiceImplTest {
	ApplicationContext context = new ClassPathXmlApplicationContext("classpath:applicationContext-mybatis.xml");
	UserService userService = (UserService) context.getBean("userService");;

	@Test
	public void test() {
		System.out.println(userService);
	}

}
