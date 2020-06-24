import java.util.concurrent.*;

import com.google.common.util.concurrent.ThreadFactoryBuilder;

public class ThreadFactoryTest{
  public static void main(String[] args){

    final ThreadFactory threadFactory = new ThreadFactoryBuilder()
            .setNameFormat("Orders-%d")
            .setDaemon(false)
            .build();
    final ExecutorService executor = Executors.newFixedThreadPool(6, threadFactory);

    Test test = new Test();
       try{

         for(int i = 0; i < 10; i++){
           executor.submit(test);
         }

       }catch(Exception e){}

    executor.shutdown();
    while (!executor.isTerminated()) {

    }
    System.out.println("DONE!");
  }
}

 class Test implements Callable<Void>{


  public Void call() throws Exception{

    System.out.println(Thread.currentThread().getName());
    Thread.sleep(1000);
    return null;
  }


}
