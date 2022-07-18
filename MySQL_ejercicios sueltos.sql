-- ============================= Proyecto - DHespegar ============================= --
-- ================================ Checkpoint ================================ --

-- Ejercicios sueltos --

SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- Código de camada: 0522TDBD1N2C2LAED0222PT
-- Equipo N°: 2
-- Integrantes: ESTANISLAO AYALA, LEANDRO GUTIERREZ, PATRICIO CABRERA, JOSE D. LEONETT

SET sql_mode = 'ONLY_FULL_GROUP_BY';

-- 1. Listar todas las reservas de hoteles realizadas en la ciudad de Nápoles.
-- rows: 6
SELECT r.idreserva, h.ciudad
FROM reservas r 
INNER JOIN hotelesxreserva hr ON r.idreserva = hr.idReserva
INNER JOIN hoteles h ON hr.idHotel = h.idhotel
WHERE h.ciudad = "Nápoles";


-- 2. Listar el número de pago (idpago), el precio, la cantidad de cuotas de todas las
-- reservas realizadas con tarjeta de crédito.
-- rows: 19
SELECT pg.idpago AS nroPago, pg.precioTotal AS precio, pg.cantidadCuotas
FROM pagos pg
INNER JOIN metodospago mp ON pg.idMetodosPago = mp.idmetodospago
WHERE mp.nombre = "Tarjeta de Crédito";


-- 3. Listar la cantidad de reservas realizadas de acuerdo al método de pago.
-- rows: 3
SELECT mp.nombre, COUNT(r.idreserva) AS cantidadReservas
FROM reservas r
INNER JOIN pagos pg ON r.idPago = pg.idpago
INNER JOIN metodospago mp ON pg.idMetodosPago = mp.idmetodospago
GROUP BY mp.nombre;


-- 4. Listar las reservas de los clientes cuyo pago lo hicieron a través de tarjeta de
-- crédito, se pide mostrar el nombre, apellido, país y el método de pago.
-- rows: 19
SELECT c.nombres, c.apellidos, ps.nombre, mp.nombre
FROM clientes c
INNER JOIN paises ps ON c.idPais = ps.idPais
INNER JOIN reservas r ON c.idcliente = r.idCliente
INNER JOIN pagos pg ON r.idPago = pg.idpago
INNER JOIN metodospago mp ON pg.idMetodosPago = mp.idmetodospago
WHERE mp.nombre = "Tarjeta de Crédito";


-- 5. Listar la cantidad de reservas de hoteles por país, se necesita mostrar el nombre
-- del país y la cantidad.
-- rows: 8
SELECT ps.nombre, COUNT(hr.idhotelesxreserva) AS cantidadReservasHotel
FROM reservas r
INNER JOIN hotelesxreserva hr ON r.idreserva = hr.idReserva
INNER JOIN hoteles h ON hr.idHotel = h.idhotel
INNER JOIN paises ps ON h.idPais = ps.idpais
GROUP BY ps.nombre;


-- 6. Listar el nombre, apellido, número de pasaporte,ciudad y (paises) nombre del país de los
-- clientes de origen Peruano.
-- rows: 5
SELECT c.nombres, c.apellidos, c.numeroPasaporte, c.ciudad, ps.nombre
FROM clientes c
INNER JOIN paises ps ON c.idPais = ps.idpais
WHERE ps.idpais = 3;

-- 7. Listar la cantidad de reservas realizadas de acuerdo al método de pago y el
-- nombre completo del cliente.
-- rows: 51
SELECT COUNT(mp.nombre) cantidadReservas, mp.nombre metodoPago, CONCAT(c.nombres, ' ', c.apellidos) nombreCompleto
FROM reservas r
INNER JOIN pagos pg ON pg.idpago = r.idPago
INNER JOIN metodospago mp ON pg.idMetodosPago = mp.idmetodospago
INNER JOIN clientes c ON r.idCliente = c.idcliente
GROUP BY mp.nombre, c.idcliente
ORDER BY nombreCompleto;


-- 8. Mostrar la cantidad de clientes por país, se necesita visualizar el nombre del
-- país y la cantidad de clientes.
-- rows: 11
SELECT COUNT(c.idcliente) cantidadClientes, ps.nombre nombrePais
FROM clientes c
INNER JOIN paises ps ON c.idPais = ps.idpais
GROUP BY ps.nombre;

-- 9. Listar todas las reservas de hotel, se pide mostrar el nombre del hotel,dirección,
-- ciudad, el país, el tipo de pensión y que tengan como tipo de hospedaje 'Media pensión'.
-- rows: 22
SELECT r.idReserva,
r.codigoReserva,
h.nombre nombreHotel,
h.direccion,
h.ciudad,
p.nombre pais,
th.nombre tipoPension
FROM reservas r
INNER JOIN hotelesxreserva hr ON r.idreserva = hr.idReserva
LEFT JOIN hoteles h ON hr.idHotel = h.idhotel
INNER JOIN tiposhospedaje  th ON hr.idTiposHospedaje = th.idtiposhospedaje
INNER JOIN paises p ON h.idPais = p.idpais
WHERE th.nombre = 'Media pensión';


