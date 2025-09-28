package runners;

import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

public class testRunner {
    @Karate.Test
    public Karate mainRunner()
    {
        Runner.path("classpath:features/auth.feature")
                .tags("@regression");
                //.parallel(5);
                return Karate.run("classpath:features/auth/auth.feature").tags("@regression");
    }
}
