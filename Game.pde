import java.util.*;
class Game implements Comparable{
    private String name;
    private double fileSize;
    private String fileSizeStr;
    
    //Base Constuctor
    public Game(){
        name = "";
        fileSize = 0;
        fileSizeStr = "";
    }

    //Constuctor Based on a double for the file size
    public Game(String n, double f){
        this();
        setName(n);
        setSize(f);
        setSizeStr(f + "b");
    }

    //Constuctor Based on a string for the file size
    public Game(String n, String f){
        this();
        setName(n);
        setSize(f);
        setSizeStr(f);
    }

    //Compares by file size then by name of game 
    public int compareTo(Object g){
        // return (int)(this.getSize() - ((Game)g).getSize());
        if(this.getSize()==((Game)g).getSize())
            return this.getName().compareTo(((Game)g).getName());
        return (int)(this.getSize()-((Game)g).getSize());
    }

    //Getters and Setters
    public String getName(){return name;}
    public void setName(String n){name = n;}
    public double getSize(){return fileSize;}
    public void setSize(double n){fileSize = n;}
    public void setSize(String s){fileSize = bFormatToBit(s);} //calls bFormatToBit to convert string to numberic file Size
    public void setSizeStr(String s){fileSizeStr = s;}
    public String getSizeStr(){return fileSizeStr;}

    //Converts from String storage size to number of kilobytes
    public double bFormatToBit(String s){
        double totalSize = 0.0;
             if(s.contains("EB")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("EB")))) *1000000000000000.0;}
        else if(s.contains("Eb")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("Eb")))) *(1000000000000000.0/8);}
        else if(s.contains("PB")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("PB")))) *1000000000000.0;}
        else if(s.contains("Pb")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("Pb")))) *(1000000000000.0/8);}
        else if(s.contains("TB")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("TB")))) *1000000000.0;}
        else if(s.contains("Tb")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("Tb")))) *(1000000000.0/8);}
        else if(s.contains("GB")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("GB")))) *1000000.0;}
        else if(s.contains("Gb")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("Gb")))) *(1000000.0/8);}
        else if(s.contains("MB")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("MB")))) *1000.0;}
        else if(s.contains("Mb")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("Mb")))) *(1000.0/8);}
        else if(s.contains("KB")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("KB"))));}
        else if(s.contains("Kb")){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("Kb")))) *(1.0/8);}
        else if(s.contains("B" )){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("B" ))))/1000.0;}
        else if(s.contains("b" )){totalSize = Double.parseDouble(s.substring(0,(s.indexOf("b" )))) /(1000.0*8);}
        return totalSize;
    }
    //returns name:fileSize
    public String toString(){
        return name + " -:-  " + fileSizeStr;
    }
}
