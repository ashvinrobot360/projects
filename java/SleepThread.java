/*Group together words that are each others anagram.

For instance given this list of words:
PANS
POTS
OPT
SNAP
STOP
TOPS

Produce the following output:

PANS, SNAP
OPT
POTS, STOP, TOPS
*/
import java.util.*;
import java.util.Arrays;
import java.lang.String.*;
import java.text.SimpleDateFormat;

public class SleepThread{
  public static void main(String[] args){
    MyThread[] myThreads = new MyThread[10];
    Random random = new Random();

    for(int i = 1; i < 10; i++){
      myThreads[i] = new MyThread( random.nextInt(9000) );
      myThreads[i].start();
      System.out.println(myThreads[i].getId());
    }
  }
 }

class MyThread extends Thread{
    int milliseconds = 0;
    public MyThread(int milliseconds){
      this.milliseconds = milliseconds;
    }
    public void run() {
      try{
        Thread.sleep(milliseconds);
        System.out.println( this.getId() + " died at " + timeCalc()) ;
      }catch(InterruptedException e){
        System.out.println("Exception Caught!");
      }
    }

    public String timeCalc(){
      SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
      Date date = new Date();
      return (formatter.format(date));
    }

}
