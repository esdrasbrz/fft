library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity twiddle_table is
	generic (
		ADDR_WIDTH: natural := 4;
		DATA_WIDTH: natural := 16
	);
	
	port (
		clk: in std_logic;
		k: in std_logic_vector(ADDR_WIDTH-1 downto 0);
		t_sin: out std_logic_vector(DATA_WIDTH-1 downto 0);
		t_cos: out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end twiddle_table;

architecture rtl of twiddle_table is
	constant rom_length: integer := 16;
	
	type rom_t is array(0 to rom_length-1) of signed(DATA_WIDTH-1 downto 0);
	signal sin_rom: rom_t;
	signal cos_rom: rom_t;
begin
	-- rom logic
	process (clk)
	begin
		if (rising_edge(clk)) then
			t_sin <= std_logic_vector(sin_rom(to_integer(unsigned(k))));
			t_cos <= std_logic_vector(cos_rom(to_integer(unsigned(k))));
		end if;
	end process;

	-- rom table
	cos_rom(0) <= x"7fff";
	sin_rom(0) <= x"0000";
	cos_rom(1) <= x"7d89";
	sin_rom(1) <= x"18f9";
	cos_rom(2) <= x"7641";
	sin_rom(2) <= x"30fb";
	cos_rom(3) <= x"6a6d";
	sin_rom(3) <= x"471c";
	cos_rom(4) <= x"5a82";
	sin_rom(4) <= x"5a82";
	cos_rom(5) <= x"471c";
	sin_rom(5) <= x"6a6d";
	cos_rom(6) <= x"30fb";
	sin_rom(6) <= x"7641";
	cos_rom(7) <= x"18f9";
	sin_rom(7) <= x"7d89";
	
	cos_rom(8) <= x"0000";
	sin_rom(8) <= x"7fff";
	cos_rom(9) <= x"e707";
	sin_rom(9) <= x"7d89";
	cos_rom(10) <= x"cf05";
	sin_rom(10) <= x"7641";
	cos_rom(11) <= x"b8e4";
	sin_rom(11) <= x"6a6d";
	cos_rom(12) <= x"a57e";
	sin_rom(12) <= x"5a82";
	cos_rom(13) <= x"9593";
	sin_rom(13) <= x"471c";
	cos_rom(14) <= x"89bf";
	sin_rom(14) <= x"30fb";
	cos_rom(15) <= x"8277";
	sin_rom(15) <= x"18f9";
end rtl;