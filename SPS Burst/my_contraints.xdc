# Connected to Addr pins of MRAM
set_property PACKAGE_PIN A21 [get_ports {addr_to_MRAM[0]}];  # "FMC-LA32_P"
set_property PACKAGE_PIN A22 [get_ports {addr_to_MRAM[1]}];  # "FMC-LA32_N"
set_property PACKAGE_PIN C15 [get_ports {addr_to_MRAM[2]}];  # "FMC-LA30_P"
set_property PACKAGE_PIN B15 [get_ports {addr_to_MRAM[3]}];  # "FMC-LA30_N"
set_property PACKAGE_PIN A16 [get_ports {addr_to_MRAM[4]}];  # "FMC-LA28_P"
set_property PACKAGE_PIN A17 [get_ports {addr_to_MRAM[5]}];  # "FMC-LA28_N"
set_property PACKAGE_PIN A18 [get_ports {addr_to_MRAM[6]}];  # "FMC-LA24_P"
set_property PACKAGE_PIN A19 [get_ports {addr_to_MRAM[7]}];  # "FMC-LA24_N"
set_property PACKAGE_PIN E19 [get_ports {addr_to_MRAM[8]}];  # "FMC-LA21_P"
set_property PACKAGE_PIN E20 [get_ports {addr_to_MRAM[9]}];  # "FMC-LA21_N"
set_property PACKAGE_PIN G15 [get_ports {addr_to_MRAM[10]}];  # "FMC-LA19_P"
set_property PACKAGE_PIN G16 [get_ports {addr_to_MRAM[11]}];  # "FMC-LA19_N"
set_property PACKAGE_PIN J16 [get_ports {addr_to_MRAM[12]}];  # "FMC-LA15_P"
set_property PACKAGE_PIN J17 [get_ports {addr_to_MRAM[13]}];  # "FMC-LA15_N"
set_property PACKAGE_PIN N17 [get_ports {addr_to_MRAM[14]}];  # "FMC-LA11_P"
set_property PACKAGE_PIN N18 [get_ports {addr_to_MRAM[15]}];  # "FMC-LA11_N"
set_property PACKAGE_PIN T16 [get_ports {addr_to_MRAM[16]}];  # "FMC-LA07_P"
set_property PACKAGE_PIN T17 [get_ports {addr_to_MRAM[17]}];  # "FMC-LA07_N"
set_property PACKAGE_PIN M21 [get_ports {addr_to_MRAM[18]}];  # "FMC-LA04_P"
set_property PACKAGE_PIN M22 [get_ports {addr_to_MRAM[19]}];  # "FMC-LA04_N"


# Connected to Data pins of MRAM
set_property PACKAGE_PIN C18 [get_ports {data_to_MRAM[0]}];  # "FMC-LA29_N"
set_property PACKAGE_PIN C17 [get_ports {data_to_MRAM[1]}];  # "FMC-LA29_P"
set_property PACKAGE_PIN C22 [get_ports {data_to_MRAM[2]}];  # "FMC-LA25_N"
set_property PACKAGE_PIN D22 [get_ports {data_to_MRAM[3]}];  # "FMC-LA25_P"
set_property PACKAGE_PIN F19 [get_ports {data_to_MRAM[4]}];  # "FMC-LA22_N"
set_property PACKAGE_PIN G19 [get_ports {data_to_MRAM[5]}];  # "FMC-LA22_P"
set_property PACKAGE_PIN G21 [get_ports {data_to_MRAM[6]}];  # "FMC-LA20_N"
set_property PACKAGE_PIN G20 [get_ports {data_to_MRAM[7]}];  # "FMC-LA20_P"
set_property PACKAGE_PIN K21 [get_ports {data_to_MRAM[8]}];  # "FMC-LA16_N"
set_property PACKAGE_PIN J20 [get_ports {data_to_MRAM[9]}];  # "FMC-LA16_P"
set_property PACKAGE_PIN P21 [get_ports {data_to_MRAM[10]}];  # "FMC-LA12_N"
set_property PACKAGE_PIN P20 [get_ports {data_to_MRAM[11]}];  # "FMC-LA12_P"
set_property PACKAGE_PIN J22 [get_ports {data_to_MRAM[12]}];  # "FMC-LA08_N"
set_property PACKAGE_PIN J21 [get_ports {data_to_MRAM[13]}];  # "FMC-LA08_P"
set_property PACKAGE_PIN P22 [get_ports {data_to_MRAM[14]}];  # "FMC-LA03_N"
set_property PACKAGE_PIN N22 [get_ports {data_to_MRAM[15]}];  # "FMC-LA03_P"

# Connected to control signals of MRAM
set_property PACKAGE_PIN P17 [get_ports {chip_en}];         # "FMC-LA02_P"
set_property PACKAGE_PIN B22 [get_ports {out_en}];          # "FMC-LA33_N"
set_property PACKAGE_PIN B21 [get_ports {write_en}];        # "FMC-LA33_P"
set_property PACKAGE_PIN B17 [get_ports {lower_byte_en}];   # "FMC-LA31_N"
set_property PACKAGE_PIN B16 [get_ports {upper_byte_en}];   # "FMC-LA31_P"


