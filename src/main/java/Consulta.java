
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/Consulta")
public class Consulta extends HttpServlet {

    /**
     * 
     * @param out
     * @throws SQLException
     */
    private void consultarLlibres(PrintWriter out) throws SQLException {
        // Connexió i consulta
        try (Connection conn = Connexio.getConnexio()) {
            // Consulta SQL
            String query = "SELECT llibres.titol, llibres.isbn, llibres.any_publicacio, " +
                           "editorials.nom AS editorial, GROUP_CONCAT(DISTINCT autors.nom) AS autors, " +
                           "GROUP_CONCAT(DISTINCT generes.nom) AS generes " +
                           "FROM llibres " +
                           "LEFT JOIN editorials ON llibres.id_editorial = editorials.id " +
                           "LEFT JOIN llibre_autor ON llibres.id = llibre_autor.id_llibre " +
                           "LEFT JOIN autors ON llibre_autor.id_autor = autors.id " +
                           "LEFT JOIN llibre_genere ON llibres.id = llibre_genere.id_llibre " +
                           "LEFT JOIN generes ON llibre_genere.id_genere = generes.id " +
                           "GROUP BY llibres.id";

            // Crear statement
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery(query)) {

                // Mostrar els resultats
                out.println("<table border='1'>");
                out.println("<tr><th>Títol</th><th>ISBN</th><th>Any de Publicació</th><th>Editorial</th><th>Autors</th><th>Gèneres</th></tr>");
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getString("titol") + "</td>");
                    out.println("<td>" + rs.getString("isbn") + "</td>");
                    out.println("<td>" + rs.getInt("any_publicacio") + "</td>");
                    out.println("<td>" + rs.getString("editorial") + "</td>");
                    out.println("<td>" + rs.getString("autors") + "</td>");
                    out.println("<td>" + rs.getString("generes") + "</td>");
                    out.println("</tr>");
                }
                
                out.println("</table>");
            }
        } catch (SQLException e) {
            out.println("<p>Error al consultar la base de dades: " + e.getMessage() + "</p>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Configurar la resposta per a tipus HTML
        response.setContentType("text/html;charset=UTF-8");
        
        // Crear el PrintWriter per escriure la resposta HTML
        try (PrintWriter out = response.getWriter()) {
            // Titular
            out.println("<html><head><title>Consulta de Llibres</title></head><body>");
            out.println("<h1>Llibres a la Base de Dades</h1>");

            // Cridar la funció per fer la consulta
            consultarLlibres(out);

            out.println("</body></html>");
        } catch (SQLException ex) {
            Logger.getLogger(Consulta.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tractar el mètode POST (si s'utilitza)
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet que realitza una consulta a la base de dades i mostra els llibres.";
    }
}