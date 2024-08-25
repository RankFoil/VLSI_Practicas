library ieee;
use ieee.std_logic_1164.all;
--Declaramos la entidad display
entity display is
port (
--clk es una entrada que representa la reloj
    clk : in std_logic;
--mi es una entrada de 7 bits
    mi  : in std_logic_vector(6 downto 0);
--mo es una salida de 7 bits
    mo  : out std_logic_vector(6 downto 0)
  );
end entity;
--Declaramos la arquitectura de display
architecture a of display is
begin
--Es un proceso sincronizado por el reloj
  process (clk)
  begin
 --cada vez que clk pasa de 0 a 1 la entrada mi se transfiere a la salida m0
    if rising_edge(clk) then
      mo <= mi;
    end if;
  end process;
end architecture;