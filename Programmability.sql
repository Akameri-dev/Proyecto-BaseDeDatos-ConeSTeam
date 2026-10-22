USE ConeSTeamDB;
GO

/*ADD FUNC
*/
CREATE FUNCTION fn_calcular_impuesto(@monto DECIMAL(10, 2))
    RETURNS DECIMAL(10, 2)
    AS
    BEGIN
        SET @monto= @monto * 0.16
        RETURN @monto
    END;
GO

CREATE FUNCTION fn_precio_con_descuento(@ID_Producto INT, @fecha DATE)
    RETURNS DECIMAL(10, 2)
    BEGIN
        DECLARE @precio_final DECIMAL(10, 2)
        DECLARE @precio_base DECIMAL(10, 2)
        DECLARE @porcentaje DECIMAL (3, 2)

        --conseguimos precios base y lo guardamos en su var 
        SELECT @precio_base = pd.Precio_Base_Actual
        FROM Producto_Digital pd 
        WHERE pd.ID_Producto = @ID_Producto

        --obtenemos el porcentaje si existe
        SELECT @porcentaje = hd.Porcentaje_Descuento
        FROM Historial_Descuento hd
        WHERE (@ID_Producto = hd.ID_Producto_FK
              AND @fecha <= hd.Fecha_Fin AND hd.Fecha_Inicio <= @fecha)

        --revisa para definir precio final
        IF @porcentaje IS NOT NULL
            BEGIN
                SET @precio_final = @precio_base - (@precio_base * @porcentaje)
            END;
        ELSE
            BEGIN
                SET @precio_final = @precio_base
            END;    

        RETURN @precio_final
    END; 
GO

CREATE FUNCTION fn_clasificar_ingreso (@monto DECIMAL(10, 2))
    RETURNS VARCHAR(12)
    AS
    BEGIN
        DECLARE @clasif VARCHAR(12)

        --establecemos un clasif segun el @monto
        IF @monto > 10000
            BEGIN
                SET @clasif = 'AAA'
            END;
        ELSE IF @monto BETWEEN 2000 AND 10000
            BEGIN
                SET @clasif = 'Consolidado'
            END;
        ELSE
            BEGIN
                SET @clasif = 'Indie'
            END;

        RETURN @clasif
    END;
GO
    
--SET @clasif = CASE 
--WHEN @monto > 10000 THEN 'AAA'
--WHEN @monto BETWEEN 2000 AND 10000 THEN 'Consolidado'
--ELSE 'Indie'
--END;  
--otra forma de hacerlo era asi, pero hoy no dejare que jarvis guie mi codigo*/



  
CREATE FUNCTION fn_calcular_reputacion(@ID_Producto INT)
    RETURNS DECIMAL(5, 2)
    AS
    BEGIN
        DECLARE @reputacion DECIMAL(5, 2)
        DECLARE @promedio_calificacion DECIMAL(5, 2)
        DECLARE @puntaje_metacritic DECIMAL(5, 2)
        DECLARE @total_jugadores INT

        -- obtener promedio
        SELECT @promedio_calificacion = ISNULL(SUM(r.Calificacion_1_10 * 1.0) / NULLIF(COUNT(r.ID_Usuario_FK), 0), 0)
        FROM Resena r 
        WHERE @Id_Producto = r.ID_Producto_FK

        -- obtener puntaje metacritic
        SELECT @puntaje_metacritic = ISNULL(pd.Metacritic_Score, 0)
        FROM Producto_Digital pd
        WHERE @ID_Producto = pd.ID_Producto

        -- obtener total jugadores

        SELECT @total_jugadores = COUNT(b.ID_Usuario_FK)
        FROM Biblioteca b
        WHERE b.ID_Producto_FK = @Id_Producto

        -- calculo de formula
        -- tiene tope en 100, deberiamos revisar en la practica, de mientras voy a obligar que si pasa de ese valor, lo forzaremos a 100
        SET @reputacion = (@promedio_calificacion * 7) + (@puntaje_metacritic * 0.2) + (@total_jugadores * 0.05)

        IF (@reputacion > 100)
            BEGIN
                SET @reputacion = 100
            END;

        RETURN @reputacion

    END;
GO

