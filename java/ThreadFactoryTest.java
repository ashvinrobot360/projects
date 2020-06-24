import java.util.concurrent.*;

import com.google.common.util.concurrent.ThreadFactoryBuilder;

public class ThreadFactoryTest{
  public static void main(String[] args){

    final ThreadFactory threadFactory = new ThreadFactoryBuilder()
            .setNameFormat("Thread%d")
            .setDaemon(true)
            .build();
    final ExecutorService executor = Executors.newFixedThreadPool(20, threadFactory);

    Test test = new Test();
       try{

         for(int i = 0; i < 20; i++){
           executor.submit(test);
           System.out.println(((ThreadPoolExecutor)executor).getActiveCount());
         }

       }catch(Exception e){}

    executor.shutdown();
    while (!executor.isTerminated()) {
      ;;
    }
    System.out.println("DONE!");
  }
}

 class Test implements Callable<Void>{


  public Void call() throws Exception{

    System.out.println(Thread.currentThread().getName());
    Thread.sleep(20000);
    return null;
  }


}

//
// class MyFutureTask extends FutureTask<V>{
//   public MyFutureTask(Callable callable) {
//     super(callable);
//   }
//
//   public int getStatus(){
//     return 1;
//   }
// }
