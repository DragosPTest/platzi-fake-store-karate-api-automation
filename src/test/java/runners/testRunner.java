package runners;

import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

public class testRunner {
    @Karate.Test
    public Karate mainRunner()
    {
        Runner.path("classpath:features/users.feature")
                .tags("@Test");
               // .parallel(5);
                return Karate.run("classpath:features/users/users.feature").tags("@Test");
    }
}
