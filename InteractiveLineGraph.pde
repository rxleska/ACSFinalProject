class InteractiveLineGraph extends InteractiveGraph{
    public InteractiveLineGraph(){super();}
    public InteractiveLineGraph(String x, String y){super(x,y);} //x and y
    public InteractiveLineGraph(String x, String y, int b){super(x,y,b);} // x, y, and bound
    
    public void graphIt(){
        stroke(0,255,0);
        fill(0,255,0);
        text(super.getOption.get(getY()) + " by " + super.getOption.get(getX()), getBound()/2,getBound()/2);
        //Create Graph Outline
        stroke(255,0,0);
        strokeWeight(5);
        line(getBound(),getBound(),getBound(),height-getBound());
        line(getBound(),height-getBound(), width-getBound(),height-getBound());
        //Create Legends
        String[] ledgeNums = { 
            (getY().toLowerCase() != "year" ? doubleToReadableSize(getMax(getY())) : Math.round(getMax(getY())) + ""),
            (getY().toLowerCase() != "year" ? doubleToReadableSize(getMin(getY())) : Math.round(getMin(getY())*0.9) + "") + ":" +
            (getX().toLowerCase() != "year" ? doubleToReadableSize(getMin(getX())) : Math.round(getMin(getX())) + ""),
            (getX().toLowerCase() != "year" ? doubleToReadableSize(getMax(getX())) : Math.round(getMax(getX())) + "")
        };  
        text(ledgeNums[0], getBound(),getBound());
        text(ledgeNums[1], 0,height-5);
        text(ledgeNums[2], width-getBound()*3,height-5);
        //Left Legend
        push();
            fill(255);
            textAlign(CENTER);
            translate(getBound()/2,height/2);
            rotate(PI/2);
            text(super.getOption.get(getY()),0,0);
            textAlign(LEFT);
        pop();
        //Right Legend
        push();
            fill(255);
            textAlign(CENTER);
            translate(width/2,height-(getBound()/6));
            text(super.getOption.get(getX()),50,0);
            textAlign(LEFT);
        pop();
        //Places dots
        push();
            //changes to drawing from the origin of the graph
            translate(getBound(), height-getBound());
            //defines area of graph
            float xGraphable = width - (getBound()*2);
            float yGraphable = height - (getBound()*2.25);
            //defines the x axis scale and starting point
            float startX = (float) getMin(getX()) ;
            float xLedg =  (float)(getMax(getX()) - getMin(getX()));
            //defines the max y value
            float yMax = (float) getMax(getY()); //11 GB in KB
            ArrayList<PVector> pnts = new ArrayList<PVector>();
            ArrayList<PVector> hPnts = new ArrayList<PVector>();
            //Plots dots for each console
            for(int i = 0; i < consoles.size(); i++){
                Console c = consoles.get(i);
                //creates x position relaitive to the x axis definition
                float xPos = (float) (((c.getData(getX()) - startX)*1.0f) / xLedg);
                xPos = (xPos * xGraphable);
                //creates y position relative to the y max value
                float yPos = (float) (((float) c.getData(getY())) / yMax);
                yPos = -1.0f * (yPos * yGraphable);
                //makes dot pink if console is hand held
                noStroke();
                if(c.isHandHeld())
                    fill(255,0,255);
                else
                    fill(255);
                if( (c.isHandHeld() ?
                        hPnts.size() >=1:
                        pnts.size() >=1) 
                    &&consoles.get(i-1).getYear() == c.getYear()
                ){
                    if(!c.isHandHeld()){
                        pnts.set((pnts.size()-1), new PVector(
                            (pnts.get(pnts.size()-1).x + xPos)/2,
                            (pnts.get(pnts.size()-1).y + yPos)/2 
                            ));
                    }
                    else{
                        hPnts.set((hPnts.size()-1), new PVector(
                            (hPnts.get(hPnts.size()-1).x + xPos)/2,
                            (hPnts.get(hPnts.size()-1).y + yPos)/2 
                            ));
                    }
                }
                else{
                    if(!c.isHandHeld())
                        pnts.add(new PVector(xPos,yPos));
                    else
                        hPnts.add(new PVector(xPos,yPos));
                }
                //draws dot
                circle(xPos, yPos, 20);
                //text
                fill(0,255,255);
                stroke(0,255,255);
                if(xPos > width - (graphBound*3)){
                    xPos = xPos-40;
                    textAlign(RIGHT);
                }
                else{
                    textAlign(LEFT);
                }
                text("" + c.getName(),xPos + 20, yPos);
                textAlign(LEFT);
            }
            // drawWackCurve(pnts,color(255));
            // drawWackCurve(hPnts,color(255,0,255));
            drawLinearRegression(pnts, color(255));
            // graphCC(pnts,color(255));
            drawLinearRegression(hPnts, color(255,0,255));
        pop();
        if(getX().equals("year"))
            drawGenerations(startX, startX+xLedg);
    }

    //Calculate Linear Regreesion using formula from Refrence.txt
    public void drawLinearRegression(ArrayList<PVector> pnts, color col){
        //create y=bx+a
        float a = (float)(((sumY(pnts)*sumXsq(pnts))-(sumX(pnts)*sumXY(pnts)))
                 /((pnts.size()*sumXsq(pnts))-(Math.pow(sumX(pnts),2))));
        float b = (float)(((pnts.size()*sumXY(pnts))-(sumX(pnts)*sumY(pnts)))
                 /((pnts.size()*sumXsq(pnts))-(Math.pow(sumX(pnts),2))));
        //create line from equation constants
        float endX = width-(graphBound*2);
        fill(col);
        stroke(col);
        float startX = (-1)*a/b;
        line(startX,0, endX, b*endX + a);
    }
    
    //Functions needed for linear Regression Calculation
    public float sumX(ArrayList<PVector> pnts){
        float sum = 0.0;
        for(PVector pnt: pnts){
            sum += pnt.x;
        }
        return sum;
    }
    public float sumY(ArrayList<PVector> pnts){
        float sum = 0.0;
        for(PVector pnt: pnts){
            sum += pnt.y;
        }
        return sum;
    }
    public float sumXsq(ArrayList<PVector> pnts){
        float sum = 0.0;
        for(PVector pnt: pnts){
            sum += (pnt.x)*(pnt.x);
        }
        return sum;
    }
    public float sumYsq(ArrayList<PVector> pnts){
        float sum = 0.0;
        for(PVector pnt: pnts){
            sum += (pnt.y)*(pnt.y);
        }
        return sum;
    }
    public float sumXY(ArrayList<PVector> pnts){
        float sum = 0.0;
        for(PVector pnt: pnts){
            sum += (pnt.x)*(pnt.y);
        }
        return sum;
    }

    //Wacky Curve Dont Use
    public void drawWackCurve(ArrayList<PVector> pnts, color col){
        noFill();
        strokeWeight(2);
        stroke(col);
        beginShape();
        curveVertex(pnts.get(0).x,pnts.get(0).y);
        for(PVector pnt: pnts){
            curveVertex(pnt.x, pnt.y);
        }
        curveVertex(pnts.get(pnts.size()-1).x,pnts.get(pnts.size()-1).y);
        endShape();
    }

    //##################################################################################
    //######## Correlation Constant Might Use Later for Other Regressions ##############
    //##################################################################################
    public float coefficientOfCorrelation(ArrayList<PVector> pnts){
        float r = (float)(((pnts.size()*sumXY(pnts))-(sumX(pnts)*sumY(pnts)))
                 /(Math.sqrt((pnts.size()*sumXsq(pnts))-Math.pow(sumX(pnts),2))*Math.sqrt((pnts.size()*sumYsq(pnts))-Math.pow(sumY(pnts),2)))); 
        return r;
    }

    //Doesnt work yet, I dont understand the math yet
    public void graphCC(ArrayList<PVector> pnts, color col){
        float b = (float)(((sumY(pnts)*sumXsq(pnts))-(sumX(pnts)*sumXY(pnts)))
                 /((pnts.size()*sumXsq(pnts))-(Math.pow(sumX(pnts),2))));
        // System.out.println(b);
        float r = coefficientOfCorrelation(pnts);
        float a = -1*(float)Math.pow(10,b);
        System.out.println("Ar^x = " + a + "" + r + "^x");
    }

    //Adds Generation Marks to x axis when year is x axis
    public void drawGenerations(float xMin, float xMax){
        fill(#ffff00); // yellow
        stroke(#ffff00);
        textSize(30);
        textAlign(RIGHT);
        
        text("5Gen", graphBound + ((width-(graphBound*2)) * ((1999-xMin)/(xMax-xMin))), height-graphBound+25);
        rect(graphBound + ((width-(graphBound*2)) * ((1999-xMin)/(xMax-xMin)))+10, height-graphBound+15,2,-30);
        
        text("6Gen", graphBound + ((width-(graphBound*2)) * ((2003-xMin)/(xMax-xMin))), height-graphBound+25);
        rect(graphBound + ((width-(graphBound*2)) * ((2003-xMin)/(xMax-xMin)))+10, height-graphBound+15,2,-30);
        
        text("7Gen", graphBound + ((width-(graphBound*2)) * ((2006-xMin)/(xMax-xMin))), height-graphBound+25);
        rect(graphBound + ((width-(graphBound*2)) * ((2006-xMin)/(xMax-xMin)))+10, height-graphBound+15,2,-30);
        
        text("8Gen", graphBound + ((width-(graphBound*2)) * ((2017-xMin)/(xMax-xMin))), height-graphBound+25);
        rect(graphBound + ((width-(graphBound*2)) * ((2017-xMin)/(xMax-xMin)))+10, height-graphBound+15,2,-30);
        // text("9Gen", graphBound + ((width-(graphBound*2)) * ((2006-xMin)/(xMax-xMin))), height-graphBound);
        textAlign(LEFT);
        setBasicTextSize();
    }
}