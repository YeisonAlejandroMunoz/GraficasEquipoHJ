-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 19-10-2022 a las 13:28:42
-- Versión del servidor: 10.4.24-MariaDB
-- Versión de PHP: 8.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `huevosjireth`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DATOSGRAFICO_BAR` ()   SELECT Producto, SUM(Total) FROM reservas WHERE Producto = 'Huevos Pequeños' AND Estado='Retirado'
UNION
SELECT Producto, SUM(Total) FROM reservas WHERE Producto = 'Huevos Medianos' AND Estado='Retirado'
UNION
SELECT Producto, SUM(Total) FROM reservas WHERE Producto = 'Huevos Triple A' AND Estado='Retirado'
UNION
SELECT Producto, SUM(Total) FROM reservas WHERE Producto = 'Huevos Doble Yema' AND Estado='Retirado'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DATOSGRAFICO_CANT` ()   SELECT Producto, SUM(Cantidad) FROM reservas WHERE Producto='Huevos Pequeños' AND Estado='Retirado'
UNION
SELECT Producto, SUM(Cantidad) FROM reservas WHERE Producto='Huevos Medianos' AND Estado='Retirado'
UNION
SELECT Producto, SUM(Cantidad) FROM reservas WHERE Producto='Huevos Triple A' AND Estado='Retirado'
UNION
SELECT Producto, SUM(Cantidad) FROM reservas WHERE Producto='Huevos Doble Yema' AND Estado='Retirado'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DATOSGRAFICO_MAS` ()   SELECT Producto, COUNT(Producto) FROM reservas WHERE Producto='Huevos Pequeños' AND Estado='Retirado'
UNION
SELECT Producto, COUNT(Producto) FROM reservas WHERE Producto='Huevos Medianos' AND Estado='Retirado'
UNION
SELECT Producto, COUNT(Producto) FROM reservas WHERE Producto='Huevos Triple A' AND Estado='Retirado'
UNION
SELECT Producto, COUNT(Producto) FROM reservas WHERE Producto='Huevos Doble Yema' AND Estado='Retirado'$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DATOSGRAFICO_PARAMETRO_GANACIAS` (IN `FECHAINICIO` VARCHAR(10), IN `FECHAFIN` VARCHAR(10))   SELECT
productos.Producto,
SUM(reservas.Total) AS TOTALVENTAS
FROM
reservas
INNER JOIN productos ON reservas.Producto = productos.Producto
WHERE Estado = "Retirado" AND YEAR(reservas.Fecha) BETWEEN FECHAINICIO AND FECHAFIN
GROUP BY productos.idProducto$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DATOSGRAFICO_PARAMETRO_UNIDADES` (IN `FECHAINICIO` VARCHAR(10), IN `FECHAFIN` VARCHAR(10))   SELECT
productos.Producto,
SUM(reservas.Cantidad) AS CANTIDAD
FROM
reservas 
INNER JOIN productos ON reservas.Producto = productos.Producto
WHERE Estado = "Retirado" AND YEAR(reservas.Fecha) BETWEEN FECHAINICIO AND FECHAFIN
GROUP BY productos.idProducto$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_DATOSGRAFICO_PARAMETRO_VENTAS` (IN `FECHAINICIO` VARCHAR(10), IN `FECHAFIN` VARCHAR(10))   SELECT
productos.Producto,
COUNT(reservas.Producto) AS PRODUCTO
FROM
reservas 
INNER JOIN productos ON reservas.Producto = productos.Producto
WHERE Estado = "Retirado" AND YEAR(reservas.Fecha) BETWEEN FECHAINICIO AND FECHAFIN
GROUP BY productos.idProducto$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensajes`
--

CREATE TABLE `mensajes` (
  `idMensaje` int(11) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Correo` varchar(30) NOT NULL,
  `Telefono` varchar(10) NOT NULL,
  `Mensaje` varchar(500) NOT NULL,
  `idUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `mensajes`
--

INSERT INTO `mensajes` (`idMensaje`, `Nombre`, `Correo`, `Telefono`, `Mensaje`, `idUsuario`) VALUES
(9, 'llamozin', 'llamozin@gmail.com', '321654', 'asdsalndkas', 0),
(10, '', '', '', '', 0),
(11, 'andres', 'andres@gmail.com', '321654987', 'jashbduashbdsuhdubdhas', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `idProducto` int(11) NOT NULL,
  `Nombre` varchar(30) NOT NULL,
  `Precio` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Descripcion` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`idProducto`, `Nombre`, `Precio`, `Cantidad`, `Descripcion`) VALUES
