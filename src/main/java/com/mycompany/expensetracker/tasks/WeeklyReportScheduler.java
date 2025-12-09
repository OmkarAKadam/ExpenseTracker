package com.mycompany.expensetracker.tasks;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.Calendar;
import java.util.Date;
import java.util.Timer;
import java.util.TimeZone;

@WebListener
public class WeeklyReportScheduler implements ServletContextListener {

    private Timer timer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("🕒 WeeklyReportScheduler initialized...");

        timer = new Timer(true);

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
            cal.add(Calendar.WEEK_OF_YEAR, 1);
            firstRun = cal.getTime();
        }

        long oneWeekMillis = 7L * 24 * 60 * 60 * 1000;

        timer.scheduleAtFixedRate(
                new WeeklyReportTask(),
                firstRun,
                oneWeekMillis
        );

        System.out.println("✅ WeeklyReportTask scheduled. First run at: " + firstRun);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (timer != null) {
            timer.cancel();
            System.out.println("🛑 WeeklyReportScheduler stopped.");
        }
    }
}
