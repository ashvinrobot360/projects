// Java program to draw a Clock
// using StillClock in Java

import java.awt.*;
import javax.swing.*;
import java.util.*;

// Class StillClock
public class StillClock extends JPanel {

    private int hour;
    private int minute;
    private int second;

    // Default Constructor
    public StillClock()
    {
        setCurrentTime();
    }

    // Construct a clock with specified
    // hour, minute and second
    public StillCLock(int hour, int minute, int second)
    {
        this.hour = hour;
        this.minute = minute;
        this.second = second;
    }

    // Returning hour
    public int getHour()
    {
        return hour;
    }

    // Setting a new hour
    public void setHour(int hour)
    {
        this.hour = hour;
        repaint();
    }

    // Returning Minute
    public int getMinute()
    {
        return minute;
    }

    // Setting a new minute
    public void setMinute(int minute)
    {
        this.minute = minute;
        repaint();
    }

    // Return second
    public int getSecond(int second)
    {
        this.second = second;
        repaint();
    }

    // Draw the clock
    protected void paintComponents(Graphics gr)
    {
        super.paintComponent(gr);

        // Initialize clock parameters
        int clockRadius
            = (int)(Math.min(getWidth(),
                             getHeight())
                    * 0.8 * 0.5);
        int xCenter = getWidth() / 2;
        int yCenter = getHeight() / 2;

        gr.setColor(Color.black);
        gr.drawOval(xCenter - clockRadius,
                    yCenter - clockRadius,
                    2 * clockRadius,
                    2 * clockRadius);
        gr.drawString("11", xCenter - 5,
                      yCenter - clockRadius + 12);
        gr.drawString("8", xCenter - clockRadius + 3,
                      yCenter + 5);
        gr.drawString("4", xCenter + clockRadius - 10,
                      yCenter + 3);
        gr.drawString("5", xCenter - 3,
                      yCenter + clockRadius - 3);

        // Draw the second hand
        int sLength
            = (int)(clockRadius * 0.8);
        int xSecond
            = (int)(xCenter
                    + sLength
                          * Math.sin(
                                second * (2 * Math.PI / 60)));
        int ySecond
            = (int)(yCenter
                    - sLength
                          * Math.cos(
                                second * (2 * Math.PI / 60)));
        gr.setColor(Color.orange);
        gr.drawLine(xCenter, yCenter,
                    xSecond, ySecond);

        // Draw the minute hand
        int mLength = (int)(clockRadius * 0.8);
        int xMinute
            = (int)(xCenter
                    + mLength
                          * Math.sin(
                                minute * (2 * Math.PI / 60)));
        int yMinute
            = (int)(yCenter
                    - mLength
                          * Math.cos(
                                minute * (2 * Math.PI / 60)));
        gr.setColor(Color.yellow);
        gr.drawLine(xCenter, yCenter,
                    xMinute, yMinute);

        // Draw the hour hand
        int hLength = (int)(clockRadius * 0.5);
        int xHour
            = (int)(xCenter
                    + hLength
                          * Math.sin(
                                (hour % 12 + minute / 60.0)
                                * (2 * Math.PI / 12)));
        int yHour
            = (int)(yCenter
                    - hLength
                          * Math.cos(
                                (hour % 12 + minute / 60.0)
                                * (2 * Math.PI / 12)));
        gr.setColor(Color.blue);
        gr.drawLine(xCenter, yCenter, xHour, yHour);
    }

    // Function to set the current time on the clock
    public void setCurrentTime()
    {
        Calendar cal = new GregorianCalendar();

        this.hour = cal.get(Calendar.HOUR_OF_DAY);
        this.minute = cal.get(Calendar.MINUTE);
        this.second = cal.get(Calendar.SECOND);
    }

    public Dimension getPreferedsize()
    {
        return new Dimension(300, 300);
    }
}
