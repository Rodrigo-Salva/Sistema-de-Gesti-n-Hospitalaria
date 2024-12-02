CREATE TABLE Contacto (
    idContacto NUMBER PRIMARY KEY,
    Telefono VARCHAR2(45) NOT NULL,
    Direccion VARCHAR2(45) NOT NULL,
    Email VARCHAR2(45) UNIQUE
);

CREATE TABLE Reservas (
    idReservas NUMBER PRIMARY KEY,
    FechaReserva DATE NOT NULL,
    HoraInicio DATE NOT NULL,
    HoraFin DATE NOT NULL,
    Reservado VARCHAR2(45) NOT NULL,
    Contacto_idContacto NUMBER,
    Citas_idCitas NUMBER,
    CONSTRAINT fk_Contacto FOREIGN KEY (Contacto_idContacto) REFERENCES Contacto(idContacto),
    CONSTRAINT fk_Citas FOREIGN KEY (Citas_idCitas) REFERENCES Citas(idCitas),
    CONSTRAINT chk_HoraReserva CHECK (HoraInicio < HoraFin)
);

CREATE TABLE Citas (
    idCitas NUMBER PRIMARY KEY,
    Fecha VARCHAR2(45) NOT NULL,
    Descripcion VARCHAR2(45) NOT NULL,
    Medicos_idMedicos NUMBER,
    Pacientes_idPacientes NUMBER,
    Consultas_idConsultas NUMBER,
    Email VARCHAR2(45),
    Genero VARCHAR2(45),
    Telefono VARCHAR2(8) NOT NULL,
    Departamento VARCHAR2(45) NOT NULL,
    Mensaje VARCHAR2(75),
    CONSTRAINT fk_Medico FOREIGN KEY (Medicos_idMedicos) REFERENCES Medicos(idMedicos),
    CONSTRAINT fk_Paciente FOREIGN KEY (Pacientes_idPacientes) REFERENCES Pacientes(idPacientes),
    CONSTRAINT fk_Consulta FOREIGN KEY (Consultas_idConsultas) REFERENCES Consultas(idConsultas),
    CONSTRAINT chk_Telefono CHECK (Telefono LIKE '___-___-___')
);

CREATE TABLE Consultas (
    idConsultas NUMBER PRIMARY KEY,
    Nombre VARCHAR2(45) NOT NULL,
    Ubicacion VARCHAR2(45) NOT NULL
);

CREATE TABLE Historial_Citas (
    idHistorial_Citas NUMBER PRIMARY KEY,
    Fecha DATE NOT NULL,
    Citas_idCitas NUMBER,
    CONSTRAINT fk_Citas_Historial FOREIGN KEY (Citas_idCitas) REFERENCES Citas(idCitas)
);

CREATE TABLE Pacientes (
    idPacientes NUMBER PRIMARY KEY,
    Nombre VARCHAR2(45) NOT NULL,
    Apellido VARCHAR2(45) NOT NULL,
    Fecha_nac DATE NOT NULL,
    Sexo VARCHAR2(10) CHECK (Sexo IN ('Masculino', 'Femenino')) NOT NULL,
    Telefono VARCHAR2(20),
    Direccion VARCHAR2(45),
    Email VARCHAR2(20) UNIQUE
);

CREATE TABLE Historiales_Medico (
    idHistorial_Medico NUMBER PRIMARY KEY,
    Fecha DATE NOT NULL,
    Descripcion VARCHAR2(15),
    Diagnostico VARCHAR2(45),
    Tratamiento VARCHAR2(45),
    Pacientes_idPacientes NUMBER,
    CONSTRAINT fk_Paciente_Historial FOREIGN KEY (Pacientes_idPacientes) REFERENCES Pacientes(idPacientes)
);

CREATE TABLE SeguroMedico (
    idSeguroMedico NUMBER PRIMARY KEY,
    Nombre VARCHAR2(25) NOT NULL,
    DNV VARCHAR2(8) UNIQUE,
    Mensajes VARCHAR2(75)
);

