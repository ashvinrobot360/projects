import java.io.*;
import java.net.*;
public class URLConnectionExample {
public static void main(String[] args){
        try{
                URL url=new URL("http://www.javatpoint.com");
                URLConnection urlcon=url.openConnection();
                InputStream stream=urlcon.getInputStream();
                int i;
                while((i=stream.read())!=-1) {
                        System.out.print((char)i);
                }

                InetAddress ip=InetAddress.getByName("www.javatpoint.com");

                System.out.println();
                System.out.println("Host Name: "+ip.getHostName());
                System.out.println("IP Address: "+ip.getHostAddress());
        }catch(Exception e) {System.out.println(e); }
}
}
