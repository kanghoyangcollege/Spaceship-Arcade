//-------------------------------------------------------------------------
//      fp.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//--------------------//-------------------------------------------------------------------------
//      fp.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module fp( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
             output logic [6:0]  HEX0, HEX1, HEX2, HEX3,HEX4, HEX5,HEX6, HEX7,
             // VGA Interface 
             output logic [7:0]  VGA_R,        //VGA Red
                                 VGA_G,        //VGA Green
                                 VGA_B,        //VGA Blue
             output logic        VGA_CLK,      //VGA Clock
                                 VGA_SYNC_N,   //VGA Sync signal
                                 VGA_BLANK_N,  //VGA Blank signal
                                 VGA_VS,       //VGA virtical sync signal
                                 VGA_HS,       //VGA horizontal sync signal
             // CY7C67200 Interface
             inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
             output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
             output logic        OTG_CS_N,     //CY7C67200 Chip Select
                                 OTG_RD_N,     //CY7C67200 Write
                                 OTG_WR_N,     //CY7C67200 Read
                                 OTG_RST_N,    //CY7C67200 Reset
             input               OTG_INT,      //CY7C67200 Interrupt
             // SDRAM Interface for Nios II Software
             output logic [12:0] DRAM_ADDR,    //SDRAM Address 13 Bits
             inout  wire  [31:0] DRAM_DQ,      //SDRAM Data 32 Bits
             output logic [1:0]  DRAM_BA,      //SDRAM Bank Address 2 Bits
             output logic [3:0]  DRAM_DQM,     //SDRAM Data Mast 4 Bits
             output logic        DRAM_RAS_N,   //SDRAM Row Address Strobe
                                 DRAM_CAS_N,   //SDRAM Column Address Strobe
                                 DRAM_CKE,     //SDRAM Clock Enable
                                 DRAM_WE_N,    //SDRAM Write Enable
                                 DRAM_CS_N,    //SDRAM Chip Select
                                 DRAM_CLK      //SDRAM Clock
                    );
    
    logic Reset_h, Clk, finish_game1, finish_game2, collision, start_game;
	 logic [11:0] is_bullet;
    logic [47:0] keycode;
	 //logic [15:0] keycode2;
	 logic [9:0] x_cor, y_cor, is_enemy;
	 logic [98:0] mem_addr;
	 logic [107:0] bullet_addr;
	 logic [2:0] bullet_number;
	 logic [2:0] bullet_number2;
	 logic [3:0] player1_cnt;
	 logic [3:0] player2_cnt;
	 logic [1:0] is_player;
	 logic [8:0] player2_addr;
	 logic [89:0] enemy_bullet_addr;
	 logic [9:0] is_enemy_bullet;
    logic [5:0] bullet_status1, bullet_status2;
	 logic		 start_enemy_bullets;
	 
	 
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     fp_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode[31:0]),
									  .keycode2_export(keycode[47:32]),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
    control_logic player1_control (.clk(Clk), .reset(Reset_h), .player(1'b0), .counter_sum(player1_cnt + player2_cnt), .counter(player1_cnt), .start_enemy_bullets(start_enemy_bullets), .collision(collision), .keycode(keycode), .bullet_num(bullet_number), .finish_game(finish_game1), .start_game(start_game), .bullet_status(bullet_status1));
	 control_logic player2_control (.clk(Clk), .reset(Reset_h), .player(1'b1), .counter_sum(player1_cnt + player2_cnt), .counter(player2_cnt), .start_enemy_bullets(), .collision(collision), .keycode(keycode), .bullet_num(bullet_number2), .finish_game(finish_game2), .start_game(), .bullet_status(bullet_status2));
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(.Clk(Clk), .Reset(Reset_h), .VGA_HS(VGA_HS), .VGA_VS(VGA_VS),
														 .VGA_CLK(VGA_CLK), .VGA_BLANK_N(VGA_BLANK_N), .VGA_SYNC_N(VGA_SYNC_N), .DrawX(x_cor), .DrawY(y_cor));
    
    // Which signal should be frame_clk?
    ball ball_instance(.Clk(Clk), .Reset(Reset_h), .frame_clk(VGA_VS), .DrawX(x_cor), .DrawY(y_cor), .is_ball(is_bullet), .is_player(is_player), .player2_addr(player2_addr), .is_enemy(is_enemy), .keycode(keycode), .start_enemy_bullets(start_enemy_bullets), .bullet_number({bullet_number2, bullet_number}), .mem_addr(mem_addr), .bullet_addr(bullet_addr), .is_enemy_bullet(is_enemy_bullet), .enemy_bullet_addr(enemy_bullet_addr));
    
    color_mapper color_instance(.clk(Clk), .keycode(keycode), .reset(Reset_h), .start_game(start_game), .finish_game(finish_game1), .player2_addr(player2_addr), .mem_addr(mem_addr), .bullet_status({bullet_status2, bullet_status1}), .bullet_addr(bullet_addr), .is_player(is_player), .is_enemy(is_enemy), .is_enemy_bullet(is_enemy_bullet), .is_ball(is_bullet), .enemy_bullet_addr(enemy_bullet_addr), .DrawX(x_cor), .DrawY(y_cor), .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B));
    
    // Display keycode on hex display
    HexDriver hex_inst_0 (keycode[3:0], HEX0);
    HexDriver hex_inst_1 (keycode[7:4], HEX1);
	 HexDriver hex_inst_2 (keycode[11:8], HEX2);
    HexDriver hex_inst_3 (keycode[15:12], HEX3);
	 HexDriver hex_inst_4 (keycode[35:32], HEX4);
    HexDriver hex_inst_5 (keycode[39:36], HEX5);
    HexDriver hex_inst_6 (keycode[43:40], HEX6);
    HexDriver hex_inst_7 (keycode[47:44], HEX7);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
