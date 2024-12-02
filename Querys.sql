--Obtener todos los pacientes y su historial médico correspondiente

CREATE OR REPLACE PROCEDURE LISTAR_HISTORIAL_MEDICO_PACIENTE(
    p_idPACIENTE IN NUMBER -- Parámetro de entrada para el id del paciente
)
AS
BEGIN
    FOR c IN (
        SELECT 
            p.Nombre, 
            p.Apellido, 
            hm.Descripcion, 
            hm.Diagnostico, 
            hm.Tratamiento
        FROM 
            Pacientes p
        JOIN 
            Historiales_Medico hm ON p.idPacientes = hm.Pacientes_idPacientes
        WHERE 
            p.idPacientes = p_idPACIENTE
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || c.Nombre || ', Apellido: ' || c.Apellido || 
                             ', Descripción: ' || c.Descripcion || ', Diagnóstico: ' || c.Diagnostico || 
                             ', Tratamiento: ' || c.Tratamiento);
    END LOOP;
END;


--Obtener todas las reservas junto con los detalles de contacto y cita correspondiente

CREATE OR REPLACE PROCEDURE LISTAR_RESERVAS_CONTACTO(
    p_idCONTACTO IN NUMBER -- Parámetro de entrada para el id del contacto
)
AS
BEGIN
    FOR c IN (
        SELECT 
            r.FechaReserva, 
            r.HoraInicio, 
            r.HoraFin, 
            c.Telefono, 
            c.Email, 
            c.Direccion, 
            ci.Descripcion AS CitaDescripcion
        FROM 
            Reservas r
        JOIN 
            Contacto c ON r.Contacto_idContacto = c.idContacto
        JOIN 
            Citas ci ON r.Citas_idCitas = ci.idCitas
        WHERE 
            r.Contacto_idContacto = p_idCONTACTO
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Fecha Reserva: ' || c.FechaReserva || ', Hora Inicio: ' || c.HoraInicio || 
                             ', Hora Fin: ' || c.HoraFin || ', Telefono: ' || c.Telefono || 
                             ', Cita Descripción: ' || c.CitaDescripcion);
    END LOOP;
END;

--Obtener el monto total de pagos realizados por un paciente específico

CREATE OR REPLACE PROCEDURE LISTAR_TOTAL_PAGOS_PACIENTE(
    p_idPACIENTE IN NUMBER -- Parámetro de entrada para el id del paciente
)
AS
    total_pagos DECIMAL(10,2);
BEGIN
    SELECT SUM(pa.Monto)
    INTO total_pagos
    FROM Pagos pa
    JOIN Facturas f ON pa.Facturas_idFacturas = f.idFacturas
    JOIN Pacientes p ON f.Pacientes_idPacientes = p.idPacientes
    WHERE p.idPacientes = p_idPACIENTE;
    
    DBMS_OUTPUT.PUT_LINE('Total de Pagos para el paciente: ' || total_pagos);
END;

--Obtener todos los pacientes que tienen un seguro médico específico

CREATE OR REPLACE PROCEDURE LISTAR_PACIENTES_SEGURO(
    p_nombreSeguro IN VARCHAR2 -- Nombre del seguro médico
)
AS
BEGIN
    FOR c IN (
        SELECT 
            p.Nombre, 
            p.Apellido, 
            sm.Nombre AS SeguroMedico
        FROM 
            Pacientes p
        JOIN 
            Pacientes_Seguro ps ON p.idPacientes = ps.Pacientes_idPacientes
        JOIN 
            SeguroMedico sm ON ps.SeguroMedico_idSeguroMedico = sm.idSeguroMedico
        WHERE 
            sm.Nombre = p_nombreSeguro
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Paciente: ' || c.Nombre || ' ' || c.Apellido || 
                             ', Seguro Médico: ' || c.SeguroMedico);
    END LOOP;
END;

--Obtener todos los médicos y sus especialidades

