package runners;

import com.intuit.karate.junit5.Karate;

public class scenarioTestRunner {
    @Karate.Test
    public Karate testSample() {
        return Karate.run("classpath:features/auth/auth.feature").tags("@Test");
    }
}
