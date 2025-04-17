import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/Eliminar")
public class Eliminar extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String id = request.getParameter("id");

        try (PrintWriter out = response.getWriter()) {
            if (id == null || id.isEmpty()) {
                out.println("<p>Error: No s'ha especificat cap ID.</p>");
                return;
            }

            try (Connection conn = Connexio.getConnexio()) {
                String sql = "DELETE FROM llibres WHERE id = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, Integer.parseInt(id));
                    int rowsDeleted = stmt.executeUpdate();
                    if (rowsDeleted > 0) {
                        out.println("<p>Llibre eliminat correctament.</p>");
                    } else {
                        out.println("<p>Error: No s'ha trobat cap registre amb aquest ID.</p>");
                    }
                }
            } catch (Exception e) {
                out.println("<p>Error al connectar-se a la base de dades: " + e.getMessage() + "</p>");
            }
        }
    }
}