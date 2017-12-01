----------------------------------------------------------------------------------
-- Company: 
-- Engineer: wangkai
-- 
-- Create Date:    21:42:32 11/11/2012 
-- Design Name: 
-- Module Name:    VGACore - Behavioral 
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

library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.std_logic_unsigned.all;
use		ieee.std_logic_arith.all;

entity VGACore is
	 port(
			clk_0 : in  std_logic;
			hs,vs : out std_logic;
			r,g,b : out std_logic_vector(2 downto 0);
			GRamAddra : in std_logic_vector(15 downto 0);
			GRamDina : in std_logic_vector(15 downto 0)
	  );
end VGACore; 

architecture behavior of VGACore is	
	signal r1,g1,b1   : std_logic_vector(2 downto 0);					
	signal hs1,vs1    : std_logic;				
	signal vector_x : std_logic_vector(9 downto 0);
	signal vector_y : std_logic_vector(8 downto 0);
	signal clk	:	 std_logic;
	signal GRamAddrb_in : std_logic_vector(18 downto 0);
	signal GRamDoutb_in :  std_logic_vector(0 downto 0);
	signal unsignedA : unsigned(9 downto 0);
	signal unsignedB : unsigned(8 downto 0);
	signal result : unsigned(18 downto 0);
	signal GRamDouta : std_logic_vector(15 downto 0);
	signal const40 : std_logic_vector(9 downto 0);
	component GM is
		port (
			clka : in std_logic;
			wea : in std_logic_vector(0 downto 0);
			addra : in std_logic_vector(14 downto 0);
			dina : in std_logic_vector(15 downto 0);
			douta : out std_logic_vector(15 downto 0);
			clkb : in std_logic;
			web : in std_logic_vector(0 downto 0);
			addrb : in std_logic_vector(18 downto 0);
			dinb : in std_logic_vector(0 downto 0);
			doutb : out std_logic_vector(0 downto 0)
		);
	end component;
begin
	const40 <= "101000";
	GRam_c: GRam port map(
			clka => clk_0,
			clkb => clk_0,
			wea => "1",
			web => "0",
			addra => GRamAddra,
			dina => GRamDina,
			douta => GRamDouta,
			addrb => GRamAddrb_in,
			dinb => (others => 'Z'),
			doutb => GRamDoutb_in
		);
  	 process(clk_0)
     begin
        if(clk_0'event and clk_0='1') then 
             clk <= not clk;
        end if;
 	 end process;
	 process(clk)
	 begin
	  	if clk'event and clk='1' then
	   		if vector_x=799 then
	    		vector_x <= (others=>'0');
	   		else
	    		vector_x <= vector_x + 1;
	   		end if;
	  	end if;
	 end process;
	 process(clk)
	 begin
	  	if clk'event and clk='1' then
	   		if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others=>'0');
	    		else
	     			vector_y <= vector_y + 1;
	    		end if;
	   		end if;
	  	end if;
	 end process;
	 process(clk)
	 begin
		  if clk'event and clk='1' then
		   	if vector_x>=656 and vector_x<752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
		  end if;
	 end process;
	 process(clk)
	 begin
	  	if clk'event and clk='1' then
	   		if vector_y>=490 and vector_y<492 then
	    		vs1 <= '0';
	   		else
	    		vs1 <= '1';
	   		end if;
	  	end if;
	 end process;
	 process(clk)
	 begin
	  	if clk'event and clk='1' then
	   		hs <=  hs1;
	  	end if;
	 end process;
	 process(clk)
	 begin
	  	if clk'event and clk='1' then
	   		vs <=  vs1;
	  	end if;
	 end process;
 	unsignedA <= unsigned(vector_x) SRA 2;
 	unsignedB <= unsigned(vector_y) SRA 2;
 	result <= unsignedB*unsigned(const40)+unsignedA;
 	GRamAddrb_in <= std_logic_vector(result);
	process(clk,vector_x,vector_y)
	begin
		if(clk'event and clk='1')then
			if vector_x > 639 or vector_y > 479 then 
					r1  <= "000";
					g1	<= "000";
					b1	<= "000";
			else
				r1 <= GRamDoutb_in(15 downto 13);
				g1 <= GRamDoutb_in(12 downto 10);
				b1 <= GRamDoutb_in(9 downto 7);
			end if;
		end if;		 
	end process;	
	process (hs1, vs1, r1, g1, b1)
	begin
		if hs1 = '1' and vs1 = '1' then
			r	<= r1;
			g	<= g1;
			b	<= b1;
		else
			r	<= (others => '0');
			g	<= (others => '0');
			b	<= (others => '0');
		end if;
	end process;

end behavior;