-- 10. Mostrar por cada método de pago el monto total obtenido,se pide visualizar el
-- nombre del método de pago y el total.
-- rows: 3
SELECT mp.nombre, SUM(p.precioTotal) AS total
FROM pagos p
INNER JOIN metodospago mp ON p.idMetodosPago = mp.idmetodospago
GROUP BY p.idMetodosPago
ORDER BY total DESC;




-- 11. Mostrar la suma de los pagos realizados en la sucursal de Mendoza, llamar al
-- resultado “TOTAL MENDOZA”.
-- rows:1 (total = 19626)
SELECT SUM(pg.precioTotal) "TOTAL MENDOZA"
FROM reservas r
JOIN sucursales s ON s.idSucursal = r.idSucursal
JOIN pagos pg ON pg.idpago = r.idPago
WHERE s.ciudad = "Mendoza";

-- 12. Listar todos los clientes que no han realizado reservas.
-- rows:33
SELECT *
FROM clientes c
LEFT JOIN reservas r ON r.idCliente = c.idcliente
WHERE r.codigoReserva IS NULL;

-- 13. Listar todas las reservas de vuelos realizadas donde el origen sea Chile y el
-- destino Ecuador, mostrar el id Reserva, id Vuelo, fecha de partida, fecha de
-- llegada, fecha de la reserva.
-- rows:3
SELECT r.idreserva, v.idvuelo, v.fechaPartida, v.fechaLlegada, r.fechaRegistro
FROM reservas r
JOIN vuelosxreserva vr ON vr.idReserva = r.idreserva
JOIN vuelos v ON v.idvuelo = vr.idVuelo
WHERE v.origen = "CHILE" AND v.destino = "ECUADOR";

-- 14. Listar el nombre y cantidad de habitaciones de aquellos hoteles que tengan de
-- 30 a 70 habitaciones pertenecientes al país Argentina.
-- rows:3
SELECT h.nombre, h.cantidadHabitaciones
FROM hoteles h
JOIN paises ps ON ps.idpais = h.idPais
WHERE ps.nombre = "Argentina" AND h.cantidadHabitaciones BETWEEN 30 AND 70;

-- 15. Listar el top 10 de hoteles más utilizados y la cantidad de reservas en las que ha
-- sido reservado.
-- rows:14
SELECT h.nombre, COUNT(r.idReserva) CantReservas
FROM reservas r
JOIN hotelesxreserva hr ON hr.idReserva = r.idreserva
JOIN hoteles h ON h.idhotel = hr.idHotel
GROUP BY h.nombre
ORDER BY CantReservas DESC
LIMIT 10;


-- 16. Listar los clientes (nombre y apellido) y cuáles han sido los medios de pago que
-- han utilizado, esta lista deberá estar ordenada por apellidos de manera
-- ascendente.
-- rows:62 filas
SELECT concat(c.nombres, ' ', c.apellidos) AS listaClientes, mp.nombre AS medioDePago FROM clientes c
INNER JOIN reservas r ON c.idcliente = r.idCliente
INNER JOIN pagos pg ON r.idPago = pg.idpago
INNER JOIN metodospago mp ON pg.idMetodosPago = mp.idmetodospago
ORDER BY c.apellidos ASC;


-- 17. Listar la cantidad de reservas que se realizaron para los vuelos que el origen ha
-- sido de Argentina o Colombia, en el horario de las 18hs. Mostrar la cantidad de
-- vuelos y país de origen.
-- rows 13 filas
SELECT concat(v.cantidadTurista + v.cantidadPrimeraClase) AS cantidadReservas,
v.origen AS vueloOrigen,
EXTRACT(HOUR FROM v.fechaPartida) AS horario
FROM reservas r
INNER JOIN vuelosxreserva vr ON r.idreserva = vr.idReserva
INNER JOIN vuelos v ON vr.idVuelo = v.idvuelo
WHERE v.origen = 'Argentina' OR v.origen = 'Colombia' 
HAVING horario = 18;


-- 18. Mostrar los totales de ventas de sucursales por países y ordenarlas de mayor a
-- menor.
-- rows:2 filas
SELECT sum(pg.precioTotal) AS totalVentas, ps.nombre AS pais FROM pagos pg
INNER JOIN reservas r ON pg.idpago = r.idPago 
INNER JOIN sucursales s ON r.idSucursal = s.idSucursal
INNER JOIN paises ps ON ps.idpais = s.idPais
GROUP BY ps.nombre
ORDER BY totalVentas DESC;


-- 19. Mostrar los países que no tienen clientes asignados ordenados por los que
-- empiezan por Z primero.
-- rows: 19
SELECT ps.nombre AS Pais FROM paises ps
LEFT JOIN clientes c ON ps.idpais = c.idPais
WHERE c.idcliente IS NULL
ORDER BY ps.nombre DESC;


-- 20. Generar un listado con los hoteles que tuvieron más de 2 reservas realizadas.
-- Mostrar el nombre del hotel y la cantidad.
-- rows: 4
SELECT h.nombre AS nombreHotel, COUNT(hr.idhotelesxreserva) AS cantidadReservasHotel
FROM hotelesxreserva hr
INNER JOIN hoteles h ON hr.idHotel = h.idhotel
GROUP BY h.nombre
HAVING cantidadReservasHotel > 2;

