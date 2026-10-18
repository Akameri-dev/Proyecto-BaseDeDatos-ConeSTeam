USE ConeSTeamDB;
GO

-- 1. Desactivar todas las restricciones de foreign keys para evitar conflictos de orden
EXEC sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL';
GO

-- 2. Vaciar todas las tablas de la base de datos
-- (Se usa DELETE en lugar de TRUNCATE para evitar problemas con referencias cruzadas)
EXEC sp_MSforeachtable 'DELETE FROM ?';
GO

-- 3. Reiniciar los contadores IDENTITY (IDs autoincrementables) de todas las tablas a 0
EXEC sp_MSforeachtable '
IF OBJECTPROPERTY(object_id(?(?)), ''TableHasIdentity'') = 1
    DBCC CHECKIDENT (''?'', RESEED, 0)
';
GO

-- 4. Volver a activar todas las restricciones
EXEC sp_MSforeachtable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL';
GO

PRINT '¡Base de datos reseteada por completo! Ya puedes ejecutar tus INSERTS desde cero.';
GO