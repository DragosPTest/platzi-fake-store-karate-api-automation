package runners;

import com.intuit.karate.junit5.Karate;

public class scenarioRunner {
    @Karate.Test
    Karate scenarioRunner() {
        return Karate.run("classpath:features/auth/auth.feature").tags("@Test");
    }
}