CREATE FUNCTION fn_calcular_horas_totales_usuario(@ID_Usuario INT)
    RETURNS DECIMAL(10, 2)
    AS
    BEGIN
        DECLARE @horas_totales DECIMAL(10, 2)

        -- observamos si el wey no tiene productos en biblioteca con el isnull 
        SELECT @horas_totales = ISNULL(SUM(b.Horas_Jugadas),0.0)
        FROM Biblioteca b
        WHERE @ID_Usuario = b.ID_Usuario_FK

        RETURN @horas_totales
    END;
GO



/*ADD TRIGGER
*/
CREATE TRIGGER tr_Auditoria_Precios
ON Producto_Digital
AFTER UPDATE 
AS
    BEGIN  
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN DELETED d ON i.ID_Producto = d.ID_Producto
            WHERE d.Precio_Base_Actual != 0
                AND ABS(i.Precio_Base_Actual - d.Precio_Base_Actual) > (d.Precio_Base_Actual * 0.5) 
        ) BEGIN
            RAISERROR('El cambio supera el 50% del precio anterior.', 16, 1);
            ROLLBACK TRANSACTION;
        END;
    END;
GO

CREATE TRIGGER tr_Proteccion_menores
ON Detalle_Factura
AFTER INSERT
AS
    BEGIN 
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN Producto_Digital pd ON pd.ID_Producto = i.ID_Producto_FK
            JOIN Factura f ON f.ID_Factura = i.ID_Factura_FK
            JOIN Usuario u ON u.Id_Usuario = f.ID_Usuario_FK
            WHERE (pd.Clasificacion_Edad IN ('M', 'AO'))
                AND u.Fecha_Nacimiento > DATEADD(YEAR,-13,GETDATE()) -- arreglao, aqui la idea es que los mayores de 13 puedan

        ) BEGIN
            RAISERROR('Error: papi fuera de aqui que ute no tiene la eda necesaria.', 16, 2);
            ROLLBACK TRANSACTION; 
        END
END;
GO

--raise error es ocmo un emnsaje de error que puedes darle un valor de gravedad de err


CREATE TRIGGER tr_Add_auto_biblioteca
ON Detalle_Factura
AFTER INSERT
AS
        BEGIN
        INSERT INTO Biblioteca (ID_Usuario_FK, ID_Producto_FK, Horas_Jugadas, Fecha_Ultima_Sesion)
            SELECT f.ID_Usuario_FK, i.ID_Producto_FK, 0, NULL
            FROM INSERTED i
            JOIN Factura f ON i.ID_Factura_FK = f.ID_Factura
            WHERE NOT EXISTS (
                SELECT 1
                FROM Biblioteca b
                WHERE (b.ID_Usuario_FK = f.ID_Usuario_FK
                        AND b.ID_Producto_FK = i.ID_Producto_FK)
            )     
END;
GO

--funciona por el orden de ejecucion de los tr

--reembolso = chao de biblioteca
CREATE TRIGGER  tr_Reembolso_dlt
ON Reembolso
AFTER INSERT
AS
    BEGIN
        DELETE b
        FROM Biblioteca b
        JOIN INSERTED i ON b.ID_Producto_FK = i.ID_Producto_FK
        JOIN Factura f ON f.ID_Factura = i.ID_Factura_FK
        WHERE b.ID_Usuario_FK = f.ID_Usuario_FK;
END;
GO


CREATE TRIGGER tr_Validaciones_carrito
ON Carrito
AFTER INSERT
AS
    BEGIN  
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN Biblioteca b ON b.ID_Usuario_FK = i.ID_Usuario_FK
            WHERE b.ID_Producto_FK = i.ID_Producto_FK
        ) BEGIN
            RAISERROR('Producto ya en biblioteca.', 16, 3);
            ROLLBACK TRANSACTION;
        END

        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN DLC dlc ON dlc.ID_Producto_FK = i.ID_Producto_FK
            WHERE NOT EXISTS (
                SELECT 1
                FROM Biblioteca b
                WHERE dlc.ID_Juego_Base_FK = b.ID_Producto_FK AND b.ID_Usuario_FK = i.ID_Usuario_FK

            UNION

                SELECT 1
                FROM Carrito c
                WHERE c.ID_Usuario_FK = i.ID_Usuario_FK AND c.ID_Producto_FK = dlc.ID_Juego_Base_FK

            )

        ) BEGIN
            RAISERROR('Producto Falta de Juego Base.', 16, 4);
            ROLLBACK TRANSACTION;
        END

    END;
GO










/*ADD SP
*/


