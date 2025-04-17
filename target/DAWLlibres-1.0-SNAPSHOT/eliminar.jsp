<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Eliminar Llibre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container my-5">
        <h1 class="text-center mb-4">Eliminar Llibre</h1>

        <%
            String dbURL = "jdbc:mysql://192.168.1.137:3306/llibres"; 
            String dbUser = "usuari"; 
            String dbPassword = "usuari123"; 
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;

            try {
                // Conexión a la base de datos
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Recupera el ID del libro a eliminar
                String llibreId = request.getParameter("id");

                // Si el ID está presente, realizar la eliminación
                if (llibreId != null) {
                    // Paso 1: Eliminar las relaciones en la tabla intermédia (llibre_autor y llibre_genere)
                    String sqlDeleteAutor = "DELETE FROM llibre_autor WHERE id_llibre = ?";
                    stmt = conn.prepareStatement(sqlDeleteAutor);
                    stmt.setInt(1, Integer.parseInt(llibreId));
                    stmt.executeUpdate();

                    String sqlDeleteGenere = "DELETE FROM llibre_genere WHERE id_llibre = ?";
                    stmt = conn.prepareStatement(sqlDeleteGenere);
                    stmt.setInt(1, Integer.parseInt(llibreId));
                    stmt.executeUpdate();

                    // Paso 2: Eliminar el libro de la tabla llibres
                    String sqlDeleteLlibre = "DELETE FROM llibres WHERE id = ?";
                    stmt = conn.prepareStatement(sqlDeleteLlibre);
                    stmt.setInt(1, Integer.parseInt(llibreId));
                    int rowsAffected = stmt.executeUpdate();
                    
                    if (rowsAffected > 0) {
                        out.println("<div class='alert alert-success'>Llibre eliminat correctament.</div>");
                    } else {
                        out.println("<div class='alert alert-warning'>No s'ha trobat el llibre amb ID: " + llibreId + "</div>");
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error al connectar amb la base de dades: " + e.getMessage() + "</div>");
            } finally {
                // Tancar recursos
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>

        <div class="text-center mt-4">
            <a href="llibreria.jsp" class="btn btn-primary">Tornar a la llista de llibres</a>
        </div>
    </div>
</body>
</html>