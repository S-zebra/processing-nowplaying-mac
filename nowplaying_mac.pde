import java.io.*;
import java.util.*;
import javax.swing.ImageIcon;

List<String> infoKeys;
final String NOWPLAYING_CLI_PATH = "/path/to/nowplaying-cli";

void setup() {
  size(1000, 480);
  frameRate(2);
  textFont(createFont("SansSerif", 18, true));
  infoKeys = new ArrayList<String>();
  infoKeys.add("title");
  infoKeys.add("artist");
  infoKeys.add("album");
  infoKeys.add("elapsedTime");
}

void draw() {
  background(0);
  
  // Get artwork image
  byte[] image = Base64.getDecoder().decode(getParam("artworkData"));
  PImage img = new PImage(new ImageIcon(image).getImage());
  image(img, width / 4 - img.width, height / 2 - img.height / 2);
  
  // Get text info
  StringBuilder sb = new StringBuilder();
  for(String k : infoKeys) {
    sb.append(getParam(k));
    sb.append('\n');
  }
  
  fill(255);
  // Write text wherever you like
  text(sb.toString(), width / 4 + 5, height / 2 - img.height / 2 + 12);
}

String getParam(String k) {
  try {
    Process p = new ProcessBuilder()
    .command(NOWPLAYING_CLI_PATH, "get", k)
    .start();
    p.waitFor();
    BufferedReader bs = new BufferedReader(new InputStreamReader(p.getInputStream()));
    String l = null;
    StringBuilder sb = new StringBuilder();
    while((l = bs.readLine()) != null) {
      sb.append(l);
    }
    bs.close();
    return sb.toString();
  } catch (Exception e) {
    println(e);
    return "";
  }
}
