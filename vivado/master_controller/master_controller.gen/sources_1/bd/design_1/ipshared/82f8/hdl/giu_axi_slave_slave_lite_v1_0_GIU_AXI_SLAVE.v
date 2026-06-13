
`timescale 1 ns / 1 ps

	module giu_axi_slave_slave_lite_v1_0_GIU_AXI_SLAVE #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Width of S_AXI data bus
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		// Width of S_AXI address bus
		parameter integer C_S_AXI_ADDR_WIDTH	= 14
	)
	(
		// Users to add ports here
        // --- Porturi adaugate manual catre buffere ---
        // vertex_buffer
        output reg [7:0]            vb_addr,
        output reg                  vb_cs,
        output reg                  vb_wr,
        output reg [95:0]           vb_dataIn,   // {z,y,x} Q16.16
        
        // edge_buffer  
        output reg [9:0]            eb_addr,
        output reg                  eb_cs,
        output reg                  eb_wr,
        output reg [19:0]           eb_dataIn,   // {idx_b, idx_a}
        
        // control catre master_controller
        output reg                  start_frame,
        output  [9:0]               vertex_count,
        output  [9:0]               edge_count,
        output  [9:0]               angle,
        output  [2:0]               rotation_type,
        output                      pause,
        input                       frame_done,
        input                       busy,
		// User ports ends
		// Do not modify the ports beyond this line

		// Global Clock Signal
		input wire  S_AXI_ACLK,
		// Global Reset Signal. This Signal is Active LOW
		input wire  S_AXI_ARESETN,
		// Write address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
		// Write channel Protection type. This signal indicates the
    		// privilege and security level of the transaction, and whether
    		// the transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_AWPROT,
		// Write address valid. This signal indicates that the master signaling
    		// valid write address and control information.
		input wire  S_AXI_AWVALID,
		// Write address ready. This signal indicates that the slave is ready
    		// to accept an address and associated control signals.
		output wire  S_AXI_AWREADY,
		// Write data (issued by master, acceped by Slave) 
		input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
		// Write strobes. This signal indicates which byte lanes hold
    		// valid data. There is one write strobe bit for each eight
    		// bits of the write data bus.    
		input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
		// Write valid. This signal indicates that valid write
    		// data and strobes are available.
		input wire  S_AXI_WVALID,
		// Write ready. This signal indicates that the slave
    		// can accept the write data.
		output wire  S_AXI_WREADY,
		// Write response. This signal indicates the status
    		// of the write transaction.
		output wire [1 : 0] S_AXI_BRESP,
		// Write response valid. This signal indicates that the channel
    		// is signaling a valid write response.
		output wire  S_AXI_BVALID,
		// Response ready. This signal indicates that the master
    		// can accept a write response.
		input wire  S_AXI_BREADY,
		// Read address (issued by master, acceped by Slave)
		input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
		// Protection type. This signal indicates the privilege
    		// and security level of the transaction, and whether the
    		// transaction is a data access or an instruction access.
		input wire [2 : 0] S_AXI_ARPROT,
		// Read address valid. This signal indicates that the channel
    		// is signaling valid read address and control information.
		input wire  S_AXI_ARVALID,
		// Read address ready. This signal indicates that the slave is
    		// ready to accept an address and associated control signals.
		output wire  S_AXI_ARREADY,
		// Read data (issued by slave)
		output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
		// Read response. This signal indicates the status of the
    		// read transfer.
		output wire [1 : 0] S_AXI_RRESP,
		// Read valid. This signal indicates that the channel is
    		// signaling the required read data.
		output wire  S_AXI_RVALID,
		// Read ready. This signal indicates that the master can
    		// accept the read data and response information.
		input wire  S_AXI_RREADY
	);

	// AXI4LITE signals
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awready;
	reg  	axi_wready;
	reg [1 : 0] 	axi_bresp;
	reg  	axi_bvalid;
	reg [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
	reg  	axi_arready;
	reg [1 : 0] 	axi_rresp;
	reg  	axi_rvalid;

	// Example-specific design signals
	// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
	// ADDR_LSB is used for addressing 32/64 bit registers/memories
	// ADDR_LSB = 2 for 32 bits (n downto 2)
	// ADDR_LSB = 3 for 64 bits (n downto 3)
	localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
	localparam integer OPT_MEM_ADDR_BITS = 2;
	
	// -----------------------------------------------
    // Harta de registre GIU AXI Slave
    // -----------------------------------------------
    // Adresa = BASEADDR + offset
    //
    // Offset  Alias           Directie  Descriere
    // 0x00    REG_CTRL        W         bit[0]=start_frame (puls 1 ciclu)
    // 0x04    REG_STATUS      R         bit[0]=frame_done, bit[1]=busy
    // 0x08    REG_COUNTS      W         bit[9:0]=vertex_count, bit[19:10]=edge_count
    // 0x0C    REG_ANGLE       W         bit[9:0]=unghi [0..719] jumatati de grade
    // 0x10    REG_ROTATION    W         bit[2:0]=rotation_type, bit[3]=pause
    // -----------------------------------------------
    // Adrese BRAM (in afara registrelor de control):
    // 0x1000 - 0x1FFF  vertex_buffer  (3 scrieri × 4 bytes per vertex)
    // 0x2000 - 0x2FFF  edge_buffer    (1 scriere × 4 bytes per edge)
    // -----------------------------------------------
    
    localparam REG_CTRL     = 3'h0;  // offset 0x00 -> slv_reg0
    localparam REG_STATUS   = 3'h1;  // offset 0x04 -> slv_reg1 (read-only)
    localparam REG_COUNTS   = 3'h2;  // offset 0x08 -> slv_reg2
    localparam REG_ANGLE    = 3'h3;  // offset 0x0C -> slv_reg3
    localparam REG_ROTATION = 3'h4;  // offset 0x10 -> slv_reg4
	
	
	
	//----------------------------------------------
	//-- Signals for user logic register space example
	//------------------------------------------------
	//-- Number of Slave Registers 8
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg0;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg1;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg2;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg3;
	reg [C_S_AXI_DATA_WIDTH-1:0]	slv_reg4;

	integer	 byte_index;

	// I/O Connections assignments

	assign S_AXI_AWREADY	= axi_awready;
	assign S_AXI_WREADY	= axi_wready;
	assign S_AXI_BRESP	= axi_bresp;
	assign S_AXI_BVALID	= axi_bvalid;
	assign S_AXI_ARREADY	= axi_arready;
	assign S_AXI_RRESP	= axi_rresp;
	assign S_AXI_RVALID	= axi_rvalid;
	 //state machine varibles 
	 reg [1:0] state_write;
	 reg [1:0] state_read;
	 //State machine local parameters
	 localparam Idle = 2'b00,
	            Raddr = 2'b10,
	            Rdata = 2'b11,
	            Waddr = 2'b10,
	            Wdata = 2'b11;
	            
	// Implement Write state machine
	// Outstanding write transactions are not supported by the slave i.e., master should assert bready to receive response on or before it starts sending the new transaction
	always @(posedge S_AXI_ACLK)                                 
	  begin                                 
	     if (S_AXI_ARESETN == 1'b0)                                 
	       begin                                 
	         axi_awready <= 0;                                 
	         axi_wready <= 0;                                 
	         axi_bvalid <= 0;                                 
	         axi_bresp <= 0;                                 
	         axi_awaddr <= 0;                                 
	         state_write <= Idle;                                 
	       end                                 
	     else                                  
	       begin                                 
	         case(state_write)                                 
	           Idle:                                      
	             begin                                 
	               if(S_AXI_ARESETN == 1'b1)                                  
	                 begin                                 
	                   axi_awready <= 1'b1;                                 
	                   axi_wready <= 1'b1;                                 
	                   state_write <= Waddr;                                 
	                 end                                 
	               else state_write <= state_write;                                 
	             end                                 
	           Waddr:        //At this state, slave is ready to receive address along with corresponding control signals and first data packet. Response valid is also handled at this state                                 
	             begin                                 
	               if (S_AXI_AWVALID && S_AXI_AWREADY)                                 
	                  begin                                 
	                    axi_awaddr <= S_AXI_AWADDR;                                 
	                    if(S_AXI_WVALID)                                  
	                      begin                                   
	                        axi_awready <= 1'b1;                                 
	                        state_write <= Waddr;                                 
	                        axi_bvalid <= 1'b1;                                 
	                      end                                 
	                    else                                  
	                      begin                                 
	                        axi_awready <= 1'b0;                                 
	                        state_write <= Wdata;                                 
	                        if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;                                 
	                      end                                 
	                  end                                 
	               else                                  
	                  begin                                 
	                    state_write <= state_write;                                 
	                    if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;                                 
	                   end                                 
	             end                                 
	          Wdata:        //At this state, slave is ready to receive the data packets until the number of transfers is equal to burst length                                 
	             begin                                 
	               if (S_AXI_WVALID)                                 
	                 begin                                 
	                   state_write <= Waddr;                                 
	                   axi_bvalid <= 1'b1;                                 
	                   axi_awready <= 1'b1;                                 
	                 end                                 
	                else                                  
	                 begin                                 
	                   state_write <= state_write;                                 
	                   if (S_AXI_BREADY && axi_bvalid) axi_bvalid <= 1'b0;                                 
	                 end                                              
	             end                                 
	          endcase                                 
	        end                                 
	      end                                 

	// Implement memory mapped register select and write logic generation
	// The write data is accepted and written to memory mapped registers when
	// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
	// select byte enables of slave registers while writing.
	// These registers are cleared when reset (active low) is applied.
	// Slave register write enable is asserted when valid address and data are available
	// and the slave is ready to accept the write address and write data.
	
    // Registre interne pentru stocarea temporara a coordonatelor X si Y	 
    reg [31:0] temp_x;
    reg [31:0] temp_y;
    
    // Conditie de scriere valida pe magistrala
    wire [C_S_AXI_ADDR_WIDTH-1 : 0] waddr = (S_AXI_AWVALID) ? S_AXI_AWADDR : axi_awaddr;
    wire w_en = S_AXI_WVALID && axi_wready;
    
    
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
            vb_cs <= 0;
            vb_wr <= 0;
            vb_addr <= 0; 
            vb_dataIn <= 0;
            
            eb_cs <= 0;
            eb_wr <= 0;
            eb_addr <= 0; 
            eb_dataIn <= 0;
            
            temp_x <= 0; 
            temp_y <= 0;
            
            start_frame   <= 0;
            // Nota: vertex_count, edge_count etc. sunt asignate prin combinational (assign) mai jos în codul tău, 
            // deci nu le resetăm/scriem aici în mod secvențial.
            
            slv_reg0 <= 0; 
            slv_reg2 <= 0; 
            slv_reg3 <= 0; 
            slv_reg4 <= 0;
        end 
      else begin
        // Comportament implicit: pulsuri de 1 singur ciclu de ceas pentru semnalele de control/BRAM
        vb_cs       <= 0;
        vb_wr       <= 0;
        eb_cs       <= 0;
        eb_wr       <= 0;
        start_frame <= 0;          
      
        // Masterul scrie ceva valid doar cand w_en este 1
        if (w_en)
          begin
            
            // 1. Logica pentru REGISTRE DE CONTROL (Adrese mici, ex: 0x00, 0x04, 0x08...)
            // Ne asiguram ca biții de sus ai adresei sunt 0 (nu scriem in zona BRAM-urilor 0x1000 sau 0x2000)
            if (waddr[13:12] == 2'b00) 
              begin
                case ( waddr[ADDR_LSB+OPT_MEM_ADDR_BITS : ADDR_LSB] )
                  REG_CTRL: begin
                        slv_reg0    <= S_AXI_WDATA;
                        start_frame <= S_AXI_WDATA[0];  // Generează un puls de un ciclu
                    end
                  REG_COUNTS:   slv_reg2 <= S_AXI_WDATA;
                  REG_ANGLE:    slv_reg3 <= S_AXI_WDATA;
                  REG_ROTATION: slv_reg4 <= S_AXI_WDATA; 
                  default : begin
                        slv_reg0 <= slv_reg0;
                        slv_reg2 <= slv_reg2;
                        slv_reg3 <= slv_reg3;
                        slv_reg4 <= slv_reg4;
                    end
                endcase
              end
              
            // 2. Logica pentru VERTEX BUFFER (Adrese: 0x1000 - 0x1FFF -> waddr[12] este 1)
            else if (waddr[13:12] == 2'b01)
              begin
                // Aici aplicăm protocolul cu 3 scrieri succesive (X, apoi Y, apoi Z)
                // Folosim biții de adresă [3:2] ca să ne dăm seama care din cele 3 cuvinte se scrie
                case (waddr[3:2])
                  2'b00: begin // Prima scriere: Coordonata X
                     temp_x <= S_AXI_WDATA;
                  end
                  2'b01: begin // A doua scriere: Coordonata Y
                     temp_y <= S_AXI_WDATA;
                  end
                  2'b10: begin // A treia scriere: Coordonata Z -> Acum le avem pe toate și scriem în BRAM!
                     vb_cs     <= 1'b1;
                     vb_wr     <= 1'b1;
                     vb_addr   <= waddr[11:4]; // Adresa unică a vertexului (waddr[11:4] ignoră offset-ul de cuvânt)
                     vb_dataIn <= { S_AXI_WDATA, temp_y, temp_x }; // Concatenare {Z, Y, X} -> 95:0
                  end
                endcase
              end
              
            // 3. Logica pentru EDGE BUFFER (Adrese: 0x2000 - 0x2FFF -> waddr[13] este 1)
            else if (waddr[13:12] == 2'b10)
              begin
                eb_cs     <= 1'b1;
                eb_wr     <= 1'b1;
                eb_addr   <= waddr[11:2]; // Adresa muchiei (mapare 1:1 direct din magistrală)
                eb_dataIn <= S_AXI_WDATA[19:0]; // Salvăm doar bit[19:0] ({idx_b, idx_a})
              end

          end
          
          // Actualizare registru de status (R-only pentru master) din intrările busy și frame_done
          slv_reg1 <= {30'b0, busy, frame_done};
      end
    end

	// Implement read state machine
	  always @(posedge S_AXI_ACLK)                                       
	    begin                                       
	      if (S_AXI_ARESETN == 1'b0)                                       
	        begin                                       
	         //asserting initial values to all 0's during reset                                       
	         axi_arready <= 1'b0;                                       
	         axi_rvalid <= 1'b0;                                       
	         axi_rresp <= 1'b0;                                       
	         state_read <= Idle;                                       
	        end                                       
	      else                                       
	        begin                                       
	          case(state_read)                                       
	            Idle:     //Initial state inidicating reset is done and ready to receive read/write transactions                                       
	              begin                                                
	                if (S_AXI_ARESETN == 1'b1)                                        
	                  begin                                       
	                    state_read <= Raddr;                                       
	                    axi_arready <= 1'b1;                                       
	                  end                                       
	                else state_read <= state_read;                                       
	              end                                       
	            Raddr:        //At this state, slave is ready to receive address along with corresponding control signals                                       
	              begin                                       
	                if (S_AXI_ARVALID && S_AXI_ARREADY)                                       
	                  begin                                       
	                    state_read <= Rdata;                                       
	                    axi_araddr <= S_AXI_ARADDR;                                       
	                    axi_rvalid <= 1'b1;                                       
	                    axi_arready <= 1'b0;                                       
	                  end                                       
	                else state_read <= state_read;                                       
	              end                                       
	            Rdata:        //At this state, slave is ready to send the data packets until the number of transfers is equal to burst length                                       
	              begin                                           
	                if (S_AXI_RVALID && S_AXI_RREADY)                                       
	                  begin                                       
	                    axi_rvalid <= 1'b0;                                       
	                    axi_arready <= 1'b1;                                       
	                    state_read <= Raddr;                                       
	                  end                                       
	                else state_read <= state_read;                                       
	              end                                       
	           endcase                                       
	          end                                       
	        end                                         
	// Implement memory mapped register select and read logic generation
    assign S_AXI_RDATA = (axi_araddr[13:12] == 2'b00) ? 
                            ((axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 3'h0) ? slv_reg0 :
                             (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 3'h1) ? slv_reg1 :
                             (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 3'h2) ? slv_reg2 :
                             (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 3'h3) ? slv_reg3 :
                             (axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] == 3'h4) ? slv_reg4 : 32'b0)
                         : 32'b0;	
    // Add user logic here

    // Semnale de iesire derivate din registre
    assign vertex_count  = slv_reg2[9:0];
    assign edge_count    = slv_reg2[19:10];
    assign angle         = slv_reg3[9:0];
    assign rotation_type = slv_reg4[2:0];
    assign pause         = slv_reg4[3];


	// User logic ends

	endmodule
