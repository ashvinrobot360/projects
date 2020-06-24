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
public class Anagrams{
  public static void main(String[] args){
    Map<String, String> map = new HashMap<String, String>();
    map.put("PANS", "");
    map.put("POTS", "");
    map.put("OPT", "");
    map.put("SNAP", "");
    map.put("STOP", "");
    map.put("TOPS", "");

    Set set  = map.entrySet();
    Iterator it = set.iterator();
    ArrayList<String> list = new ArrayList<String>();

    while(it.hasNext()){
      Map.Entry entry = (Map.Entry) it.next();
      System.out.println("Key: "  + entry.getKey() + " Value: " + entry.getValue());
      String s = entry.getKey().toString();
      char[] c = s.toCharArray();        // convert to array of chars
      java.util.Arrays.sort(c);          // sort
      String newVal = new String(c);  // convert back to String
      // System.out.println(newVal);
      entry.setValue(newVal);
      System.out.println("Key: "  + entry.getKey() + " Value: " + entry.getValue());
      String word = entry.getValue().toString();

      if(!list.contains(word)){
        list.add(word);
      }
    }
       System.out.println(set.toString());

       it = set.iterator();

       for(int i = 0; i < list.size(); i++){
        while(it.hasNext()){
          Map.Entry entry = (Map.Entry) it.next();
          if(entry.getValue().equals(list.get(i))){
            System.out.print(entry.getKey() + ", ");
          }
       }
       it = set.iterator();
       System.out.println();


     }
    }


  }
