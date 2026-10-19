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


-- 3) Análisis de dominios de correo
SELECT 
    SUBSTRING(Correo, CHARINDEX('@', Correo) + 1, LEN(Correo)) AS Dominio,
    COUNT(*) AS Cantidad_Usuarios
FROM Usuario
GROUP BY SUBSTRING(Correo, CHARINDEX('@', Correo) + 1, LEN(Correo))
HAVING COUNT(*) > 10;


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




-- 10) Juegos de Élite 

WITH Estadisticas_Juego AS (
    SELECT 
        ID_Producto_FK AS ID_Producto,
        COUNT(ID_Resena) AS Total_Resenas,
        AVG(Calificacion_1_10 * 1.0) AS Promedio_Calificacion
    FROM Resena
    GROUP BY ID_Producto_FK
),
Promedio_Estudios AS (
    -- 2. Calculamos el promedio de reseñas por estudio
    SELECT 
        jb.ID_Estudio_Dev_FK AS ID_Estudio,
        AVG(r.Calificacion_1_10 * 1.0) AS Promedio_Estudio
    FROM Juego_Base jb
    JOIN Resena r ON jb.ID_Producto_FK = r.ID_Producto_FK
    GROUP BY jb.ID_Estudio_Dev_FK
),
Reputacion_Promedio AS (
    -- 3. Calculamos el promedio general de reputación
    SELECT AVG(dbo.fn_calcular_reputacion(ID_Producto_FK)) AS Rep_Promedio_General
    FROM Juego_Base
)

SELECT 
    pd.Titulo, 
    ec.Nombre AS Estudio, 
    ej.Total_Resenas AS Total_Jugadores, -- Usamos las reseñas como métrica
    ej.Promedio_Calificacion,
    dbo.fn_calcular_reputacion(pd.ID_Producto) AS Puntaje_Reputacion
FROM Juego_Base jb
JOIN Producto_Digital pd ON jb.ID_Producto_FK = pd.ID_Producto
JOIN Empresa_Corporativa ec ON jb.ID_Estudio_Dev_FK = ec.ID_Empresa
JOIN Estadisticas_Juego ej ON pd.ID_Producto = ej.ID_Producto
JOIN Promedio_Estudios pe ON jb.ID_Estudio_Dev_FK = pe.ID_Estudio
CROSS JOIN Reputacion_Promedio rp
WHERE pd.ID_Producto NOT IN (SELECT DISTINCT ID_Producto_FK FROM Reembolso)
  AND ej.Total_Resenas >= 20
  AND ej.Promedio_Calificacion > pe.Promedio_Estudio -- Aquí va el MAYOR QUE
  AND dbo.fn_calcular_reputacion(pd.ID_Producto) > rp.Rep_Promedio_General
ORDER BY Puntaje_Reputacion DESC;

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

-- 12) Tendencias REVISAR
SELECT TOP 3 ec.Nombre_Etiqueta,  SUM(pe.Cantidad_Votos) AS Votos_Totales,
COUNT(DISTINCT pe.ID_Producto_FK) AS Productos_Asociados
FROM Etiqueta_Comunidad ec
JOIN Producto_Etiqueta pe ON ec.ID_Etiqueta = pe.ID_Etiqueta_FK
JOIN Producto_Digital pd ON pe.ID_Producto_FK = pd.ID_Producto
WHERE pd.Fecha_Lanzamiento >= DATEADD(YEAR, -1, GETDATE())
GROUP BY ec.ID_Etiqueta, ec.Nombre_Etiqueta
ORDER BY Votos_Totales DESC;


-- 13) Coleccionistas completos REVISAR
SELECT u.Nickname, p.Titulo AS Titulo_Juego, COUNT(DISTINCT dl.ID_Logro_FK) AS Total_Logros
FROM Usuario u
JOIN Desbloqueo_Logro dl ON u.Id_Usuario = dl.ID_Usuario_FK
JOIN Producto_Digital p ON dl.ID_Juego_Base_FK = p.ID_Producto
WHERE 
    (SELECT COUNT(*)
    FROM Logro l 
    WHERE l.ID_Juego_Base_FK = dl.ID_Juego_Base_FK) 
    = 
    (SELECT COUNT(DISTINCT dl2.ID_Logro_FK) 
     FROM Desbloqueo_Logro dl2 
     WHERE dl2.ID_Usuario_FK = u.Id_Usuario AND dl2.ID_Juego_Base_FK = dl.ID_Juego_Base_FK)
GROUP BY u.Nickname, p.Titulo;


-- 14) Liquidación de regalías


