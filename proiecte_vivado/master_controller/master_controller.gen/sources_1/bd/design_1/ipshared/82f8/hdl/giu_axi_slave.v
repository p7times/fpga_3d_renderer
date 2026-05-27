
`timescale 1 ns / 1 ps

	module giu_axi_slave #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface GIU_AXI_SLAVE
		parameter integer C_GIU_AXI_SLAVE_DATA_WIDTH	= 32,
		parameter integer C_GIU_AXI_SLAVE_ADDR_WIDTH	= 14
	)
	(
		// Users to add ports here

        output [7:0]  vb_addr,
        output        vb_cs, vb_wr,
        output [95:0] vb_dataIn,
        output [9:0]  eb_addr,
        output        eb_cs, eb_wr,
        output [19:0] eb_dataIn,
        output        start_frame,
        output [9:0]  vertex_count, edge_count, angle,
        output [2:0]  rotation_type,
        output        pause,
        input         frame_done,
        input         busy,

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface GIU_AXI_SLAVE
		input wire  giu_axi_slave_aclk,
		input wire  giu_axi_slave_aresetn,
		input wire [C_GIU_AXI_SLAVE_ADDR_WIDTH-1 : 0] giu_axi_slave_awaddr,
		input wire [2 : 0] giu_axi_slave_awprot,
		input wire  giu_axi_slave_awvalid,
		output wire  giu_axi_slave_awready,
		input wire [C_GIU_AXI_SLAVE_DATA_WIDTH-1 : 0] giu_axi_slave_wdata,
		input wire [(C_GIU_AXI_SLAVE_DATA_WIDTH/8)-1 : 0] giu_axi_slave_wstrb,
		input wire  giu_axi_slave_wvalid,
		output wire  giu_axi_slave_wready,
		output wire [1 : 0] giu_axi_slave_bresp,
		output wire  giu_axi_slave_bvalid,
		input wire  giu_axi_slave_bready,
		input wire [C_GIU_AXI_SLAVE_ADDR_WIDTH-1 : 0] giu_axi_slave_araddr,
		input wire [2 : 0] giu_axi_slave_arprot,
		input wire  giu_axi_slave_arvalid,
		output wire  giu_axi_slave_arready,
		output wire [C_GIU_AXI_SLAVE_DATA_WIDTH-1 : 0] giu_axi_slave_rdata,
		output wire [1 : 0] giu_axi_slave_rresp,
		output wire  giu_axi_slave_rvalid,
		input wire  giu_axi_slave_rready
	);
// Instantiation of Axi Bus Interface GIU_AXI_SLAVE
	giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE # ( 
		.C_S_AXI_DATA_WIDTH(C_GIU_AXI_SLAVE_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_GIU_AXI_SLAVE_ADDR_WIDTH)
	) giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE_inst (
		.S_AXI_ACLK(giu_axi_slave_aclk),
		.S_AXI_ARESETN(giu_axi_slave_aresetn),
		.S_AXI_AWADDR(giu_axi_slave_awaddr),
		.S_AXI_AWPROT(giu_axi_slave_awprot),
		.S_AXI_AWVALID(giu_axi_slave_awvalid),
		.S_AXI_AWREADY(giu_axi_slave_awready),
		.S_AXI_WDATA(giu_axi_slave_wdata),
		.S_AXI_WSTRB(giu_axi_slave_wstrb),
		.S_AXI_WVALID(giu_axi_slave_wvalid),
		.S_AXI_WREADY(giu_axi_slave_wready),
		.S_AXI_BRESP(giu_axi_slave_bresp),
		.S_AXI_BVALID(giu_axi_slave_bvalid),
		.S_AXI_BREADY(giu_axi_slave_bready),
		.S_AXI_ARADDR(giu_axi_slave_araddr),
		.S_AXI_ARPROT(giu_axi_slave_arprot),
		.S_AXI_ARVALID(giu_axi_slave_arvalid),
		.S_AXI_ARREADY(giu_axi_slave_arready),
		.S_AXI_RDATA(giu_axi_slave_rdata),
		.S_AXI_RRESP(giu_axi_slave_rresp),
		.S_AXI_RVALID(giu_axi_slave_rvalid),
		.S_AXI_RREADY(giu_axi_slave_rready),
		
// --- Conectarea porturilor custom adaugate manual ---
        .vb_addr(vb_addr),
        .vb_cs(vb_cs),    
        .vb_wr(vb_wr),
        .vb_dataIn(vb_dataIn),
        
        .eb_addr(eb_addr),
        .eb_cs(eb_cs),
        .eb_wr(eb_wr),
        .eb_dataIn(eb_dataIn),
        
        .start_frame(start_frame),
        .vertex_count(vertex_count),
        .edge_count(edge_count),
        .angle(angle),
        .rotation_type(rotation_type),
        .pause(pause),
        .frame_done(frame_done),
        .busy(busy)
		
	);

	// Add user logic here

	// User logic ends

	endmodule
