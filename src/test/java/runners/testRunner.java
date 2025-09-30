package runners;
import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import org.junit.jupiter.api.Test;

public class testRunner {
    @Test
    void testParallel() {
        Results results = Runner.path("classpath:features/auth/auth.feature", "classpath:features/users/users.feature", "classpath:features/products/products.feature").tags("@regression").parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());

    }
}
