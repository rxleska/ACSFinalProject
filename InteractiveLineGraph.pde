class InteractiveLineGraph extends InteractiveGraph{
    public InteractiveLineGraph(){super();}
    public InteractiveLineGraph(String x, String y){super(x,y);} //x and y
    public InteractiveLineGraph(String x, String y, int b){super(x,y,b);} // x, y, and bound
    
    public void graphIt(){
        text(getY() + " by " + getX(), getBound()/2,getBound()/2);
        //Create Graph Outline
        stroke(255,0,0);
        strokeWeight(5);
        line(getBound(),getBound(),getBound(),height-getBound());
        line(getBound(),height-getBound(), width-getBound(),height-getBound());
    
        String[] ledgeNums = { 
            (getY().toLowerCase() != "year" ? doubleToReadableSize(getMax(getY())) : Math.round(getMax(getY())) + ""),
            (getY().toLowerCase() != "year" ? doubleToReadableSize(getMin(getY())) : Math.round(getMin(getY())) + "") + ":" +
            (getX().toLowerCase() != "year" ? doubleToReadableSize(getMin(getX())) : Math.round(getMin(getX())) + ""),
            (getX().toLowerCase() != "year" ? doubleToReadableSize(getMax(getX())) : Math.round(getMax(getX())) + "")
        };

        
        text(ledgeNums[0], getBound(),getBound());
        text(ledgeNums[1], 0,height-5);
        text(ledgeNums[2], width-getBound()*3,height-5);

        push();
            fill(255);
            textAlign(CENTER);
            translate(getBound()/2,height/2);
            rotate(PI/2);
            text(getY(),0,0);
            textAlign(LEFT);
        pop();
        
        push();
            fill(255);
            textAlign(CENTER);
            translate(width/2,height-(getBound()/2));
            text(getX(),0,0);
            textAlign(LEFT);
        pop();

        //Places dots
        push();
            //changes to drawing from the origin of the graph
            translate(getBound(), height-getBound());
            //defines area of graph
            float xGraphable = width - (getBound()*2);
            float yGraphable = height - (getBound()*2);
            
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
                fill(255);
                text("" + c.getName(),xPos + 20, yPos);
            }
            
            drawWackCurve(pnts,color(255));
            drawWackCurve(hPnts,color(255,0,255));
            drawLinearRegression(pnts, color(255));
            // graphCC(pnts,color(255));
            drawLinearRegression(hPnts, color(255,0,255));
        pop();
    }



    public void drawLinearRegression(ArrayList<PVector> pnts, color col){
        float a = (float)(((sumY(pnts)*sumXsq(pnts))-(sumX(pnts)*sumXY(pnts)))
                 /((pnts.size()*sumXsq(pnts))-(Math.pow(sumX(pnts),2))));
        float b = (float)(((pnts.size()*sumXY(pnts))-(sumX(pnts)*sumY(pnts)))
                 /((pnts.size()*sumXsq(pnts))-(Math.pow(sumX(pnts),2))));
        // System.out.println("y=ax+b :" + "y=" + b + "x + " + a);

        // a = 1/a;

        float endX = width-(graphBound*2);
        fill(col);
        stroke(col);
        line(0.0f,a, endX, b*endX + a);

    }

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
    
    public float coefficientOfCorrelation(ArrayList<PVector> pnts){
        float r = (float)(((pnts.size()*sumXY(pnts))-(sumX(pnts)*sumY(pnts)))
                 /(Math.sqrt((pnts.size()*sumXsq(pnts))-Math.pow(sumX(pnts),2))*Math.sqrt((pnts.size()*sumYsq(pnts))-Math.pow(sumY(pnts),2)))); 
        return r;
    }
    public void graphCC(ArrayList<PVector> pnts, color col){
        float b = (float)(((sumY(pnts)*sumXsq(pnts))-(sumX(pnts)*sumXY(pnts)))
                 /((pnts.size()*sumXsq(pnts))-(Math.pow(sumX(pnts),2))));
        // System.out.println(b);
        float r = coefficientOfCorrelation(pnts);
        float a = -1*(float)Math.pow(10,b);
        System.out.println("Ar^x = " + a + "" + r + "^x");
    }

}