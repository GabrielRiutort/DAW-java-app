import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/Modificar")
public class Modificar extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String llibreId = request.getParameter("id");
        String titol = request.getParameter("titol");
        String isbn = request.getParameter("isbn");
        String anyPublicacio = request.getParameter("any_publicacio");
        String idEditorial = request.getParameter("id_editorial");
        String idAutor = request.getParameter("id_autor");
        String idGenere = request.getParameter("id_genere");

        try (Connection conn = Connexio.getConnexio()) {
            // Actualizar libro
            String sql = "UPDATE llibres SET titol = ?, isbn = ?, any_publicacio = ?, id_editorial = ? WHERE id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, titol);
                stmt.setString(2, isbn);
                stmt.setInt(3, Integer.parseInt(anyPublicacio));
                stmt.setInt(4, Integer.parseInt(idEditorial));
                stmt.setInt(5, Integer.parseInt(llibreId));
                stmt.executeUpdate();
            }

            // Actualizar relación autor
            String deleteAutorSQL = "DELETE FROM llibre_autor WHERE id_llibre = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteAutorSQL)) {
                deleteStmt.setInt(1, Integer.parseInt(llibreId));
                deleteStmt.executeUpdate();
            }

            String insertAutorSQL = "INSERT INTO llibre_autor (id_llibre, id_autor) VALUES (?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertAutorSQL)) {
                insertStmt.setInt(1, Integer.parseInt(llibreId));
                insertStmt.setInt(2, Integer.parseInt(idAutor));
                insertStmt.executeUpdate();
            }

            // Actualizar relación género
            String deleteGenereSQL = "DELETE FROM llibre_genere WHERE id_llibre = ?";
            try (PreparedStatement deleteStmt = conn.prepareStatement(deleteGenereSQL)) {
                deleteStmt.setInt(1, Integer.parseInt(llibreId));
                deleteStmt.executeUpdate();
            }

            String insertGenereSQL = "INSERT INTO llibre_genere (id_llibre, id_genere) VALUES (?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertGenereSQL)) {
                insertStmt.setInt(1, Integer.parseInt(llibreId));
                insertStmt.setInt(2, Integer.parseInt(idGenere));
                insertStmt.executeUpdate();
            }

            // Redirigir después de la actualización
            response.sendRedirect("llibreria.jsp");

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.getWriter().write("Error al actualizar: " + e.getMessage());
        }
    }
}