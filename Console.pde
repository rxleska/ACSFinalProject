import java.util.*;
class Console {
    private String name;
    private Set<Game> games;
    
    public Console(){
        name = "";
        games = new TreeSet<Game>();
    }

    public void setName(String n){name = n;}
    public String getName(){return name;}
    public void addGame(Game g){games.add(g);}
    public void addGame(Set<Game> g){games.addAll(g);}
}
