class StatTrack{
    private int linesOfData, linesOfCode, comments, justWhiteSpace;

    public StatTrack(){
        linesOfData = 0;
        linesOfCode = 0;
        comments = 0;
        justWhiteSpace = 0;
    }

    public StatTrack(int d){this(); setDataLines(d); generateLinesOfCode();}
    public StatTrack(int d, int c){this(); setDataLines(d); setCodeLines(c);}

    //Setters
    public void setDataLines(int i){linesOfData = i;}
    public void setCodeLines(int i){linesOfCode = i;}
    public void setComments(int i){comments = i;}
    public void setWS(int i){justWhiteSpace = i;}

    //Getters
    public int getDataLines(){return linesOfData;}
    public int getCodeLines(){return linesOfCode;}
    public int getComments(){return comments;}
    public int getWS(){return justWhiteSpace;}

    //Generates numbers from code files
    public void generateLinesOfCode(){
        addNotIncludedData();
        File folder = new File(filePath);
        File[] listOfFiles = folder.listFiles();
        for(File file: listOfFiles){
            String name = file.getName();
            if(name.length() > 6 && name.substring(name.length()-4,name.length()).equals(".pde")){
                try{
                    Scanner read = new Scanner(file, "UTF-8");
                    while(read.hasNextLine()){
                        String ln = read.nextLine();
                        if(ln.contains("//"))
                            comments++;
                        if(ln.trim().length()==0)
                            justWhiteSpace++;
                        else if(ln.trim().charAt(0)!='/');
                            linesOfCode++;
                        
                    }
                    read.close();
                }
                catch(Exception e){
                    e.printStackTrace();
                }
            }
        }
    }

    public void displayData(){
        //Setup Text mode
        textSize(50);
        fill(255);
        stroke(255);
        textAlign(CENTER);
        //End Text
        text("Thank you for Viewing my ACS Final Project!!!\nHere are some Fun Facts about the project\nIt intook " + (linesOfData) + " lines of data\nAs well as " + (linesOfCode) + " full lines of Code\n"+ comments + " Code Commments\n" + justWhiteSpace + " lines of White Space for readablity\nI hope to Expand this project more in the future\nso stay tuned for updates on my github\nhttps://github.com/rxleska",width/2, 100);
        //reset
        setBasicTextSize();
        textAlign(LEFT);
    }

    public void addNotIncludedData(){
        File folder = new File(filePath+"/notIncludedData");
        File[] listOfFiles = folder.listFiles();
        for(File file: listOfFiles){
            try{
                    Scanner read = new Scanner(file, "UTF-8");
                    while(read.hasNextLine()){
                        linesOfData++;
                        read.nextLine();                        
                    }
                    read.close();
                }
                catch(Exception e){
                    e.printStackTrace();
                }
        }
    }
}