

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "giu_axi_slave" "NUM_INSTANCES" "DEVICE_ID"  "C_GIU_AXI_SLAVE_BASEADDR" "C_GIU_AXI_SLAVE_HIGHADDR"
}
