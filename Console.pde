import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
class Console implements Comparable{
    //Class Variables
    private String name;
    private TreeSet<Game> games;
    public int year;
    public boolean handHeld;
    
    //Constuctors
    public Console(){
        name = "";
        games = new TreeSet<Game>();
        year = 0;
        handHeld = false;
    }
    public Console(String n){
        this();
        setName(n);
    }
    public Console(String n, String y){
        this();
        setName(n);
        setYear(y);
    }
    public Console(String n, int y){
        this();
        setName(n);
        setYear(y);
    }
    public Console(String n, String y, boolean h){this(n,y); setHHStatus(h);}
    public Console(String n, int y, boolean h){this(n,y); setHHStatus(h);}
    public Console(String n, String y, String h){this(n,y); setHHStatus(h);}
    public Console(String n, int y, String h){this(n,y); setHHStatus(h);}

    //#############################
    //#### Getters and Setters ####
    //#############################
    public void setName(String n){name = n;}
    public String getName(){return name;}
    //Tree of Games
    public void addGame(Game g){games.add(g);}
    public void addGame(Set<Game> g){games.addAll(g);}
    public TreeSet getTree(){return games;}
    public int numGames(){return games.size();}
    //Release Year 
    public void setYear(int y){year = y;}
    public void setYear(String y){year = parseInt(y);}
    public int getYear(){return year;}
    public String getTitle(){return getName() + ":" + getYear();}
    //Handheld vs full Console status
    public void setHHStatus(boolean h){handHeld = h;}
    public void setHHStatus(String s){handHeld = s.toUpperCase().equals("H");}
    public boolean isHandHeld(){return handHeld;}
    //Dynamic Getter and Setter
    public double getData(String s){
        switch(s.toLowerCase()){
            case "year":
                return (double) getYear();
            case "smallest":
                return getSmallest().getSize();
            case "largest":
                return getLargest().getSize();
            case "average":
                return getAverageSize();
            case "median":
                return getMedian().getSize();
            case "total":
                return getTotalSize();
            case "date":
                return (double) getYear();
            case "small":
                return getSmallest().getSize();
            case "large":
                return getLargest().getSize();
            case "ave":
                return getAverageSize();
            case "mid":
                return getMedian().getSize();
            case "tot":
                return getTotalSize();
        }
        return 0.0;
    }

    public String getDataReadable(String s){
        switch(s.toLowerCase()){
            case "year":
                return getYear() + "";
            case "smallest":
                return getSmallest().getSizeStr();
            case "largest":
                return getLargest().getSizeStr();
            case "average":
                return getAverageReadable();
            case "median":
                return getMedian().getSizeStr();
            case "total":
                return getTotalReadable();
            case "date":
                return getYear() + "";
            case "small":
                return getSmallest().getSizeStr();
            case "large":
                return getLargest().getSizeStr();
            case "ave":
                return getAverageReadable();
            case "mid":
                return getMedian().getSizeStr();
            case "tot":
                return getTotalReadable();
        }
        return "unrecognised value";
    }


    //randomly gets game from Set games
    public Game getRandomGame(){
        int i = (int) random(games.size());
        for(Game g: games){
            if(i==0){
                return g;
            }
            i--;
        }
        return games.first();
    }


    //Generates Set for Console based on read file
    public void generateSet(File f){
        try{
            Scanner read = new Scanner(f,"UTF-8");
            String curLine = "";
            while(read.hasNextLine()){
                lineODat++;
                curLine = read.nextLine();
                //Remove all text wrapped in () {} [] or <>
                curLine = curLine.replaceAll("\\([^)]*\\)|\\{[^}]*\\}|\\[.*?\\]|\\<[^>]*\\>", "");
                //Remove Commas Between Quotes
                curLine = removeCommaBetweenQuotes(curLine);
                //Remove all file extensions
                curLine = curLine.replaceAll(".rar","").replaceAll(".zip","").replaceAll(".iso","").replaceAll(".7z","").replaceAll(".nsp","").replaceAll(".wbfs","");
                //Remove - and Change _ to space for consistancy
                curLine = curLine.replaceAll("-","").replaceAll("_"," ");
                //Remove Speciality Number Codes Like the 3ds number code
                curLine = curLine.replaceAll("(3DS)\\d\\d\\d\\d","");
                //Remove all excess whitespace 
                curLine = curLine.replaceAll("( +)"," ").replaceAll("\t","").replaceAll("\"","");
                //Breaks the newly created line into chunks base upon commas then creates a new Game object based on the first two values from the line
                    String[] items = curLine.split(",");
                    //remove numbers other than years
                    items[0] = items[0].replaceAll("([03456789]\\d\\d\\d)|\\d{5,26}|\\b\\d{1,3}\\b|([2][3-8]\\d\\d)","");
                    //remove dots and excess spaces
                    items[0] = items[0].replaceAll("[.]"," ").replaceAll("( +)"," ").trim();
                    games.add(new Game(items[0], items[1]));
            }
            read.close();
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

    //uses Regex to remove commas in betweeen quotes by  
    public String removeCommaBetweenQuotes(String s){
        //Checking for quotes with commas in them
        if(s.matches("(.*)(\".*),(.*\")(.*)")){
            while(s.matches("(.*)(\".*),(.*\")(.*)")){
                //Gets index of where the quote is
                int i = indexOfReg("(\".*),(.*\")",s);
                //Takes quote chunk out 
                String chunk = firstCaseOfReg("(\".*),(.*\")", s); 
                s = s.replaceFirst("(\".*),(.*\")","");
                //Modifies the chunk
                chunk = chunk.replaceAll(",","").replaceAll("\"","");
                //joings back together the chunks
                s = s.substring(0,i) + chunk + s.substring(i);
            }
        }
        return s;
    }

    //Gets the index of a part of a string that matches regex
    public int indexOfReg(String regex,String string){
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(string);
        if(matcher.find()){
            return matcher.start();
        }
        return 0;
    }

    //Returns first case of regex seen in a string 
    public String firstCaseOfReg(String regex,String string){
        Pattern pattern = Pattern.compile(regex);
        Matcher matcher = pattern.matcher(string);
        if(matcher.find()){
            return matcher.group();
        }
        return "";
    }


    //Returns the smallest or largest game by file size and then by name
    public Game getSmallest(){return games.first();}
    public Game getLargest() {return games.last(); }
    //Returns Median by finding the middle item in the set
    public Game getMedian(){
        if(games.isEmpty())
            return null;
         Iterator iter = games.iterator();
         for(int mid = games.size()/2;mid > 0; mid--){
             iter.next();
         }
         return (Game) iter.next();
    }
    
    //Gets the average size of file by getting total then dividing
    public double getAverageSize(){
        double tot = 0.0;
        Iterator iter = games.iterator();
        while(iter.hasNext()){
            tot += ((Game)iter.next()).getSize();
        }
        return tot / games.size();
    }
    public String getAverageReadable(){
        return doubleToReadableSize(getAverageSize());
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

    //gets total file sizes of all games
    public double getTotalSize(){
        double tot = 0.0;
        Iterator iter = games.iterator();
        while(iter.hasNext()){
            tot += ((Game)iter.next()).getSize();
        }
        return tot;
    }
    public String getTotalReadable(){
        return doubleToReadableSize(getTotalSize());
    }
    public int compareTo(Object o){
        return this.getYear() - ((Console) o).getYear();
    }
    public String toString(){
        return getName() + ":" + getYear() + " -+- " +  numGames(); 
    }
}
