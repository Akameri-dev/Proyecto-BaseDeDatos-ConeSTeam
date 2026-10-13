/* TABLAS
*/
 CREATE TABLE Empresa_Corporativa (
    ID_Empresa INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(30),
    Pais_Origen VARCHAR (30),
    Fecha_Fundacion DATE,
    ID_Empresa_Matriz_FK INT,
 );

 CREATE TABLE Producto_Digital (
    ID_Producto INT IDENTITY(1,1) PRIMARY KEY,
    Titulo VARCHAR(50),
    Descripcion_Corta VARCHAR(150),
    Descripcion_Larga VARCHAR(300),
    Fecha_Lanzamiento DATE,
    Tamano_GB DECIMAL(6, 2),
    Clasificacion_Edad VARCHAR(2), 
    Precio_Base_Actual DECIMAL(10, 2), 
    Tipo_Producto VARCHAR(50),
    Metacritic_Score INTEGER, 

    );


 CREATE TABLE Galeria_Multimedia (
    ID_Multimedia INT IDENTITY(1, 1),
    URL_Archivo VARCHAR(MAX),
    Tipo_Archivo VARCHAR(5), 
    ID_Producto_FK INTEGER,
    PRIMARY KEY(ID_Producto_FK, ID_Multimedia),
 )

 CREATE TABLE Juego_Base (
    Motor_Grafico VARCHAR(50),
    Tiene_Compras_InGame BIT, 
    Soporta_Cloud_Saves BIT,
    ID_Producto_FK INTEGER PRIMARY KEY,
    ID_Estudio_Dev_FK INTEGER,
    ID_Publisher_FK INTEGER,
 );


 CREATE TABLE DLC (
    Tipo_Contenido VARCHAR(50), 
    Subtipo_Jugable VARCHAR(50), 
    ID_Producto_FK INTEGER PRIMARY KEY,
    ID_Juego_Base_FK INTEGER NOT NULL,
 );


 CREATE TABLE Perfil_Requisito (
    Tipo_Perfil VARCHAR(50), 
    Sistema_Operativo VARCHAR(50),
    Procesador VARCHAR(50),
    Memoria_RAM DECIMAL(5, 2),
    Tarjeta_Grafica VARCHAR(50),
    ID_Producto_FK INTEGER,
    PRIMARY KEY (ID_Producto_FK, Tipo_Perfil),
 ); 

 CREATE TABLE Logro (
    ID_Logro INTEGER,
    Nombre_Logro VARCHAR(MAX),
    Descripcion_Logro VARCHAR(MAX),
    Es_Secreto BIT, 
    ID_Juego_Base_FK INTEGER NOT NULL,
    PRIMARY KEY (ID_Juego_Base_FK, ID_Logro),
 );

 CREATE TABLE Categoria_Oficial (
    ID_Categoria INT IDENTITY(1, 1) PRIMARY KEY,
    Nombre_Categoria VARCHAR(50),
    Descripcion_Categoria VARCHAR(500),
 );

 CREATE TABLE Juego_Categoria (
   ID_Producto_FK INTEGER,
   ID_Categoria_FK INTEGER,
   PRIMARY KEY (ID_Categoria_FK, ID_Producto_FK),
 );

 CREATE TABLE Idioma (
    ID_Idioma INT IDENTITY(1, 1) PRIMARY KEY,
    Nombre_Idioma VARCHAR(50),
 );

 CREATE TABLE Soporte_Idioma (
    Soporta_Interfaz BIT, 
    Soporta_Audio BIT,
    Soporta_Subtitulos BIT,
    ID_Producto_FK INTEGER,
    ID_Idioma_FK INTEGER,
    PRIMARY KEY (ID_Idioma_FK, ID_Producto_FK),
 );

 CREATE TABLE Etiqueta_Comunidad (
    Id_Etiqueta INT IDENTITY(1, 1) PRIMARY KEY,
    Nombre_Etiqueta VARCHAR(50),

 );

 CREATE TABLE Producto_Etiqueta (
    Cantidad_Votos INTEGER,
    ID_Producto_FK INTEGER,
    ID_Etiqueta_FK INTEGER,
    PRIMARY KEY (ID_Etiqueta_FK, ID_Producto_FK),
 );

 CREATE TABLE Mod (
    ID_Mod INT IDENTITY(1, 1),
    Nombre_Mod VARCHAR(50),
    Descripcion_Mod VARCHAR(500),
    Tamano_MB DECIMAL(8, 2),
    ID_Producto_FK INTEGER NOT NULL,
    PRIMARY KEY (ID_Mod, ID_Producto_FK),

 );

 CREATE TABLE Usuario (
    Id_Usuario INT IDENTITY(1, 1) PRIMARY KEY,
    Nickname VARCHAR(50),
    Correo VARCHAR(100),
    Contrasena_Hash VARCHAR(100),
    Fecha_Nacimiento DATE, 
    Fecha_Registro DATE, 
    Pais_Residencia VARCHAR(50),
    Estado_Cuenta VARCHAR(50), 
 );

 CREATE TABLE Amistad_Usuario (
    Fecha_Amistad DATE,
    Estado_Amistad VARCHAR(50), 
    ID_Usuario_Solicitante_FK INTEGER,
    ID_Usuario_Receptor_FK INTEGER,
    PRIMARY KEY (ID_Usuario_Solicitante_FK, ID_Usuario_Receptor_FK),
 );

 CREATE TABLE Desbloqueo_Logro (
    Fecha_Desbloqueo DATE,
    ID_Usuario_FK INTEGER,
    ID_Juego_Base_FK INTEGER,
    ID_Logro_FK INTEGER,
    PRIMARY KEY (ID_Usuario_FK, ID_Juego_Base_FK, ID_Logro_FK),
 );   

 CREATE TABLE Biblioteca (
    Horas_Jugadas INTEGER,
    Fecha_Ultima_Sesion DATE,
    ID_Usuario_FK INTEGER,
    ID_Producto_FK INTEGER,
    PRIMARY KEY (ID_Usuario_FK, ID_Producto_FK),
 );

 CREATE TABLE Lista_Deseos (
    Fecha_Agregado DATE,
    Notificar_Descuento BIT 
    ID_Usuario_FK INTEGER,
    ID_Producto_FK INTEGER,
    PRIMARY KEY (ID_Usuario_FK, ID_Producto_FK),
 );

 CREATE TABLE Carrito (
    Fecha_Agregado DATE,
    ID_Usuario_FK INTEGER,
    ID_Producto_FK INTEGER,
   PRIMARY KEY (ID_Usuario_FK, ID_Producto_FK),
 );

 CREATE TABLE Resena (
    ID_Resena INT IDENTITY(1, 1) PRIMARY KEY,
    Texto_Resena VARCHAR(500),
    Calificacion_1_10 INTEGER, 
    Fecha_Publicacion DATE,
    Es_Critica_Especializada BIT, 

 );



 CREATE TABLE Suscripcion_Mod (
    Fecha_Suscripcion DATE,
    ID_Usuario_FK INTEGER,
    ID_Producto_Base_FK INTEGER,
    ID_Mod_FK INTEGER,
    PRIMARY KEY (ID_Usuario_FK, ID_Producto_Base_FK, ID_Mod_FK),
 );

 CREATE TABLE Metodo_Pago (
    ID_Metodo_Pago INTEGER PRIMARY KEY,
    Nombre_Metodo VARCHAR(50),
    Moneda VARCHAR(50),
    Requiere_Validacion BIT, 

 );

 CREATE TABLE Factura (
    ID_Factura INT IDENTITY(1, 1) PRIMARY KEY,
    Codigo_Transaccion INTEGER,
    Fecha_Hora_Emision DATETIME2,
    Sub_Total DECIMAL(10, 2),
    Monto_Descuento DECIMAL(10, 2),
    Monto_Impuesto DECIMAL(10, 2),
    Total_Pagado DECIMAL(10, 2),
    ID_Usuario_FK INTEGER NOT NULL,
    ID_Metodo_Pago_FK INTEGER NOT NULL
    
 );

 CREATE TABLE Detalle_Factura (
    Precio_Venta_Historico DECIMAL(10, 2),
    Descuento_Aplicado_Pct DECIMAL(10, 2),
    ID_Factura_FK INTEGER,
    ID_Producto_FK INTEGER,
    PRIMARY KEY (ID_Factura_FK, ID_Producto_FK),
 );

 CREATE TABLE Reembolso (
    ID_Reembolso INT IDENTITY(1, 1) PRIMARY KEY,
    Fecha_Reembolso DATE, 
    Monto_Reembolsado DECIMAL(10, 2),
    Motivo VARCHAR(500),
    ID_Factura_FK INTEGER,
    ID_Producto_FK INTEGER,
 );

 CREATE TABLE Historial_Descuento (
    Fecha_Inicio DATE, 
    Fecha_Fin DATE,
    Porcentaje_Descuento DECIMAL(3, 1),
    Nombre_Evento VARCHAR(50),
    ID_Producto_FK INTEGER,
    PRIMARY KEY (Fecha_Inicio, ID_Producto_FK),

    
 );

 CREATE TABLE Registro_Concurrencia (
    Fecha_Registro DATE,
    Pico_Maximo_Jugadores INTEGER,
    ID_Producto_FK INTEGER,
    PRIMARY KEY (Fecha_Registro, ID_Producto_FK),    
 );


