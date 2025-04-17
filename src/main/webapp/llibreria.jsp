<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Biblioteca</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body class="bg-light">
    <div class="container my-5">
        <h1 class="text-center mb-4">Llibres Disponibles</h1>

        <%
            String dbURL = "jdbc:mysql://192.168.1.137:3306/llibres"; // Canvia l'IP per la de la teva base de dades
            String dbUser = "usuari"; // Canvia pel nom d'usuari de la teva base de dades
            String dbPassword = "usuari123"; // Canvia per la contrasenya del teu usuari

            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                // Connexió a la base de dades
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

                // Consulta per obtenir els llibres amb informació associada
                String query = "SELECT llibres.titol, llibres.isbn, llibres.any_publicacio, " +
                               "editorials.nom AS editorial, GROUP_CONCAT(DISTINCT autors.nom) AS autors, " +
                               "GROUP_CONCAT(DISTINCT generes.nom) AS generes, llibres.id AS llibre_id " +
                               "FROM llibres " +
                               "LEFT JOIN editorials ON llibres.id_editorial = editorials.id " +
                               "LEFT JOIN llibre_autor ON llibres.id = llibre_autor.id_llibre " +
                               "LEFT JOIN autors ON llibre_autor.id_autor = autors.id " +
                               "LEFT JOIN llibre_genere ON llibres.id = llibre_genere.id_llibre " +
                               "LEFT JOIN generes ON llibre_genere.id_genere = generes.id " +
                               "GROUP BY llibres.id";

                stmt = conn.createStatement();
                rs = stmt.executeQuery(query);
        %>

        <table class="table table-bordered table-hover">
            <thead class="table-dark">
                <tr>
                    <th>Títol</th>
                    <th>ISBN</th>
                    <th>Any de Publicació</th>
                    <th>Editorial</th>
                    <th>Autors</th>
                    <th>Gèneres</th>
                    <th>Accions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getString("titol") %></td>
                    <td><%= rs.getString("isbn") %></td>
                    <td><%= rs.getInt("any_publicacio") %></td>
                    <td><%= rs.getString("editorial") %></td>
                    <td><%= rs.getString("autors") %></td>
                    <td><%= rs.getString("generes") %></td>
                    <td>
                        <a href="modificar.jsp?id=<%= rs.getInt("llibre_id") %>" class="btn btn-warning btn-sm">Modificar</a>
                        <a href="eliminar.jsp?id=<%= rs.getInt("llibre_id") %>" class="btn btn-danger btn-sm">Eliminar</a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>

        <div class="text-center">
            <a href="insertar.jsp" class="btn btn-success">Afegir Llibre</a>
        </div>

        <%
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error al connectar amb la base de dades: " + e.getMessage() + "</div>");
            } finally {
                // Tancar recursos
                if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
                if (stmt != null) try { stmt.close(); } catch (SQLException ignored) {}
                if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
            }
        %>
    </div>
</body>
</html>