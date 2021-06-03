import java.util.*;
ArrayList<Console> consoles;
boolean atHome = false;
String filePath;
int sceneSequencer;
final int graphBound = 50;
final color[] colors = {#e6194b, #3cb44b, #ffe119, #4363d8, #f58231, #911eb4, #46f0f0, #f032e6, #bcf60c, #fabebe, #008080, #e6beff, #9a6324, #fffac8, #800000, #aaffc3, #808000, #ffd8b1, #000075, #808080, #ffffff};
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
}
void draw(){
    background(0);
    switch(sceneSequencer){
        case 0:
            displayValues();
        break;
        case 1:
            displayGraph();
        break;
        case 2:
            pieChartAverage();
        break;
        case 3:
            pieChartTotals();
        break;
        case 4:
            readableTest();
        break;
        case 5:
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

void checkWork(){
    for(Console c: consoles){
        System.out.println(c.getName() + "  :  " + c.numGames() + "\n" + c.getRandomGame());
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


//Creates a Graph of the Average Game size by year of the consoles
void displayGraph(){
    //Create Graph Outline
    stroke(255,0,0);
    strokeWeight(5);
    line(graphBound,graphBound,graphBound,height-graphBound);
    line(graphBound,height-graphBound, width-graphBound,height-graphBound);
    
    //Places dots
    push();
        //changes to drawing from the origin of the graph
        translate(graphBound, height-graphBound);
        //defines area of graph
        float xGraphable = width - (graphBound*2);
        float yGraphable = height - (graphBound*2);
        
        //defines the x axis scale and starting point
        float startYear = consoles.get(0).getYear() * 1.0f;
        float xLedg = consoles.get(consoles.size()-1).getYear() - startYear;
        
        //defines the max y value
        float yMax = 11.0f * 1000000; //11 GB in KB

        //Plots dots for each console
        for(Console c: consoles){
        
            //creates x position relaitive to the x axis definition
            float xPos = (((c.getYear() - startYear)*1.0f) / xLedg);
            xPos = (xPos * xGraphable);

            //creates y position relative to the y max value
            float yPos =  (((float) c.getAverageSize()) / yMax);
            yPos = -1.0f * (yPos * yGraphable);
            
            //makes dot pink if console is hand held
            noStroke();
            if(c.isHandHeld())
                fill(255,0,255);
            else
                fill(255);

            //draws dot
            circle(xPos, yPos, 20);
        }
    pop();
}

//
void displayGraph(String xa, String ya){
    //Create Graph Outline
    stroke(255,0,0);
    strokeWeight(5);
    line(graphBound,graphBound,graphBound,height-graphBound);
    line(graphBound,height-graphBound, width-graphBound,height-graphBound);
    
    //Places dots
    push();
        //changes to drawing from the origin of the graph
        translate(graphBound, height-graphBound);
        //defines area of graph
        float xGraphable = width - (graphBound*2);
        float yGraphable = height - (graphBound*2);
        
        //defines the x axis scale and starting point
        float startX = getMin(xa) * 1.0f;
        float xLedg = getMax(xa) - getMin(xa);
        
        //defines the max y value
        float yMax = getMax(ya); //11 GB in KB

        //Plots dots for each console
        for(Console c: consoles){
        
            //creates x position relaitive to the x axis definition
            float xPos = (((c.getData(xa) - startX)*1.0f) / xLedg);
            xPos = (xPos * xGraphable);


//########################################################################################
//##############################################################################################################
//########################################################################################
//##############################################################################################################

            //creates y position relative to the y max value
            float yPos =  (((float) c.getAverageSize()) / yMax);
            yPos = -1.0f * (yPos * yGraphable);
            
            //makes dot pink if console is hand held
            noStroke();
            if(c.isHandHeld())
                fill(255,0,255);
            else
                fill(255);

            //draws dot
            circle(xPos, yPos, 20);
        }
    pop();
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

void readableTest(){
    
    String[] testable = {"year","smallest","largest","average","median","total","date","small","large","ave","mid","tot"};
    textSize(28 * (((testable.length*(1.0))/16)));
    for(int i = testable.length-1; i>=0; i--){
        Console temp = consoles.get(i%consoles.size());
        text(testable[i] + " : " + getMax(testable[i]) + ":" + getMin(testable[i]),40, (height/(testable.length+1))*(i+1));
    }
}

void dbug(){
    System.out.println("HEREHEREHEREHEREHEREHEREHEREHEREHERE");
}

public color diffColor(int x){
    return colors[x%colors.length];
}

public double getMax(String s){
    double max = 0.0;
    for(Console c: consoles){
        if(c.getData(s) > max)
            max = c.getData(s);
    }
    return max;
}

public double getMin(String s){
    double min = Double.MAX_VALUE;
    for(Console c: consoles){
        if(c.getData(s) < min)
            min = c.getData(s);
    }
    return min;
}