/*ADD FK
*/

ALTER TABLE Empresa_Corporativa
ADD CONSTRAINT ID_Empresa_Matriz
FOREIGN KEY (ID_Empresa_Matriz_FK)
REFERENCES Empresa_Corporativa(ID_Empresa);

ALTER TABLE Galeria_Multimedia
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Juego_Base
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Juego_Base
ADD CONSTRAINT ID_Estudio_Dev
FOREIGN KEY (ID_Estudio_Dev_FK)
REFERENCES Empresa_Corporativa(ID_Empresa);

ALTER TABLE Juego_Base
ADD CONSTRAINT ID_Publisher
FOREIGN KEY (ID_Publisher_FK)
REFERENCES Empresa_Corporativa(ID_Empresa);

ALTER TABLE DLC
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE DLC
ADD CONSTRAINT ID_Juego_Base
FOREIGN KEY (ID_Juego_Base_FK)
REFERENCES Juego_Base(ID_Producto);

ALTER TABLE Perfil_Requisito
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Logro
ADD CONSTRAINT ID_Juego_Base
FOREIGN KEY (ID_Juego_Base_FK)
REFERENCES Juego_Base(ID_Producto);

ALTER TABLE Juego_Categoria
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Juego_Base(ID_Producto);

ALTER TABLE Juego_Categoria
ADD CONSTRAINT ID_Categoria
FOREIGN KEY (ID_Categoria_FK)
REFERENCES Categoria_Oficial(ID_Categoria);

