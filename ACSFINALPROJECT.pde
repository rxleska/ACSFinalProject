import java.util.*;
ArrayList<Console> consoles;
boolean atHome = true;
String filePath;
void settings(){
    size(1400,800);
}
void setup(){
    consoles = new ArrayList<Console>();
    filePath = atHome ? "C:/Users/ryan/programingFiles/ACSFinalProject/gameData" : "";
    readFiles();
    // checkWork();
    fill(255);
    textSize(28);
    noStroke();
}
void draw(){
    background(0);
    displayValues();
}

void readFiles(){
    File folder = new File(filePath);
    // System.out.println(folder.getAbsolutePath());
    File[] listOfFiles = folder.listFiles();
    for(File file : listOfFiles){
        if(file.isFile()){
            consoles.add(new Console(file.getName().substring(0,file.getName().length()-4)));
            consoles.get(consoles.size()-1).generateSet(file);
        }
    }
}
void checkWork(){
    for(Console c: consoles){
        System.out.println(c.getName() + "  :  " + c.numGames() + "\n" + c.getRandomGame());
    }
}

void displayValues(){
    int i = 0; 
    for(Console c: consoles){
        text(c.getName(),40, (height/(consoles.size()+1))*(i+1));
        text("  :  " + c.numGames(),200, (height/(consoles.size()+1))*(i+1));
        text(c.getTree().last().toString(),350, (height/(consoles.size()+1))*(i+1));
        i++;
    }
}

