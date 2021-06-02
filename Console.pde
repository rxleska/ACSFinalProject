import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
class Console {
    //Class Variables
    private String name;
    private TreeSet<Game> games;
    
    //Constuctors
    public Console(){
        name = "";
        games = new TreeSet<Game>();
    }
    public Console(String n){
        this();
        setName(n);
    }

    //Getters and Setters
    public void setName(String n){name = n;}
    public String getName(){return name;}
    public void addGame(Game g){games.add(g);}
    public void addGame(Set<Game> g){games.addAll(g);}
    public TreeSet getTree(){return games;}
    public int numGames(){return games.size();}

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
}
