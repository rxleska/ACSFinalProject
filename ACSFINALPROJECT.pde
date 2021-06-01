import java.util.*;
ArrayList<Console> consoles;
void settings(){
    size(400,400);
}
void setup(){
    consoles = new ArrayList<Console>();
    readFiles();
}
void draw(){
    background(255,0,255);
}

void readFiles(){
    File folder = new File("./");
    System.out.println(folder.getAbsolutePath());
    // File[] listOfFiles = folder.listFiles();
    // for(File file : listOfFiles){
    //     if(file.isFile()){
    //         System.out.println(file.getName());
    //     }
    // }
}