CREATE OR REPLACE PROCEDURE LISTAR_MEDICOS_ESPECIALIDADES(
    p_idMEDICO IN NUMBER -- Parámetro de entrada para el id del médico
)
AS
BEGIN
    FOR c IN (
        SELECT 
            m.Nombre, 
            m.Apellido, 
            e.Nombre AS Especializacion
        FROM 
            Medicos m
        JOIN 
            Especializaciones e ON m.Horario_idHorario = e.idEspecializaciones
        WHERE 
            m.idMedicos = p_idMEDICO
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Médico: ' || c.Nombre || ' ' || c.Apellido || 
                             ', Especialización: ' || c.Especializacion);
    END LOOP;
END;

--Obtener la última reserva para un contacto en particular

CREATE OR REPLACE PROCEDURE LISTAR_ULTIMA_RESERVA(
    p_idCONTACTO IN NUMBER -- Parámetro de entrada para el id del contacto
)
AS
BEGIN
    FOR c IN (
        SELECT 
            r.FechaReserva, 
            r.HoraInicio, 
            r.HoraFin, 
            c.Nombre
        FROM 
            Reservas r
        JOIN 
            Contacto c ON r.Contacto_idContacto = c.idContacto
        WHERE 
            r.Contacto_idContacto = p_idCONTACTO
        ORDER BY 
            r.FechaReserva DESC
        FETCH FIRST 1 ROWS ONLY
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Fecha Reserva: ' || c.FechaReserva || 
                             ', Hora Inicio: ' || c.HoraInicio || ', Hora Fin: ' || c.HoraFin);
    END LOOP;
END;

-- Obtener una lista de todos los servicios ofrecidos por el hospital

CREATE OR REPLACE PROCEDURE LISTAR_SERVICIOS_HOSPITAL 
IS
BEGIN
    FOR c IN (
        SELECT 
            s.Nombre, 
            s.Descripcion
        FROM 
            Servicios s
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Servicio: ' || c.Nombre || ', Descripción: ' || c.Descripcion);
    END LOOP;
END;
/


--Obtener el número total de deudas por paciente

CREATE OR REPLACE PROCEDURE LISTAR_DEUDAS_PACIENTE(
    p_idPACIENTE IN NUMBER -- Parámetro de entrada para el id del paciente
)
AS
BEGIN
    FOR c IN (
        SELECT 
            p.Nombre, 
            p.Apellido, 
            COUNT(d.idDeudas) AS TotalDeudas
        FROM 
            Deudas d
        JOIN 
            Pacientes p ON d.Pacientes_idPacientes = p.idPacientes
        WHERE 
            p.idPacientes = p_idPACIENTE
        GROUP BY 
            p.Nombre, p.Apellido
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Paciente: ' || c.Nombre || ' ' || c.Apellido || 
                             ', Total de Deudas: ' || c.TotalDeudas);
    END LOOP;
END;

--Obtener una lista de todas las consultas con su respectivo médico y paciente

CREATE OR REPLACE PROCEDURE LISTAR_CONSULTAS_MEDICO_PACIENTE(
    p_idPACIENTE IN NUMBER -- Parámetro de entrada para el id del paciente
)
AS
BEGIN
    FOR c IN (
        SELECT 
            ci.Descripcion, 
            m.Nombre AS Medico, 
            p.Nombre AS Paciente
        FROM 
            Citas ci
        JOIN 
            Medicos m ON ci.Medicos_idMedicos = m.idMedicos
        JOIN 
            Pacientes p ON ci.Pacientes_idPacientes = p.idPacientes
        WHERE 
            p.idPacientes = p_idPACIENTE
    ) LOOP
        DBMS_OUTPUT.PUT_LINE('Descripción: ' || c.Descripcion || 
                             ', Médico: ' || c.Medico || ', Paciente: ' || c.Paciente);
    END LOOP;
END;

--Estos  son los codigo para ejecutar--

-- Habilitar la salida DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- Ejecutar el procedimiento, por ejemplo, para listar las citas de un paciente con ID 1
EXEC LISTAR_CITAS_PACIENTE(p_idPACIENTE => 1);

--Para listar
BEGIN
    LISTAR_SERVICIOS_HOSPITAL;
END;
/

--Habilitar la salida de DBMS_OUTPUT, es para la salida de mensajes
SET SERVEROUTPUT ON;

