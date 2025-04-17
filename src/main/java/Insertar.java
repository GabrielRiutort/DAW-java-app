import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/Insertar")
public class Insertar extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head><title>Afegir Llibre</title></head>");
            out.println("<body>");
            out.println("<h1>Formulari per afegir un nou llibre</h1>");
            out.println("<form action='Insertar' method='post'>");

            // Campos del formulario
            out.println("<label for='titol'>Títol:</label><br>");
            out.println("<input type='text' id='titol' name='titol' required><br>");
            out.println("<label for='isbn'>ISBN:</label><br>");
            out.println("<input type='text' id='isbn' name='isbn' required><br>");
            out.println("<label for='any_publicacio'>Any de Publicació:</label><br>");
            out.println("<input type='number' id='any_publicacio' name='any_publicacio' required><br>");
            out.println("<label for='id_editorial'>ID Editorial:</label><br>");
            out.println("<input type='number' id='id_editorial' name='id_editorial' required><br><br>");

            // Selección de autor
            out.println("<label for='id_autor'>Autor:</label><br>");
            out.println("<select id='id_autor' name='id_autor' required>");
            // Aquí deberías cargar los autores de la base de datos
            out.println("<option value='1'>J.K. Rowling</option>");
            out.println("<option value='2'>George R.R. Martin</option>");
            out.println("<option value='3'>Dan Brown</option>");
            out.println("<option value='4'>J.R.R. Tolkien</option>");
            out.println("<option value='5'>Suzanne Collins</option>");
            out.println("</select><br><br>");

            // Selección de género
            out.println("<label for='id_genere'>Gènere:</label><br>");
            out.println("<select id='id_genere' name='id_genere' required>");
            // Aquí deberías cargar los géneros de la base de datos
            out.println("<option value='1'>Fantasía</option>");
            out.println("<option value='2'>Ciència Ficció</option>");
            out.println("<option value='3'>Thriller</option>");
            out.println("<option value='4'>Ficció Històrica</option>");
            out.println("<option value='5'>Juvenil</option>");
            out.println("</select><br><br>");

            out.println("<button type='submit'>Afegir Llibre</button>");
            out.println("</form>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String titol = request.getParameter("titol");
        String isbn = request.getParameter("isbn");
        String anyPublicacio = request.getParameter("any_publicacio");
        String idEditorial = request.getParameter("id_editorial");
        String idAutor = request.getParameter("id_autor");
        String idGenere = request.getParameter("id_genere");

        try (PrintWriter out = response.getWriter()) {
            if (titol == null || isbn == null || anyPublicacio == null || idEditorial == null || idAutor == null || idGenere == null) {
                out.println("<p>Error: Falten dades al formulari.</p>");
                return;
            }

            try (Connection conn = Connexio.getConnexio()) {
                // Paso 1: Insertar el libro en la tabla llibres
                String sqlLlibre = "INSERT INTO llibres (titol, isbn, any_publicacio, id_editorial) VALUES (?, ?, ?, ?)";
                try (PreparedStatement stmtLlibre = conn.prepareStatement(sqlLlibre, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    stmtLlibre.setString(1, titol);
                    stmtLlibre.setString(2, isbn);
                    stmtLlibre.setInt(3, Integer.parseInt(anyPublicacio));
                    stmtLlibre.setInt(4, Integer.parseInt(idEditorial));

                    int rowsInserted = stmtLlibre.executeUpdate();

                    if (rowsInserted > 0) {
                        // Obtener el ID del libro recién insertado
                        ResultSet rs = stmtLlibre.getGeneratedKeys();
                        if (rs.next()) {
                            int idLlibre = rs.getInt(1);  // ID del libro

                            // Paso 2: Insertar relación libro-autor
                            String sqlLlibreAutor = "INSERT INTO llibre_autor (id_llibre, id_autor) VALUES (?, ?)";
                            try (PreparedStatement stmtLlibreAutor = conn.prepareStatement(sqlLlibreAutor)) {
                                stmtLlibreAutor.setInt(1, idLlibre);
                                stmtLlibreAutor.setInt(2, Integer.parseInt(idAutor));
                                stmtLlibreAutor.executeUpdate();
                            }

                            // Paso 3: Insertar relación libro-género
                            String sqlLlibreGenere = "INSERT INTO llibre_genere (id_llibre, id_genere) VALUES (?, ?)";
                            try (PreparedStatement stmtLlibreGenere = conn.prepareStatement(sqlLlibreGenere)) {
                                stmtLlibreGenere.setInt(1, idLlibre);
                                stmtLlibreGenere.setInt(2, Integer.parseInt(idGenere));
                                stmtLlibreGenere.executeUpdate();
                            }

                            out.println("<p>Llibre inserit correctament!</p>");
                            // Redirigir a la página de inicio o tabla
                            response.sendRedirect("llibreria.jsp");
                        }
                    } else {
                        out.println("<p>Error: No s'ha pogut inserir el llibre.</p>");
                    }
                }
            } catch (Exception e) {
                out.println("<p>Error al connectar-se a la base de dades: " + e.getMessage() + "</p>");
            }
        }
    }
}