class InteractivePieChart {
    private String comparedValue;
    private float radius;
    private boolean edit;
    
    //Constants for options allowed
    final String[] opts = {"Year of Console","Smallest Game File Size","Largest Game File Size","Average Storage Size","Median Storage Value","Total Storage Size"};
    final String[] optSimp = {"year","smallest","largest","average","median","total"};
    final HashMap<String,String> getOption = new HashMap<String,String>(){{
        for(int i = opts.length-1; i>=0;i--){
            put(optSimp[i],opts[i]);
        }
    }};
    private float graphBound;

    public InteractivePieChart(){
        comparedValue = optSimp[3];
        radius = 300.0f;
        edit = false;
        graphBound = 50;
    }

    //Constructors 
    public InteractivePieChart(String s){this(); setValue(s);}
    public InteractivePieChart(String s, float f){this(s); setRadius(f);}
    public InteractivePieChart(String s, int f){this(s); setRadius(f);}
    public InteractivePieChart(int s, float f){this(); setValue(s); setRadius(f);}

    //Setters
    public void setValue(String s){comparedValue = s;}
    public void setValue(int i){comparedValue = optSimp[i];}
    public void setRadius(float r){radius = r;}
    public void setRadius(double r){radius = (float) r;}
    public void setRadius(int r){radius = (float) r;}
    public void setBound(int b){graphBound = (float) b;}
    public void setBound(float b){graphBound = b;}

    //Getters
    public String getValue(){return comparedValue;}
    public float getRadius(){return radius;}
    public boolean getEdit(){return edit;}
    public float getBound(){return graphBound;}
    public int getOptsLength(){return opts.length;}

    //toggles
    public void editOn(){edit=true;}
    public void editOff(){edit=false;}

    //Draw edit or main
    public void drawChart(){
        if(edit){
            editor();
        }
        else{
            drawChangeDataButton();
            displayChart();
        }
    }

    public void editor(){
        //Title
        fill(0,255,51);
        textSize(32);
        text("Please Select what value you would like to compare:",graphBound,graphBound);
        textSize(60);
        //Options
        for(int i = 0; i < opts.length; i++){
            fill(0,255,51);
            if(optSimp[i] == comparedValue)
                fill(255,50,151);
            text(opts[i],graphBound+10,graphBound+100+(90*i));
        }
        //Hecka Lots of Code for done button
        noStroke();
        fill(100,100,255);
        rect(width-graphBound*4, height-graphBound,graphBound*4,graphBound);
        fill(0,255,51);
        text("Done", width-graphBound*3.5, height-5);
        textSize(28 * (((consoles.size()+1)*(1.0))/16));
    }

    public void displayChart(){
        //Title
        strokeWeight(2);
        fill(100,255,100);
        stroke(100,255,100);
        text(getOption.get(comparedValue) + " Compared", graphBound/2,graphBound/2);
        double total = getTotal(comparedValue);
        //2000 positions for creation of circle
        float radStep = PI/1000.0F;
        int currentStep = 0;
        //translates to center screen and starts drawing 
        push();
        translate(width/2, height/2);
        int count = 0;
        boolean far = false;
        for(Console c: consoles){
            //finds percentage then finds number of lines to draw and draws them
            float percent = (float) ((c.getData(comparedValue))/total);
            // System.out.print(comparedValue);
            for(int steps = (int) Math.floor(percent*2000);steps > 0; steps--){
                currentStep++;
                stroke(color(diffColor(count))); //colors from colors array of differentiable colors list in refernces.txt
                fill(color(diffColor(count)));
                triangle(0.0f,0.0f,300.0f * ((float)Math.cos(currentStep*radStep)),300.0f * ((float)Math.sin(currentStep*radStep)),300.0f * ((float)Math.cos((currentStep+1)*radStep)),300.0f * ((float)Math.sin((currentStep+1)*radStep)));
                if(steps == ((int) Math.floor(percent*2000))/2){
                    //Hecka lots of stuff to try and trick the numbers to not intersect still happens but I dont reall want to write a more safisticated solution
                    float dist = far ? 400.0f : 330.0f;
                    float addY = percent < 0.01 ? 
                      percent < 0.003 ? -50 : -20
                     :0;
                    if(percent > 0.16)
                        dist = 330.0f;
                    if(dist * ((float)Math.cos(currentStep*radStep)) < 0)
                        textAlign(RIGHT);
                    else   
                        textAlign(LEFT);
                    float xCord = dist * ((float)Math.cos(currentStep*radStep));
                    float yCord = addY + dist * ((float)Math.sin(currentStep*radStep));
                    yCord = Math.abs(yCord) > (height/2)-50 ? yCord * 0.95 : yCord; 
                    text(c.getName() +":"+(Math.floor(percent*10000)/100) + "%", xCord,yCord);
                    far = !far;
                }
            }
            count++;
        }
        //Surrounding Circle to correct Triangle draw errors
        noFill();
        stroke(0);
        strokeWeight(20);
        circle(0,0,600);
        pop();
    }

    public double getTotal(String s){
        double tot = 0.0;
        for(Console c: consoles){
            tot += c.getData(s);
        }
        return tot;
    }

    //Change Button
    private void drawChangeDataButton(){
        //Rectange
        fill(100,255,100);
        stroke(100,255,100);
        rect(0,graphBound,graphBound,height-(2*graphBound));
        //Words
        fill(0);
        noStroke();
        textAlign(CENTER);
        push();
            translate(graphBound/1.75,height/2);
            rotate((PI/2)*3);
            text("Click to Change Tested Value",0,0);
        pop();
        textAlign(LEFT);
    }
}