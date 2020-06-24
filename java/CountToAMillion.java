import java.util.concurrent.*;

public class CountToAMillion{
  public static void main(String[] args){
    ExecutorService executor = Executors.newFixedThreadPool(10);

    Count count = new Count(0);
    Future<Integer> future;
    Integer temp = 5;
    do{
       try{
         future = executor.submit(count);
         temp = future.get();
       }catch(Exception e){}
    }  while(temp < 10000);

    executor.shutdown();
    System.out.println("DONE!");
  }
}

 class Count implements Callable<Integer>{
  Integer count;

  public Count(int count){
    this.count = (Integer)count;
  }
  public Integer call() throws Exception{
      return incrementCount();
  }

  public synchronized Integer  incrementCount(){
      count++;
      if(count > 10000){
        System.out.println("ERROR");
      }else{
      System.out.println(count);
    }
    return (Integer)count;

  }
}
