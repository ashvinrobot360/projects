import java.util.concurrent.*;

import com.google.common.util.concurrent.ThreadFactoryBuilder;
import java.util.*;

public class FutureResultProcessing{
  public static void main(String[] args){
    final int NUM = 10;
    final ThreadFactory threadFactory = new ThreadFactoryBuilder()
            .setNameFormat("Paapu %d")
            .setDaemon(false)
            .build();
    final ExecutorService executor = Executors.newFixedThreadPool(NUM, threadFactory);

    List<Future<ResultHolder>> resultList = new ArrayList<>();
    List<Test> inputList = new ArrayList<>();
    Random random = new Random();

    Test test;
    for (int i=0; i<NUM; i++)
    {
        Integer number = random.nextInt(10);
        test  = new Test(number);
        inputList.add(test);
        Future<ResultHolder> result = executor.submit(test);
        resultList.add(result);
    }
    int i =0;
    boolean allDone = false;
    while(!allDone)
    {
      for(i = 0; i < resultList.size(); i++){
      if(resultList.get(i).isDone()){
          try
          {
              System.out.println("And Task output is " + resultList.get(i).get());
              resultList.remove(i);
          }
          catch (InterruptedException | ExecutionException e)
          {
              e.printStackTrace();
          }
      }
      if(resultList.size() == 0){
        allDone = true;
      }
      }
    }
      //shut down the executor service now
      executor.shutdown();

    while (!executor.isTerminated()) {
      ;;
    }
    System.out.println("DONE!");
  }
}

class Test implements Callable<ResultHolder>{
  Integer i;
  String threadName;

   public Test(Integer i){
     this.i = i;
   }

  public ResultHolder call() throws Exception{
    threadName = Thread.currentThread().getName();
    System.out.println(Thread.currentThread().getName());
    Thread.sleep(i * 1000);
    ResultHolder rh = new ResultHolder(i, threadName);
    return rh;
  }

  public String toString(){
    return threadName;
  }
}

class ResultHolder {
    public Integer result;
    public String threadName;

    public ResultHolder(Integer r, String t){
      this.result = r;
      this.threadName = t;
    }
    public String toString(){
      return threadName + " " + result;
    }
}
