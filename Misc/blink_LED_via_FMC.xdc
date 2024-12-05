# GPIO_0
#set_property PACKAGE_PIN F22 [get_ports {gpio_rtl_tri_io[0]}] 
set_property PACKAGE_PIN L21 [get_ports {gpio_rtl_tri_io[0]}];  # "FMC-LA06_P"

# GPIO_1
#set_property PACKAGE_PIN T22 [get_ports {gpio_rtl_0_tri_io[0]}] 
set_property PACKAGE_PIN L22 [get_ports {gpio_rtl_0_tri_io[0]}];  # "FMC-LA06_N"

# 3.3v
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_rtl_tri_io[*]}] 
set_property IOSTANDARD LVCMOS33 [get_ports {gpio_rtl_0_tri_io[*]}] 

set_property PULLDOWN true [get_ports {gpio_rtl_tri_io[*]}] 
set_property PULLDOWN true [get_ports {gpio_rtl_0_tri_io[*]}] 
