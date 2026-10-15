/*ADD SP
*/




/*ADD FUNC
*/
CREATE FUNCTION fn_calcular_impuesto(@monto DECIMAL(10, 2))
    RETURNS DECIMAL(10, 2)
    AS
    BEGIN
        @monto * 0.16
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
        FROM Historial_Descuento 
        WHERE (@ID_Producto = hd.ID_Producto
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
        SELECT @promedio_calificacion = ISNULL(SUM(r.Calificacion_1_10 * 1.0) / NULLIF(COUNT(r.ID_Usuario), 0), 0)
        FROM Resena r 
        WHERE @Id_Producto = r.ID_Producto

        -- obtener puntaje metacritic
        SELECT @puntaje_metacritic = ISNULL(pd.Metacritic_Score, 0)
        FROM Producto_Digital pd
        WHERE @ID_Producto = pd.ID_Producto

        -- obtener total jugadores

        SELECT @total_jugadores = COUNT(b.ID_Usuario)
        FROM Biblioteca b
        WHERE b.ID_Producto = @ID_Producto

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
        WHERE @ID_Usuario = b.ID_Usuario

        RETURN @horas_totales
    END;
GO



/*ADD TRIGGER
*/
CREATE TRIGGER tr_Auditoria_Precios
ON Producto_Digital
AFTER UPDATE 
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
        END
    END;
GO

CREATE TRIGGER tr_Proteccion_menores
ON Detalle_Factura
AFTER INSERT
    BEGIN 
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN Producto_Digital pd ON pd.ID_Producto = i.ID_Producto
            JOIN Factura f ON f.ID_Factura = i.ID_Factura
            JOIN Usuario u ON u.Id_Usuario = f.Id_Usuario
            WHERE (pd.Clasificacion_Edad IN ('M', 'AO'))
                AND u.Fecha_Nacimiento > DATEADD(YEAR,-18,GETDATE()) 

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
        BEGIN

        INSERT ON Biblioteca (ID_Usuario_FK, ID_Producto_FK, Horas_Jugadas, Fecha_Ultima_Sesion)
            SELECT f.ID_Usuario, i.ID_Producto, 0, NULL
            FROM INSERTED i
            JOIN Factura f ON i.ID_Factura = f.ID_Factura
            WHERE NOT EXIST (
                SELECT 1
                FROM Biblioteca b
                WHERE (b.ID_Usuario = f.ID_Usuario
                        AND b.ID_Producto = i.ID_Producto)
            )     
END;
GO

--funciona por el orden de ejecucion de los tr

--reembolso = chao de biblioteca
CREATE TRIGGER  tr_Reembolso_dlt
ON Reembolso
AFTER INSERT
    BEGIN
        DELETE FROM Biblioteca b
        WHERE EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN Detalle_Factura df ON df.ID_Factura = i.ID_Factura
            JOIN Factura f ON f.ID_Factura = df.ID_Factura 
            WHERE (i.ID_Producto = f.ID_Producto
                  AND b.ID_Usuario = f.ID_Usuario)
        )
END;
GO


CREATE TRIGGER tr_Validaciones_carrito
ON Carrito
AFTER INSERT
    BEGIN  
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN Biblioteca b ON b.ID_Usuario = i.ID_Usuario
            WHERE b.ID_Producto = i.ID_Producto
        ) BEGIN
            RAISERROR('Producto ya en biblioteca.', 16, 3);
            ROLLBACK TRANSACTION;
        END

        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN DLC dlc ON dlc.ID_Producto = i.ID_Producto
            WHERE NOT EXISTS (
                SELECT 1
                FROM Biblioteca b
                WHERE dlc.Juego_Base = b.ID_Producto AND b.ID_Usuario = i.ID_Usuario

            UNION

                SELECT 1
                FROM Carrito c
                WHERE c.ID_Usuario = i.ID_Usuario AND c.ID_Producto = dlc.ID_Juego_Base

            )

        ) BEGIN
            RAISERROR('Producto Falta de Juego Base.', 16, 4);
            ROLLBACK TRANSACTION;
        END

    END;
GO