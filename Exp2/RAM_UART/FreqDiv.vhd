----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:55:04 11/08/2017 
-- Design Name: 
-- Module Name:    FreqDiv - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity FreqDiv is
    generic
    (
        div : integer := 50;
        half : integer := 25 
    );
    port
    (
        CLK: in std_logic;
        RST: in std_logic;
        O: out std_logic
    );
end FreqDiv;

architecture FreqDiv_bhv of FreqDiv is
    signal counter: integer range 0 to half - 1;
    signal output: std_logic;    
begin
    O <= output;

    process(CLK, RST)
    begin
        if RST = '1' then
            output <= '0';
            counter <= 0;
        else
            if rising_edge(CLK) then
                if counter = half - 1 then
                    output <= not output;
                    counter <= 0;
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;
end;