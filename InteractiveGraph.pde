class InteractiveGraph{
    private String xa;
    private String ya;
    private int graphBound;
    private boolean editY, editX;
    final String[] opts = {"Year of Console","Smallest Game File Size","Largest Game File Size","Average Storage Size","Median Storage Value","Total Storage Size"};
    final String[] optSimp = {"year","smallest","largest","average","median","total"};
    // private ArrayList<Console> consoles;

    public InteractiveGraph(){
        xa = "";
        ya = "";
        graphBound = 50;
        editX = false;
        editY = false;
    }
    public InteractiveGraph(String x, String y){this(); setX(x); setY(y);} //x and y
    public InteractiveGraph(String x, String y, int b){this(x,y); setBound(b);} // x, y, and bound
    // public InteractiveGraph(String x, String y, int b, ArrayList<Console> c){this(x,y,b);}


    public void setX(String x){xa=x;}
    public void setX(int x){xa = optSimp[x];}
    public void setY(String y){ya=y;}
    public void setY(int y){ya = optSimp[y];}
    public void setBound(int b){graphBound =b;}
    // public void setConsArr(ArrayList<Console> c){consoles = c;}
    public String getX(){return xa;}
    public String getY(){return ya;}
    public int getBound(){return graphBound;}
    public boolean getXEdit(){return editX;}
    public boolean getYEdit(){return editY;}
    public int getOptsLength(){return opts.length;}
    // public ArrayList<Console> getConsArr(){return consoles;};
    
    
    public void drawGraph(){
        if(editX)
            xEditor();
        else if(editY)
            yEditor();
        else{
            graphIt();
        }
    }
    public void editYOn(){editY = true;}
    public void editXOn(){editX = true;}
    public void editYOff(){editY = false;}
    public void editXOff(){editX = false;}

    public void xEditor(){
        fill(0,255,51);
        textSize(32);
        text("Please Select what the X Axis value should be:",graphBound,graphBound);
        textSize(60);
        
        for(int i = 0; i < opts.length; i++){
            fill(0,255,51);
            if(optSimp[i] == xa)
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
    public void yEditor(){
        fill(0,255,51);
        textSize(32);
        text("Please Select what the Y Axis value should be:",graphBound,graphBound);
        textSize(60);
        
        for(int i = 0; i < opts.length; i++){
            fill(0,255,51);
            if(optSimp[i] == ya)
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

    public void graphIt(){
        text(ya + " by " + xa, graphBound/2,graphBound/2);
        //Create Graph Outline
        stroke(255,0,0);
        strokeWeight(5);
        line(graphBound,graphBound,graphBound,height-graphBound);
        line(graphBound,height-graphBound, width-graphBound,height-graphBound);

        String[] ledgeNums = { 
            (ya.toLowerCase() != "year" ? doubleToReadableSize(getMax(ya)) : Math.round(getMax(ya)) + ""),
            (ya.toLowerCase() != "year" ? doubleToReadableSize(getMin(ya)) : Math.round(getMin(ya)) + "") + ":" +
            (xa.toLowerCase() != "year" ? doubleToReadableSize(getMin(xa)) : Math.round(getMin(xa)) + ""),
            (xa.toLowerCase() != "year" ? doubleToReadableSize(getMax(xa)) : Math.round(getMax(xa)) + "")
        };

        
        text(ledgeNums[0], graphBound,graphBound);
        text(ledgeNums[1], 0,height-5);
        text(ledgeNums[2], width-graphBound*3,height-5);

        push();
            fill(255);
            textAlign(CENTER);
            translate(graphBound/2,height/2);
            rotate(PI/2);
            text(ya,0,0);
            textAlign(LEFT);
        pop();
        
        push();
            fill(255);
            textAlign(CENTER);
            translate(width/2,height-(graphBound/2));
            text(xa,0,0);
            textAlign(LEFT);
        pop();

        //Places dots
        push();
            //changes to drawing from the origin of the graph
            translate(graphBound, height-graphBound);
            //defines area of graph
            float xGraphable = width - (graphBound*2);
            float yGraphable = height - (graphBound*2);
            
            //defines the x axis scale and starting point
            float startX = (float) getMin(xa) ;
            float xLedg =  (float)(getMax(xa) - getMin(xa));
            
            //defines the max y value
            float yMax = (float) getMax(ya); //11 GB in KB

            //Plots dots for each console
            for(Console c: consoles){
            
                //creates x position relaitive to the x axis definition
                float xPos = (float) (((c.getData(xa) - startX)*1.0f) / xLedg);
                xPos = (xPos * xGraphable);

                //creates y position relative to the y max value
                float yPos = (float) (((float) c.getData(ya)) / yMax);
                yPos = -1.0f * (yPos * yGraphable);
                
                //makes dot pink if console is hand held
                noStroke();
                if(c.isHandHeld())
                    fill(255,0,255);
                else
                    fill(255);

                //draws dot
                circle(xPos, yPos, 20);
                //text
                fill(255);
                text("" + c.getName(),xPos + 20, yPos);
            }
        pop();
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

    //Converts kb file sizes to readable values
    public String doubleToReadableSize(double totalSize){
        String swSize = ((int)Math.floor(totalSize)) + "";
        switch(
            //case to integer for switch, Math ceiling to round up no matter what
            (int) Math.ceil(
                // length of KB value converted to double then divided by 3 to get the magnitude
                (swSize.length() * 1.0)/3
            ) -1 // subtract one to match the switch below
        ){
            case 5:
            return Math.ceil((totalSize/(Math.pow(10,9)))*1000)/1000 + " EB";
            case 4:
            return Math.ceil((totalSize/(Math.pow(10,9)))*1000)/1000 + " PB";
            case 3:
            return Math.ceil((totalSize/(Math.pow(10,9)))*1000)/1000 + " TB";
            case 2:
            return Math.ceil((totalSize/(Math.pow(10,6)))*1000)/1000 + " GB";
            case 1:
            return Math.ceil((totalSize/(Math.pow(10,3)))*1000)/1000 + " MB";
            case 0:
            return Math.ceil((totalSize*1000))/1000 + " KB";
        }
        return "unknown size";
    }
    
}