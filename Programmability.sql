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
            WHERE d.Precio_Base_Actual !=0
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

CREATE TRIGGER tr_Add_auto_biblioteca
ON Detalle_Factura
AFTER INSERT
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM INSERTED i
            JOIN Biblioteca b ON b.ID_Producto = i.ID_Producto
            WHERE ()
        )
END;
GO