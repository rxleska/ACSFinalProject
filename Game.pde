import java.util.*;
class Game implements Comparable{
    private String name;
    private double fileSize;
    public Game(){
        name = "";
        fileSize = 0;
    }
    public Game(String n, double f){
        this();
        setName(n);
        setSize(f);
    }
    public Game(String n, String f){
        this();
        setName(n);
        setSize(f);
    }
    public int compareTo(Object g){
        return (int)(this.getSize() - ((Game)g).getSize());
    }
    public String getName(){return name;}
    public void setName(String n){name = n;}
    public double getSize(){return fileSize;}
    public void setSize(double n){fileSize = n;}
    public void setSize(String s){fileSize = bFormatToBit(s);}

    public double bFormatToBit(String s){
        return 0.0;
    }
}
