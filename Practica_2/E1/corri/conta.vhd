library ieee;
use ieee.std_logic_1164.all;
--Declaramos la entidad conta
entity conta is
port (
--son entradas clock y switch
clk, reset: in std_logic;
--Es una salida de 3 bits
salMoore: out std_logic_vector (2 downto 0)
);
end entity;
--Declaramos la arquitectura de conta
architecture a of conta is
--state es un subtipo de 3 bits
subtype state is std_logic_vector (2 downto 0);
--Se usan para almacenar el estado actual y el siguiente
signal present_state, next_state: state;
--De e0 a e7 se definen los valores binarios de los estados
constant e0: state:="000";
constant e1: state:="001"; 
constant e2: state:="010";
constant e3: state:="011"; 
constant e4: state:="100";
constant e5: state:="101";
constant e6: state:="110";
constant e7: state:="111";
begin
--Se inicia un proceso con la señal de reloj
process (clk)
begin
--entra si detecta un cambio en el reloj
if rising_edge(clk) then 
--Si el reset está activado, el estado actual vuelve a e0	
	if (reset='1') then
		present_state<=e0;
	else
--Si no está activado el reset, el estado actual se actualiza al siguiente
		present_state<=next_state;
	end if;
end if;
end process;
--Se declara un proceso que contiene los estados actuales y su estado siguiente
--se ejectuta cada vez que present_state cambia
process (present_state) 
begin
case present_state is 
when e0=> next_state<=e1; 
when e1=> next_state<=e2; 
when e2=> next_state<=e3; 
when e3=> next_state<=e4; 
when e4=> next_state<=e5; 
when e5=> next_state<=e6; 
when e6=> next_state<=e7; 
when e7=> next_state<=e0; 
when others=> next_state<=e0; 
end case;
--Se actualiza con el valor del estado actual
salMoore<=present_state; 
end process; 
end;