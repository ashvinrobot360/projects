// Java Program illustrating the
// Byte Stream to copy
// contents of one file to another file.
import java.io.*;
public class BStream {
    public static void main(
        String[] args) throws IOException
    {
      FileInputStream geek = new FileInputStream("sourcefile.txt");
      FileOutputStream geekOut = new FileOutputStream("targetfile.txt");

        InputStreamReader sourceStream = null;
        OutputStreamWriter targetStream = null;

        try {
            sourceStream
                = new InputStreamReader(geek);
            targetStream
                = new OutputStreamWriter(geekOut);

            // Reading source file and writing
            // content to target file byte by byte
            int temp;
            while ((
                       temp = sourceStream.read())
                   != -1)
                targetStream.write((byte)temp);
        }
        finally {
            if (sourceStream != null)
                sourceStream.close();
            if (targetStream != null)
                targetStream.close();
        }
    }
}
