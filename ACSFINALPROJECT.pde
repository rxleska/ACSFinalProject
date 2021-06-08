import java.util.*;
//Console Collections
ArrayList<Console> consoles, removedCons;

//constants
final int graphBound = 50;
final color[] colors = {#e6194b, #3cb44b, #ffe119, #4363d8, #f58231, #911eb4, #46f0f0, #f032e6, #bcf60c, #fabebe, #008080, #e6beff, #9a6324, #fffac8, #800000, #aaffc3, #808000, #ffd8b1, #000075, #808080, #ffffff};

//Filepath changes
boolean atHome = true;
String filePath;

//Scene Sequence and scene objects
int sceneSequencer;
InteractiveLineGraph ig;
InteractivePieChart ipc;
StatTrack st;

//toggles for console types
boolean includeHH,includeCon;
int lineODat;

//why does this need to be in settings, why?
void settings(){
    size(1400,800);
}

void setup(){
    lineODat = 0;
    filePath = atHome ? "C:/Users/ryan/programingFiles/ACSFinalProject" : "/Users/786784/Desktop/ACSFinalProject";
    consoles = new ArrayList<Console>();
    removedCons = new ArrayList<Console>();
    //read data and sort
    readFiles();
    Collections.sort(consoles);
    //Scene Setup
    sceneSequencer = 0;
    ig = new InteractiveLineGraph("year","average");
    ipc = new InteractivePieChart();
    st = new StatTrack(lineODat);
    //toggles
    includeHH = true;
    includeCon = true;
    fill(255);
    setBasicTextSize();
    noStroke();
}

void draw(){
    background(0);
    setBasicTextSize();
    switch(sceneSequencer){
        case 0:
            includeSwitch();
            displayValues();
        break;
        case 1:
            includeSwitch();
            textSize(28);
            ig.drawGraph();
        break;
        case 2:
            includeSwitch();
            textSize(28);
            ipc.drawChart();
            // pieChartTotals();
        break;
        case 3:
            st.displayData();
        break;
        case 4:
            sceneSequencer = 0;
        break;
    }
    
}

void keyPressed() { // moves between scenes
    if(key == ' '){
        sceneSequencer++;
    }
}

void readFiles(){
    File folder = new File(filePath+"/gameData");
    // System.out.println(folder.getAbsolutePath());
    File[] listOfFiles = folder.listFiles();
    for(File file : listOfFiles){
        if(file.isFile()){
            //checks if a handheld
            if(file.getName().charAt(0) == 72 || file.getName().charAt(0) == 104){
                consoles.add(
                    new Console(
                        file.getName().substring(5,file.getName().length()-4), 
                        file.getName().substring(1,5),true));
            }
            else{
                consoles.add(
                    new Console(
                        file.getName().substring(4,file.getName().length()-4), 
                        file.getName().substring(0,4)));
            }
            consoles.get(consoles.size()-1).generateSet(file);
        }
    }
}

void displayValues(){
    int i = 0; 
    fill(144,238,144);
    text("System:Year",40, (height/(consoles.size()+2))*(i+1));
        text("  :#Games" ,275, (height/(consoles.size()+2))*(i+1));
        text("Largest Game <+-+> Total storage size of all Games",450, (height/(consoles.size()+2))*(i+1));
        i++;
    for(Console c: consoles){
        if(c.isHandHeld())
            fill(255,192,203);
        else
            fill(255);
        text(c.getTitle(),40, (height/(consoles.size()+2))*(i+1));
        text("  :  " + c.numGames(),275, (height/(consoles.size()+2))*(i+1));
        text(c.getLargest().getSizeStr() + " <+-+> " + c.getTotalReadable(),450, (height/(consoles.size()+2))*(i+1));
        i++;
    }
}

//different colors from the differentiable colors array
public color diffColor(int x){
    return colors[x%colors.length];
}

//Mouse Click interactions
void mousePressed(){
    //toggle buttons
    if(mouseX > width-100.0){
        if(mouseY < 20)
            switchCon();
        else if(mouseY < 40)
            switchHH();
    } 
    if(sceneSequencer == 1){
        //Checks for Selection in X editor
        if(ig.getXEdit()){
            if(mouseY > height- ig.getBound() && mouseX > width- (ig.getBound()*4)){
                ig.editXOff();
            }
            else{
                for(int end = ig.getOptsLength()-1; end >=0; end--){
                    if(mouseY > ig.getBound() +40 + (90*end)){
                        ig.setX(end);
                        break;
                    }
                }  
            }
        }
        //Checks of Selection in Y Editor
        else if(ig.getYEdit()){
            if(mouseY > height- ig.getBound() && mouseX > width- (ig.getBound()*4)){
                ig.editYOff();
            }
            else{
                for(int end = ig.getOptsLength()-1; end >=0; end--){
                    if(mouseY > ig.getBound() +40 + (90*end)){
                        ig.setY(end);
                        break;
                    }
                }
            }
        }
        //Checks for clicking x or y axis in interactive graph
        else if(mouseX < ig.getBound() && mouseY > ig.getBound() && mouseY < height-ig.getBound())
            ig.editYOn();
        else if(mouseY > height - ig.getBound() && mouseX > ig.getBound() && mouseX < width-ig.getBound())
            ig.editXOn();
        else{
            //dont
        }
    }
    //pie chart buttons
    else if(sceneSequencer == 2){
        if(ipc.getEdit()){
            if(mouseY > height- ipc.getBound() && mouseX > width- (ipc.getBound()*4)){
                ipc.editOff();
            }
            else{
                for(int end = ipc.getOptsLength()-1; end >=0; end--){
                    if(mouseY > ipc.getBound() +40 + (90*end)){
                        ipc.setValue(end);
                        break;
                    }
                }  
            }
        }
        else if(mouseX < ig.getBound() && mouseY > ig.getBound() && mouseY < height-ig.getBound())
            ipc.editOn();
    }
}

//Method that allows the user to toggle seeing standalone consoles vs handheld consolesd 
void includeSwitch(){
    //button setup
    stroke(0);
    strokeWeight(1);
    textSize(20);
    //con button
    if(includeCon)
        fill(100,255,100); 
    else
        fill(255,100,100);
    rect(width,0,-100.0f,20.0f);
    textAlign(RIGHT);
    fill(0);
    text("Consoles",width-5.0f,18.0f);
    //hand held button
    if(includeHH)
        fill(100,255,100);    
    else
        fill(255,100,100);
    rect(width,20,-100.0f,20.0f);
    fill(0);
    text("HandHeld",width-5.0f,38.0f);
    
    //reset stuff
    textAlign(LEFT);
    setBasicTextSize();
}

//toggles standalone consoles 
void switchCon(){
    if(includeHH == false && includeCon == true){
        includeHH = true;
        includeCon = false;
    }
    else    
        includeCon = !includeCon;
    changeData();
}

//toggles Hand held consoles
void switchHH(){
    if(includeCon == false && includeHH == true){
        includeCon = true;
        includeHH = false;
    }
    else    
        includeHH = !includeHH;
    changeData();
}

//changes data in consoles arraylist 
void changeData(){
    for(int i = consoles.size()-1; i >= 0; i--){
        Console c = consoles.get(i);
        if(c.isHandHeld()){
            if(!includeHH){
                removedCons.add(c);
                consoles.remove(i);
            }
        }
        else{
            if(!includeCon){
                removedCons.add(c);
                consoles.remove(i);
            }
        }
    }
    for(int i = removedCons.size()-1; i >= 0; i--){
        Console c = removedCons.get(i);
        if(c.isHandHeld()){
            if(includeHH){
                consoles.add(c);
                removedCons.remove(i);
            }
        }
        else{
            if(includeCon){
                consoles.add(c);
                removedCons.remove(i);
            }
        }
    }
    Collections.sort(consoles);
}

//uniform text size setter
void setBasicTextSize(){
    textSize(28 * (16.0/((consoles.size()+1)*(1.0)) < 1.25 ? 16/((consoles.size()+1)*(1.0)) : 1.25));
}