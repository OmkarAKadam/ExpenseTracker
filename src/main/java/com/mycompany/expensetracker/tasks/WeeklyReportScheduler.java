package com.mycompany.expensetracker.tasks;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

@WebListener
public class WeeklyReportScheduler implements ServletContextListener {

    private ScheduledExecutorService executor;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🕒 WeeklyReportScheduler initialized...");

        executor = Executors.newSingleThreadScheduledExecutor(); // NON-DAEMON → keeps server alive

        TimeZone tz = TimeZone.getTimeZone("Asia/Kolkata");
        Calendar cal = Calendar.getInstance(tz);

        cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);
        cal.set(Calendar.HOUR_OF_DAY, 10);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);

        Date now = new Date();
        Date firstRun = cal.getTime();

        if (firstRun.before(now)) {
            cal.add(Calendar.WEEK_OF_YEAR, 1); // Next week
            firstRun = cal.getTime();
        }

        long delay = firstRun.getTime() - now.getTime();
        long period = 7L * 24 * 60 * 60 * 1000; // Every 7 days

        executor.scheduleAtFixedRate(
                new WeeklyReportTask(),
                delay,
                period,
                TimeUnit.MILLISECONDS
        );

        System.out.println("✅ WeeklyReportTask scheduled. First run at: " + firstRun);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (executor != null && !executor.isShutdown()) {
            executor.shutdownNow();
            System.out.println("🛑 WeeklyReportScheduler stopped.");
        }
    }
}
