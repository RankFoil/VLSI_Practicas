library ieee;
use ieee.std_logic_1164.all;

--Declaramos la entidad con sus puertos de entrada y salida
entity corri is
  port (
  --clk y reset son entradas (clock y un switch)
    clk, reset: in std_logic;
	 --Son puertos de salida de 7 bits, buffer indica que las
	 --señales se pueden leer y escribir dentro de la arquitectura
    hex0, hex1, hex2, hex3, hex4 : buffer std_logic_vector(6 downto 0)
  );
end entity;
--Definimos la arquitectura
architecture a of corri is
  signal clkl : std_logic;
  --bcd es una señal de 3 bits que representa un número en BCD
  signal bcd  : std_logic_vector(2 downto 0);
begin
--La instancia u1 conecta al componente relojlento a la arquitectura,
--Relojlento se encarga de reducir la frecuencia del reloj.
  u1 : entity work.relojlento(a) port map(clk, clkl);
--La instancia u2 conecta al componente conta a la arquitectura,
--conta es un contador cuya salida está en bcd.
  u2 : entity work.conta(a) port map(clkl, reset, bcd);
--La instancia u3 conecta al componente dec7seg a la arquitectura,
--dec7seg decodifica el valor en 0+bcd (4 bits en total) a hex (7bits) para el display
  u3 : entity work.dec7seg(a) port map ('0'&bcd, hex0);
--Las instancias u4-7 conecta al componente display a la arquitectura,
--display toma el valor de un display y lo transfiere al siguiente.
  u4: entity work.display(a) port map(clkl, hex0, hex1);
  u5: entity work.display(a) port map(clkl, hex1, hex2);
  u6: entity work.display(a) port map(clkl, hex2, hex3);
  u7: entity work.display(a) port map(clkl, hex3, hex4);
end architecture;