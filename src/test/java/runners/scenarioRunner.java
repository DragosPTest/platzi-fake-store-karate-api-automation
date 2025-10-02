package runners;

import com.intuit.karate.junit5.Karate;

public class scenarioRunner {
    @Karate.Test
    public Karate scenarioRunner() {
        return Karate.run("classpath:features/products/products.feature").tags("@Test");
    }
}