CREATE PROCEDURE sp_realizar_compra
    @ID_Usuario INT,
    @ID_Metodo_Pago INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- Validar que el carrito no esté vacío
        IF NOT EXISTS (SELECT 1 FROM Carrito WHERE ID_Usuario_FK = @ID_Usuario)
        BEGIN
            RAISERROR('El carrito está vacío.', 16, 1);
        END

        -- Validar que el usuario no posea ya alguno de los productos del carrito
        IF EXISTS (
            SELECT 1 FROM Carrito c 
            JOIN Biblioteca b ON c.ID_Usuario_FK = b.ID_Usuario_FK AND c.ID_Producto_FK = b.ID_Producto_FK
            WHERE c.ID_Usuario_FK = @ID_Usuario
        )
        BEGIN
            RAISERROR('El usuario ya posee uno o más productos del carrito en su biblioteca.', 16, 1);
        END

        -- Variables
        DECLARE @SubTotal DECIMAL(10,2) = 0;
        DECLARE @MontoDescuento DECIMAL(10,2) = 0;
        DECLARE @MontoImpuesto DECIMAL(10,2) = 0;
        DECLARE @TotalPagado DECIMAL(10,2) = 0;
        DECLARE @FechaActual DATE = CAST(GETDATE() AS DATE);

        -- Tabla temporal para procesar los items
        DECLARE @Items TABLE (ID_Producto INT, PrecioOriginal DECIMAL(10,2), PrecioFinal DECIMAL(10,2), DescuentoAplicado DECIMAL(10,2));

        -- Calcular precios usando tus funciones
        INSERT INTO @Items (ID_Producto, PrecioOriginal, PrecioFinal, DescuentoAplicado)
        SELECT 
            c.ID_Producto_FK,
            pd.Precio_Base_Actual,
            dbo.fn_precio_con_descuento(c.ID_Producto_FK, @FechaActual),
            pd.Precio_Base_Actual - dbo.fn_precio_con_descuento(c.ID_Producto_FK, @FechaActual)
        FROM Carrito c
        JOIN Producto_Digital pd ON c.ID_Producto_FK = pd.ID_Producto
        WHERE c.ID_Usuario_FK = @ID_Usuario;

        -- Sumar totales
        SELECT @SubTotal = SUM(PrecioOriginal), @MontoDescuento = SUM(DescuentoAplicado) FROM @Items;
        SET @MontoImpuesto = dbo.fn_calcular_impuesto(@SubTotal - @MontoDescuento);
        SET @TotalPagado = (@SubTotal - @MontoDescuento) + @MontoImpuesto;

        -- Generar Factura
        DECLARE @ID_Factura INT;
        INSERT INTO Factura (Codigo_Transaccion, Fecha_Hora_Emision, Sub_Total, Monto_Descuento, Monto_Impuesto, Total_Pagado, ID_Usuario_FK, ID_Metodo_Pago_FK)
        VALUES (CAST(RAND()*1000000 AS INT), GETDATE(), @SubTotal, @MontoDescuento, @MontoImpuesto, @TotalPagado, @ID_Usuario, @ID_Metodo_Pago);

        SET @ID_Factura = SCOPE_IDENTITY();

        -- Generar Detalle_Factura (El Trigger 3 meterá esto a Biblioteca automáticamente)
        INSERT INTO Detalle_Factura (Precio_Venta_Historico, Descuento_Aplicado_Pct, ID_Factura_FK, ID_Producto_FK)
        SELECT 
            PrecioOriginal, 
            CASE WHEN PrecioOriginal > 0 THEN (DescuentoAplicado / PrecioOriginal) * 100 ELSE 0 END,
            @ID_Factura, 
            ID_Producto
        FROM @Items;

        -- Vaciar el carrito
        DELETE FROM Carrito WHERE ID_Usuario_FK = @ID_Usuario;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO











