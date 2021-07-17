package conduitApp;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;


public class ConduitTest {

    @Test
    public void testParallel() {
        Results results = Runner.path("classpath:conduitApp/feature").parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
