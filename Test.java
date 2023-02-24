import jdk.crac.Core;
import jdk.crac.management.*;
import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;

public class Test {

     public static void main(String args[]) throws Exception {
        CRaCMXBean cracMXBean = CRaCMXBean.getCRaCMXBean();
        Core.checkpointRestore();
        final long uptime = cracMXBean.getUptimeSinceRestore();
        System.out.println("finish");
        System.out.println("UptimeSinceRestore: " + uptime + " ms");
    }
}