CREATE PROCEDURE sp_dashboard_estudio
    @ID_Empresa INT,
    @FechaInicio DATE,
    @FechaFin DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Tabla 1: KPIs
    SELECT 
        COALESCE(SUM(df.Precio_Venta_Historico), 0) AS Ingreso_Total,
        COUNT(df.ID_Producto_FK) AS Unidades_Vendidas,
        COALESCE((SELECT SUM(r.Monto_Reembolsado) 
         FROM Reembolso r 
         JOIN Detalle_Factura df2 ON r.ID_Factura_FK = df2.ID_Factura_FK AND r.ID_Producto_FK = df2.ID_Producto_FK
         JOIN Juego_Base jb2 ON df2.ID_Producto_FK = jb2.ID_Producto_FK
         WHERE jb2.ID_Estudio_Dev_FK = @ID_Empresa AND r.Fecha_Reembolso BETWEEN @FechaInicio AND @FechaFin), 0) AS Total_Reembolsos
    FROM Factura f
    JOIN Detalle_Factura df ON f.ID_Factura = df.ID_Factura_FK
    JOIN Juego_Base jb ON df.ID_Producto_FK = jb.ID_Producto_FK
    WHERE jb.ID_Estudio_Dev_FK = @ID_Empresa AND CAST(f.Fecha_Hora_Emision AS DATE) BETWEEN @FechaInicio AND @FechaFin;

    -- Tabla 2: Top 5 Juegos más vendidos
    SELECT TOP 5 
        p.Titulo,
        COUNT(df.ID_Producto_FK) AS Unidades_Vendidas
    FROM Factura f
    JOIN Detalle_Factura df ON f.ID_Factura = df.ID_Factura_FK
    JOIN Juego_Base jb ON df.ID_Producto_FK = jb.ID_Producto_FK
    JOIN Producto_Digital p ON jb.ID_Producto_FK = p.ID_Producto
    WHERE jb.ID_Estudio_Dev_FK = @ID_Empresa AND CAST(f.Fecha_Hora_Emision AS DATE) BETWEEN @FechaInicio AND @FechaFin
    GROUP BY p.Titulo
    ORDER BY Unidades_Vendidas DESC;

    -- Tabla 3: Top 5 mejores compradores
    SELECT TOP 5 
        u.Nickname,
        SUM(df.Precio_Venta_Historico) AS Gasto_Total
    FROM Factura f
    JOIN Detalle_Factura df ON f.ID_Factura = df.ID_Factura_FK
    JOIN Juego_Base jb ON df.ID_Producto_FK = jb.ID_Producto_FK
    JOIN Usuario u ON f.ID_Usuario_FK = u.Id_Usuario
    WHERE jb.ID_Estudio_Dev_FK = @ID_Empresa AND CAST(f.Fecha_Hora_Emision AS DATE) BETWEEN @FechaInicio AND @FechaFin
    GROUP BY u.Nickname
    ORDER BY Gasto_Total DESC;
END;
GO









CREATE PROCEDURE sp_publicar_producto_con_etiquetas
    @Titulo VARCHAR(70), @DescCorta VARCHAR(150), @DescLarga VARCHAR(300),
    @Fecha DATE, @Tamano DECIMAL(6,2), @Clasificacion VARCHAR(2), @Precio DECIMAL(10,2),
    @Tipo VARCHAR(50), @Metacritic INT, @Etiquetas VARCHAR(MAX),
    @Motor VARCHAR(50) = NULL, @Compras BIT = NULL, @Cloud BIT = NULL,
    @ID_Estudio INT = NULL, @ID_Publisher INT = NULL, @ID_JuegoBase_FK INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        -- Insertar Producto
        INSERT INTO Producto_Digital (Titulo, Descripcion_Corta, Descripcion_Larga, Fecha_Lanzamiento, Tamano_GB, Clasificacion_Edad, Precio_Base_Actual, Tipo_Producto, Metacritic_Score)
        VALUES (@Titulo, @DescCorta, @DescLarga, @Fecha, @Tamano, @Clasificacion, @Precio, @Tipo, @Metacritic);

        DECLARE @NewID INT = SCOPE_IDENTITY();

        -- Insertar subtabla
        IF @Tipo = 'Juego_Base'
        BEGIN
            INSERT INTO Juego_Base (Motor_Grafico, Tiene_Compras_InGame, Soporta_Cloud_Saves, ID_Producto_FK, ID_Estudio_Dev_FK, ID_Publisher_FK)
            VALUES (@Motor, @Compras, @Cloud, @NewID, @ID_Estudio, @ID_Publisher);
        END
        ELSE IF @Tipo = 'DLC'
        BEGIN
            INSERT INTO DLC (Tipo_Contenido, Subtipo_Jugable, ID_Producto_FK, ID_Juego_Base_FK)
            VALUES ('Jugable', 'Mapa', @NewID, @ID_JuegoBase_FK);
        END

        -- Procesar Etiquetas
        DECLARE @Etiqueta VARCHAR(50), @Pos INT;
        SET @Etiquetas = LTRIM(RTRIM(@Etiquetas)) + ',';

        WHILE CHARINDEX(',', @Etiquetas) > 0
        BEGIN
            SET @Pos = CHARINDEX(',', @Etiquetas);
            SET @Etiqueta = LTRIM(RTRIM(SUBSTRING(@Etiquetas, 1, @Pos - 1)));

            IF @Etiqueta <> ''
            BEGIN
                DECLARE @ID_Etiqueta INT;
                -- Agregamos TOP 1 para que si hay etiquetas con el mismo nombre, no falle
                SELECT TOP 1 @ID_Etiqueta = Id_Etiqueta FROM Etiqueta_Comunidad WHERE Nombre_Etiqueta = @Etiqueta;

                IF @ID_Etiqueta IS NULL
                BEGIN
                    INSERT INTO Etiqueta_Comunidad (Nombre_Etiqueta) VALUES (@Etiqueta);
                    SET @ID_Etiqueta = SCOPE_IDENTITY();
                END

                -- Validamos que no exista ya la relación para evitar error de PK
                IF NOT EXISTS (SELECT 1 FROM Producto_Etiqueta WHERE ID_Producto_FK = @NewID AND ID_Etiqueta_FK = @ID_Etiqueta)
                BEGIN
                    INSERT INTO Producto_Etiqueta (Cantidad_Votos, ID_Producto_FK, ID_Etiqueta_FK)
                    VALUES (0, @NewID, @ID_Etiqueta);
                END
            END
            SET @Etiquetas = SUBSTRING(@Etiquetas, @Pos + 1, LEN(@Etiquetas));
        END

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO








