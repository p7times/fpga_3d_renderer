`timescale 1 ns / 1 ps

    module giu_axi_slave #
    (
        // Users to add parameters here

        // User parameters ends
        // Do not modify the parameters beyond this line


        // Parameters of Axi Slave Bus Interface S00_AXI
        parameter integer C_S00_AXI_DATA_WIDTH    = 32,
        parameter integer C_S00_AXI_ADDR_WIDTH    = 11
    )
    (
        // Users to add ports here
        
        // --- Interfata Vertex Buffer ---
        output wire [31:0] vb_data_out,
        output wire [9:0]  vb_addr_out,
        output wire        vb_cs,
        output wire        vb_write_en,
        
        // --- Interfata Edge Buffer ---
        output wire [19:0] eb_data_out,
        output wire [9:0]  eb_addr_out,
        output wire        eb_cs,
        output wire        eb_write_en,
        
        // --- Registre de Control GIU ---
        output wire [9:0]  vertex_count,
        output wire [9:0]  edge_count,
        output wire [31:0] ctrl_reg,     // bit0=start, bit1=pause, etc.
        output wire [31:0] theta_reg,
        output wire [2:0]  rotation_reg,

        // User ports ends
        // Do not modify the ports beyond this line


        // Ports of Axi Slave Bus Interface S00_AXI
        input wire  s00_axi_aclk,
        input wire  s00_axi_aresetn,
        input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
        input wire [2 : 0] s00_axi_awprot,
        input wire  s00_axi_awvalid,
        output wire  s00_axi_awready,
        input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
        input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
        input wire  s00_axi_wvalid,
        output wire  s00_axi_wready,
        output wire [1 : 0] s00_axi_bresp,
        output wire  s00_axi_bvalid,
        input wire  s00_axi_bready,
        input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
        input wire [2 : 0] s00_axi_arprot,
        input wire  s00_axi_arvalid,
        output wire  s00_axi_arready,
        output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
        output wire [1 : 0] s00_axi_rresp,
        output wire  s00_axi_rvalid,
        input wire  s00_axi_rready
    );
// Instantiation of Axi Bus Interface S00_AXI
    giu_axi_slave_slave_lite_v1_0_S00_AXI # ( 
        .C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) giu_axi_slave_slave_lite_v1_0_S00_AXI_inst (
        .S_AXI_ACLK(s00_axi_aclk),
        .S_AXI_ARESETN(s00_axi_aresetn),
        .S_AXI_AWADDR(s00_axi_awaddr),
        .S_AXI_AWPROT(s00_axi_awprot),
        .S_AXI_AWVALID(s00_axi_awvalid),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WDATA(s00_axi_wdata),
        .S_AXI_WSTRB(s00_axi_wstrb),
        .S_AXI_WVALID(s00_axi_wvalid),
        .S_AXI_WREADY(s00_axi_wready),
        .S_AXI_BRESP(s00_axi_bresp),
        .S_AXI_BVALID(s00_axi_bvalid),
        .S_AXI_BREADY(s00_axi_bready),
        .S_AXI_ARADDR(s00_axi_araddr),
        .S_AXI_ARPROT(s00_axi_arprot),
        .S_AXI_ARVALID(s00_axi_arvalid),
        .S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_RDATA(s00_axi_rdata),
        .S_AXI_RRESP(s00_axi_rresp),
        .S_AXI_RVALID(s00_axi_rvalid),
        .S_AXI_RREADY(s00_axi_rready),
        
        // --- Conectarea noilor porturi catre logica interna ---
        .vb_data_out(vb_data_out),
        .vb_addr_out(vb_addr_out),
        .vb_cs(vb_cs),
        .vb_write_en(vb_write_en),
        
        .eb_data_out(eb_data_out),
        .eb_addr_out(eb_addr_out),
        .eb_cs(eb_cs),
        .eb_write_en(eb_write_en),
        
        .vertex_count(vertex_count),
        .edge_count(edge_count),
        .ctrl_reg(ctrl_reg),
        .theta_reg(theta_reg),
        .rotation_reg(rotation_reg)
    );

    // Add user logic here

    // User logic ends

    endmodule