CREATE TABLE Pacientes_Seguro (
    idPacientes_Seguro NUMBER PRIMARY KEY,
    Pacientes_idPacientes NUMBER,
    SeguroMedico_idSeguroMedico NUMBER,
    CONSTRAINT fk_Paciente_Seguro FOREIGN KEY (Pacientes_idPacientes) REFERENCES Pacientes(idPacientes),
    CONSTRAINT fk_Seguro FOREIGN KEY (SeguroMedico_idSeguroMedico) REFERENCES SeguroMedico(idSeguroMedico)
);

CREATE TABLE Facturas (
    idFacturas NUMBER PRIMARY KEY,
    Fecha_factura DATE NOT NULL,
    Monto_total DECIMAL CHECK (Monto_total > 0) NOT NULL,
    Pacientes_idPacientes NUMBER,
    CONSTRAINT fk_Paciente_Factura FOREIGN KEY (Pacientes_idPacientes) REFERENCES Pacientes(idPacientes)
);

CREATE TABLE Pagos (
    idPagos NUMBER PRIMARY KEY,
    Monto DECIMAL CHECK (Monto > 0) NOT NULL,
    Fecha_pago DATE NOT NULL,
    MetodoDePago VARCHAR2(15),
    Facturas_idFacturas NUMBER,
    Nombre VARCHAR2(45),
    Genero VARCHAR2(45),
    Mensaje VARCHAR2(15),
    CONSTRAINT fk_Factura_Pago FOREIGN KEY (Facturas_idFacturas) REFERENCES Facturas(idFacturas)
);

CREATE TABLE Disponibilidad (
    idDisponibilidad NUMBER PRIMARY KEY,
    Fecha DATE NOT NULL,
    Estado VARCHAR2(45) CHECK (Estado IN ('Disponible', 'No Disponible')) NOT NULL
);

CREATE TABLE Medicos (
    idMedicos NUMBER PRIMARY KEY,
    Nombre VARCHAR2(45) NOT NULL,
    Apellido VARCHAR2(45) NOT NULL,
    Especializacion VARCHAR2(45) NOT NULL,
    Email VARCHAR2(45) UNIQUE,
    Horario_idHorario NUMBER
);

CREATE TABLE Especializaciones (
    idEspecializaciones NUMBER PRIMARY KEY,
    Nombre VARCHAR2(45) NOT NULL
);

CREATE TABLE Servicios (
    idServicios NUMBER PRIMARY KEY,
    Nombre VARCHAR2(45) NOT NULL,
    Descripcion VARCHAR2(15) NOT NULL
);

CREATE TABLE Noticias (
    idNoticias NUMBER PRIMARY KEY,
    Titulo VARCHAR2(45) NOT NULL,
    Contenido VARCHAR2(45) NOT NULL,
    Tipo_de_Noticia VARCHAR2(45) NOT NULL,
    Medicos_idMedicos INT,
    CONSTRAINT fk_Medico_Noticia FOREIGN KEY (Medicos_idMedicos) REFERENCES Medicos(idMedicos)
);

CREATE TABLE Deudas (
    idDeudas NUMBER PRIMARY KEY,
    MontoDeuda DECIMAL CHECK (MontoDeuda > 0) NOT NULL,
    FechaDeuda DATE NOT NULL,
    Estado VARCHAR2(20) CHECK (Estado IN ('Pendiente', 'Pagada')) NOT NULL,
    Pacientes_idPacientes NUMBER,
    Facturas_idFacturas NUMBER,
    CONSTRAINT fk_Paciente_Deuda FOREIGN KEY (Pacientes_idPacientes) REFERENCES Pacientes(idPacientes),
    CONSTRAINT fk_Factura_Deuda FOREIGN KEY (Facturas_idFacturas) REFERENCES Facturas(idFacturas)
);

