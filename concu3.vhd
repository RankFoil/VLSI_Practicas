library ieee;
use ieee.std_logic_1164.all;

entity concu3 is ---Se declara la identidad con sus respectivos puertos de entrada y salida, 
	         ---segun corresponda, estos representaran los displays
port( clk: in std_logic;
		ssg0: out std_logic_vector(6 downto 0);  --- tenemos el nombre ssg0, el modo out que significa que es una  
                                                         --- señal de salida,y el tipo que es un vector del bit 6 al bit 0
		ssg1: out std_logic_vector(6 downto 0);
		ssg2: out std_logic_vector(6 downto 0);
		ssg3: out std_logic_vector(6 downto 0)
);
end entity;

architecture a of concu3 is ---Se desclara las variables a utilizar
signal clkl: std_logic :='0'; ---Asignacion de un cero lógico
signal contador: integer range 0 to 25000000; ---se utiliza la mitad de los 50 mega Hertz 
                                              --- para la frecuencia de la tarjeta, de modo que cada 25 000 000 
                                              ---se activara la bandera clkl
signal conteo1,conteo2,conteo3,conteo4 : integer := 0;
signal bandera1: std_logic :='0'; ---Tenemos una asignación de valores a costantes, 
                                  --- que en este caso es un cero lógico
signal bandera2: std_logic :='0';
signal bandera3: std_logic :='0';
begin

	process(clk) --- El primer proceso reflejara un la division de frecuencia 
	             --- que nos dara el tiempo dentro de nuestro sistema
		begin 
			if (rising_edge(clk)) then 
				if (contador=2500000) then --- contador inicializa en 0 y estara contando 
					                   --- de 0 a 25 millones, cuando llegue a 25 millones 
					                   --- se inicialia en cero  
					contador<=0;
					clkl <= not clkl; --- cada 25 mega Hertz clkl cambia de valor de 0 y 1 
			                                  --- lo que reduce la velocidad del reloj a segundos 
				else 
					contador <= contador +1; --- Se incrementara de uno en una hasta llegar 
			                                         --- al valor maximo de 25 millones 
				end if;
			end if;
	end process;
		
	process(clkl)	---Este primer contador representa el contador de minutos en unidades, 
			---por lo cual cada vez que llega a 9 se reiniciara y se aumentara 
			--- en uno al contador de minutos en decenas
		begin 
			if(rising_edge(clkl)) then ---Devuelve true cuando la señal cambia de 
				                   --- un valor bajo ('0' o 'L') a un valor alto ('1' o 'H').
				if (conteo1=9) then ---Si conteo4 llega al valor de 9 se reinicia a 0
					conteo1<=0; ---se asigna un cero 
					bandera1 <='1'; ---Asignacion de un 1 lógico
				else
					conteo1<= conteo1 +1; ---se incrementa en uno hasta llegar a un valor de 9
					bandera1<='0'; ---Asignacion de un cero lógico
				end if;
			end if;
		end process;
		
		process(bandera1) ---Al recibir el primer banderazo de que ya que se cumplieron los 9 segundos, 
				  --- entonces se aumenta en uno las decenas, esto hasta llegar a los 60 minutos, 
				  --- dara una señal para que sume la hora.
		begin 
			if(rising_edge(bandera1)) then  ---Devuelve true cuando la señal cambia de 
				                        --- un valor bajo ('0' o 'L') a un valor alto ('1' o 'H').
				if (conteo2=5) then  ---Si conteo2 llega al valor de 5 se reinicia a 0
					conteo2<=0; ---se asigna un cero 
					bandera2 <='1'; ---Asignacion de un 1 lógico
				else
					conteo2<= conteo2 +1; --- se incrementa en uno hasta llegar a un valor de 5
					bandera2<='0'; ---Asignacion de un cero lógico
				end if;
			end if;
		end process;
		
		process(bandera2)	---Al recibir el banderazo que ya pasaron 60 minutos, 
				        --- se aumenta el uno las unidades de las horas, esto se hara hasta que 
				        --- existan 9 horas y se tenga que aumentar en decenas las horas, 
				        --- o cuando se llegue las 23 horas para realizar el reinicio del reloj
		begin 
			if(rising_edge(bandera2)) then  ---Devuelve true cuando la señal cambia de 
				                        --- un valor bajo ('0' o 'L') a un valor alto ('1' o 'H').
				if (conteo3=9 OR (conteo3=3 and conteo4=2)) then 
					conteo3<=0; ---se asigna un cero
					bandera3 <='1'; ---Asignacion de un 1 lógico
				else
					conteo3<= conteo3 +1; --- se incrementa en uno hasta llegar a un valor de 9
					bandera3<='0'; ---Asignacion de un cero lógico
				end if;
			end if;
		end process;
		
		process(bandera3)	---Este ultimo banderazo aumetara las decenas de las horas, 
				        --- validando que solo se aumente las decenas,
				        --- o cuando se ha el caso se reinicie dicho valor. 
		begin 
			if(rising_edge(bandera3)) then   ---Devuelve true cuando la señal cambia de 
				                         --- un valor bajo ('0' o 'L') a un valor alto ('1' o 'H').
				if (conteo4=2) then ---Si conteo4 llega al valor de 2 se reinicia a 0
					conteo4<=0; ---se asigna un cero
				else
					conteo4<= conteo4 +1; --- se incrementa en uno hasta llegar a un valor de 2
				end if;
			end if;
		end process;
--- Dependiendo del valor que se tenga, dentro de cada conteo, que representa 
--- el display correspondiente, se le asignara el valor. 		
		with conteo1 select 
			ssg0 <= 	"1000000" when 0, ---Un multiplexor de 10 entradas y una salida. 
				                          --- La entrada es un dato entero y la salida 
				                          --- es un tipo de dato vector de 7 bits. 
				                          --- Con esto nos acoplamos a un display de 7 segmentos
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
			ssg1 <= 	"1000000" when 0, ---Un multiplexor de 10 entradas y una salida. 
					                  --- La entrada es un dato entero y la salida 
					                  --- es un tipo de dato vector de 7 bits. 
					                  --- Con esto nos acoplamos a un display de 7 segmentos
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
			ssg2 <= 	"1000000" when 0, ---Un multiplexor de 10 entradas y una salida. 
				                          --- La entrada es un dato entero y la salida 
				                          --- es un tipo de dato vector de 7 bits. 
				                          --- Con esto nos acoplamos a un display de 7 segmentos
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
			ssg3 <= 	"1000000" when 0, ---Un multiplexor de 10 entradas y una salida. 
			                                  --- La entrada es un dato entero y la salida 
			                                  --- es un tipo de dato vector de 7 bits. 
			                                  --- Con esto nos acoplamos a un display de 7 segmentos
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