# SPS burst module IO pins
set_property PACKAGE_PIN J18 [get_ports {clk}];             # "FMC-LA05_P"
set_property PACKAGE_PIN K18 [get_ports {rst}];             # "FMC-LA05_N"
set_property PACKAGE_PIN L21 [get_ports {burst_en}];        # "FMC-LA06_P"
set_property PACKAGE_PIN L22 [get_ports {mode_sel}];        # "FMC-LA06_N"
set_property PACKAGE_PIN R20 [get_ports {burst_len_in}];    # "FMC-LA09_P"
set_property PACKAGE_PIN R21 [get_ports {addr_in}];         # "FMC-LA09_N"
set_property PACKAGE_PIN R19 [get_ports {data_in}];         # "FMC-LA10_P"
set_property PACKAGE_PIN T19 [get_ports {read_write_sel[0]}];   # "FMC-LA10_N"
set_property PACKAGE_PIN L17 [get_ports {read_write_sel[1]}];  # "FMC-LA13_P"
set_property PACKAGE_PIN M17 [get_ports {read_write_sel[2]}];  # "FMC-LA13_N"
set_property PACKAGE_PIN K19 [get_ports {PTS_ser_data_out}];  # "FMC-LA14_P"

# GPIO
set_property PACKAGE_PIN K20 [get_ports {gpio_rtl_0_tri_io[0]}];  # "FMC-LA14_N"
set_property PACKAGE_PIN B19 [get_ports {gpio_rtl_tri_io[0]}];  # "FMC-LA17_CC_P"
set_property PACKAGE_PIN B20 [get_ports {gpio_rtl_tri_io[1]}];  # "FMC-LA17_CC_N"
set_property PACKAGE_PIN D20 [get_ports {gpio_rtl_tri_io[2]}];  # "FMC-LA18_CC_P"
set_property PACKAGE_PIN C20 [get_ports {gpio_rtl_tri_io[3]}];  # "FMC-LA18_CC_N"
set_property PACKAGE_PIN E15 [get_ports {gpio_rtl_tri_io[4]}];  # "FMC-LA23_P"
set_property PACKAGE_PIN D15 [get_ports {gpio_rtl_tri_io[5]}];  # "FMC-LA23_N"
set_property PACKAGE_PIN F18 [get_ports {gpio_rtl_tri_io[6]}];  # "FMC-LA26_P"
set_property PACKAGE_PIN E18 [get_ports {gpio_rtl_tri_io[7]}];  # "FMC-LA26_N"
set_property PACKAGE_PIN E21 [get_ports {gpio_rtl_tri_io[8]}];  # "FMC-LA27_P"
set_property PACKAGE_PIN D21 [get_ports {gpio_rtl_tri_io[9]}];  # "FMC-LA27_N"

# Power Management
set_property IOSTANDARD LVCMOS33 [get_ports {addr_to_MRAM[*]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {data_to_MRAM[*]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {chip_en}] 
set_property IOSTANDARD LVCMOS33 [get_ports {out_en}] 
set_property IOSTANDARD LVCMOS33 [get_ports {write_en}] 
set_property IOSTANDARD LVCMOS33 [get_ports {lower_byte_en}] 
set_property IOSTANDARD LVCMOS33 [get_ports {upper_byte_en}] 
set_property IOSTANDARD LVCMOS33 [get_ports {clk}] 
set_property IOSTANDARD LVCMOS33 [get_ports {rst}] 
set_property IOSTANDARD LVCMOS33 [get_ports {burst_en}] 
set_property IOSTANDARD LVCMOS33 [get_ports {mode_sel}] 
set_property IOSTANDARD LVCMOS33 [get_ports {burst_len_in}] 
set_property IOSTANDARD LVCMOS33 [get_ports {addr_in}] 
set_property IOSTANDARD LVCMOS33 [get_ports {data_in}] 
set_property IOSTANDARD LVCMOS33 [get_ports {read_write_sel[*]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {PTS_ser_data_out}] 
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_rtl_tri_io[*]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_rtl_0_tri_io[*]}] 

#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 34]];
#set_property IOSTANDARD LVCMOS33 [get_ports -of_objects [get_iobanks 35]];
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 34 } ]
set_property IOSTANDARD LVCMOS33 [get_ports -filter { IOBANK == 35 } ]


set_property PULLDOWN true [get_ports {addr_to_MRAM[*]}] 
set_property PULLDOWN true [get_ports {data_to_MRAM[*]}] 
set_property PULLDOWN true [get_ports {chip_en}] 
set_property PULLDOWN true [get_ports {out_en}] 
set_property PULLDOWN true [get_ports {write_en}] 
set_property PULLDOWN true [get_ports {lower_byte_en}] 
set_property PULLDOWN true [get_ports {upper_byte_en}] 
set_property PULLDOWN true [get_ports {clk}] 
set_property PULLDOWN true [get_ports {rst}] 
set_property PULLDOWN true [get_ports {burst_en}] 
set_property PULLDOWN true [get_ports {mode_sel}] 
set_property PULLDOWN true [get_ports {burst_len_in}] 
set_property PULLDOWN true [get_ports {addr_in}] 
set_property PULLDOWN true [get_ports {data_in}] 
set_property PULLDOWN true [get_ports {read_write_sel[*]}] 
set_property PULLDOWN true [get_ports {PTS_ser_data_out}] 
set_property PULLDOWN true [get_ports {gpio_rtl_tri_io[*]}] 
set_property PULLDOWN true [get_ports {gpio_rtl_0_tri_io[*]}] 

#warning stuff
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets clk_IBUF]