WITH VentasMes AS (
    SELECT ec.ID_Empresa, ec.Nombre AS Estudio, ec.Pais_Origen, ISNULL(SUM(df.Precio_Venta_Historico), 0.00) AS Ingreso_Bruto
    FROM Empresa_Corporativa ec
    JOIN Juego_Base jb ON ec.ID_Empresa = jb.ID_Estudio_Dev_FK
    JOIN Detalle_Factura df ON jb.ID_Producto_FK = df.ID_Producto_FK
    JOIN Factura f ON df.ID_Factura_FK = f.ID_Factura
    WHERE MONTH(f.Fecha_Hora_Emision) = MONTH(GETDATE())
      AND YEAR(f.Fecha_Hora_Emision) = YEAR(GETDATE())
    GROUP BY ec.ID_Empresa, ec.Nombre, ec.Pais_Origen
),
ReembolsosMes AS (
    SELECT jb.ID_Estudio_Dev_FK,  ISNULL(SUM(r.Monto_Reembolsado), 0.00) AS Total_Reembolsos
    FROM Reembolso r
    JOIN Juego_Base jb ON r.ID_Producto_FK = jb.ID_Producto_FK
    WHERE MONTH(r.Fecha_Reembolso) = MONTH(GETDATE())
      AND YEAR(r.Fecha_Reembolso) = YEAR(GETDATE())
    GROUP BY jb.ID_Estudio_Dev_FK
),
CalculoRegalias AS (
    SELECT v.Estudio, v.Pais_Origen, v.Ingreso_Bruto, ISNULL(rm.Total_Reembolsos, 0.00) AS Reembolsos,
      (v.Ingreso_Bruto - ISNULL(rm.Total_Reembolsos, 0.00)) AS Ingreso_Neto,
        dbo.fn_clasificar_ingreso(v.Ingreso_Bruto) AS Tramo_Comision,
        CASE dbo.fn_clasificar_ingreso(v.Ingreso_Bruto)
            WHEN 'AAA' THEN 0.30
            WHEN 'Consolidado' THEN 0.25
            WHEN 'Indie' THEN 0.20
            ELSE 0.20
        END AS Porcentaje_Comision,
        ((v.Ingreso_Bruto - ISNULL(rm.Total_Reembolsos, 0.00)) * 
            CASE dbo.fn_clasificar_ingreso(v.Ingreso_Bruto)
                WHEN 'AAA' THEN 0.30
                WHEN 'Consolidado' THEN 0.25
                WHEN 'Indie' THEN 0.20
                ELSE 0.20
            END
        ) AS Comision,
        ((v.Ingreso_Bruto - ISNULL(rm.Total_Reembolsos, 0.00)) * 
            (1 - CASE dbo.fn_clasificar_ingreso(v.Ingreso_Bruto)
                    WHEN 'AAA' THEN 0.30
                    WHEN 'Consolidado' THEN 0.25
                    WHEN 'Indie' THEN 0.20
                    ELSE 0.20
                END)
        ) AS Monto_A_Pagar
    FROM VentasMes v
    LEFT JOIN ReembolsosMes rm ON v.ID_Empresa = rm.ID_Estudio_Dev_FK
)
SELECT Estudio, Pais_Origen, Ingreso_Bruto, Reembolsos, Ingreso_Neto, Tramo_Comision, Comision, Monto_A_Pagar
FROM CalculoRegalias
WHERE Monto_A_Pagar > (SELECT AVG(Monto_A_Pagar) FROM CalculoRegalias);




-- 15) Ecosistema los sims 4 

