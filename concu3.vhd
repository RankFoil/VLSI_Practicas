library ieee;
use ieee.std_logic_1164.all;

entity concu3 is ---Se declara la identidad con sus respectivos puertos de entrada y salida, segun corresponda, estos representaran los displays
port( clk: in std_logic;
		ssg0: out std_logic_vector(6 downto 0);
		ssg1: out std_logic_vector(6 downto 0);
		ssg2: out std_logic_vector(6 downto 0);
		ssg3: out std_logic_vector(6 downto 0)
);
end entity;

architecture a of concu3 is ---Se desclara las variables a utilizar
signal clkl: std_logic :='0';
signal contador: integer range 0 to 25000000;
signal conteo1,conteo2,conteo3,conteo4 : integer := 0;
signal bandera1: std_logic :='0';
signal bandera2: std_logic :='0';
signal bandera3: std_logic :='0';
begin

	process(clk) --- El primer proceso reflejara un la division de frecuencia que nos dara el tiempo dentro de nuestro sistema
		begin 
			if (rising_edge(clk)) then 
				if (contador=2500000) then 
					contador<=0;
					clkl <= not clkl;
				else 
					contador <= contador +1;
				end if;
			end if;
	end process;
		
	process(clkl)	---Este primer contador representa el contador de minutos en unidades, por lo cual cada vez que llega a 9 se reiniciara y se aumentara en uno al contador de minutos en decenas
		begin 
			if(rising_edge(clkl)) then 
				if (conteo1=9) then 
					conteo1<=0;
					bandera1 <='1';
				else
					conteo1<= conteo1 +1;
					bandera1<='0';
				end if;
			end if;
		end process;
		
		process(bandera1) ---Al recibir el primer banderazo de que ya que se cumplieron los 9 segundos, entonces se aumenta en uno las decenas, esto hasta llegar a los 60 minutos, dara una señal para que sume la hora.
		begin 
			if(rising_edge(bandera1)) then 
				if (conteo2=5) then 
					conteo2<=0;
					bandera2 <='1';
				else
					conteo2<= conteo2 +1;
					bandera2<='0';
				end if;
			end if;
		end process;
		
		process(bandera2)	---Al recibir el banderazo que ya pasaron 60 minutos, se aumenta el uno las unidades de las horas, esto se hara hasta que existan 9 horas y se tenga que aumentar en decenas las horas, o cuando se llegue las 23 horas para realizar el reinicio del reloj
		begin 
			if(rising_edge(bandera2)) then 
				if (conteo3=9 OR (conteo3=3 and conteo4=2)) then 
					conteo3<=0;
					bandera3 <='1';
				else
					conteo3<= conteo3 +1;
					bandera3<='0';
				end if;
			end if;
		end process;
		
		process(bandera3)	---Este ultimo banderazo aumetara las decenas de las horas, validando que solo se aumente las decenas, o cuando se ha el caso se reinicie dicho valor. 
		begin 
			if(rising_edge(bandera3)) then 
				if (conteo4=2) then 
					conteo4<=0;
				else
					conteo4<= conteo4 +1;
				end if;
			end if;
		end process;
--- Dependiendo del valor que se tenga, dentro de cada conteo, que representa el display correspondiente, se le asignara el valor. 		
		with conteo1 select 
			ssg0 <= 	"1000000" when 0,
			"1111001" when 1,
			"0100100" when 2,
			"0110000" when 3,
			"0011001" when 4,
			"0010010" when 5,
			"0000010" when 6,
			"1111000" when 7,
			"0000000" when 8,
			"0011000" when 9,
			"1000000" when others;
			
		with conteo2 select 
			ssg1 <= 	"1000000" when 0,
			"1111001" when 1,
			"0100100" when 2,
			"0110000" when 3,
			"0011001" when 4,
			"0010010" when 5,
			"0000010" when 6,
			"1111000" when 7,
			"0000000" when 8,
			"0011000" when 9,
			"1000000" when others;
		
		with conteo3 select 
			ssg2 <= 	"1000000" when 0,
			"1111001" when 1,
			"0100100" when 2,
			"0110000" when 3,
			"0011001" when 4,
			"0010010" when 5,
			"0000010" when 6,
			"1111000" when 7,
			"0000000" when 8,
			"0011000" when 9,
			"1000000" when others;
		
		with conteo4 select 
			ssg3 <= 	"1000000" when 0,
			"1111001" when 1,
			"0100100" when 2,
			"0110000" when 3,
			"0011001" when 4,
			"0010010" when 5,
			"0000010" when 6,
			"1111000" when 7,
			"0000000" when 8,
			"0011000" when 9,
			"1000000" when others;
			
end architecture;	
