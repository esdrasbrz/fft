library ieee;

use ieee.std_logic_1164.all;

package fft_pkg is
    type signal_arr is array(natural range <>) of std_logic_vector(15 downto 0);
end package;

library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fft_pkg.all;


entity fft is
    generic (
        DATA_WIDTH: natural := 16;
        BUFFER_SIZE: natural := 32;
        FFT_SIZE: natural := 5
    );

    port (
        clk: in std_logic;
        signal_re: in signal_arr(0 to BUFFER_SIZE-1);
        signal_im: in signal_arr(0 to BUFFER_SIZE-1);
        output_re: out signal_arr(0 to BUFFER_SIZE-1);
        output_im: out signal_arr(0 to BUFFER_SIZE-1)
    );
end fft;

architecture rtl of fft is
    type mem_blocks is array(0 to FFT_SIZE) of signal_arr(0 to BUFFER_SIZE-1);

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


    signal ja: std_logic_vector(4 downto 0);
    signal mem_re: mem_blocks;
    signal mem_im: mem_blocks;
begin
    mem_re(0) <= signal_re;
    mem_im(0) <= signal_im;

    fft_level:
    for i in 0 to FFT_SIZE-1 generate
        butterfly_index:
        for j in 0 to DATA_WIDTH-1 generate
            -- ja = shift_left(to_unsigned(j*2, FFT_SIZE), i);
            -- jb = shift_left(to_unsigned(j*2+1, FFT_SIZE), i);
            butterfly_portmap:
            butterfly port map (
                clk => clk,
                a_re_in => mem_re(i)(to_integer(shift_left(to_unsigned(j*2, FFT_SIZE), i))),
                a_im_in => mem_im(i)(to_integer(shift_left(to_unsigned(j*2, FFT_SIZE), i))),
                b_re_in => mem_re(i)(to_integer(shift_left(to_unsigned(j*2+1, FFT_SIZE), i))),
                b_im_in => mem_im(i)(to_integer(shift_left(to_unsigned(j*2+1, FFT_SIZE), i))),

                a_re_out => mem_re(i+1)(to_integer(shift_left(to_unsigned(j*2, FFT_SIZE), i))),
                a_im_out => mem_im(i+1)(to_integer(shift_left(to_unsigned(j*2, FFT_SIZE), i))),
                b_re_out => mem_re(i+1)(to_integer(shift_left(to_unsigned(j*2+1, FFT_SIZE), i))),
                b_im_out => mem_im(i+1)(to_integer(shift_left(to_unsigned(j*2+1, FFT_SIZE), i)))
            );
        end generate;
    end generate;
end rtl;
