import java.util.*;
ArrayList<Console> consoles;
boolean atHome = true;
String filePath;
int sceneSequencer;
final int graphBound = 50;
final color[] colors = {#e6194b, #3cb44b, #ffe119, #4363d8, #f58231, #911eb4, #46f0f0, #f032e6, #bcf60c, #fabebe, #008080, #e6beff, #9a6324, #fffac8, #800000, #aaffc3, #808000, #ffd8b1, #000075, #808080, #ffffff};
InteractiveLineGraph ig;
// InteractiveLineGraph ilg;
InteractivePieChart ipc;
void settings(){
    size(1400,800);
}
void setup(){
    consoles = new ArrayList<Console>();
    filePath = atHome ? "C:/Users/ryan/programingFiles/ACSFinalProject/gameData" : "/Users/786784/Desktop/ACSFinalProject/gameData";
    readFiles();
    // checkWork();
    fill(255);
    textSize(28 * (((consoles.size()+1)*(1.0))/16));
    noStroke();
    sceneSequencer = 0;
    Collections.sort(consoles);
    ig = new InteractiveLineGraph("year","average");
    // ilg = new InteractiveLineGraph("year","average");
    ipc = new InteractivePieChart();
}
void draw(){
    background(0);
    switch(sceneSequencer){
        case 0:
            displayValues();
        break;
        case 1:
            ig.drawGraph();
        break;
        case 2:
            ipc.drawChart();
            // pieChartTotals();
        break;
        case 3:
            sceneSequencer = 0;
        break;
    }
    
}

void keyPressed() {
    if(key == ' '){
        sceneSequencer++;
    }
}

void readFiles(){
    File folder = new File(filePath);
    // System.out.println(folder.getAbsolutePath());
    File[] listOfFiles = folder.listFiles();
    for(File file : listOfFiles){
        if(file.isFile()){
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

//Creates a pie chart comparing sizes of game libraries for each console
void pieChartTotals(){
    strokeWeight(2);
    
    //defines a total to create percentages
    float total = 0;
    for(Console c: consoles){
        total += c.getTotalSize();
    }

    //2000 positions for creation of circle
    float radStep = PI/1000.0F;
    int currentStep = 0;
    
    //translates to center screen and starts drawing 
    push();
    translate(width/2, height/2);
    int count = 0;
    for(Console c: consoles){
        
        //finds percentage then finds number of lines to draw and draws them
        float percent = (float) c.getTotalSize()/total;
        for(int steps = (int) Math.floor(percent*2000);steps > 0; steps--){
            currentStep++;
            stroke(color(diffColor(count))); //colors from colors array of differentiable colors list in refernces.txt
            triangle(0.0f,0.0f,300.0f * ((float)Math.cos(currentStep*radStep)),300.0f * ((float)Math.sin(currentStep*radStep)),300.0f * ((float)Math.cos((currentStep+1)*radStep)),300.0f * ((float)Math.sin((currentStep+1)*radStep)));
        }
        count++;
    }

    //Surrounding Circle to correct Triangle draw errors
    noFill();
    stroke(0);
    strokeWeight(25);
    circle(0,0,600);
    pop();
}

void pieChartAverage(){
    strokeWeight(2);
    //defines a total to create percentages
    float total = 0;
    for(Console c: consoles){
        total += c.getAverageSize();
    }

    //2000 positions for creation of circle
    float radStep = PI/1000.0F;
    int currentStep = 0;

    //translates to center screen and starts drawing 
    push();
    translate(width/2, height/2);
    int count = 0;
    for(Console c: consoles){

        //finds percentage then finds number of lines to draw and draws them
        float percent = (float) c.getAverageSize()/total;
        for(int steps = (int) Math.floor(percent*2000);steps > 0; steps--){
            currentStep++;
            stroke(color(diffColor(count))); //colors from colors array of differentiable colors list in refernces.txt
            triangle(0.0f,0.0f,300.0f * ((float)Math.cos(currentStep*radStep)),300.0f * ((float)Math.sin(currentStep*radStep)),300.0f * ((float)Math.cos((currentStep+1)*radStep)),300.0f * ((float)Math.sin((currentStep+1)*radStep)));
        }
        count++;
    }

    //Surrounding Circle to correct Triangle draw errors
    noFill();
    stroke(0);
    strokeWeight(25);
    circle(0,0,600);
    pop();
}

void dbug(){
    System.out.println("HEREHEREHEREHEREHEREHEREHEREHEREHERE");
}

public color diffColor(int x){
    return colors[x%colors.length];
}

//Mouse Click interactions
void mousePressed(){
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