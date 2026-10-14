/*ADD SP
*/




/*ADD FUNC
*/






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

#raise error es ocmo un emnsaje de error que puedes darle un valor de gravedad de err


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

# funciona por el orden de ejecucion de los tr

# reembolso = chao de biblioteca
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