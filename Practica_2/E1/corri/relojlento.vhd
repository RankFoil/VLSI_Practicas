
library ieee;
use ieee.std_logic_arith.all; 
use ieee.std_logic_1164. all; 
--Declaramos la entidad relojlento
entity relojlento is 
port(
--clkl es una entrada
	clkl: in std_logic;
--Led es una salida
	led: buffer std_logic:= '0'
);
end relojlento;
--Definimos la arquitectura a de relojlento
architecture a of relojlento is
--Conteo es una señal con un rango de 0 1 25,000,000, actúa como contador
signal conteo: integer range 0 to 25000000;
begin
--Este proceso ocurre cada ciclo de reloj
process(clkl)
	begin
	--Verifica que la señal vaya de 0 a 1
		if(clkl' event and clkl='1') then
	--Si el contador alcanza 25,000,000, se reinicia y el led cambia de estado
			if (conteo=25000000) then 
				conteo<=0; 
				led<=not (led);
	--En el resto de casos, el contador aumenta en 1
			else
				conteo<=conteo+1;
			end if;
		end if;
	end process;
end;