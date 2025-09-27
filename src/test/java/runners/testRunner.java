package runners;

import com.intuit.karate.junit5.Karate;

public class testRunner {
    @Karate.Test
    public Karate fileUploadRunnerFeature() {
        return Karate.run("classpath:features/users/users.feature");
    }
}
