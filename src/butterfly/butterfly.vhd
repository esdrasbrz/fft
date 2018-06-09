library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity butterfly is
    generic (
        DATA_WIDTH : natural := 16
    );
	
    port (
        clk	: in std_logic;
        a_re_in	: in std_logic_vector(DATA_WIDTH-1 downto 0);
        a_im_in	: in std_logic_vector(DATA_WIDTH-1 downto 0);
        b_re_in	: in std_logic_vector(DATA_WIDTH-1 downto 0);
        b_im_in	: in std_logic_vector(DATA_WIDTH-1 downto 0);
        tw_re_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        tw_im_in: in std_logic_vector(DATA_WIDTH-1 downto 0);
        a_re_out: out std_logic_vector(DATA_WIDTH-1 downto 0);
        a_im_out: out std_logic_vector(DATA_WIDTH-1 downto 0);
        b_re_out: out std_logic_vector(DATA_WIDTH-1 downto 0);
        b_im_out: out std_logic_vector(DATA_WIDTH-1 downto 0)
    );
end butterfly;

architecture rtl of butterfly is
begin
    process (clk, a_re_in, a_im_in, b_re_in, b_im_in, tw_re_in, tw_im_in)
        constant rounding: integer := 2**(DATA_WIDTH * 2 - 2);
        variable t1: signed(2*DATA_WIDTH - 1 downto 0);
        variable t2: signed(2*DATA_WIDTH - 1 downto 0);
        variable t3: signed(2*DATA_WIDTH - 1 downto 0);
        variable t4: signed(2*DATA_WIDTH - 1 downto 0);
        variable t5: signed(2*DATA_WIDTH - 1 downto 0);
        variable t6: signed(2*DATA_WIDTH - 1 downto 0);
        variable mul_re: signed(DATA_WIDTH - 1 downto 0);
        variable mul_im: signed(DATA_WIDTH - 1 downto 0);
    begin
        if (rising_edge(clk)) then
            -- calc b_in * tw
            t1 := signed(b_re_in) * signed(tw_re_in);
            t2 := signed(b_im_in) * signed(tw_im_in);
            t3 := signed(b_re_in) * signed(tw_im_in);
            t4 := signed(b_im_in) * signed(tw_re_in);
            
            t5 := t1 - t2;
            t6 := t3 + t4;
            
            mul_re := t5(2*DATA_WIDTH-2 downto DATA_WIDTH-1);
            mul_im := t6(2*DATA_WIDTH-2 downto DATA_WIDTH-1);
            
            -- calc a = a + mul
            a_re_out <= std_logic_vector(signed(a_re_in) + mul_re);
            a_im_out <= std_logic_vector(signed(a_im_in) + mul_im);
            
            -- calc b = a - mul
            b_re_out <= std_logic_vector(signed(a_re_in) - mul_re);
            b_im_out <= std_logic_vector(signed(a_im_in) - mul_im);
        end if;
    end process;
end rtl;
