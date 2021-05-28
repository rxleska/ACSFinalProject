class Game implements Comparable{
    private String name;
    private double fileSize;
    private String console;
    public Game(){
        name = "";
        fileSize = 0;
        console = "";
    }
    public Game(String n, double f, String c){
        this();
        setName(n);
        setSize(f);
        setConsole(c);
    }
    public Game(String n, String f, String c){
        this();
        setName(n);
        setSize(f);
        setConsole(c);
    }
    public int compareTo(Game g){
        return (int)(this.getSize() - g.getSize());
    }
    public String getName(){return name;}
    public void setName(String n){name = n;}
    public double getSize(){return fileSize;}
    public void setSize(double n){fileSize = n;}
    public void setSize(String s){fileSize = bFormatToBit(s);}
    public String getConsole(){return console;}
    public void setConsole(String s){console = s;}

    public double bFormatToBit(String s){
        return 0.0;
    }
}