WITH DLCs_Comprados AS (
    SELECT f.ID_Usuario_FK, COUNT(df.ID_Producto_FK) AS Cantidad_DLCs
    FROM Factura f
    JOIN Detalle_Factura df ON f.ID_Factura = df.ID_Factura_FK
    JOIN DLC d ON df.ID_Producto_FK = d.ID_Producto_FK
    WHERE d.ID_Juego_Base_FK = 301 
    GROUP BY f.ID_Usuario_FK
),
Mods_Suscritos AS (
    SELECT ID_Usuario_FK, COUNT(ID_Mod_FK) AS Mods_Suscritos
    FROM Suscripcion_Mod
    WHERE ID_Producto_Base_FK = 301
    GROUP BY ID_Usuario_FK
),
Gasto_Total AS (
    SELECT f.ID_Usuario_FK, SUM(df.Precio_Venta_Historico) AS Total_Gastado
    FROM Factura f
    JOIN Detalle_Factura df ON f.ID_Factura = df.ID_Factura_FK
    WHERE df.ID_Producto_FK = 301 
       OR df.ID_Producto_FK IN (SELECT ID_Producto_FK FROM DLC WHERE ID_Juego_Base_FK = 301)
    GROUP BY f.ID_Usuario_FK
),
Reembolsos_Total AS (
    SELECT f.ID_Usuario_FK, SUM(r.Monto_Reembolsado) AS Total_Reembolsado
    FROM Reembolso r
    JOIN Factura f ON r.ID_Factura_FK = f.ID_Factura
    WHERE r.ID_Producto_FK = 301 
       OR r.ID_Producto_FK IN (SELECT ID_Producto_FK FROM DLC WHERE ID_Juego_Base_FK = 301)
    GROUP BY f.ID_Usuario_FK
)
SELECT u.Nickname, dc.Cantidad_DLCs,  ms.Mods_Suscritos, (gt.Total_Gastado - COALESCE(rt.Total_Reembolsado, 0)) AS Dinero_Invertido
FROM Usuario u
JOIN Biblioteca b ON u.Id_Usuario = b.ID_Usuario_FK AND b.ID_Producto_FK = 301
JOIN DLCs_Comprados dc ON u.Id_Usuario = dc.ID_Usuario_FK AND dc.Cantidad_DLCs >= 5
JOIN Mods_Suscritos ms ON u.Id_Usuario = ms.ID_Usuario_FK AND ms.Mods_Suscritos >= 1
LEFT JOIN Gasto_Total gt ON u.Id_Usuario = gt.ID_Usuario_FK
LEFT JOIN Reembolsos_Total rt ON u.Id_Usuario = rt.ID_Usuario_FK
ORDER BY Dinero_Invertido DESC;







-- 16) Red cooperativa

WITH Amigos_Aceptados AS (
    SELECT ID_Usuario_Solicitante_FK AS ID_Usuario, ID_Usuario_Receptor_FK AS ID_Amigo
    FROM Amistad_Usuario
    WHERE Estado_Amistad = 'Aceptada'
    
    UNION ALL
    
    SELECT ID_Usuario_Receptor_FK AS ID_Usuario, ID_Usuario_Solicitante_FK AS ID_Amigo
    FROM Amistad_Usuario
    WHERE Estado_Amistad = 'Aceptada'
),
Amigos_Con_Overcooked AS (
    SELECT  aa.ID_Usuario, COUNT(DISTINCT aa.ID_Amigo) AS Amigos_Con_Juego
    FROM Amigos_Aceptados aa
    JOIN Biblioteca b_amigo ON aa.ID_Amigo = b_amigo.ID_Usuario_FK AND b_amigo.ID_Producto_FK = 309
    GROUP BY aa.ID_Usuario
)
SELECT u.Nickname, b.Horas_Jugadas, aco.Amigos_Con_Juego
FROM Usuario u
JOIN Biblioteca b ON u.Id_Usuario = b.ID_Usuario_FK AND b.ID_Producto_FK = 309
JOIN Amigos_Con_Overcooked aco ON u.Id_Usuario = aco.ID_Usuario
WHERE aco.Amigos_Con_Juego >= 2 
ORDER BY aco.Amigos_Con_Juego DESC;




--17) . Éxito a precio completo



WITH Idiomas_Por_Juego AS (
    SELECT ID_Producto_FK, COUNT(DISTINCT ID_Idioma_FK) AS Idiomas_Soportados
    FROM Soporte_Idioma
    GROUP BY ID_Producto_FK
    HAVING COUNT(DISTINCT ID_Idioma_FK) >= 4
),
Ventas_Sin_Descuento AS (
    SELECT ID_Producto_FK, COUNT(*) AS Ventas_Full_Price
    FROM Detalle_Factura
    WHERE Descuento_Aplicado_Pct = 0
    GROUP BY ID_Producto_FK
    HAVING COUNT(*) > 50
)
SELECT pd.Titulo, pd.Precio_Base_Actual, ipj.Idiomas_Soportados, vsd.Ventas_Full_Price
FROM Juego_Base jb
JOIN Producto_Digital pd ON jb.ID_Producto_FK = pd.ID_Producto
JOIN Idiomas_Por_Juego ipj ON pd.ID_Producto = ipj.ID_Producto_FK
JOIN Ventas_Sin_Descuento vsd ON pd.ID_Producto = vsd.ID_Producto_FK
WHERE pd.Precio_Base_Actual > ( SELECT AVG(pd_sub.Precio_Base_Actual)
                                FROM Juego_Base jb_sub
                                JOIN Producto_Digital pd_sub ON jb_sub.ID_Producto_FK = pd_sub.ID_Producto
                              );