ALTER TABLE Soporte_Idioma
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Soporte_Idioma
ADD CONSTRAINT ID_Idioma
FOREIGN KEY (ID_Idioma_FK)
REFERENCES Idioma(ID_Idioma);

ALTER TABLE Producto_Etiqueta
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Producto_Etiqueta
ADD CONSTRAINT ID_Etiqueta
FOREIGN KEY (ID_Etiqueta_FK)
REFERENCES Etiqueta_Comunidad(ID_Etiqueta);

ALTER TABLE Mod
ADD CONSTRAINT ID_Producto_Base
FOREIGN KEY (ID_Producto_FK)
REFERENCES Juego_Base(ID_Producto);

ALTER TABLE Amistad_Usuario
ADD CONSTRAINT ID_Usuario_Solicitante
FOREIGN KEY (ID_Usuario_Solicitante_FK)
REFERENCES Usuario(ID_Usuario);

ALTER TABLE Amistad_Usuario
ADD CONSTRAINT ID_Usuario_Receptor
FOREIGN KEY (ID_Usuario_Receptor_FK)
REFERENCES Usuario(ID_Usuario);

ALTER TABLE Desbloqueo_Logro
ADD CONSTRAINT ID_Usuario
FOREIGN KEY (ID_Usuario_FK)
REFERENCES Usuario(ID_Usuario);

ALTER TABLE Desbloqueo_Logro
ADD CONSTRAINT ID_Juego_Base
FOREIGN KEY (ID_Producto_FK)
REFERENCES Juego_Base(ID_Producto);

ALTER TABLE Desbloqueo_Logro
ADD CONSTRAINT ID_Logro
FOREIGN KEY (ID_Logro_FK)
REFERENCES Logro(ID_Logro);

ALTER TABLE Biblioteca
ADD CONSTRAINT ID_Usuario
FOREIGN KEY (ID_Usuario_FK)
REFERENCES Usuario(ID_Usuario);

ALTER TABLE Biblioteca
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Lista_Deseos
ADD CONSTRAINT ID_Usuario
FOREIGN KEY (ID_Usuario_FK)
REFERENCES Usuario(ID_Usuario);

ALTER TABLE Lista_Deseos
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Carrito
ADD CONSTRAINT ID_Usuario
FOREIGN KEY (ID_Usuario_FK)
REFERENCES Usuario(ID_Usuario);

ALTER TABLE Carrito
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Suscripcion_Mod
ADD CONSTRAINT ID_Usuario
FOREIGN KEY (ID_Usuario_FK)
REFERENCES Usuario(ID_Usuario);

ALTER TABLE Suscripcion_Mod
ADD CONSTRAINT ID_Producto_Base
FOREIGN KEY (ID_Producto_FK)
REFERENCES Juego_Base(ID_Producto);

