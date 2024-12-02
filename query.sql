-- 1. Obtener el número total de citas por médico
SELECT Medicos.Nombre, COUNT(Citas.idCitas) AS TotalCitas
FROM Medicos
JOIN Citas ON Medicos.idMedicos = Citas.Medicos_idMedicos
GROUP BY Medicos.Nombre;

-- 2. Obtener el monto total de pagos por paciente
SELECT Pacientes.Nombre, SUM(Pagos.Monto) AS TotalPagos
FROM Pacientes
JOIN Pagos ON Pacientes.idPacientes = Pagos.Pacientes_idPacientes
GROUP BY Pacientes.Nombre;

-- 3. Consultar pacientes con facturas pendientes
SELECT Pacientes.Nombre, Facturas.Monto_total, Deudas.Estado
FROM Pacientes
JOIN Facturas ON Pacientes.idPacientes = Facturas.Pacientes_idPacientes
JOIN Deudas ON Facturas.idFacturas = Deudas.Facturas_idFacturas
WHERE Deudas.Estado = 'Pendiente';

-- 4. Obtener el médico con más pacientes
SELECT Medicos.Nombre, COUNT(DISTINCT Citas.Pacientes_idPacientes) AS TotalPacientes
FROM Medicos
JOIN Citas ON Medicos.idMedicos = Citas.Medicos_idMedicos
GROUP BY Medicos.Nombre
ORDER BY TotalPacientes DESC;

-- 5. Obtener el total de facturación por consulta
SELECT Consultas.Nombre, SUM(Facturas.Monto_total) AS TotalFacturado
FROM Consultas
JOIN Citas ON Consultas.idConsultas = Citas.Consultas_idConsultas
JOIN Facturas ON Citas.Pacientes_idPacientes = Facturas.Pacientes_idPacientes
GROUP BY Consultas.Nombre;

-- 6. Consultar pagos realizados con método de pago 'Tarjeta'
SELECT Pagos.Monto, Pagos.Fecha_pago, Pagos.MetodoDePago
FROM Pagos
WHERE Pagos.MetodoDePago = 'Tarjeta';

-- 7. Mostrar pacientes con más de una cita
SELECT Pacientes.Nombre, COUNT(Citas.idCitas) AS CitasTotales
FROM Pacientes
JOIN Citas ON Pacientes.idPacientes = Citas.Pacientes_idPacientes
GROUP BY Pacientes.Nombre
HAVING COUNT(Citas.idCitas) > 1;

-- 8. Verificar la disponibilidad para una fecha específica
SELECT Disponibilidad.Fecha, Disponibilidad.Estado
FROM Disponibilidad
WHERE Disponibilidad.Fecha = TO_DATE('2024-12-15', 'YYYY-MM-DD');

-- 9. Obtener las especializaciones disponibles
SELECT Especializaciones.Nombre
FROM Especializaciones;

-- 10. Mostrar pacientes con deudas superiores a 500
SELECT Pacientes.Nombre, Deudas.MontoDeuda
FROM Pacientes
JOIN Deudas ON Pacientes.idPacientes = Deudas.Pacientes_idPacientes
WHERE Deudas.MontoDeuda > 500;

-- 11. Obtener noticias relacionadas con un médico específico
SELECT Noticias.Titulo, Noticias.Contenido
FROM Noticias
WHERE Noticias.Medicos_idMedicos = 1;

-- 12. Consultar médicos disponibles por especialización
SELECT Medicos.Nombre, Medicos.Especializacion
FROM Medicos
WHERE Medicos.Especializacion = 'Cardiología';

-- 13. Verificar facturas pagadas
SELECT Facturas.Fecha_factura, Facturas.Monto_total
FROM Facturas
JOIN Deudas ON Facturas.idFacturas = Deudas.Facturas_idFacturas
WHERE Deudas.Estado = 'Pagada';

-- 14. Obtener pacientes con su seguro médico
SELECT Pacientes.Nombre, SeguroMedico.Nombre AS Seguro
FROM Pacientes
JOIN Pacientes_Seguro ON Pacientes.idPacientes = Pacientes_Seguro.Pacientes_idPacientes
JOIN SeguroMedico ON Pacientes_Seguro.SeguroMedico_idSeguroMedico = SeguroMedico.idSeguroMedico;

-- 15. Buscar citas por fecha
SELECT Citas.Fecha, Citas.Descripcion
FROM Citas
WHERE Citas.Fecha = '2024-12-01';

-- 16. Calcular el monto promedio de facturación
SELECT AVG(Monto_total) AS PromedioFacturado
FROM Facturas;

-- 17. Contar pacientes por género
SELECT Pacientes.Sexo, COUNT(Pacientes.idPacientes) AS TotalPacientes
FROM Pacientes
GROUP BY Pacientes.Sexo;

-- 18. Mostrar pacientes con fechas de nacimiento en un rango específico
SELECT Pacientes.Nombre, Pacientes.Fecha_nac
FROM Pacientes
WHERE Pacientes.Fecha_nac BETWEEN TO_DATE('1990-01-01', 'YYYY-MM-DD') AND TO_DATE('2000-12-31', 'YYYY-MM-DD');

-- 19. Verificar citas por teléfono
SELECT Citas.Fecha, Citas.Telefono
FROM Citas
WHERE Citas.Telefono = '123-456789';

-- 20. Obtener la especialización más popular entre médicos
SELECT Medicos.Especializacion, COUNT(Medicos.idMedicos) AS TotalMedicos
FROM Medicos
GROUP BY Medicos.Especializacion
ORDER BY TotalMedicos DESC;