-- 18) Imperios corporativos


WITH Jerarquia_Empresas AS (
    -- Caso Base: Empresas Matrices (las que no tienen matriz superior pero tienen subsidiarias)
    SELECT ec.ID_Empresa AS ID_Matriz_Principal, ec.Nombre AS Empresa_Matriz_Principal, ec.ID_Empresa AS ID_Subsidiaria,
    ec.Nombre AS Empresa_Subsidiaria, 1 AS Nivel_Jerarquia
    FROM Empresa_Corporativa ec
    WHERE ec.ID_Empresa_Matriz_FK IS NULL
      AND EXISTS (
          SELECT 1 
          FROM Empresa_Corporativa sub 
          WHERE sub.ID_Empresa_Matriz_FK = ec.ID_Empresa
      )

    UNION ALL

    SELECT j.ID_Matriz_Principal, j.Empresa_Matriz_Principal, ec.ID_Empresa AS ID_Subsidiaria, ec.Nombre AS Empresa_Subsidiaria,
    j.Nivel_Jerarquia + 1 AS Nivel_Jerarquia
    FROM Empresa_Corporativa ec
    INNER JOIN Jerarquia_Empresas j ON ec.ID_Empresa_Matriz_FK = j.ID_Subsidiaria
),
Productos_Por_Empresa AS (
    SELECT jb.ID_Estudio_Dev_FK AS ID_Empresa, jb.ID_Producto_FK AS ID_Producto
    FROM Juego_Base jb
    
    UNION ALL
    
    SELECT jb.ID_Estudio_Dev_FK AS ID_Empresa, d.ID_Producto_FK AS ID_Producto
    FROM DLC d
    INNER JOIN Juego_Base jb ON d.ID_Juego_Base_FK = jb.ID_Producto_FK
),
Ventas_Mes_Actual AS (
    SELECT df.ID_Producto_FK, SUM(df.Precio_Venta_Historico * (1 - (df.Descuento_Aplicado_Pct / 100.0))) AS Total_Ventas
    FROM Detalle_Factura df
    INNER JOIN Factura f ON df.ID_Factura_FK = f.ID_Factura
    WHERE MONTH(f.Fecha_Hora_Emision) = MONTH(GETDATE())
      AND YEAR(f.Fecha_Hora_Emision) = YEAR(GETDATE())
    GROUP BY df.ID_Producto_FK
),
Reembolsos_Mes_Actual AS (
    SELECT r.ID_Producto_FK, SUM(r.Monto_Reembolsado) AS Total_Reembolsos
    FROM Reembolso r
    WHERE MONTH(r.Fecha_Reembolso) = MONTH(GETDATE())
      AND YEAR(r.Fecha_Reembolso) = YEAR(GETDATE())
    GROUP BY r.ID_Producto_FK
)
SELECT je.Empresa_Matriz_Principal, je.Empresa_Subsidiaria, je.Nivel_Jerarquia, COUNT(DISTINCT pe.ID_Producto) AS Productos_Desarrollados,
    ISNULL(SUM(v.Total_Ventas), 0) - ISNULL(SUM(rm.Total_Reembolsos), 0) AS Ingreso_Neto_Mensual
FROM Jerarquia_Empresas je
INNER JOIN Productos_Por_Empresa pe ON je.ID_Subsidiaria = pe.ID_Empresa
LEFT JOIN Ventas_Mes_Actual v ON pe.ID_Producto = v.ID_Producto_FK
LEFT JOIN Reembolsos_Mes_Actual rm ON pe.ID_Producto = rm.ID_Producto_FK
WHERE je.Nivel_Jerarquia > 1 -- Excluir a la propia matriz de salir como su propia subsidiaria
GROUP BY  je.ID_Matriz_Principal, je.Empresa_Matriz_Principal, je.ID_Subsidiaria, je.Empresa_Subsidiaria, je.Nivel_Jerarquia
ORDER BY  je.Empresa_Matriz_Principal,  je.Nivel_Jerarquia, 
    Ingreso_Neto_Mensual DESC;







-- 19) Críticos Inexpertos 

WITH Logros_Totales_Por_Juego AS (
    SELECT ID_Juego_Base_FK, COUNT(ID_Logro) AS Total_Logros
    FROM Logro
    GROUP BY ID_Juego_Base_FK
    HAVING COUNT(ID_Logro) > 0
),
Logros_Desbloqueados_Usuario AS (
    SELECT ID_Usuario_FK, ID_Juego_Base_FK, COUNT(ID_Logro_FK) AS Logros_Desbloqueados
    FROM Desbloqueo_Logro
    GROUP BY ID_Usuario_FK, ID_Juego_Base_FK
)
SELECT u.Nickname, p.Titulo AS Titulo_Juego, r.Calificacion_1_10, COALESCE(ldu.Logros_Desbloqueados, 0) AS Logros_Desbloqueados,
    ltp.Total_Logros
