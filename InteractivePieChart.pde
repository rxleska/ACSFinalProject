class InteractivePieChart {
    private String comparedValue;
    private float radius;
    private boolean edit;
    final String[] opts = {"Year of Console","Smallest Game File Size","Largest Game File Size","Average Storage Size","Median Storage Value","Total Storage Size"};
    final String[] optSimp = {"year","smallest","largest","average","median","total"};
    private float graphBound;

    public InteractivePieChart(){
        comparedValue = optSimp[3];
        radius = 300.0f;
        edit = false;
        graphBound = 50;
    }
    public InteractivePieChart(String s){this(); setValue(s);}
    public InteractivePieChart(String s, float f){this(s); setRadius(f);}
    public InteractivePieChart(String s, int f){this(s); setRadius(f);}
    public InteractivePieChart(int s, float f){this(); setValue(s); setRadius(f);}

    public void setValue(String s){comparedValue = s;}
    public void setValue(int i){comparedValue = optSimp[i];}
    public void setRadius(float r){radius = r;}
    public void setRadius(double r){radius = (float) r;}
    public void setRadius(int r){radius = (float) r;}
    public void setBound(int b){graphBound = (float) b;}
    public void setBound(float b){graphBound = b;}
    

    public String getValue(){return comparedValue;}
    public float getRadius(){return radius;}
    public boolean getEdit(){return edit;}
    public float getBound(){return graphBound;}
    public int getOptsLength(){return opts.length;}

    public void editOn(){edit=true;}
    public void editOff(){edit=false;}

    public void drawChart(){
        if(edit){
            editor();
        }
        else{
            displayChart();
        }
    }

    public void editor(){
        fill(0,255,51);
        textSize(32);
        text("Please Select what value you would like to compare:",graphBound,graphBound);
        textSize(60);
        
        for(int i = 0; i < opts.length; i++){
            fill(0,255,51);
            if(optSimp[i] == comparedValue)
                fill(255,50,151);
            text(opts[i],graphBound+10,graphBound+100+(90*i));
        }
        noStroke();
        fill(100,100,255);
        rect(width-graphBound*4, height-graphBound,graphBound*4,graphBound);
        fill(0,255,51);
        text("Done", width-graphBound*3.5, height-5);
        textSize(28 * (((consoles.size()+1)*(1.0))/16));
    }
    public void displayChart(){
        strokeWeight(2);
        text(comparedValue + " compared", graphBound/2,graphBound/2);
        double total = getTotal(comparedValue);

        //2000 positions for creation of circle
        float radStep = PI/1000.0F;
        int currentStep = 0;

        //translates to center screen and starts drawing 
        push();
        translate(width/2, height/2);
        int count = 0;
        for(Console c: consoles){
            //finds percentage then finds number of lines to draw and draws them
            float percent = (float) ((c.getData(comparedValue))/total);
            // System.out.print(comparedValue);
            for(int steps = (int) Math.floor(percent*2000);steps > 0; steps--){
                currentStep++;
                stroke(color(diffColor(count))); //colors from colors array of differentiable colors list in refernces.txt
                fill(color(diffColor(count)));
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
    public double getTotal(String s){
        double tot = 0.0;
        for(Console c: consoles){
            tot += c.getData(s);
        }
        return tot;
    }
}