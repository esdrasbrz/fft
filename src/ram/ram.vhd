-- Quartus Prime VHDL Template
-- True Dual-Port RAM with single clock
--
-- Read-during-write on port A or B returns newly written data
-- 
-- Read-during-write between A and B returns either new or old data depending
-- on the order in which the simulator executes the process statements.
-- Quartus Prime will consider this read-during-write scenario as a 
-- don't care condition to optimize the performance of the RAM.  If you
-- need a read-during-write between ports to return the old data, you
-- must instantiate the altsyncram Megafunction directly.

library ieee;
use ieee.std_logic_1164.all;

entity ram is
    generic 
    (
        DATA_WIDTH : natural := 16;
        ADDR_WIDTH : natural := 5
    );

    port 
    (
        clk      : in std_logic;
        addr_a	 : in natural range 0 to 2**ADDR_WIDTH - 1;
        addr_b	 : in natural range 0 to 2**ADDR_WIDTH - 1;
        data_a_re: in std_logic_vector((DATA_WIDTH-1) downto 0);
        data_a_im: in std_logic_vector((DATA_WIDTH-1) downto 0);
        data_b_re: in std_logic_vector((DATA_WIDTH-1) downto 0);
        data_b_im: in std_logic_vector((DATA_WIDTH-1) downto 0);
        we_a	 : in std_logic := '1';
        we_b	 : in std_logic := '1';
        q_a_re	 : out std_logic_vector((DATA_WIDTH -1) downto 0);
        q_a_im	 : out std_logic_vector((DATA_WIDTH -1) downto 0);
        q_b_re	 : out std_logic_vector((DATA_WIDTH -1) downto 0);
        q_b_im	 : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );

end ram;

architecture rtl of ram is
    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Declare the RAM 
    shared variable ram_re : memory_t;
    shared variable ram_im : memory_t;

begin


    -- Port A
    process(clk)
    begin
    if(rising_edge(clk)) then 
        if(we_a = '1') then
            ram_re(addr_a) := data_a_re;
            ram_im(addr_a) := data_a_im;
        end if;
        q_a_re <= ram_re(addr_a);
        q_a_im <= ram_im(addr_a);
    end if;
    end process;

    -- Port B 
    process(clk)
    begin
    if(rising_edge(clk)) then 
        if(we_b = '1') then
            ram_re(addr_b) := data_b_re;
            ram_im(addr_b) := data_b_im;
        end if;
        q_b_re <= ram_re(addr_b);
        q_b_im <= ram_im(addr_b);
    end if;
    end process;

end rtl;