(101, 'Huevos Pequeños', 10500, 10, 'Los huevos más pequeños, con el precio más barato y accesibles para nuestros clientes.'),
(202, 'Huevos Medianos', 15400, 13, 'Huevos de tamaño mediano, económicos con un precio razonable.'),
(303, 'Huevos Triple A', 18500, 16, 'El huevo más grande que vendemos, cuenta con una clara y yema más grande y alta proteína.'),
(404, 'Huevos Doble Yema', 22000, 12, 'Los huevos que contienen doble sorpresa por dentro, los más costosos y con mejor aceptación de nuestros clientes.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reservas`
--

CREATE TABLE `reservas` (
  `idReserva` int(11) NOT NULL,
  `Cliente` varchar(50) NOT NULL,
  `Producto` varchar(50) NOT NULL,
  `Precio` int(11) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Total` int(11) GENERATED ALWAYS AS (`Precio` * `Cantidad`) VIRTUAL,
  `Fecha` date DEFAULT NULL,
  `Hora` time DEFAULT NULL,
  `Estado` varchar(15) NOT NULL DEFAULT 'Vigente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `reservas`
--

INSERT INTO `reservas` (`idReserva`, `Cliente`, `Producto`, `Precio`, `Cantidad`, `Fecha`, `Hora`, `Estado`) VALUES
(32, 'llamozin', 'Huevos Pequeños', 10500, 1, '2022-10-14', '07:25:14', 'Retirado'),
(33, 'llamozin', 'Huevos Medianos', 15400, 2, '2022-10-14', '07:25:25', 'Cancelado'),
(34, 'yeison', 'Huevos Triple A', 18500, 3, '2022-10-14', '08:32:37', 'Retirado'),
(35, 'santiago', 'Huevos Doble Yema', 22000, 4, '2022-10-14', '08:32:58', 'Cancelado'),
(36, 'llamozin', 'Huevos Triple A', 18500, 1, '2022-10-14', '08:39:19', 'Retirado'),
(37, 'llamozin', 'Huevos Triple A', 18500, 3, '2022-10-14', '08:41:53', 'Cancelado'),
(38, 'yeison', 'Huevos Medianos', 15400, 1, '2022-10-14', '08:43:37', 'Retirado'),
(39, 'yeison', 'Huevos Doble Yema', 22000, 1, '2022-10-14', '08:43:47', 'Retirado'),
(40, 'llamozin', 'Huevos Medianos', 15400, 4, '2022-10-14', '08:45:10', 'Cancelado'),
(41, 'llamozin', 'Huevos Triple A', 18500, 4, '2022-10-14', '08:45:24', 'Retirado'),
(42, 'llamozin', 'Huevos Doble Yema', 22000, 5, '2022-10-14', '08:45:39', 'Retirado'),
(43, 'yeison', 'Huevos Pequeños', 10500, 5, '2022-10-14', '08:45:57', 'Retirado'),
(44, 'yeison', 'Huevos Triple A', 18500, 3, '2022-10-14', '08:46:04', 'Retirado'),
(45, 'yeison', 'Huevos Doble Yema', 22000, 2, '2022-10-14', '08:46:11', 'Retirado'),
(46, 'jesus', 'Huevos Doble Yema', 22000, 5, '2022-10-14', '08:46:33', 'Retirado'),
(47, 'jesus', 'Huevos Medianos', 15400, 5, '2022-10-14', '08:46:41', 'Retirado'),
(48, 'jesus', 'Huevos Medianos', 15400, 2, '2022-10-14', '08:46:47', 'Retirado'),
(49, 'santiago', 'Huevos Pequeños', 10500, 5, '2022-10-14', '08:47:49', 'Retirado'),
(50, 'santiago', 'Huevos Pequeños', 10500, 4, '2022-10-14', '08:47:59', 'Retirado'),
(51, 'santiago', 'Huevos Pequeños', 10500, 3, '2022-10-14', '08:48:10', 'Retirado'),
(52, 'llamozin', 'Huevos Medianos', 15400, 3, '2022-10-19', '06:24:38', 'Retirado'),
(53, 'llamozin', 'Huevos Doble Yema', 22000, 5, '2022-10-19', '06:24:48', 'Retirado'),
(54, 'llamozin', 'Huevos Doble Yema', 22000, 5, '2022-10-19', '06:25:29', 'Cancelado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `idRol` int(11) NOT NULL,
  `Perfil` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`idRol`, `Perfil`) VALUES
(1, 'Administrador'),
(2, 'Cliente');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idUsuario` int(11) NOT NULL,
  `Nombre` varchar(50) NOT NULL,
  `Correo` varchar(30) NOT NULL,
  `Contraseña` varchar(150) NOT NULL,
  `idRol` int(11) DEFAULT 2
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idUsuario`, `Nombre`, `Correo`, `Contraseña`, `idRol`) VALUES
(1, 'Andres Guzman', 'afgr@gmail.com', '098a806271230e05f2a91a1c7220c8275c3a9724594b95b22b57974491b431633abee20d7c750199e195804afb67d489d7838e315904e0ce9e2d1956ccfd30f8', 1),
(2, 'llamozin', 'llamoza@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', 2),
(3, 'jesus', 'jesus@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', 2),
(4, 'santiago', 'santiago@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', 2),
(5, 'yeison', 'yeison@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', 2),
(31, 'carlos', 'carlos@gmail.com', '3c9909afec25354d551dae21590bb26e38d53f2173b8d3dc3eee4c047e7ab1c1eb8b85103e3be7ba613b31bb5c9c36214dc9f14a42fd7a2fdb84856bca5c44c2', 2),
(32, '', '', 'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e', 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  ADD PRIMARY KEY (`idMensaje`),
  ADD KEY `idUsuario` (`idUsuario`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`idProducto`);

--
-- Indices de la tabla `reservas`
--
ALTER TABLE `reservas`
  ADD PRIMARY KEY (`idReserva`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`idRol`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idUsuario`),
  ADD KEY `idRol` (`idRol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `mensajes`
--
ALTER TABLE `mensajes`
  MODIFY `idMensaje` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `reservas`
--
ALTER TABLE `reservas`
  MODIFY `idReserva` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=55;

--
-- AUTO_INCREMENT de la tabla `roles`
--
ALTER TABLE `roles`
  MODIFY `idRol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idUsuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_user_rol` FOREIGN KEY (`idRol`) REFERENCES `roles` (`idRol`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
