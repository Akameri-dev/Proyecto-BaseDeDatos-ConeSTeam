USE ConeSTeamDB;
GO

-- ============================================================================
-- CONSULTAS DE REPORTE (1 a 12)
-- ============================================================================

-- 1) Clasificación de Estudios por Facturación
SELECT 
ec.Nombre AS Estudio, ec.Pais_Origen, COUNT(df.ID_Producto_FK) AS Juegos_Vendidos, 
ISNULL(SUM(df.Precio_Venta_Historico * (1 - (df.Descuento_Aplicado_Pct / 100.0))), 0) AS Ingreso_Total, 
dbo.fn_clasificar_ingreso(ISNULL(SUM(df.Precio_Venta_Historico * (1 - (df.Descuento_Aplicado_Pct / 100.0))), 0)) AS Clasificacion
FROM Empresa_Corporativa ec
JOIN Juego_Base jb ON ec.ID_Empresa = jb.ID_Estudio_Dev_FK
JOIN Detalle_Factura df ON jb.ID_Producto_FK = df.ID_Producto_FK
JOIN Factura f ON df.ID_Factura_FK = f.ID_Factura
WHERE f.Fecha_Hora_Emision >= DATEADD(MONTH, -1, GETDATE())
GROUP BY ec.ID_Empresa, ec.Nombre, ec.Pais_Origen;
GO

-- 2) Éxito por Categoría
WITH PuntajesMaximos AS (
    SELECT jc.ID_Categoria_FK,
     MAX(((ISNULL(Ventas.Unidades_Vendidas, 0) * 2) + (ISNULL(Resenas.Total_Resenas, 0) * 1.5) + p.Metacritic_Score)) AS Max_Puntaje
    FROM Categoria_Oficial c
    JOIN Juego_Categoria jc ON c.ID_Categoria = jc.ID_Categoria_FK
    JOIN Producto_Digital p ON jc.ID_Producto_FK = p.ID_Producto
    LEFT JOIN (
        SELECT ID_Producto_FK, COUNT(*) AS Unidades_Vendidas 
        FROM Detalle_Factura 
        GROUP BY ID_Producto_FK
    ) Ventas ON p.ID_Producto = Ventas.ID_Producto_FK
    LEFT JOIN (
        SELECT ID_Producto_FK, COUNT(*) AS Total_Resenas 
        FROM Resena 
        GROUP BY ID_Producto_FK
    ) Resenas ON p.ID_Producto = Resenas.ID_Producto_FK
    GROUP BY jc.ID_Categoria_FK
)
SELECT 
    c.Nombre_Categoria, pd.Titulo, ec.Nombre AS Estudio, pm.Max_Puntaje AS Puntaje_Popularidad
FROM Categoria_Oficial c
JOIN Juego_Categoria jc ON c.ID_Categoria = jc.ID_Categoria_FK
JOIN Producto_Digital pd ON jc.ID_Producto_FK = pd.ID_Producto
JOIN PuntajesMaximos pm ON c.ID_Categoria = pm.ID_Categoria_FK
LEFT JOIN Juego_Base jb ON pd.ID_Producto = jb.ID_Producto_FK
LEFT JOIN Empresa_Corporativa ec ON jb.ID_Estudio_Dev_FK = ec.ID_Empresa
LEFT JOIN (
    SELECT ID_Producto_FK, COUNT(*) AS Unidades_Vendidas 
    FROM Detalle_Factura 
    GROUP BY ID_Producto_FK
) Ventas ON pd.ID_Producto = Ventas.ID_Producto_FK
LEFT JOIN (
    SELECT ID_Producto_FK, COUNT(*) AS Total_Resenas 
    FROM Resena 
    GROUP BY ID_Producto_FK
) Resenas ON pd.ID_Producto = Resenas.ID_Producto_FK
WHERE ((ISNULL(Ventas.Unidades_Vendidas, 0) * 2) + (ISNULL(Resenas.Total_Resenas, 0) * 1.5) + pd.Metacritic_Score) = pm.Max_Puntaje;
GO

-- 3) Análisis de dominios de correo
SELECT 
    SUBSTRING(Correo, CHARINDEX('@', Correo) + 1, LEN(Correo)) AS Dominio,
    COUNT(*) AS Cantidad_Usuarios
FROM Usuario
GROUP BY SUBSTRING(Correo, CHARINDEX('@', Correo) + 1, LEN(Correo))
HAVING COUNT(*) > 10;
GO

-- 4) Recompra temprana

SELECT u.Nickname, CAST(p1.Fecha_Primera AS DATE) AS Fecha_Primera_Compra, CAST(p2.Fecha_Segunda AS DATE) AS Fecha_Segunda_Compra,
    DATEDIFF(DAY, p1.Fecha_Primera, p2.Fecha_Segunda) AS Dias_Entre_Compras
