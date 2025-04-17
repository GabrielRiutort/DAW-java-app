
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Connexio {

    
    private static final String DB_URL = "jdbc:mysql://192.168.1.137:3306/llibres"; // Canvia l'IP i el nom de la base de dades
    private static final String USER = "usuari"; // Canvia pel teu usuari de la base de dades
    private static final String PASSWORD = "usuari123"; // Canvia per la contrasenya del teu usuari

   /**
    * 
    * @return
    * @throws SQLException
    */
    public static Connection getConnexio() throws SQLException {
        try {
            // Carregar el driver de MySQL
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Retornar la connexió
            return DriverManager.getConnection(DB_URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException e) {
            throw new SQLException("Error al connectar amb la base de dades: " + e.getMessage(), e);
        }
    }
}
