<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Modificar Llibre</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container my-5">
        <h1 class="text-center mb-4">Modificar Llibre</h1>

        <%
            String dbURL = "jdbc:mysql://192.168.1.137:3306/llibres"; 
            String dbUser = "usuari"; 
            String dbPassword = "usuari123"; 
            Connection conn = null;
            PreparedStatement stmt = null;
            ResultSet rs = null;
            String llibreId = request.getParameter("id");

            String titol = "";
            String isbn = "";
            String anyPublicacio = "";
            String idEditorial = "";
            String idAutor = "";
            String idGenere = "";

            try {
                // Conexión a la base de datos
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Recuperar los datos del libro desde la base de datos
                if (llibreId != null) {
                    String sql = "SELECT * FROM llibres WHERE id = ?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setInt(1, Integer.parseInt(llibreId));
                    rs = stmt.executeQuery();

                    if (rs.next()) {
                        titol = rs.getString("titol");
                        isbn = rs.getString("isbn");
                        anyPublicacio = String.valueOf(rs.getInt("any_publicacio"));
                        idEditorial = String.valueOf(rs.getInt("id_editorial"));
                    }
                }

                // Recuperar el autor actual del libro
                String sqlAutor = "SELECT a.id, a.nom FROM autors a " +
                                  "JOIN llibre_autor la ON a.id = la.id_autor " +
                                  "WHERE la.id_llibre = ?";
                PreparedStatement stmtAutor = conn.prepareStatement(sqlAutor);
                stmtAutor.setInt(1, Integer.parseInt(llibreId));
                ResultSet rsAutor = stmtAutor.executeQuery();

                // Recuperar el género actual del libro
                String sqlGenere = "SELECT g.id, g.nom FROM generes g " +
                                   "JOIN llibre_genere lg ON g.id = lg.id_genere " +
                                   "WHERE lg.id_llibre = ?";
                PreparedStatement stmtGenere = conn.prepareStatement(sqlGenere);
                stmtGenere.setInt(1, Integer.parseInt(llibreId));
                ResultSet rsGenere = stmtGenere.executeQuery();

        %>

        <!-- Formulario para modificar el libro -->
        <form action="Modificar" method="post" class="shadow p-4 rounded bg-light">
            <input type="hidden" name="id" value="<%= llibreId %>">

            <!-- Títol -->
            <div class="mb-3">
                <label for="titol" class="form-label">Títol:</label>
                <input type="text" id="titol" name="titol" class="form-control" value="<%= titol %>" required>
            </div>

            <!-- ISBN -->
            <div class="mb-3">
                <label for="isbn" class="form-label">ISBN:</label>
                <input type="text" id="isbn" name="isbn" class="form-control" value="<%= isbn %>" required>
            </div>

            <!-- Any de publicació -->
            <div class="mb-3">
                <label for="any_publicacio" class="form-label">Any de Publicació:</label>
                <input type="number" id="any_publicacio" name="any_publicacio" class="form-control" value="<%= anyPublicacio %>" required>
            </div>

            <!-- ID Editorial -->
            <div class="mb-3">
                <label for="id_editorial" class="form-label">ID Editorial:</label>
                <input type="number" id="id_editorial" name="id_editorial" class="form-control" value="<%= idEditorial %>" required>
            </div>

            <!-- Autor -->
            <div class="mb-3">
                <label for="id_autor" class="form-label">Autor:</label>
                <select id="id_autor" name="id_autor" class="form-control" required>
                    <%
                        while (rsAutor.next()) {
                            String autorId = rsAutor.getString("id");
                            String autorNom = rsAutor.getString("nom");
                            String selected = (autorId.equals(idAutor)) ? "selected" : "";
                            out.println("<option value='" + autorId + "' " + selected + ">" + autorNom + "</option>");
                        }
                    %>
                </select>
            </div>

            <!-- Gènere -->
            <div class="mb-3">
                <label for="id_genere" class="form-label">Gènere:</label>
                <select id="id_genere" name="id_genere" class="form-control" required>
                    <%
                        while (rsGenere.next()) {
                            String genereId = rsGenere.getString("id");
                            String genereNom = rsGenere.getString("nom");
                            String selected = (genereId.equals(idGenere)) ? "selected" : "";
                            out.println("<option value='" + genereId + "' " + selected + ">" + genereNom + "</option>");
                        }
                    %>
                </select>
            </div>

            <!-- Botones de Acción -->
            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-success">Actualizar</button>
                <a href="llibreria.jsp" class="btn btn-danger">Cancelar</a>
            </div>
        </form>

        <%
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error al conectar con la base de datos: " + e.getMessage() + "</div>");
            } finally {
                // Cerrar recursos
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>

    </div>
</body>
</html>