USE ConeSTeamDB;
GO



-- ==========================================
-- PASO 1: Meter un juego al carrito del Usuario 5
-- (Usamos el juego 310 para que no dé error de que ya lo tiene)
-- ==========================================
INSERT INTO Carrito (Fecha_Agregado, ID_Usuario_FK, ID_Producto_FK) 
VALUES (GETDATE(), 5, 310);
GO

-- ==========================================
-- PASO 2: Ejecutar el Procedimiento Almacenado
-- ==========================================
EXEC sp_realizar_compra @ID_Usuario = 5, @ID_Metodo_Pago = 1;
GO

-- ==========================================
-- PASO 3: Verificaciones (Comprobar que funcionó)
-- ==========================================

PRINT '--- 1. Verificando que el carrito quedó vacío ---';
SELECT * FROM Carrito WHERE ID_Usuario_FK = 5;

PRINT '--- 2. Verificando la última factura generada ---';
SELECT TOP 1 * FROM Factura ORDER BY ID_Factura DESC;

PRINT '--- 3. Verificando el detalle de esa factura ---';
SELECT TOP 1 * FROM Detalle_Factura ORDER BY ID_Factura_FK DESC;

PRINT '--- 4. Verificando que el Trigger 3 metió el juego a la Biblioteca ---';
SELECT * FROM Biblioteca WHERE ID_Usuario_FK = 5 AND ID_Producto_FK = 310;
GO




USE ConeSTeamDB;
GO
EXEC sp_dashboard_estudio @ID_Empresa = 14, @FechaInicio = '2026-10-01', @FechaFin = '2026-10-31';


USE ConeSTeamDB;
GO
EXEC sp_publicar_producto_con_etiquetas 
    @Titulo = 'Mi Juego Increible', 
    @DescCorta = 'Un juego de prueba', 
    @DescLarga = 'Este es un juego creado desde un SP',
    @Fecha = '2026-10-18', 
    @Tamano = 15.5, 
    @Clasificacion = 'T', 
    @Precio = 29.99, 
    @Tipo = 'Juego_Base', 
    @Metacritic = 85, 
    @Etiquetas = 'RPG,Acción,Inventada,Supervivencia', 
    @Motor = 'Unreal', 
    @Compras = 1, 
    @Cloud = 1, 
    @ID_Estudio = 14, 
    @ID_Publisher = 3;
GO

-- Verificación
SELECT * FROM Producto_Digital WHERE Titulo = 'Mi Juego Increible';
SELECT e.Nombre_Etiqueta 
FROM Producto_Etiqueta pe
JOIN Etiqueta_Comunidad e ON pe.ID_Etiqueta_FK = e.Id_Etiqueta
WHERE pe.ID_Producto_FK = (SELECT ID_Producto FROM Producto_Digital WHERE Titulo = 'Mi Juego Increible');



USE ConeSTeamDB;
GO
EXEC sp_desbloquear_logro @ID_Usuario = 1, @ID_Juego_Base = 309, @ID_Logro = 1;
GO

-- Verificación
SELECT * FROM Desbloqueo_Logro WHERE ID_Usuario_FK = 1 AND ID_Juego_Base_FK = 309 AND ID_Logro_FK = 1;

USE ConeSTeamDB;
GO
-- Reembolsamos el juego 310 al usuario 5 (Factura 605)
EXEC sp_procesar_reembolso 
    @ID_Factura = 605, 
    @ID_Producto = 310, 
    @Motivo = 'No me gustó el juego';
GO

-- Verificación 1: El reembolso debe aparecer en la tabla
SELECT * FROM Reembolso WHERE ID_Factura_FK = 605;

-- Verificación 2: El Trigger 4 debió borrar el juego 310 de la biblioteca del usuario 5
SELECT * FROM Biblioteca WHERE ID_Usuario_FK = 5 AND ID_Producto_FK = 310;