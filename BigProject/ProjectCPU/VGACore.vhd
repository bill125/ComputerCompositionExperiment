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
use     ieee.numeric_std.all;

entity VGACore is
	 port(
			clk : in  std_logic;
			i_data : in std_logic_vector(15 downto 0); --读到的数�
			hs,vs : out std_logic;
			r,g,b : out std_logic_vector(2 downto 0);
			o_vectorX : out std_logic_vector(9 downto 0);  --需要获取颜色的x
			o_vectorY : out std_logic_vector(8 downto 0);  --需要获取颜色的y
			o_read_EN : out std_logic -- 是否需要读SRAM ��� '0' - 不读
	  );
end VGACore; 

architecture behavior of VGACore is	
	signal r1,g1,b1   : std_logic_vector(2 downto 0);					
	signal hs1,vs1    : std_logic;				
	signal vector_x : std_logic_vector(9 downto 0);
	signal vector_y : std_logic_vector(8 downto 0);
	signal unsignedA : unsigned(9 downto 0);
	--signal unsignedB : unsigned(8 downto 0);
begin
	 process(clk)
	 begin
	  	if clk'event and clk='1' then
	   		if vector_x=799 then
	    		vector_x <= (others=>'0');
	   		else 
	    		vector_x <= vector_x + 1;
				if vector_x=159 then
					o_read_EN <= '1';
				elsif vector_x=479 then
					o_read_EN <= '0';
				end if;
	   		end if;
	  	end if;
	 end process;
	 process(clk)
	 begin
	  	if clk'event and clk='1' then
	   		if vector_x=799 then
	    		if vector_y=524 then
	     			vector_y <= (others=>'0');
					o_read_EN <= '1';
	    		else
	     			vector_y <= vector_y + 1;
					if vector_y=480 then
						o_read_EN <= '0';
					end if;
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

 	unsignedA <= unsigned(vector_x);
 	o_vectorX <= to_stdlogicvector(to_bitvector(conv_std_logic_vector(unsignedA-160,10)) srl 1) when unsignedA>159 else
	 			 (others => '0');
 	o_vectorY <= to_stdlogicvector(to_bitvector(vector_y) srl 1);
	
	process(clk,vector_x,vector_y)
	begin
		if(clk'event and clk='1')then
			if vector_x < 160 or vector_x > 479 or vector_y > 479 then
					r1  <= "000";
					g1	<= "000";
					b1	<= "000";
			else
				r1 <= i_data(15 downto 13);
				g1 <= i_data(12 downto 10);
				b1 <= i_data(9 downto 7);
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