ALTER TABLE Detalle_Factura
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Detalle_Factura
ADD CONSTRAINT ID_Factura
FOREIGN KEY (ID_Factura_FK)
REFERENCES Factura(ID_Factura);

ALTER TABLE Reembolso
ADD CONSTRAINT ID_Factura
FOREIGN KEY (ID_Factura_FK)
REFERENCES Factura(ID_Factura);

ALTER TABLE Reembolso
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Historial_Descuento
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Registro_Concurrencia
ADD CONSTRAINT ID_Producto
FOREIGN KEY (ID_Producto_FK)
REFERENCES Producto_Digital(ID_Producto);

ALTER TABLE Factura
ADD CONSTRAINT FK_Factura_Usuario
FOREIGN KEY (ID_Usuario_FK)
REFERENCES Usuario(Id_Usuario);

ALTER TABLE Factura
ADD CONSTRAINT FK_Factura_Metodo_Pago
FOREIGN KEY (ID_Metodo_Pago_FK)
REFERENCES Metodo_Pago(ID_Metodo_Pago);

/*ADD CHECK*/

ALTER TABLE Producto_Digital 
ADD CONSTRAINT CHK_Precio_Base CHECK (Precio_Base_Actual >= 0);

ALTER TABLE Factura
ADD CONSTRAINT CHK_Sub_total CHECK (Sub_Total >= 0);

ALTER TABLE Factura
ADD CONSTRAINT CHK_Monto_Descuento CHECK (Monto_Descuento >= 0);

ALTER TABLE Factura
ADD CONSTRAINT CHK_Monto_Impuesto CHECK (Monto_Impuesto >= 0);

ALTER TABLE Factura
ADD CONSTRAINT CHK_Total_Pagado CHECK (Total_Pagado >= 0);

ALTER TABLE Detalle_Factura 
ADD CONSTRAINT CHK_Precio_Historico CHECK (Precio_Venta_Historico >= 0);

ALTER TABLE Reembolso
ADD CONSTRAINT CHK_Reembolso CHECK (Monto_Reembolsado >= 0);

ALTER TABLE Producto_Digital
ADD CONSTRAINT CHK_Clasificacion CHECK (Clasificacion_Edad IN ('E', 'T', 'M', 'AO'));

ALTER TABLE Producto_Digital
ADD CONSTRAINT CHK_producto CHECK (Tipo_Producto IN ('Juego_Base', 'DLC'));

ALTER TABLE Producto_Digital
ADD CONSTRAINT CHK_Metacritic CHECK ((Metacritic_Score >= 0) AND (Metacritic_Score <= 100));

ALTER TABLE Galeria_Multimedia
ADD CONSTRAINT CHK_TipoArchivo CHECK (Tipo_Archivo IN ('Foto', 'Video'));

ALTER TABLE DLC
ADD CONSTRAINT CHK_TipoContenido CHECK (Tipo_Contenido IN ('Jugable', 'Banda_Sonora', 'Arte'));

ALTER TABLE DLC
ADD CONSTRAINT CHK_Subcontenido CHECK (
    (Tipo_Contenido = 'Jugable' AND Subtipo_Jugable IN ('Personaje', 'Mapa', 'Modo_Juego', 'Cosmetico'))
    OR 
    (Tipo_Contenido <> 'Jugable' AND Subtipo_Jugable IS NULL)
);

ALTER TABLE Perfil_Requisito
ADD CONSTRAINT CHK_Perfil CHECK (Tipo_Perfil IN ('Minimo', 'Recomendado'));

ALTER TABLE Usuario
ADD CONSTRAINT CHK_EDO CHECK (Estado_Cuenta IN ('Activa', 'Suspendida', 'Baneada'));

ALTER TABLE Amistad_Usuario
ADD CONSTRAINT CHK_EDOAmistad CHECK (Estado_Amistad IN ('Pendiente', 'Aceptada', 'Bloqueada'));

 ALTER TABLE Resena 
 ADD CONSTRAINT CHK_Resena CHECK ((Calificacion_1_10 >= 1) AND (Calificacion_1_10 <= 10));

ALTER TABLE Historial_Descuento
ADD CONSTRAINT CHK_Porcentaje CHECK (Porcentaje_Descuento >=0 AND Porcentaje_Descuento <= 100); 

ALTER TABLE Historial_Descuento
ADD CONSTRAINT CHK_Fechas_Descuento CHECK (Fecha_Fin >= Fecha_Inicio);

# checar si no falta alguna tabla

 