FROM Usuario u

JOIN (
    SELECT ID_Usuario_FK, MIN(Fecha_Hora_Emision) AS Fecha_Primera
    FROM Factura
    GROUP BY ID_Usuario_FK
) p1 ON u.Id_Usuario = p1.ID_Usuario_FK

JOIN (
    SELECT f.ID_Usuario_FK, MIN(f.Fecha_Hora_Emision) AS Fecha_Segunda
    FROM Factura f
    JOIN ( SELECT ID_Usuario_FK, MIN(Fecha_Hora_Emision) AS Fecha_Primera
           FROM Factura
           GROUP BY ID_Usuario_FK
         ) primera ON f.ID_Usuario_FK = primera.ID_Usuario_FK
    WHERE f.Fecha_Hora_Emision > primera.Fecha_Primera
    GROUP BY f.ID_Usuario_FK
) p2 ON u.Id_Usuario = p2.ID_Usuario_FK

WHERE DATEDIFF(DAY, p1.Fecha_Primera, p2.Fecha_Segunda) <= 30;

-- 5) Peso del catálogo por estudio
SELECT ec.Nombre AS Estudio, COUNT(jb.ID_Producto_FK) AS Cantidad_Juegos,
    CASE 
        WHEN SUM(p.Tamano_GB) >= 1024 THEN 
            CAST(CAST(SUM(p.Tamano_GB) / 1024.0 AS DECIMAL(10,2)) AS VARCHAR(20)) + ' TB'
        ELSE 
            CAST(CAST(SUM(p.Tamano_GB) AS DECIMAL(10,2)) AS VARCHAR(20)) + ' GB'
    END AS Peso_Total
FROM Empresa_Corporativa ec
JOIN Juego_Base jb ON ec.ID_Empresa = jb.ID_Estudio_Dev_FK
JOIN Producto_Digital p ON jb.ID_Producto_FK = p.ID_Producto
GROUP BY ec.ID_Empresa, ec.Nombre;

-- 6) Mapa de Calor Financiero

WITH FacturacionPorPais AS (
    SELECT u.Pais_Residencia AS Pais, SUM(f.Total_Pagado - ISNULL(r.Monto_Reembolsado, 0)) AS Total_Neto
    FROM Usuario u
    JOIN Factura f ON u.Id_Usuario = f.ID_Usuario_FK
    LEFT JOIN Reembolso r ON f.ID_Factura = r.ID_Factura_FK
    GROUP BY u.Pais_Residencia
)
SELECT Pais, Total_Neto, CAST(CAST((Total_Neto * 100.0) / (
                                                            SELECT SUM(Total_Neto) 
                                                            FROM FacturacionPorPais) AS DECIMAL(5,2)) AS VARCHAR(20)) + '%' AS Share

FROM FacturacionPorPais;


-- 7) Bibliotecas Cruzadas

SELECT u.Nickname, SUM(f.Total_Pagado) AS Gasto_Total_Historico
FROM Usuario u
JOIN Factura f ON u.ID_Usuario = f.ID_Usuario_FK
WHERE u.ID_Usuario IN (
    SELECT b.ID_Usuario_FK 
    FROM Biblioteca b
    JOIN Juego_Categoria jc ON b.ID_Producto_FK = jc.ID_Producto_FK
    JOIN Categoria_Oficial c ON jc.ID_Categoria_FK = c.ID_Categoria
    WHERE c.Nombre_Categoria = 'Estrategia'
)
AND u.ID_Usuario IN (
    SELECT b.ID_Usuario_FK
    FROM Biblioteca b
    JOIN Juego_Categoria jc ON b.ID_Producto_FK = jc.ID_Producto_FK
    JOIN Categoria_Oficial c ON jc.ID_Categoria_FK = c.ID_Categoria
    WHERE c.Nombre_Categoria = 'Terror'
)
GROUP BY u.ID_Usuario, u.Nickname
HAVING SUM(f.Total_Pagado) > 100;
GO

-- 8) Generaciones
SELECT 
    CASE 
        WHEN YEAR(u.Fecha_Nacimiento) > 2000 THEN 'Gen Z'
        WHEN YEAR(u.Fecha_Nacimiento) BETWEEN 1981 AND 2000 THEN 'Millennials'
        ELSE 'Gen X y anteriores'
    END AS Generacion, COUNT(DISTINCT u.ID_Usuario) AS Cantidad_Usuarios_Activos,
    ISNULL(AVG(f.Total_Pagado), 0) AS Gasto_Promedio
