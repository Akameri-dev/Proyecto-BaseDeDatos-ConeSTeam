/*ADD SP
*/




/*ADD FUNC
*/






/*ADD TRIGGER
*/
CREATE TRIGGER tr_auditoria_Precios
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