CREATE PROCEDURE sp_procesar_reembolso
    @ID_Factura INT, @ID_Producto INT, @Motivo VARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @FechaCompra DATETIME2, @MontoPagado DECIMAL(10,2), @ID_Usuario INT;

        SELECT @FechaCompra = f.Fecha_Hora_Emision, @MontoPagado = df.Precio_Venta_Historico, @ID_Usuario = f.ID_Usuario_FK
        FROM Factura f
        JOIN Detalle_Factura df ON f.ID_Factura = df.ID_Factura_FK
        WHERE f.ID_Factura = @ID_Factura AND df.ID_Producto_FK = @ID_Producto;

        IF @FechaCompra IS NULL
            RAISERROR('No se encontró la compra especificada.', 16, 1);

        IF DATEDIFF(DAY, @FechaCompra, GETDATE()) > 14
            RAISERROR('El periodo de reembolso (14 días) ha expirado.', 16, 1);

        DECLARE @HorasJugadas INT;
        SELECT @HorasJugadas = Horas_Jugadas FROM Biblioteca WHERE ID_Usuario_FK = @ID_Usuario AND ID_Producto_FK = @ID_Producto;

        IF COALESCE(@HorasJugadas, 0) >= 2
            RAISERROR('El usuario ha jugado 2 horas o más, no es elegible para reembolso.', 16, 1);

        -- Insertar Reembolso (Trigger 4 borra de la biblioteca automáticamente)
        INSERT INTO Reembolso (Fecha_Reembolso, Monto_Reembolsado, Motivo, ID_Factura_FK, ID_Producto_FK)
        VALUES (GETDATE(), @MontoPagado, @Motivo, @ID_Factura, @ID_Producto);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO





















CREATE PROCEDURE sp_desbloquear_logro
    @ID_Usuario INT, @ID_Juego_Base INT, @ID_Logro INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (SELECT 1 FROM Logro WHERE ID_Juego_Base_FK = @ID_Juego_Base AND ID_Logro = @ID_Logro)
            RAISERROR('El logro no existe o no pertenece a este juego base.', 16, 1);

        IF NOT EXISTS (SELECT 1 FROM Biblioteca WHERE ID_Usuario_FK = @ID_Usuario AND ID_Producto_FK = @ID_Juego_Base)
            RAISERROR('El usuario no posee este juego en su biblioteca.', 16, 1);

        IF EXISTS (SELECT 1 FROM Desbloqueo_Logro WHERE ID_Usuario_FK = @ID_Usuario AND ID_Juego_Base_FK = @ID_Juego_Base AND ID_Logro_FK = @ID_Logro)
            RAISERROR('El usuario ya desbloqueó este logro previamente.', 16, 1);

        INSERT INTO Desbloqueo_Logro (Fecha_Desbloqueo, ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK)
        VALUES (GETDATE(), @ID_Usuario, @ID_Juego_Base, @ID_Logro);

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO