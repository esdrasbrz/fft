library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity butterfly_tb is
end butterfly_tb;

architecture tb of butterfly_tb is
    component butterfly is
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
    end component;

    signal clk: std_logic := '0';
    signal a_re_in: std_logic_vector(15 downto 0);
    signal a_im_in: std_logic_vector(15 downto 0);
    signal b_re_in: std_logic_vector(15 downto 0);
    signal b_im_in: std_logic_vector(15 downto 0);
    signal tw_re_in: std_logic_vector(15 downto 0);
    signal tw_im_in: std_logic_vector(15 downto 0);
    signal a_re_out: std_logic_vector(15 downto 0);
    signal a_im_out: std_logic_vector(15 downto 0);
    signal b_re_out: std_logic_vector(15 downto 0);
    signal b_im_out: std_logic_vector(15 downto 0);
begin
    -- clock 100ns
    clk <= not clk after 100 ns;


    process 
        variable a_re: integer;
        variable a_im: integer;
        variable b_re: integer;
        variable b_im: integer;
        variable tw_re: integer;
        variable tw_im: integer;
	variable l: line;
	file input_file: text is in "input.txt";
    begin
        wait until rising_edge(clk);

        readline(input_file, l);
        read(l, a_re);
        read(l, a_im);
        read(l, b_re);
        read(l, b_im);
        read(l, tw_re);
        read(l, tw_im);

        a_re_in <= std_logic_vector(to_signed(a_re,16));
        a_im_in <= std_logic_vector(to_signed(a_im,16));
        b_re_in <= std_logic_vector(to_signed(b_re,16));
        b_im_in <= std_logic_vector(to_signed(b_im,16));
        tw_re_in <= std_logic_vector(to_signed(tw_re,16));
        tw_im_in <= std_logic_vector(to_signed(tw_im,16));


        wait for 1000 ns;

        report "a_re: " & integer'image(to_integer(signed(a_re_out)));
        report "a_im: " & integer'image(to_integer(signed(a_im_out)));
        report "b_re: " & integer'image(to_integer(signed(b_re_out)));
        report "b_im: " & integer'image(to_integer(signed(b_im_out)));

        wait;
    end process;

    butterfly_portmap:
    butterfly port map (
        clk => clk,
        a_re_in => a_re_in,
        a_im_in => a_im_in,
        b_re_in => b_re_in,
        b_im_in => b_im_in,
        tw_re_in => tw_re_in,
        tw_im_in => tw_im_in,
        a_re_out => a_re_out,
        a_im_out => a_im_out,
        b_re_out => b_re_out,
        b_im_out => b_im_out
    );
end tb;
