library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_tp3_1 is
end tb_tp3_1;

architecture rtl of tb_tp3_1 is
    component producto
        port (
            a, b: in integer range 0 to 100;
            s: out integer range 0 to 10000
        );
    end component;

    SIGNAL x, y: INTEGER RANGE 0 TO 100;
    SIGNAL z: INTEGER RANGE 0 TO 10000;

begin

    uut: producto PORT MAP (x, y, z);

    PROCESS
        FILE input_file  : TEXT open read_mode IS "entradas.txt";
        FILE output_file : TEXT open write_mode IS "salida.txt";
        VARIABLE buffer_in, buffer_out : LINE;
        VARIABLE entrada, salida : INTEGER;

    BEGIN

        WHILE NOT ENDFILE (input_file) LOOP
            READLINE (input_file, buffer_in);
            READ (buffer_in, entrada);
            x <= entrada;
            READ (buffer_in, entrada);
            y <= entrada;
            wait for 10 ns; --se debe agregar un delay para que no se cero el primer valor de z
            salida := z;
            WRITE (buffer_out, salida);
            WRITELINE (output_file, buffer_out);
            wait for 50 ns;
        END LOOP;
        FILE_CLOSE(input_file);
        FILE_CLOSE(output_file);
        REPORT "fin de la simulación";
        WAIT;
    END PROCESS;

end architecture;