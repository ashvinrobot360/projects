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
import java.util.concurrent.*;
import java.util.Arrays;
import java.lang.String.*;
import java.text.SimpleDateFormat;

public class SleepThreadPool{
  public static void main(String[] args){
    MyThread[] myThreads = new MyThread[10];
    Random random = new Random();

    Callable<Integer> worker = new MyThread(1000);
    Callable<Integer> worker2 = new MyThread(1000);
    ExecutorService execService = Executors.newFixedThreadPool(2);
    Future<Integer> future = execService.submit(worker);
    Future<Integer> future2 = execService.submit(worker2);
    try{
      System.out.println(future.get());
      System.out.println(future2.get());
  }catch(Exception e){
    System.out.println("Exception Caught!");
  }
  execService.shutdown();
  }
 }

class MyThread implements Callable<Integer>{
    int milliseconds = 0;
    public MyThread(int milliseconds){
      this.milliseconds = milliseconds;
    }
    public Integer call() throws Exception{
      try{
        Thread.sleep(milliseconds);
        System.out.println( Thread.currentThread().getId() + " finished sleeping at " + timeCalc()) ;
        return (Integer)milliseconds;
      }catch(InterruptedException e){
        System.out.println("Exception Caught!");
      }
      return (Integer)0;
    }

    public String timeCalc(){
      SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
      Date date = new Date();
      return (formatter.format(date));
    }

}
