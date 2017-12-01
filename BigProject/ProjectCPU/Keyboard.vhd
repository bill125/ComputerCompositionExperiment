----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:41:12 11/30/2017 
-- Design Name: 
-- Module Name:    KeyboardAdapter - Behavioral 
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
library ieee;
use ieee.std_logic_1164.all;

entity Keyboard is
	port (
		PS2Data : in std_logic; -- PS2 data
		PS2Clock : in std_logic; -- PS2 clk
		Clock : in std_logic;
		Reset : in std_logic;
		DataReceive : in std_logic;
		DataReady : out std_logic ;  -- data output enable signal
		Output : out std_logic_vector(7 downto 0) -- scan code signal output
	);
end entity Keyboard;

architecture Behavioral of KeyboardAdapter is
	component KeyboardInput
		port (
			PS2Data : in std_logic; -- PS2 data
			PS2Clock : in std_logic; -- PS2 clk
			Clock : in std_logic;
			Reset : in std_logic;
			DataReceive : in std_logic;
			DataReady : out std_logic ;  -- data output enable signal
			Output : out std_logic_vector (7 downto 0) -- scan code signal output
		);
	end component;

	component KeyboardTranslate
		port (
			Data : in std_logic_vector (7 downto 0);
			Output : out std_logic_vector (7 downto 0)
		);
	end component;

	signal PS2DataSignal : std_logic_vector (7 downto 0);
begin

	KeyboardInput_inst : KeyboardInput port map (
		PS2Data => PS2Data,
		PS2Clock => PS2Clock,
		Clock => Clock,
		Reset => Reset,
		DataReceive => DataReceive,
		DataReady => DataReady,
		Output => PS2DataSignal
	);

	KeyboardTranslate_inst : KeyboardTranslate port map (
		Data => PS2DataSignal,
		Output => Output
	);

end architecture ; -- Behavioral

