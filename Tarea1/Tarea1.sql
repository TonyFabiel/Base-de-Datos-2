CREATE DATABASE BASES2_TAREA1;

USE BASES2_TAREA1;


CREATE TABLE Hotel 
  (
    codigo_hotel INT PRIMARY KEY NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    direccionn NVARCHAR(2000)
  );


CREATE TABLE Cliente
  (
    identidad_cliente INT PRIMARY KEY NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    telefono NVARCHAR(2000)
  );

CREATE TABLE Reserva
  (
    codigo_reserva INT PRIMARY KEY NOT NULL,
	codigo_hotel INT NOT NULL,
	identidad_cliente INT NOT NULL,
    cantidad_personas INT NOT NULL,
    fecha_in NVARCHAR(255) NOT NULL,
    fecha_out NVARCHAR(255) NOT NULL,
	FOREIGN KEY (codigo_hotel) REFERENCES Hotel(codigo_hotel),
	FOREIGN KEY (identidad_cliente) REFERENCES Cliente(identidad_cliente)
  );

CREATE TABLE Aereolinea
    (
    codigo_aereolinea INT PRIMARY KEY NOT NULL,
    descuento NVARCHAR(255) NOT NULL
  );


CREATE TABLE Boleto
  (
    codigo_boleto INT PRIMARY KEY NOT NULL,
	codigo_aereolinea INT NOT NULL,
	identidad_cliente INT NOT NULL,
    numero_vuelo INT NOT NULL,
    fecha NVARCHAR(255) NOT NULL,
    destino NVARCHAR(255) NOT NULL,
	FOREIGN KEY (codigo_aereolinea) REFERENCES Aereolinea(codigo_aereolinea),
	FOREIGN KEY (identidad_cliente) REFERENCES Cliente(identidad_cliente)
  );