FROM Usuario u
LEFT JOIN Factura f ON u.ID_Usuario = f.ID_Usuario_FK
WHERE u.Estado_Cuenta = 'Activa' 
GROUP BY 
    CASE 
        WHEN YEAR(u.Fecha_Nacimiento) > 2000 THEN 'Gen Z'
        WHEN YEAR(u.Fecha_Nacimiento) BETWEEN 1981 AND 2000 THEN 'Millennials'
        ELSE 'Gen X y anteriores'
    END;
GO

-- 9) Juegos Polémicos


SELECT pd.Titulo, COUNT(r.ID_Resena) AS Total_Resenas, AVG(r.Calificacion_1_10 * 1.0) AS Promedio_Calificacion,
    CASE 
        WHEN AVG(r.Calificacion_1_10 * 1.0) < 4 THEN 'Crítico'
        WHEN AVG(r.Calificacion_1_10 * 1.0) BETWEEN 4 AND 5.9 THEN 'Mixto'
        WHEN AVG(r.Calificacion_1_10 * 1.0) BETWEEN 6 AND 6.9 THEN 'Divisivo'
    END AS Veredicto
FROM Juego_Base jb
JOIN Producto_Digital pd ON jb.ID_Producto_FK = pd.ID_Producto
JOIN Resena r ON pd.ID_Producto = r.ID_Producto_FK
GROUP BY pd.ID_Producto, pd.Titulo
HAVING COUNT(r.ID_Resena) >= 20 AND AVG(r.Calificacion_1_10 * 1.0) < (SELECT AVG(Calificacion_1_10 * 1.0) 
                                                                      FROM Resena);
GO

-- 10) Juegos de Élite 
SELECT pd.Titulo, ec.Nombre AS Estudio, COUNT(DISTINCT b.ID_Usuario_FK) AS Total_Jugadores,
    AVG(r.Calificacion_1_10 * 1.0) AS Promedio_Calificacion,
    dbo.fn_calcular_reputacion(pd.ID_Producto) AS Puntaje_Reputacion
FROM Juego_Base jb
JOIN Producto_Digital pd ON jb.ID_Producto_FK = pd.ID_Producto
JOIN Empresa_Corporativa ec ON jb.ID_Estudio_Dev_FK = ec.ID_Empresa
JOIN Resena r ON pd.ID_Producto = r.ID_Producto_FK
LEFT JOIN Biblioteca b ON pd.ID_Producto = b.ID_Producto_FK

WHERE pd.ID_Producto NOT IN (SELECT DISTINCT ID_Producto 
                            FROM Reembolso)

GROUP BY pd.ID_Producto, pd.Titulo, ec.ID_Empresa, ec.Nombre

HAVING COUNT(r.ID_Resena) >= 20 
AND AVG(r.Calificacion_1_10 * 1.0) > (SELECT AVG(r2.Calificacion_1_10 * 1.0)
FROM Juego_Base jb2
JOIN Resena r2 ON jb2.ID_Producto_FK = r2.ID_Producto_FK
WHERE jb2.ID_Estudio_Dev_FK = ec.ID_Empresa
)
AND dbo.fn_calcular_reputacion(pd.ID_Producto) > (
        SELECT AVG(dbo.fn_calcular_reputacion(ID_Producto)) 
        FROM Juego_Base
   )
ORDER BY Puntaje_Reputacion DESC;
GO

-- 11) Usuarios “Lurkers”


SELECT u.Nickname, MAX(b.Fecha_Ultima_Sesion) AS Fecha_Ultima_Sesion, COUNT(b.ID_Producto_FK)    AS Juegos_En_Biblioteca
FROM Usuario u
JOIN Biblioteca b ON u.ID_Usuario = b.ID_Usuario_FK
WHERE NOT EXISTS (
        SELECT 1
        FROM Resena r 
        WHERE r.ID_Usuario_FK = u.ID_Usuario
      )
  AND NOT EXISTS (
        SELECT 1 
        FROM Desbloqueo_Logro d 
        WHERE d.ID_Usuario_FK = u.ID_Usuario
      )
GROUP BY u.ID_Usuario, u.Nickname;

-- 12) Tendencias 
SELECT TOP 3
    ec.Nombre_Etiqueta,
    SUM(pe.Cantidad_Votos) AS Votos_Totales,
    COUNT(DISTINCT pe.ID_Producto_FK) AS Productos_Asociados
FROM Etiqueta_Comunidad ec
JOIN Producto_Etiqueta pe ON ec.ID_Etiqueta = pe.ID_Etiqueta_FK
JOIN Producto_Digital pd ON pe.ID_Producto_FK = pd.ID_Producto
WHERE pd.Fecha_Lanzamiento >= DATEADD(YEAR, -1, GETDATE())
GROUP BY ec.ID_Etiqueta, ec.Nombre_Etiqueta
ORDER BY Votos_Totales DESC;
GO