
library ieee;
use ieee.std_logic_1164.all; 
--Declaramos la entidad dec7seg
entity dec7seg is
port (
--bdc es una entrada de 4 bits
bcd: in std_logic_vector (3 downto 0);
--hex es una entrada de 7 bits
HEX: out std_logic_vector (6 downto 0)
);
end;
--Declaramos la arquitectura 'a' de dec7seg
architecture a of dec7seg is
begin
--usamos bcd para asignar valores a hex (que representa la salida al display)
with bcd select
HEX<=
"1111111" when "0000", 
"0110001" when "0001", 
"0001000" when "0010", 
"1111010" when "0011",
"1111001" when "0100",
"0000001" when "0101",
"0100100" when "0110",
"0000000" when others; 
end a;