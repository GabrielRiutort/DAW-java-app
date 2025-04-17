<%-- 
    Document   : insertar
    Created on : 13 ene 2025, 20:51:37
    Author     : graga
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Insertar Llibre</title>
    <!-- Incloure Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center mb-4">Afegir un Nou Llibre</h1>
        <form action="Insertar" method="post" class="shadow p-4 rounded bg-light">
            <div class="mb-3">
                <label for="titol" class="form-label">Títol:</label>
                <input type="text" id="titol" name="titol" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="isbn" class="form-label">ISBN:</label>
                <input type="text" id="isbn" name="isbn" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="any_publicacio" class="form-label">Any de Publicació:</label>
                <input type="number" id="any_publicacio" name="any_publicacio" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="id_editorial" class="form-label">ID de l'Editorial:</label>
                <input type="number" id="id_editorial" name="id_editorial" class="form-control" required>
            </div>
            <!-- Campo para seleccionar Autor -->
            <div class="mb-3">
                <label for="id_autor" class="form-label">Autor:</label>
                <select id="id_autor" name="id_autor" class="form-control" required>
                    <!-- Aquí se deben cargar los autores desde la base de datos -->
                    <option value="1">J.K. Rowling</option>
                    <option value="2">George R.R. Martin</option>
                    <option value="3">Dan Brown</option>
                    <option value="4">J.R.R. Tolkien</option>
                    <option value="5">Suzanne Collins</option>
                </select>
            </div>
            <!-- Campo para seleccionar Género -->
            <div class="mb-3">
                <label for="id_genere" class="form-label">Gènere:</label>
                <select id="id_genere" name="id_genere" class="form-control" required>
                    <!-- Aquí se deben cargar los géneros desde la base de datos -->
                    <option value="1">Fantasía</option>
                    <option value="2">Ciència Ficció</option>
                    <option value="3">Thriller</option>
                    <option value="4">Ficció Històrica</option>
                    <option value="5">Juvenil</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary w-100">Afegir Llibre</button>
        </form>
    </div>
</body>
</html>