FROM Resena r
JOIN Usuario u ON r.ID_Usuario_FK = u.Id_Usuario
JOIN Producto_Digital p ON r.ID_Producto_FK = p.ID_Producto
JOIN Juego_Base jb ON p.ID_Producto = jb.ID_Producto_FK
JOIN Logros_Totales_Por_Juego ltp ON p.ID_Producto = ltp.ID_Juego_Base_FK
LEFT JOIN Logros_Desbloqueados_Usuario ldu ON u.Id_Usuario = ldu.ID_Usuario_FK AND p.ID_Producto = ldu.ID_Juego_Base_FK
WHERE r.Calificacion_1_10 < 4 AND COALESCE(ldu.Logros_Desbloqueados, 0) < (ltp.Total_Logros * 0.10) 
ORDER BY u.Nickname;



-- 20) Circulo de confianza


DECLARE @ID_Usuario INT = 1;

WITH Red_Amigos_Bidireccional AS (
    SELECT ID_Usuario_Solicitante_FK AS ID_Usuario_A, ID_Usuario_Receptor_FK AS ID_Usuario_B
    FROM Amistad_Usuario
    WHERE Estado_Amistad = 'Aceptada'

    UNION

    SELECT ID_Usuario_Receptor_FK AS ID_Usuario_A, ID_Usuario_Solicitante_FK AS ID_Usuario_B
    FROM Amistad_Usuario
    WHERE Estado_Amistad = 'Aceptada'
),
Red_Contactos_Recursiva AS (
    SELECT 
        r.ID_Usuario_B AS ID_Contacto,
        1 AS Grado_Separacion
    FROM Red_Amigos_Bidireccional r
    WHERE r.ID_Usuario_A = @ID_Usuario

    UNION ALL

    SELECT 
        r.ID_Usuario_B AS ID_Contacto,
        rc.Grado_Separacion + 1 AS Grado_Separacion
    FROM Red_Amigos_Bidireccional r
    INNER JOIN Red_Contactos_Recursiva rc ON r.ID_Usuario_A = rc.ID_Contacto
    WHERE rc.Grado_Separacion < 3
),
Grado_Minimo_Contacto AS (
    SELECT 
        rc.ID_Contacto,
        MIN(rc.Grado_Separacion) AS Grado_Separacion
    FROM Red_Contactos_Recursiva rc
    WHERE rc.ID_Contacto <> @ID_Usuario
    GROUP BY rc.ID_Contacto
),
Juegos_Usuario_Origen AS (
    SELECT b.ID_Producto_FK
    FROM Biblioteca b
    INNER JOIN Juego_Base jb ON b.ID_Producto_FK = jb.ID_Producto_FK
    WHERE b.ID_Usuario_FK = @ID_Usuario
),
Juegos_Recomendables_Por_Contacto AS (
    SELECT 
        gmc.ID_Contacto,
        gmc.Grado_Separacion,
        COUNT(DISTINCT b_contacto.ID_Producto_FK) AS Juegos_Recomendables
    FROM Grado_Minimo_Contacto gmc
    INNER JOIN Biblioteca b_contacto ON gmc.ID_Contacto = b_contacto.ID_Usuario_FK
    INNER JOIN Juego_Base jb ON b_contacto.ID_Producto_FK = jb.ID_Producto_FK
    WHERE b_contacto.ID_Producto_FK NOT IN (SELECT ID_Producto_FK FROM Juegos_Usuario_Origen)
    GROUP BY gmc.ID_Contacto, gmc.Grado_Separacion
)
SELECT 
    u.Nickname AS Nickname_Contacto,
    jrc.Grado_Separacion,
    CASE jrc.Grado_Separacion
        WHEN 1 THEN 'Amigo directo'
        WHEN 2 THEN 'Amigo de un amigo'
        WHEN 3 THEN 'Contacto lejano'
    END AS Cercania,
    jrc.Juegos_Recomendables
FROM Juegos_Recomendables_Por_Contacto jrc
INNER JOIN Usuario u ON jrc.ID_Contacto = u.Id_Usuario
WHERE jrc.Juegos_Recomendables >= 1
ORDER BY 
    jrc.Grado_Separacion ASC, 
    jrc.Juegos_Recomendables DESC;
