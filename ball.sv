//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
                             frame_clk,          // The clock indicating a new frame (~60Hz)
               input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [47:0]   keycode,
					input [5:0]	  bullet_number,
					input 				  start_enemy_bullets,
					output logic [1:0]  is_player,
					output logic [9:0]  is_enemy,
					output logic [9:0]  is_enemy_bullet,
               output logic [11:0]  is_ball,        // 
					output logic [98:0] mem_addr,		  // 8:0 - player address, 17:9 enemy address
					output logic [107:0] bullet_addr,	  // 8:0 - first bullet, 17:9 - second bullet 26:18 - third bullet address
					output logic [8:0]  player2_addr,
					output logic [89:0] enemy_bullet_addr
              );
    
    parameter [9:0] Ball_X_Center = 10'd320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd5;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd4;        // Ball size
	 
	 
	 parameter [9:0] enemy_X_Center = 10'd110;  // Center position on the X axis
    parameter [9:0] enemy_Y_Center = 10'd50;  // Center position on the Y axis
    parameter [9:0] enemy_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy_Y_Max = 10'd100;     // Bottommost point on the Y axis
    parameter [9:0] enemy_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] enemy_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy2_X_Center = 10'd250;  // Center position on the X axis
    parameter [9:0] enemy2_Y_Center = 10'd134;  // Center position on the Y axis
    parameter [9:0] enemy2_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy2_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy2_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy2_Y_Max = 10'd200;     // Bottommost point on the Y axis
    parameter [9:0] enemy2_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] enemy2_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy2_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy3_X_Center = 10'd117;  // Center position on the X axis
    parameter [9:0] enemy3_Y_Center = 10'd112;  // Center position on the Y axis
    parameter [9:0] enemy3_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy3_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy3_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy3_Y_Max = 10'd150;     // Bottommost point on the Y axis
    parameter [9:0] enemy3_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] enemy3_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy3_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy4_X_Center = 10'd410;  // Center position on the X axis
    parameter [9:0] enemy4_Y_Center = 10'd79;  // Center position on the Y axis
    parameter [9:0] enemy4_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy4_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy4_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy4_Y_Max = 10'd150;     // Bottommost point on the Y axis
    parameter [9:0] enemy4_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] enemy4_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy4_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy5_X_Center = 10'd517;  // Center position on the X axis
    parameter [9:0] enemy5_Y_Center = 10'd69;  // Center position on the Y axis
    parameter [9:0] enemy5_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy5_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy5_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy5_Y_Max = 10'd200;     // Bottommost point on the Y axis
    parameter [9:0] enemy5_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] enemy5_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy5_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy6_X_Center = 10'd260;  // Center position on the X axis
    parameter [9:0] enemy6_Y_Center = 10'd129;  // Center position on the Y axis
    parameter [9:0] enemy6_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy6_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy6_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy6_Y_Max = 10'd200;     // Bottommost point on the Y axis
    parameter [9:0] enemy6_X_Step = 10'd3;      // Step size on the X axis
    parameter [9:0] enemy6_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy6_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy7_X_Center = 10'd330;  // Center position on the X axis
    parameter [9:0] enemy7_Y_Center = 10'd133;  // Center position on the Y axis
    parameter [9:0] enemy7_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy7_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy7_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy7_Y_Max = 10'd200;     // Bottommost point on the Y axis
    parameter [9:0] enemy7_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] enemy7_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy7_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy8_X_Center = 10'd190;  // Center position on the X axis
    parameter [9:0] enemy8_Y_Center = 10'd54;  // Center position on the Y axis
    parameter [9:0] enemy8_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy8_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy8_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy8_Y_Max = 10'd100;     // Bottommost point on the Y axis
    parameter [9:0] enemy8_X_Step = 10'd3;      // Step size on the X axis
    parameter [9:0] enemy8_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy8_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy9_X_Center = 10'd443;  // Center position on the X axis
    parameter [9:0] enemy9_Y_Center = 10'd100;  // Center position on the Y axis
    parameter [9:0] enemy9_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy9_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy9_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy9_Y_Max = 10'd130;     // Bottommost point on the Y axis
    parameter [9:0] enemy9_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] enemy9_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy9_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy0_X_Center = 10'd123;  // Center position on the X axis
    parameter [9:0] enemy0_Y_Center = 10'd68;  // Center position on the Y axis
    parameter [9:0] enemy0_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] enemy0_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] enemy0_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy0_Y_Max = 10'd180;     // Bottommost point on the Y axis
    parameter [9:0] enemy0_X_Step = 10'd2;      // Step size on the X axis
    parameter [9:0] enemy0_Y_Step = 10'd0;      // Step size on the Y axis
    parameter [9:0] enemy0_Size = 10'd4;        // Ball size
	 
    parameter [9:0] bullet_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] bullet_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] bullet_Y_Step = 10'd5;      // Step size on the Y axis
    parameter [9:0] bullet_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] bullet2_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] bullet2_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] bullet2_Y_Step = 10'd5;      // Step size on the Y axis
    parameter [9:0] bullet2_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] bullet3_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] bullet3_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] bullet3_Y_Step = 10'd5;      // Step size on the Y axis
    parameter [9:0] bullet3_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] bullet4_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] bullet4_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] bullet4_Y_Step = 10'd5;      // Step size on the Y axis
    parameter [9:0] bullet4_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] bullet5_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] bullet5_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] bullet5_Y_Step = 10'd5;      // Step size on the Y axis
    parameter [9:0] bullet5_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] bullet6_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] bullet6_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] bullet6_Y_Step = 10'd5;      // Step size on the Y axis
    parameter [9:0] bullet6_Size = 10'd4;        // Ball size
	 
	 parameter [9:0] enemy_bullet_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] enemy_bullet_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] enemy_bullet_Y_Step = 10'd2;      // Step size on the Y axis
    parameter [9:0] enemy_bullet_Size = 10'd4;        // Ball size
    
    logic [9:0] Ball_X_Pos[2], Ball_X_Motion[2], Ball_Y_Pos[2], Ball_Y_Motion[2];
    logic [9:0] Ball_X_Pos_in[2], Ball_X_Motion_in[2], Ball_Y_Pos_in[2], Ball_Y_Motion_in[2];
	 
	 logic [9:0] enemy_X_Pos, enemy_X_Motion, enemy_Y_Pos, enemy_Y_Motion;
    logic [9:0] enemy_X_Pos_in, enemy_X_Motion_in, enemy_Y_Pos_in, enemy_Y_Motion_in;
	 
	 logic [9:0] enemy2_X_Pos, enemy2_X_Motion, enemy2_Y_Pos, enemy2_Y_Motion;
    logic [9:0] enemy2_X_Pos_in, enemy2_X_Motion_in, enemy2_Y_Pos_in, enemy2_Y_Motion_in;
	 
	 logic [9:0] enemy3_X_Pos, enemy3_X_Motion, enemy3_Y_Pos, enemy3_Y_Motion;
    logic [9:0] enemy3_X_Pos_in, enemy3_X_Motion_in, enemy3_Y_Pos_in, enemy3_Y_Motion_in;
	 
	 logic [9:0] enemy4_X_Pos, enemy4_X_Motion, enemy4_Y_Pos, enemy4_Y_Motion;
    logic [9:0] enemy4_X_Pos_in, enemy4_X_Motion_in, enemy4_Y_Pos_in, enemy4_Y_Motion_in;
	 
	 logic [9:0] enemy5_X_Pos, enemy5_X_Motion, enemy5_Y_Pos, enemy5_Y_Motion;
    logic [9:0] enemy5_X_Pos_in, enemy5_X_Motion_in, enemy5_Y_Pos_in, enemy5_Y_Motion_in;
	 
	 logic [9:0] enemy6_X_Pos, enemy6_X_Motion, enemy6_Y_Pos, enemy6_Y_Motion;
    logic [9:0] enemy6_X_Pos_in, enemy6_X_Motion_in, enemy6_Y_Pos_in, enemy6_Y_Motion_in;
	 
	 logic [9:0] enemy7_X_Pos, enemy7_X_Motion, enemy7_Y_Pos, enemy7_Y_Motion;
    logic [9:0] enemy7_X_Pos_in, enemy7_X_Motion_in, enemy7_Y_Pos_in, enemy7_Y_Motion_in;
	 
	 logic [9:0] enemy8_X_Pos, enemy8_X_Motion, enemy8_Y_Pos, enemy8_Y_Motion;
    logic [9:0] enemy8_X_Pos_in, enemy8_X_Motion_in, enemy8_Y_Pos_in, enemy8_Y_Motion_in;
	 
	 logic [9:0] enemy9_X_Pos, enemy9_X_Motion, enemy9_Y_Pos, enemy9_Y_Motion;
    logic [9:0] enemy9_X_Pos_in, enemy9_X_Motion_in, enemy9_Y_Pos_in, enemy9_Y_Motion_in;
	 
	 logic [9:0] enemy0_X_Pos, enemy0_X_Motion, enemy0_Y_Pos, enemy0_Y_Motion;
    logic [9:0] enemy0_X_Pos_in, enemy0_X_Motion_in, enemy0_Y_Pos_in, enemy0_Y_Motion_in;
	 
	 logic [9:0] bullet_X_Pos[2], bullet_X_Motion[2], bullet_Y_Pos[2], bullet_Y_Motion[2];
    logic [9:0] bullet_X_Pos_in[2], bullet_X_Motion_in[2], bullet_Y_Pos_in[2], bullet_Y_Motion_in[2];
	 
	 logic [9:0] bullet2_X_Pos[2], bullet2_X_Motion[2], bullet2_Y_Pos[2], bullet2_Y_Motion[2];
    logic [9:0] bullet2_X_Pos_in[2], bullet2_X_Motion_in[2], bullet2_Y_Pos_in[2], bullet2_Y_Motion_in[2];
    
	 logic [9:0] bullet3_X_Pos[2], bullet3_X_Motion[2], bullet3_Y_Pos[2], bullet3_Y_Motion[2];
    logic [9:0] bullet3_X_Pos_in[2], bullet3_X_Motion_in[2], bullet3_Y_Pos_in[2], bullet3_Y_Motion_in[2];	 
	 
	 logic [9:0] bullet4_X_Pos[2], bullet4_X_Motion[2], bullet4_Y_Pos[2], bullet4_Y_Motion[2];
    logic [9:0] bullet4_X_Pos_in[2], bullet4_X_Motion_in[2], bullet4_Y_Pos_in[2], bullet4_Y_Motion_in[2];	
	 
	 logic [9:0] bullet5_X_Pos[2], bullet5_X_Motion[2], bullet5_Y_Pos[2], bullet5_Y_Motion[2];
    logic [9:0] bullet5_X_Pos_in[2], bullet5_X_Motion_in[2], bullet5_Y_Pos_in[2], bullet5_Y_Motion_in[2];	
	 
	 logic [9:0] bullet6_X_Pos[2], bullet6_X_Motion[2], bullet6_Y_Pos[2], bullet6_Y_Motion[2];
    logic [9:0] bullet6_X_Pos_in[2], bullet6_X_Motion_in[2], bullet6_Y_Pos_in[2], bullet6_Y_Motion_in[2];
	
	 logic [9:0] enemy_bullet_X_Pos[10], enemy_bullet_X_Motion[10], enemy_bullet_Y_Pos[10], enemy_bullet_Y_Motion[10];
    logic [9:0] enemy_bullet_X_Pos_in[10], enemy_bullet_X_Motion_in[10], enemy_bullet_Y_Pos_in[10], enemy_bullet_Y_Motion_in[10];
	 
	 logic [1:0] [7:0] up, down, left , right, shoot;
	 
	 logic[1:0] flag = 2'b00;
	 logic[1:0] flag2 = 2'b00;
	 logic[1:0] flag3 = 2'b00;
	 logic[1:0] flag4 = 2'b00;
	 logic[1:0] flag5 = 2'b00;
	 logic[1:0] flag6 = 2'b00;
	 
	 logic [9:0] enemy_bullet_flags = 10'd0;
	 logic [9:0] enemy_bullet_boundary = 10'd0;
	 
	 assign up[0] = 8'd26;
	 assign down[0] = 8'd22;
	 assign left[0] = 8'd4;
	 assign right[0] = 8'd7;
	 assign shoot[0] = 8'h05;
	 assign up[1] = 8'h60;
	 assign down[1] = 8'h5d;
	 assign left[1] = 8'h5c;
	 assign right[1] = 8'h5e;
	 assign shoot[1] = 8'h34;
	 
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
				for(int i = 0; i < 2; i++)
				begin
            Ball_X_Pos[i] <= Ball_X_Center + (100*i);
            Ball_Y_Pos[i] <= Ball_Y_Center;
            Ball_X_Motion[i] <= 10'd0;
            Ball_Y_Motion[i] <= Ball_Y_Step;
				end
				
				enemy_X_Pos <= enemy_X_Center;
            enemy_Y_Pos <= enemy_Y_Center;
            enemy_X_Motion <= 10'd6;
            enemy_Y_Motion <= enemy_Y_Step;
				
				enemy2_X_Pos <= enemy2_X_Center;
            enemy2_Y_Pos <= enemy2_Y_Center;
            enemy2_X_Motion <= 10'd1;
            enemy2_Y_Motion <= enemy2_Y_Step;
				
				enemy3_X_Pos <= enemy3_X_Center;
            enemy3_Y_Pos <= enemy3_Y_Center;
            enemy3_X_Motion <= 10'd2;
            enemy3_Y_Motion <= enemy3_Y_Step;
				
				enemy4_X_Pos <= enemy4_X_Center;
            enemy4_Y_Pos <= enemy4_Y_Center;
            enemy4_X_Motion <= 10'd3;
            enemy4_Y_Motion <= enemy4_Y_Step;
				
				enemy5_X_Pos <= enemy5_X_Center;
            enemy5_Y_Pos <= enemy5_Y_Center;
            enemy5_X_Motion <= 10'd5;
            enemy5_Y_Motion <= enemy5_Y_Step;
				
				enemy6_X_Pos <= enemy6_X_Center;
            enemy6_Y_Pos <= enemy6_Y_Center;
            enemy6_X_Motion <= 10'd1;
            enemy6_Y_Motion <= enemy6_Y_Step;
				
				enemy7_X_Pos <= enemy7_X_Center;
            enemy7_Y_Pos <= enemy7_Y_Center;
            enemy7_X_Motion <= 10'd2;
            enemy7_Y_Motion <= enemy7_Y_Step;
				
				enemy8_X_Pos <= enemy8_X_Center;
            enemy8_Y_Pos <= enemy8_Y_Center;
            enemy8_X_Motion <= 10'd3;
            enemy8_Y_Motion <= enemy8_Y_Step;
				
				enemy9_X_Pos <= enemy9_X_Center;
            enemy9_Y_Pos <= enemy9_Y_Center;
            enemy9_X_Motion <= 10'd4;
            enemy9_Y_Motion <= enemy9_Y_Step;
				
				enemy0_X_Pos <= enemy0_X_Center;
            enemy0_Y_Pos <= enemy0_Y_Center;
            enemy0_X_Motion <= 10'd5;
            enemy0_Y_Motion <= enemy0_Y_Step;
				
				for(int i = 0; i < 2; i++)
				begin
				bullet_Y_Pos[i] <= 10'd500;
				bullet_Y_Motion[i] <= 10'd0;
				bullet_X_Pos[i] <= 10'd700;
				bullet_X_Motion[i] <= 10'd0;
				
				bullet2_Y_Pos[i] <= 10'd500;
				bullet2_Y_Motion[i] <= 10'd0;
				bullet2_X_Pos[i] <= 10'd700;
				bullet2_X_Motion[i] <= 10'd0;
				
				bullet3_Y_Pos[i] <= 10'd500;
				bullet3_Y_Motion[i] <= 10'd0;
				bullet3_X_Pos[i] <= 10'd700;
				bullet3_X_Motion[i] <= 10'd0;
				
				bullet4_Y_Pos[i] <= 10'd500;
				bullet4_Y_Motion[i] <= 10'd0;
				bullet4_X_Pos[i] <= 10'd700;
				bullet4_X_Motion[i] <= 10'd0;
				
				bullet5_Y_Pos[i] <= 10'd500;
				bullet5_Y_Motion[i] <= 10'd0;
				bullet5_X_Pos[i] <= 10'd700;
				bullet5_X_Motion[i] <= 10'd0;
				
				bullet6_Y_Pos[i] <= 10'd500;
				bullet6_Y_Motion[i] <= 10'd0;
				bullet6_X_Pos[i] <= 10'd700;
				bullet6_X_Motion[i] <= 10'd0;
				end
				
				for(int i = 0; i < 10; i++)
				begin
					enemy_bullet_Y_Pos[i] <= 10'd500;
					enemy_bullet_Y_Motion[i] <= 10'd0;
					enemy_bullet_X_Pos[i] <= 10'd700;
					enemy_bullet_X_Motion[i] <= 10'd0;
				end
        end
        else
        begin
				for(int i = 0; i < 2; i++)
				begin
            Ball_X_Pos[i] <= Ball_X_Pos_in[i];
            Ball_Y_Pos[i] <= Ball_Y_Pos_in[i];
            Ball_X_Motion[i] <= Ball_X_Motion_in[i];
            Ball_Y_Motion[i] <= Ball_Y_Motion_in[i];
				end
				
		      enemy_X_Pos <= enemy_X_Pos_in;
            enemy_Y_Pos <= enemy_Y_Pos_in;
            enemy_X_Motion <= enemy_X_Motion_in;
            enemy_Y_Motion <= enemy_Y_Motion_in;
				
				enemy2_X_Pos <= enemy2_X_Pos_in;
            enemy2_Y_Pos <= enemy2_Y_Pos_in;
            enemy2_X_Motion <= enemy2_X_Motion_in;
            enemy2_Y_Motion <= enemy2_Y_Motion_in;
				
				enemy3_X_Pos <= enemy3_X_Pos_in;
            enemy3_Y_Pos <= enemy3_Y_Pos_in;
            enemy3_X_Motion <= enemy3_X_Motion_in;
            enemy3_Y_Motion <= enemy3_Y_Motion_in;
				
				enemy4_X_Pos <= enemy4_X_Pos_in;
            enemy4_Y_Pos <= enemy4_Y_Pos_in;
            enemy4_X_Motion <= enemy4_X_Motion_in;
            enemy4_Y_Motion <= enemy4_Y_Motion_in;
				
				enemy5_X_Pos <= enemy5_X_Pos_in;
            enemy5_Y_Pos <= enemy5_Y_Pos_in;
            enemy5_X_Motion <= enemy5_X_Motion_in;
            enemy5_Y_Motion <= enemy5_Y_Motion_in;
				
				enemy6_X_Pos <= enemy6_X_Pos_in;
            enemy6_Y_Pos <= enemy6_Y_Pos_in;
            enemy6_X_Motion <= enemy6_X_Motion_in;
            enemy6_Y_Motion <= enemy6_Y_Motion_in;
				
				enemy7_X_Pos <= enemy7_X_Pos_in;
            enemy7_Y_Pos <= enemy7_Y_Pos_in;
            enemy7_X_Motion <= enemy7_X_Motion_in;
            enemy7_Y_Motion <= enemy7_Y_Motion_in;
				
				enemy8_X_Pos <= enemy8_X_Pos_in;
            enemy8_Y_Pos <= enemy8_Y_Pos_in;
            enemy8_X_Motion <= enemy8_X_Motion_in;
            enemy8_Y_Motion <= enemy8_Y_Motion_in;
				
				enemy9_X_Pos <= enemy9_X_Pos_in;
            enemy9_Y_Pos <= enemy9_Y_Pos_in;
            enemy9_X_Motion <= enemy9_X_Motion_in;
            enemy9_Y_Motion <= enemy9_Y_Motion_in;
				
				enemy0_X_Pos <= enemy0_X_Pos_in;
            enemy0_Y_Pos <= enemy0_Y_Pos_in;
            enemy0_X_Motion <= enemy0_X_Motion_in;
            enemy0_Y_Motion <= enemy0_Y_Motion_in;
				
				for(int i = 0; i < 2; i++)
				begin
				bullet_Y_Pos[i] <= bullet_Y_Pos_in[i];
				bullet_Y_Motion[i] <= bullet_Y_Motion_in[i];
				bullet_X_Pos[i] <= bullet_X_Pos_in[i];
				//bullet_X_Motion <= 10'd0;
				bullet2_Y_Pos[i] <= bullet2_Y_Pos_in[i];
				bullet2_Y_Motion[i] <= bullet2_Y_Motion_in[i];
				bullet2_X_Pos[i] <= bullet2_X_Pos_in[i];
				
				bullet3_Y_Pos[i] <= bullet3_Y_Pos_in[i];
				bullet3_Y_Motion[i] <= bullet3_Y_Motion_in[i];
				bullet3_X_Pos[i] <= bullet3_X_Pos_in[i];
				
				bullet4_Y_Pos[i] <= bullet4_Y_Pos_in[i];
				bullet4_Y_Motion[i] <= bullet4_Y_Motion_in[i];
				bullet4_X_Pos[i] <= bullet4_X_Pos_in[i];
				
				bullet5_Y_Pos[i] <= bullet5_Y_Pos_in[i];
				bullet5_Y_Motion[i] <= bullet5_Y_Motion_in[i];
				bullet5_X_Pos[i] <= bullet5_X_Pos_in[i];
				
			   bullet6_Y_Pos[i] <= bullet6_Y_Pos_in[i];
				bullet6_Y_Motion[i] <= bullet6_Y_Motion_in[i];
				bullet6_X_Pos[i] <= bullet6_X_Pos_in[i];
				end
				
				for(int i = 0; i < 10; i++)
				begin
					enemy_bullet_Y_Pos[i] <= enemy_bullet_Y_Pos_in[i];
					enemy_bullet_Y_Motion[i] <= enemy_bullet_Y_Motion_in[i];
					enemy_bullet_X_Pos[i] <= enemy_bullet_X_Pos_in[i];
				end
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
		  flag = 2'b00;
		  flag2 = 2'b00;
		  flag3 = 2'b00;
		  flag4 = 2'b00;
		  flag5 = 2'b00;
		  flag6 = 2'b00;
        // By default, keep motion and position unchanged
		  for(int i = 0; i < 2; i++)
		  begin
        Ball_X_Pos_in[i] = Ball_X_Pos[i];
        Ball_Y_Pos_in[i] = Ball_Y_Pos[i];
        Ball_X_Motion_in[i] = Ball_X_Motion[i];
        Ball_Y_Motion_in[i] = Ball_Y_Motion[i];
		  end
		  
		  enemy_X_Pos_in = enemy_X_Pos;
        enemy_Y_Pos_in = enemy_Y_Pos;
        enemy_X_Motion_in = enemy_X_Motion;
        enemy_Y_Motion_in = enemy_Y_Motion;
		  
		  enemy2_X_Pos_in = enemy2_X_Pos;
        enemy2_Y_Pos_in = enemy2_Y_Pos;
        enemy2_X_Motion_in = enemy2_X_Motion;
        enemy2_Y_Motion_in = enemy2_Y_Motion;
		  
		  enemy3_X_Pos_in = enemy3_X_Pos;
        enemy3_Y_Pos_in = enemy3_Y_Pos;
        enemy3_X_Motion_in = enemy3_X_Motion;
        enemy3_Y_Motion_in = enemy3_Y_Motion;
		  
		  enemy4_X_Pos_in = enemy4_X_Pos;
        enemy4_Y_Pos_in = enemy4_Y_Pos;
        enemy4_X_Motion_in = enemy4_X_Motion;
        enemy4_Y_Motion_in = enemy4_Y_Motion;
		  
		  enemy5_X_Pos_in = enemy5_X_Pos;
        enemy5_Y_Pos_in = enemy5_Y_Pos;
        enemy5_X_Motion_in = enemy5_X_Motion;
        enemy5_Y_Motion_in = enemy5_Y_Motion;
		  
		  enemy6_X_Pos_in = enemy6_X_Pos;
        enemy6_Y_Pos_in = enemy6_Y_Pos;
        enemy6_X_Motion_in = enemy6_X_Motion;
        enemy6_Y_Motion_in = enemy6_Y_Motion;
		  
		  enemy7_X_Pos_in = enemy7_X_Pos;
        enemy7_Y_Pos_in = enemy7_Y_Pos;
        enemy7_X_Motion_in = enemy7_X_Motion;
        enemy7_Y_Motion_in = enemy7_Y_Motion;
		  
		  enemy8_X_Pos_in = enemy8_X_Pos;
        enemy8_Y_Pos_in = enemy8_Y_Pos;
        enemy8_X_Motion_in = enemy8_X_Motion;
        enemy8_Y_Motion_in = enemy8_Y_Motion;
		  
		  enemy9_X_Pos_in = enemy9_X_Pos;
        enemy9_Y_Pos_in = enemy9_Y_Pos;
        enemy9_X_Motion_in = enemy9_X_Motion;
        enemy9_Y_Motion_in = enemy9_Y_Motion;
		  
		  enemy0_X_Pos_in = enemy0_X_Pos;
        enemy0_Y_Pos_in = enemy0_Y_Pos;
        enemy0_X_Motion_in = enemy0_X_Motion;
        enemy0_Y_Motion_in = enemy0_Y_Motion;
		  
		  for(int i = 0; i < 2; i++)
		  begin
		  bullet_Y_Pos_in[i] = bullet_Y_Pos[i];
		  bullet_Y_Motion_in[i] = bullet_Y_Motion[i];//bullet_Y_Motion;
		  bullet_X_Pos_in[i] = bullet_X_Pos[i];
		  
		  bullet2_Y_Pos_in[i] = bullet2_Y_Pos[i];
		  bullet2_Y_Motion_in[i] = bullet2_Y_Motion[i];//bullet_Y_Motion;
		  bullet2_X_Pos_in[i] = bullet2_X_Pos[i];
		  //bullet_X_Motion_in = 10'd0;
       
		  bullet3_Y_Pos_in[i] = bullet3_Y_Pos[i];
		  bullet3_Y_Motion_in[i] = bullet3_Y_Motion[i];//bullet_Y_Motion;
		  bullet3_X_Pos_in[i] = bullet3_X_Pos[i]; 
		  
		  bullet4_Y_Pos_in[i] = bullet4_Y_Pos[i];
		  bullet4_Y_Motion_in[i] = bullet4_Y_Motion[i];//bullet_Y_Motion;
		  bullet4_X_Pos_in[i] = bullet4_X_Pos[i];
		  
		  bullet5_Y_Pos_in[i] = bullet5_Y_Pos[i];
		  bullet5_Y_Motion_in[i] = bullet5_Y_Motion[i];//bullet_Y_Motion;
		  bullet5_X_Pos_in[i] = bullet5_X_Pos[i];
		  
		  bullet6_Y_Pos_in[i] = bullet6_Y_Pos[i];
		  bullet6_Y_Motion_in[i] = bullet6_Y_Motion[i];//bullet_Y_Motion;
		  bullet6_X_Pos_in[i] = bullet6_X_Pos[i];
        end
		  
		  for(int i = 0; i < 10; i++)
		  begin
				enemy_bullet_Y_Pos_in[i] = enemy_bullet_Y_Pos[i];
				enemy_bullet_Y_Motion_in[i] = enemy_bullet_Y_Motion[i];//bullet_Y_Motion;
				enemy_bullet_X_Pos_in[i] = enemy_bullet_X_Pos[i];
				enemy_bullet_flags[i] = 1'b0;
		  end
		  // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
			for(int i = 0 ; i <2; i++)
			begin
				// plyaer bound checking
            if( Ball_Y_Pos[i] + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                Ball_Y_Motion_in[i] = (~(10'd1) + 1'b1);  
            else if ( Ball_Y_Pos[i] <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
                Ball_Y_Motion_in[i] = 10'd1;
				else if ( Ball_X_Pos[i] + Ball_Size >= Ball_X_Max)
					Ball_X_Motion_in[i] = (~(Ball_X_Step) + 1'b1);
				else if ( Ball_X_Pos[i] <= Ball_X_Min + Ball_Size )
					Ball_X_Motion_in[i] = Ball_X_Step;
			end
				// enemy bound checking
            if( enemy_Y_Pos + enemy_Size >= enemy_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy_Y_Motion_in = (~(10'd2) + 1'b1);  // 2's complement.  
            else if ( enemy_Y_Pos <= enemy_Y_Min + enemy_Size )  // Ball is at the top edge, BOUNCE!
                enemy_Y_Motion_in = 10'd2;
				else if ( enemy_X_Pos + enemy_Size >= enemy_X_Max - 10'd10)
					enemy_X_Motion_in = (~(enemy_X_Step) + 1'b1);
				else if ( enemy_X_Pos <= enemy_X_Min + enemy_Size + 10'd10)
					enemy_X_Motion_in = enemy_X_Step;
					
				if( enemy2_Y_Pos + enemy2_Size >= enemy2_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy2_Y_Motion_in = (~(10'd3) + 1'b1);  // 2's complement.  
            else if ( enemy2_Y_Pos <= enemy2_Y_Min + enemy2_Size )  // Ball is at the top edge, BOUNCE!
                enemy2_Y_Motion_in = 10'd3;
				else if ( enemy2_X_Pos + enemy2_Size >= enemy2_X_Max - 10'd10)
					enemy2_X_Motion_in = (~(enemy2_X_Step) + 1'b1);
				else if ( enemy2_X_Pos <= enemy2_X_Min + enemy2_Size + 10'd10)
					enemy2_X_Motion_in = enemy2_X_Step;
					
				if( enemy3_Y_Pos + enemy3_Size >= enemy3_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy3_Y_Motion_in = (~(10'd1) + 1'b1);  // 2's complement.  
            else if ( enemy3_Y_Pos <= enemy3_Y_Min + enemy3_Size )  // Ball is at the top edge, BOUNCE!
                enemy3_Y_Motion_in = 10'd1;
				else if ( enemy3_X_Pos + enemy3_Size >= enemy3_X_Max - 10'd10)
					enemy3_X_Motion_in = (~(enemy3_X_Step) + 1'b1);
				else if ( enemy3_X_Pos <= enemy3_X_Min + enemy3_Size + 10'd10)
					enemy3_X_Motion_in = enemy3_X_Step;
					
				if( enemy4_Y_Pos + enemy4_Size >= enemy4_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy4_Y_Motion_in = (~(10'd3) + 1'b1);  // 2's complement.  
            else if ( enemy4_Y_Pos <= enemy4_Y_Min + enemy4_Size )  // Ball is at the top edge, BOUNCE!
                enemy4_Y_Motion_in = 10'd1;
				else if ( enemy4_X_Pos + enemy4_Size >= enemy4_X_Max - 10'd10)
					enemy4_X_Motion_in = (~(enemy4_X_Step) + 1'b1);
				else if ( enemy4_X_Pos <= enemy4_X_Min + enemy4_Size + 10'd10)
					enemy4_X_Motion_in = enemy4_X_Step;
					
				if( enemy5_Y_Pos + enemy5_Size >= enemy5_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy5_Y_Motion_in = (~(10'd2) + 1'b1);  // 2's complement.  
            else if ( enemy5_Y_Pos <= enemy5_Y_Min + enemy5_Size )  // Ball is at the top edge, BOUNCE!
                enemy5_Y_Motion_in = 10'd3;
				else if ( enemy5_X_Pos + enemy5_Size >= enemy5_X_Max - 10'd10)
					enemy5_X_Motion_in = (~(enemy5_X_Step) + 1'b1);
				else if ( enemy5_X_Pos <= enemy5_X_Min + enemy5_Size + 10'd10)
					enemy5_X_Motion_in = enemy5_X_Step;
					
				if( enemy6_Y_Pos + enemy6_Size >= enemy6_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy6_Y_Motion_in = (~(10'd1) + 1'b1);  // 2's complement.  
            else if ( enemy6_Y_Pos <= enemy6_Y_Min + enemy6_Size )  // Ball is at the top edge, BOUNCE!
                enemy6_Y_Motion_in = 10'd4;
				else if ( enemy6_X_Pos + enemy6_Size >= enemy6_X_Max - 10'd10)
					enemy6_X_Motion_in = (~(enemy6_X_Step) + 1'b1);
				else if ( enemy6_X_Pos <= enemy6_X_Min + enemy6_Size + 10'd10)
					enemy6_X_Motion_in = enemy6_X_Step;
					
				if( enemy7_Y_Pos + enemy7_Size >= enemy7_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy7_Y_Motion_in = (~(10'd3) + 1'b1);  // 2's complement.  
            else if ( enemy7_Y_Pos <= enemy7_Y_Min + enemy7_Size )  // Ball is at the top edge, BOUNCE!
                enemy7_Y_Motion_in = 10'd2;
				else if ( enemy7_X_Pos + enemy7_Size >= enemy7_X_Max - 10'd10)
					enemy7_X_Motion_in = (~(enemy7_X_Step) + 1'b1);
				else if ( enemy7_X_Pos <= enemy7_X_Min + enemy7_Size + 10'd10)
					enemy7_X_Motion_in = enemy7_X_Step;
					
				if( enemy8_Y_Pos + enemy8_Size >= enemy8_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy8_Y_Motion_in = (~(10'd1) + 1'b1);  // 2's complement.  
            else if ( enemy8_Y_Pos <= enemy8_Y_Min + enemy8_Size )  // Ball is at the top edge, BOUNCE!
                enemy8_Y_Motion_in = 10'd2;
				else if ( enemy8_X_Pos + enemy8_Size >= enemy8_X_Max - 10'd10)
					enemy8_X_Motion_in = (~(enemy8_X_Step) + 1'b1);
				else if ( enemy8_X_Pos <= enemy8_X_Min + enemy8_Size + 10'd10)
					enemy8_X_Motion_in = enemy8_X_Step;
					
				if( enemy9_Y_Pos + enemy9_Size >= enemy9_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy9_Y_Motion_in = (~(10'd1) + 1'b1);  // 2's complement.  
            else if ( enemy9_Y_Pos <= enemy9_Y_Min + enemy9_Size )  // Ball is at the top edge, BOUNCE!
                enemy9_Y_Motion_in = 10'd3;
				else if ( enemy9_X_Pos + enemy9_Size >= enemy9_X_Max - 10'd10)
					enemy9_X_Motion_in = (~(enemy9_X_Step) + 1'b1);
				else if ( enemy9_X_Pos <= enemy9_X_Min + enemy9_Size + 10'd10)
					enemy9_X_Motion_in = enemy9_X_Step;
					
				if( enemy0_Y_Pos + enemy0_Size >= enemy0_Y_Max )  // Ball is at the bottom edge, BOUNCE!
                enemy0_Y_Motion_in = (~(10'd1) + 1'b1);  // 2's complement.  
            else if ( enemy0_Y_Pos <= enemy0_Y_Min + enemy0_Size )  // Ball is at the top edge, BOUNCE!
                enemy0_Y_Motion_in = 10'd1;
				else if ( enemy0_X_Pos + enemy0_Size >= enemy0_X_Max - 10'd10)
					enemy0_X_Motion_in = (~(enemy0_X_Step) + 1'b1);
				else if ( enemy0_X_Pos <= enemy0_X_Min + enemy0_Size + 10'd10)
					enemy0_X_Motion_in = enemy0_X_Step;
			////////////////////////////////////////////////////FOR LOOP!!!!////////////////////////////////////////////////////////////////////
			   for (int i =0 ; i < 2; i++)
				begin
				// first bullet bound checking 
            if ( bullet_Y_Pos[i]  <= bullet_Y_Min + bullet_Size+ 10'd10  )  // If bullet reaches top screen, just keep going. 
				begin
                bullet_Y_Pos_in[i] = 10'd500;
					 bullet_X_Pos_in[i] = 10'd700;
					 bullet_Y_Motion_in[i] = 10'd0;
					 flag[i] = 1'b1;
				end
				
				// second bullet bound checking
				if ( bullet2_Y_Pos[i]  <= bullet2_Y_Min + bullet2_Size + 10'd10 )  // If bullet reaches top screen, just keep going. 
				begin
                bullet2_Y_Pos_in[i] = 10'd500;
					 bullet2_X_Pos_in[i] = 10'd700;
					 bullet2_Y_Motion_in[i] = 10'd0;
					 flag2[i] = 1'b1;
					 //bullet2_Y_Motion_in = 10'd0;
				end
				
				// third bullet bound checking
				if ( bullet3_Y_Pos[i]  <= bullet3_Y_Min + bullet3_Size+ 10'd10  )  // If bullet reaches top screen, just keep going. 
				begin
                bullet3_Y_Pos_in[i] = 10'd500;
					 bullet3_X_Pos_in[i] = 10'd700;
					 bullet3_Y_Motion_in[i] = 10'd0;
					 flag3[i] = 1'b1;
					 //bullet3_Y_Motion_in = 10'd0;
				end
				
				if ( bullet4_Y_Pos[i]  <= bullet4_Y_Min + bullet4_Size+ 10'd10  )  // If bullet reaches top screen, just keep going. 
				begin
                bullet4_Y_Pos_in[i] = 10'd500;
					 bullet4_X_Pos_in[i] = 10'd700;
					 bullet4_Y_Motion_in[i] = 10'd0;
					 flag4[i] = 1'b1;
					 //bullet3_Y_Motion_in = 10'd0;
				end
				
				if ( bullet5_Y_Pos[i]  <= bullet5_Y_Min + bullet5_Size+ 10'd10  )  // If bullet reaches top screen, just keep going. 
				begin
                bullet5_Y_Pos_in[i] = 10'd500;
					 bullet5_X_Pos_in[i] = 10'd700;
					 bullet5_Y_Motion_in[i] = 10'd0;
					 flag5[i] = 1'b1;
					 //bullet3_Y_Motion_in = 10'd0;
				end
				
				if ( bullet6_Y_Pos[i]  <= bullet6_Y_Min + bullet6_Size+ 10'd10  )  // If bullet reaches top screen, just keep going. 
				begin
                bullet6_Y_Pos_in[i] = 10'd500;
					 bullet6_X_Pos_in[i] = 10'd700;
					 bullet6_Y_Motion_in[i] = 10'd0;
					 flag6[i] = 1'b1;
					 //bullet3_Y_Motion_in = 10'd0;
				end
				
				
				
				// detect keypress
				//case(keycode)
						if((keycode[7:0] == up[i])|(keycode[15:8] ==up[i])|(keycode[23:16] == up[i])|(keycode[31:24] == up[i])|(keycode[39:32] == up[i])|(keycode[47:40] == up[i]))//8'd26:	// w
							begin
								//Ball_Y_Motion_in[i] = (~(10'd3) + 1'b1);
								//Ball_X_Motion_in[i] = 10'd0;
								
								if ( ~(Ball_Y_Pos[i] <= Ball_Y_Min + Ball_Size + 10'd10) )  // Ball is at the top edge, BOUNCE!
									Ball_Y_Pos_in[i] += (~(10'd5) + 1'b1);//Ball_Y_Motion_in[i] = 10'd1;
							end
						if((keycode[7:0] == left[i])|(keycode[15:8] == left[i])|(keycode[23:16] == left[i])|(keycode[31:24] == left[i])|(keycode[39:32] == left[i])|(keycode[47:40] == left[i]))//8'd4:	//a
							begin
								//Ball_X_Motion_in[i] = (~(Ball_X_Step) + 1'b1);
								//Ball_Y_Motion_in[i] = 10'd0;
								
								if ( ~(Ball_X_Pos[i] <= Ball_X_Min + Ball_Size + 10'd10) )
									Ball_X_Pos_in[i] += (~(Ball_X_Step) + 1'b1);//Ball_X_Motion_in[i] = Ball_X_Step;
							end
						if((keycode[7:0] == right[i])|(keycode[15:8] == right[i])|(keycode[23:16] == right[i])|(keycode[31:24] == right[i])|(keycode[39:32] == right[i])|(keycode[47:40] == right[i]))//8'd7:	//d
							begin
								//Ball_X_Motion_in[i] = Ball_X_Step;
								//Ball_Y_Motion_in[i] = 10'd0;
								if ( ~(Ball_X_Pos[i] + Ball_Size >= Ball_X_Max - 10'd10))
									Ball_X_Pos_in[i] += ((Ball_X_Step));
							end
						if((keycode[7:0] == down[i])|(keycode[15:8] == down[i])|(keycode[23:16] == down[i])|(keycode[31:24] == down[i])|(keycode[39:32] == down[i])|(keycode[47:40] == down[i]))//8'd22:	//s
							begin
								//Ball_Y_Motion_in[i] = 10'd3;
								//Ball_X_Motion_in[i] = 10'd0;
								if( ~(Ball_Y_Pos[i] + Ball_Size >= Ball_Y_Max - 10'd10) )  // Ball is at the bottom edge, BOUNCE!
									Ball_Y_Pos_in[i] += 10'd5;//(~(10'd1) + 1'b1);  // 2's complement.
							end
						if((keycode[7:0] == shoot[i])|(keycode[15:8] == shoot[i])|(keycode[23:16] ==shoot[i])|(keycode[31:24] == shoot[i])|(keycode[39:32] == shoot[i])|(keycode[47:40] == shoot[i]))//8'd44:	//space
							begin
								// first bullet instance
								if((bullet_number[i*3+0] == 1'b1) & (bullet_number[i*3+1] == 1'b0) & (bullet_number[i*3+2] == 1'b0) & ~flag[i])
								begin
								bullet_X_Pos_in[i] = Ball_X_Pos[i];
								bullet_Y_Motion_in[i] = (~(10'd10) + 1'b1);
								bullet_X_Motion_in[i] = 10'd0;
								bullet_Y_Pos_in[i] = Ball_Y_Pos[i];
								
									if ( bullet_Y_Pos[i]  <= bullet_Y_Min + bullet_Size+ 10'd10  )  // If bullet reaches top screen, just keep going. 
									begin
										bullet_Y_Pos_in[i] = 10'd500;
										bullet_X_Pos_in[i] = 10'd700;
										bullet_Y_Motion_in[i] = 10'd0;
									//flag = 1'b1;
									//bullet_Y_Motion_in = 10'd0;
									end
								
									flag[i] = 1'b1;
								end
								
								// second bullet
								else if((bullet_number[i*3+0] == 1'b0) & (bullet_number[i*3+1] == 1'b1) & (bullet_number[i*3+2] == 1'b0) & ~flag2[i])
								begin
								bullet2_X_Pos_in[i] = Ball_X_Pos[i];
								bullet2_Y_Motion_in[i] = (~(10'd10) + 1'b1);
								bullet2_X_Motion_in[i] = 10'd0;
								bullet2_Y_Pos_in[i] = Ball_Y_Pos[i];
									
								if ( bullet2_Y_Pos[i] <= bullet2_Y_Min + bullet2_Size+ 10'd10  )  // If bullet reaches top screen, just keep going. 
									begin
										bullet2_Y_Pos_in[i] = 10'd500;
										bullet2_X_Pos_in[i] = 10'd700;
										bullet2_Y_Motion_in[i] = 10'd0;
									//flag = 1'b1;
									//bullet2_Y_Motion_in = 10'd0;
									end
								
									flag2[i] = 1'b1;
								end
								
								// third bullet
								else if((bullet_number[i*3+0] == 1'b1) & (bullet_number[i*3+1] == 1'b1) & (bullet_number[i*3+2] == 1'b0) & ~flag3[i])
								begin
								bullet3_X_Pos_in[i] = Ball_X_Pos[i];
								bullet3_Y_Motion_in[i] = (~(10'd10) + 1'b1);
								bullet3_X_Motion_in[i] = 10'd0;
								bullet3_Y_Pos_in[i] = Ball_Y_Pos[i];
								
								if ( bullet3_Y_Pos[i]   <= bullet3_Y_Min + bullet3_Size + 10'd10 )  // If bullet reaches top screen, just keep going. 
									begin
										bullet3_Y_Pos_in[i] = 10'd500;
										bullet3_X_Pos_in[i] = 10'd700;
										bullet3_Y_Motion_in[i] = 10'd0;
									//flag = 1'b1;
									//bullet3_Y_Motion_in = 10'd0;
									end
								
									flag3[i] = 1'b1;
								end
								
								else if((bullet_number[i*3+0] == 1'b0) & (bullet_number[i*3+1] == 1'b0) & (bullet_number[i*3+2] == 1'b1) & ~flag4[i])
								begin
								bullet4_X_Pos_in[i] = Ball_X_Pos[i];
								bullet4_Y_Motion_in[i] = (~(10'd10) + 1'b1);
								bullet4_X_Motion_in[i] = 10'd0;
								bullet4_Y_Pos_in[i] = Ball_Y_Pos[i];
								
								if ( bullet4_Y_Pos[i]   <= bullet4_Y_Min + bullet4_Size + 10'd10 )  // If bullet reaches top screen, just keep going. 
									begin
										bullet4_Y_Pos_in[i] = 10'd500;
										bullet4_X_Pos_in[i] = 10'd700;
										bullet4_Y_Motion_in[i] = 10'd0;
									//flag = 1'b1;
									//bullet3_Y_Motion_in = 10'd0;
									end
								
									flag4[i] = 1'b1;
								end
								
								else if((bullet_number[i*3+0] == 1'b1) & (bullet_number[i*3+1] == 1'b0) & (bullet_number[i*3+2] == 1'b1) & ~flag5[i])
								begin
								bullet5_X_Pos_in[i] = Ball_X_Pos[i];
								bullet5_Y_Motion_in[i] = (~(10'd10) + 1'b1);
								bullet5_X_Motion_in[i] = 10'd0;
								bullet5_Y_Pos_in[i] = Ball_Y_Pos[i];
								
								if ( bullet5_Y_Pos[i]   <= bullet5_Y_Min + bullet5_Size + 10'd10 )  // If bullet reaches top screen, just keep going. 
									begin
										bullet5_Y_Pos_in[i] = 10'd500;
										bullet5_X_Pos_in[i] = 10'd700;
										bullet5_Y_Motion_in[i] = 10'd0;
									//flag = 1'b1;
									//bullet3_Y_Motion_in = 10'd0;
									end
									
									flag5[i] = 1'b1;
								end
								
								else if((bullet_number[i*3+0] == 1'b0) & (bullet_number[i*3+1] == 1'b1) & (bullet_number[i*3+2] == 1'b1) & ~flag6[i])
								begin
								bullet6_X_Pos_in[i] = Ball_X_Pos[i];
								bullet6_Y_Motion_in[i] = (~(10'd10) + 1'b1);
								bullet6_X_Motion_in[i] = 10'd0;
								bullet6_Y_Pos_in[i] = Ball_Y_Pos[i];
								
								if ( bullet6_Y_Pos[i]   <= bullet6_Y_Min + bullet6_Size + 10'd10 )  // If bullet reaches top screen, just keep going. 
									begin
										bullet6_Y_Pos_in[i] = 10'd500;
										bullet6_X_Pos_in[i] = 10'd700;
										bullet6_Y_Motion_in[i] = 10'd0;
									//flag = 1'b1;
									//bullet3_Y_Motion_in = 10'd0;
									end
								
									flag6[i] = 1'b1;
								end
							end
				//endcase
				//for(int i = 0; i < 10; i++)
				//begin
				if(start_enemy_bullets == 1'b1/*(keycode[7:0] == 8'd40)|(keycode[15:8] == 8'd40)|(keycode[23:16] == 8'd40)|(keycode[31:24] == 8'd40)*/)
						begin
								enemy_bullet_X_Pos_in[0] = enemy_X_Pos;
								enemy_bullet_Y_Motion_in[0] = 10'd1;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[0] = 10'd0;
								enemy_bullet_Y_Pos_in[0] = enemy_Y_Pos;//Ball_Y_Max;							//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[1] = enemy2_X_Pos;
								enemy_bullet_Y_Motion_in[1] = 10'd2;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[1] = 10'd0;
								enemy_bullet_Y_Pos_in[1] = enemy2_Y_Pos;						//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[2] = enemy3_X_Pos;
								enemy_bullet_Y_Motion_in[2] = 10'd3;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[2] = 10'd0;
								enemy_bullet_Y_Pos_in[2] = enemy3_Y_Pos;							//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[3] = enemy4_X_Pos;
								enemy_bullet_Y_Motion_in[3] = 10'd4;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[3] = 10'd0;
								enemy_bullet_Y_Pos_in[3] = enemy4_Y_Pos;						//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[4] = enemy5_X_Pos;
								enemy_bullet_Y_Motion_in[4] = 10'd5;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[4] = 10'd0;
								enemy_bullet_Y_Pos_in[4] = enemy5_Y_Pos;							//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[5] = enemy6_X_Pos;
								enemy_bullet_Y_Motion_in[5] = 10'd4;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[5] = 10'd0;
								enemy_bullet_Y_Pos_in[5] = enemy6_Y_Pos;					//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[6] = enemy7_X_Pos;
								enemy_bullet_Y_Motion_in[6] = 10'd3;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[6] = 10'd0;
								enemy_bullet_Y_Pos_in[6] = enemy7_Y_Pos;
								
								enemy_bullet_X_Pos_in[7] = enemy8_X_Pos;
								enemy_bullet_Y_Motion_in[7] = 10'd2;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[7] = 10'd0;
								enemy_bullet_Y_Pos_in[7] = enemy8_Y_Pos;						//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[8] = enemy9_X_Pos;
								enemy_bullet_Y_Motion_in[8] = 10'd1;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[8] = 10'd0;
								enemy_bullet_Y_Pos_in[8] = enemy9_Y_Pos;							//Shoot from corresponding enemy
								
								enemy_bullet_X_Pos_in[9] = enemy0_X_Pos;
								enemy_bullet_Y_Motion_in[9] = 10'd6;//(~(10'd5) + 1'b1);
								enemy_bullet_X_Motion_in[9] = 10'd0;
								enemy_bullet_Y_Pos_in[9] = enemy0_Y_Pos;							//Shoot from corresponding enemy
						
								enemy_bullet_flags = 10'b1111111111;
						end
				if( enemy_bullet_Y_Pos[0] + Ball_Size >= Ball_Y_Max ) 
								begin
									enemy_bullet_X_Pos_in[0] = enemy_X_Pos;
									enemy_bullet_Y_Motion_in[0] = 10'd1;//(~(10'd5) + 1'b1);
									enemy_bullet_X_Motion_in[0] = 10'd0;
									enemy_bullet_Y_Pos_in[0] = enemy_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[0] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[1] + Ball_Size >= Ball_Y_Max ) 
								begin
									enemy_bullet_X_Pos_in[1] = enemy2_X_Pos;
									enemy_bullet_Y_Motion_in[1] = 10'd2;
									enemy_bullet_X_Motion_in[1] = 10'd0;
									enemy_bullet_Y_Pos_in[1] = enemy2_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[1] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[2] + Ball_Size >= Ball_Y_Max ) 
								begin
									enemy_bullet_X_Pos_in[2] = enemy3_X_Pos;
									enemy_bullet_Y_Motion_in[2] = 10'd3;
									enemy_bullet_X_Motion_in[2] = 10'd0;
									enemy_bullet_Y_Pos_in[2] = enemy3_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[2] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[3] + Ball_Size >= Ball_Y_Max ) 
								begin
									enemy_bullet_X_Pos_in[3] = enemy4_X_Pos;
									enemy_bullet_Y_Motion_in[3] = 10'd4;
									enemy_bullet_X_Motion_in[3] = 10'd0;
									enemy_bullet_Y_Pos_in[3] = enemy4_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[3] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[4] + Ball_Size >= Ball_Y_Max) 
								begin
									enemy_bullet_X_Pos_in[4] = enemy5_X_Pos;
									enemy_bullet_Y_Motion_in[4] = 10'd5;
									enemy_bullet_X_Motion_in[4] = 10'd0;
									enemy_bullet_Y_Pos_in[4] = enemy5_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[4] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[5] + Ball_Size >= Ball_Y_Max) 
								begin
									enemy_bullet_X_Pos_in[5] = enemy6_X_Pos;
									enemy_bullet_Y_Motion_in[5] = 10'd4;
									enemy_bullet_X_Motion_in[5] = 10'd0;
									enemy_bullet_Y_Pos_in[5] = enemy6_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[5] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[6] + Ball_Size >= Ball_Y_Max ) 
								begin
									enemy_bullet_X_Pos_in[6] = enemy7_X_Pos;
									enemy_bullet_Y_Motion_in[6] = 10'd3;
									enemy_bullet_X_Motion_in[6] = 10'd0;
									enemy_bullet_Y_Pos_in[6] = enemy7_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[6] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[7] + Ball_Size >= Ball_Y_Max ) 
								begin
									enemy_bullet_X_Pos_in[7] = enemy8_X_Pos;
									enemy_bullet_Y_Motion_in[7] = 10'd2;
									enemy_bullet_X_Motion_in[7] = 10'd0;
									enemy_bullet_flags[7] = 1'b1;
									enemy_bullet_Y_Pos_in[7] = enemy8_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
								end
								
				if( enemy_bullet_Y_Pos[8] + Ball_Size >= Ball_Y_Max ) 
								begin
									enemy_bullet_X_Pos_in[8] = enemy9_X_Pos;
									enemy_bullet_Y_Motion_in[8] = 10'd1;
									enemy_bullet_X_Motion_in[8] = 10'd0;
									enemy_bullet_Y_Pos_in[8] = enemy9_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[8] = 1'b1;
								end
								
				if( enemy_bullet_Y_Pos[9] + Ball_Size >= Ball_Y_Max) 
								begin
									enemy_bullet_X_Pos_in[9] = enemy0_X_Pos;
									enemy_bullet_Y_Motion_in[9] = 10'd6;
									enemy_bullet_X_Motion_in[9] = 10'd0;
									enemy_bullet_Y_Pos_in[9] = enemy0_Y_Pos;						//Once reaching the bottom, restart from the corresponding enemy
									enemy_bullet_flags[9] = 1'b1;
								end
            // Update the ball's position with its motion
            //Ball_X_Pos_in[i] = Ball_X_Pos[i]; //+ Ball_X_Motion[i];
            //Ball_Y_Pos_in[i] = Ball_Y_Pos[i]; //+ Ball_Y_Motion[i];
				
				enemy_X_Pos_in = enemy_X_Pos + enemy_X_Motion;
            enemy_Y_Pos_in = enemy_Y_Pos + enemy_Y_Motion;
				
				enemy2_X_Pos_in = enemy2_X_Pos + enemy2_X_Motion;
            enemy2_Y_Pos_in = enemy2_Y_Pos + enemy2_Y_Motion;
				
				enemy3_X_Pos_in = enemy3_X_Pos + enemy3_X_Motion;
            enemy3_Y_Pos_in = enemy3_Y_Pos + enemy3_Y_Motion;
				
				enemy4_X_Pos_in = enemy4_X_Pos + enemy4_X_Motion;
            enemy4_Y_Pos_in = enemy4_Y_Pos + enemy4_Y_Motion;
				
				enemy5_X_Pos_in = enemy5_X_Pos + enemy5_X_Motion;
            enemy5_Y_Pos_in = enemy5_Y_Pos + enemy5_Y_Motion;
				
				enemy6_X_Pos_in = enemy6_X_Pos + enemy6_X_Motion;
            enemy6_Y_Pos_in = enemy6_Y_Pos + enemy6_Y_Motion;
				
				enemy7_X_Pos_in = enemy7_X_Pos + enemy7_X_Motion;
            enemy7_Y_Pos_in = enemy7_Y_Pos + enemy7_Y_Motion;
				
				enemy8_X_Pos_in = enemy8_X_Pos + enemy8_X_Motion;
            enemy8_Y_Pos_in = enemy8_Y_Pos + enemy8_Y_Motion;
				
				enemy9_X_Pos_in = enemy9_X_Pos + enemy9_X_Motion;
            enemy9_Y_Pos_in = enemy9_Y_Pos + enemy9_Y_Motion;
				
				enemy0_X_Pos_in = enemy0_X_Pos + enemy0_X_Motion;
            enemy0_Y_Pos_in = enemy0_Y_Pos + enemy0_Y_Motion;
				
				if(~flag[i])
				begin
				bullet_X_Pos_in[i] = bullet_X_Pos[i] + bullet_X_Motion[i];
            bullet_Y_Pos_in[i] = bullet_Y_Pos[i] + bullet_Y_Motion[i];
				flag[i] = 1'b0;
				end
				
				if(~flag2[i])
				begin
				bullet2_X_Pos_in[i] = bullet2_X_Pos[i] + bullet2_X_Motion[i];
            bullet2_Y_Pos_in[i] = bullet2_Y_Pos[i] + bullet2_Y_Motion[i];
				flag2[i] = 1'b0;
				end
				
				if(~flag3[i])
				begin
				bullet3_X_Pos_in[i] = bullet3_X_Pos[i] + bullet3_X_Motion[i];
            bullet3_Y_Pos_in[i] = bullet3_Y_Pos[i] + bullet3_Y_Motion[i];
				flag3[i] = 1'b0;
				end	
				
				if(~flag4[i])
				begin
				bullet4_X_Pos_in[i] = bullet4_X_Pos[i] + bullet4_X_Motion[i];
            bullet4_Y_Pos_in[i] = bullet4_Y_Pos[i] + bullet4_Y_Motion[i];
				flag4[i] = 1'b0;
				end	
				
				if(~flag5[i])
				begin
				bullet5_X_Pos_in[i] = bullet5_X_Pos[i] + bullet5_X_Motion[i];
            bullet5_Y_Pos_in[i] = bullet5_Y_Pos[i] + bullet5_Y_Motion[i];
				flag5[i] = 1'b0;
				end	
				
				if(~flag6[i])
				begin
				bullet6_X_Pos_in[i] = bullet6_X_Pos[i] + bullet6_X_Motion[i];
            bullet6_Y_Pos_in[i] = bullet6_Y_Pos[i] + bullet6_Y_Motion[i];
				flag6[i] = 1'b0;
				end
			
				for(int i = 0; i < 10; i++)
				begin
					if(~enemy_bullet_flags[i])
					begin
						enemy_bullet_X_Pos_in[i] = enemy_bullet_X_Pos[i] + enemy_bullet_X_Motion[i];
						enemy_bullet_Y_Pos_in[i] = enemy_bullet_Y_Pos[i] + enemy_bullet_Y_Motion[i];
					end
					enemy_bullet_flags[i] = 1'b0;
				end
        end
      end
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX[2], DistY[2], Size;
	 int enemy_X, enemy_Y;
	 int enemy2_X, enemy2_Y;
	 int enemy3_X, enemy3_Y;
	 int enemy4_X, enemy4_Y;
	 int enemy5_X, enemy5_Y;
	 int enemy6_X, enemy6_Y;
	 int enemy7_X, enemy7_Y;
	 int enemy8_X, enemy8_Y;
	 int enemy9_X, enemy9_Y;
	 int enemy0_X, enemy0_Y;
	 int enemy_bullet_X[10], enemy_bullet_Y[10];
	 int bullet_X[2], bullet_Y[2], bullet2_X[2], bullet2_Y[2], bullet3_X[2], bullet3_Y[2];
	 int bullet4_X[2], bullet4_Y[2], bullet5_X[2], bullet5_Y[2], bullet6_X[2], bullet6_Y[2];
	 always_comb
	 begin
	 for(int i = 0; i < 2; i++)
	 begin
	 bullet_X[i] = DrawX - bullet_X_Pos[i];
	 bullet_Y[i] = DrawY - bullet_Y_Pos[i];
	 
	 bullet2_X[i] = DrawX - bullet2_X_Pos[i];
	 bullet2_Y[i] = DrawY - bullet2_Y_Pos[i];
	 
	 bullet3_X[i] = DrawX - bullet3_X_Pos[i];
	 bullet3_Y[i] = DrawY - bullet3_Y_Pos[i];
	 
	 bullet4_X[i] = DrawX - bullet4_X_Pos[i];
	 bullet4_Y[i] = DrawY - bullet4_Y_Pos[i];
	 
	 bullet5_X[i] = DrawX - bullet5_X_Pos[i];
	 bullet5_Y[i] = DrawY - bullet5_Y_Pos[i];
	 
	 bullet6_X[i] = DrawX - bullet6_X_Pos[i];
	 bullet6_Y[i] = DrawY - bullet6_Y_Pos[i];
	 
	 DistX[i] = DrawX - Ball_X_Pos[i];
    DistY[i] = DrawY - Ball_Y_Pos[i];
	 end
	 
	 for(int i = 0; i < 10; i++)
	 begin
			enemy_bullet_X[i] = DrawX - enemy_bullet_X_Pos[i];
			enemy_bullet_Y[i] = DrawY - enemy_bullet_Y_Pos[i];
	 end
	 end
	 assign enemy_X = DrawX - enemy_X_Pos;
	 assign enemy_Y = DrawY - enemy_Y_Pos;
	 

	 
	 assign enemy2_X = DrawX - enemy2_X_Pos;
	 assign enemy2_Y = DrawY - enemy2_Y_Pos;
	 
	 assign enemy3_X = DrawX - enemy3_X_Pos;
	 assign enemy3_Y = DrawY - enemy3_Y_Pos;
	 
	 assign enemy4_X = DrawX - enemy4_X_Pos;
	 assign enemy4_Y = DrawY - enemy4_Y_Pos;
	 
	 assign enemy5_X = DrawX - enemy5_X_Pos;
	 assign enemy5_Y = DrawY - enemy5_Y_Pos;
	 
	 assign enemy6_X = DrawX - enemy6_X_Pos;
	 assign enemy6_Y = DrawY - enemy6_Y_Pos;
	 
	 assign enemy7_X = DrawX - enemy7_X_Pos;
	 assign enemy7_Y = DrawY - enemy7_Y_Pos;
	 
	 assign enemy8_X = DrawX - enemy8_X_Pos;
	 assign enemy8_Y = DrawY - enemy8_Y_Pos;
	 
	 assign enemy9_X = DrawX - enemy9_X_Pos;
	 assign enemy9_Y = DrawY - enemy9_Y_Pos;
	 
	 assign enemy0_X = DrawX - enemy0_X_Pos;
	 assign enemy0_Y = DrawY - enemy0_Y_Pos;
	 
    assign Size = Ball_Size;
	 
	 
    always_comb begin
			// player
        if ( (DistX[0] >= -10 & DistX[0] <= 10) & (DistY[0] >=-12 & DistY[0] <=11) /*( DistX*DistX + DistY*DistY) <= (Size*Size)*/ )
			begin
            is_player[0] = 1'b1;
				mem_addr[8:0] = (DrawY - Ball_Y_Pos[0] + 12)*20 + (DrawX - Ball_X_Pos[0]) + 10;
			end
        else
		   begin
            is_player[0] = 1'b0;
				mem_addr[8:0] = 9'd0;
			end
			
			if ( (DistX[1] >= -10 & DistX[1] <= 10) & (DistY[1] >=-12 & DistY[1] <=11) /*( DistX*DistX + DistY*DistY) <= (Size*Size)*/ )
			begin
            is_player[1] = 1'b1;
				player2_addr[8:0] = (DrawY - Ball_Y_Pos[1] + 12)*20 + (DrawX - Ball_X_Pos[1]) + 10;
			end
        else
		   begin
            is_player[1] = 1'b0;
				player2_addr[8:0] = 9'd0;
			end
			// enemy
			if ( (enemy_X >= -10 & enemy_X <= 10) & (enemy_Y >=-12 & enemy_Y <=12) )
			begin
				is_enemy[0] = 1'b1;
				mem_addr[17:9] = (DrawY - enemy_Y_Pos + 12)*20 + (DrawX - enemy_X_Pos) + 10;
			end
			else
			begin
				is_enemy[0] = 1'b0;
				mem_addr[17:9] = 9'd0;
			end
			
			if ( (enemy2_X >= -10 & enemy2_X <= 10) & (enemy2_Y >=-12 & enemy2_Y <=12) )
			begin
				is_enemy[1] = 1'b1;
				mem_addr[26:18] = (DrawY - enemy2_Y_Pos + 12)*20 + (DrawX - enemy2_X_Pos) + 10;
			end
			else
			begin
				is_enemy[1] = 1'b0;
				mem_addr[26:18] = 9'd0;
			end
			
			if ( (enemy3_X >= -10 & enemy3_X <= 10) & (enemy3_Y >=-12 & enemy3_Y <=12) )
			begin
				is_enemy[2] = 1'b1;
				mem_addr[35:27] = (DrawY - enemy3_Y_Pos + 12)*20 + (DrawX - enemy3_X_Pos) + 10;
			end
			else
			begin
				is_enemy[2] = 1'b0;
				mem_addr[35:27] = 9'd0;
			end
			
			if ( (enemy4_X >= -10 & enemy4_X <= 10) & (enemy4_Y >=-12 & enemy4_Y <=12) )
			begin
				is_enemy[3] = 1'b1;
				mem_addr[44:36] = (DrawY - enemy4_Y_Pos + 12)*20 + (DrawX - enemy4_X_Pos) + 10;
			end
			else
			begin
				is_enemy[3] = 1'b0;
				mem_addr[44:36] = 9'd0;
			end
			
			if ( (enemy5_X >= -10 & enemy5_X <= 10) & (enemy5_Y >=-12 & enemy5_Y <=12) )
			begin
				is_enemy[4] = 1'b1;
				mem_addr[53:45] = (DrawY - enemy5_Y_Pos + 12)*20 + (DrawX - enemy5_X_Pos) + 10;
			end
			else
			begin
				is_enemy[4] = 1'b0;
				mem_addr[53:45] = 9'd0;
			end
			
			if ( (enemy6_X >= -10 & enemy6_X <= 10) & (enemy6_Y >=-12 & enemy6_Y <=12) )
			begin
				is_enemy[5] = 1'b1;
				mem_addr[62:54] = (DrawY - enemy6_Y_Pos + 12)*20 + (DrawX - enemy6_X_Pos) + 10;
			end
			else
			begin
				is_enemy[5] = 1'b0;
				mem_addr[62:54] = 9'd0;
			end
			
			if ( (enemy7_X >= -10 & enemy7_X <= 10) & (enemy7_Y >=-12 & enemy7_Y <=12) )
			begin
				is_enemy[6] = 1'b1;
				mem_addr[71:63] = (DrawY - enemy7_Y_Pos + 12)*20 + (DrawX - enemy7_X_Pos) + 10;
			end
			else
			begin
				is_enemy[6] = 1'b0;
				mem_addr[71:63] = 9'd0;
			end
			
			if ( (enemy8_X >= -10 & enemy8_X <= 10) & (enemy8_Y >=-12 & enemy8_Y <=12) )
			begin
				is_enemy[7] = 1'b1;
				mem_addr[80:72] = (DrawY - enemy8_Y_Pos + 12)*20 + (DrawX - enemy8_X_Pos) + 10;
			end
			else
			begin
				is_enemy[7] = 1'b0;
				mem_addr[80:72] = 9'd0;
			end
			
			if ( (enemy9_X >= -10 & enemy9_X <= 10) & (enemy9_Y >=-12 & enemy9_Y <=12) )
			begin
				is_enemy[8] = 1'b1;
				mem_addr[89:81] = (DrawY - enemy9_Y_Pos + 12)*20 + (DrawX - enemy9_X_Pos) + 10;
			end
			else
			begin
				is_enemy[8] = 1'b0;
				mem_addr[89:81] = 9'd0;
			end
			
			if ( (enemy0_X >= -10 & enemy0_X <= 10) & (enemy0_Y >=-12 & enemy0_Y <=12) )
			begin
				is_enemy[9] = 1'b1;
				mem_addr[98:90] = (DrawY - enemy0_Y_Pos + 12)*20 + (DrawX - enemy0_X_Pos) + 10;
			end
			else
			begin
				is_enemy[9] = 1'b0;
				mem_addr[98:90] = 9'd0;
			end
			
			// bullet 1;
			//for(int i = 0; i < 10; i++)
			//begin
				if( (enemy_bullet_X[0] >= -10 & enemy_bullet_X[0] <= 10) & (enemy_bullet_Y[0] >=-12 & enemy_bullet_Y[0] <=12) )
				begin
					is_enemy_bullet[0] = 1'b1;
					enemy_bullet_addr[8:0] = ((DrawY - enemy_bullet_Y_Pos[0] + 12))*17 + (DrawX - enemy_bullet_X_Pos[0]) + 8;
				end
				else
				begin
					is_enemy_bullet[0] = 1'b0;
					enemy_bullet_addr[8:0] = 9'd0;
				end
				
				if( (enemy_bullet_X[1] >= -10 & enemy_bullet_X[1] <= 10) & (enemy_bullet_Y[1] >=-12 & enemy_bullet_Y[1] <=12) )
				begin
					is_enemy_bullet[1] = 1'b1;
					enemy_bullet_addr[17:9] = (DrawY - enemy_bullet_Y_Pos[1] + 12)*17 + (DrawX - enemy_bullet_X_Pos[1]) + 8;
				end
				else
				begin
					is_enemy_bullet[1] = 1'b0;
					enemy_bullet_addr[17:9] = 9'd0;
				end
				
				if( (enemy_bullet_X[2] >= -10 & enemy_bullet_X[2] <= 10) & (enemy_bullet_Y[2] >=-12 & enemy_bullet_Y[2] <=12) )
				begin
					is_enemy_bullet[2] = 1'b1;
					enemy_bullet_addr[26:18] = (DrawY - enemy_bullet_Y_Pos[2] + 12)*17 + (DrawX - enemy_bullet_X_Pos[2]) + 8;
				end
				else
				begin
					is_enemy_bullet[2] = 1'b0;
					enemy_bullet_addr[26:18] = 9'd0;
				end
				
				if( (enemy_bullet_X[3] >= -10 & enemy_bullet_X[3] <= 10) & (enemy_bullet_Y[3] >=-12 & enemy_bullet_Y[3] <=12) )
				begin
					is_enemy_bullet[3] = 1'b1;
					enemy_bullet_addr[35:27] = (DrawY - enemy_bullet_Y_Pos[3] + 12)*17 + (DrawX - enemy_bullet_X_Pos[3]) + 8;
				end
				else
				begin
					is_enemy_bullet[3] = 1'b0;
					enemy_bullet_addr[35:27] = 9'd0;
				end
				
				if( (enemy_bullet_X[4] >= -10 & enemy_bullet_X[4] <= 10) & (enemy_bullet_Y[4] >=-12 & enemy_bullet_Y[4] <=12) )
				begin
					is_enemy_bullet[4] = 1'b1;
					enemy_bullet_addr[44:36] = (DrawY - enemy_bullet_Y_Pos[4] + 12)*17 + (DrawX - enemy_bullet_X_Pos[4]) + 8;
				end
				else
				begin
					is_enemy_bullet[4] = 1'b0;
					enemy_bullet_addr[44:36] = 9'd0;
				end
				
				if( (enemy_bullet_X[5] >= -10 & enemy_bullet_X[5] <= 10) & (enemy_bullet_Y[5] >=-12 & enemy_bullet_Y[5] <=12) )
				begin
					is_enemy_bullet[5] = 1'b1;
					enemy_bullet_addr[53:45] = (DrawY - enemy_bullet_Y_Pos[5] + 12)*17 + (DrawX - enemy_bullet_X_Pos[5]) + 8;
				end
				else
				begin
					is_enemy_bullet[5] = 1'b0;
					enemy_bullet_addr[53:45] = 9'd0;
				end
				
				if( (enemy_bullet_X[6] >= -10 & enemy_bullet_X[6] <= 10) & (enemy_bullet_Y[6] >=-12 & enemy_bullet_Y[6] <=12) )
				begin
					is_enemy_bullet[6] = 1'b1;
					enemy_bullet_addr[62:54] = (DrawY - enemy_bullet_Y_Pos[6] + 12)*17 + (DrawX - enemy_bullet_X_Pos[6]) + 8;
				end
				else
				begin
					is_enemy_bullet[6] = 1'b0;
					enemy_bullet_addr[62:54] = 9'd0;
				end
				
				if( (enemy_bullet_X[7] >= -10 & enemy_bullet_X[7] <= 10) & (enemy_bullet_Y[7] >=-12 & enemy_bullet_Y[7] <=12) )
				begin
					is_enemy_bullet[7] = 1'b1;
					enemy_bullet_addr[71:63] = (DrawY - enemy_bullet_Y_Pos[7] + 12)*17 + (DrawX - enemy_bullet_X_Pos[7]) + 8;
				end
				else
				begin
					is_enemy_bullet[7] = 1'b0;
					enemy_bullet_addr[71:63] = 9'd0;
				end
				
				if( (enemy_bullet_X[8] >= -10 & enemy_bullet_X[8] <= 10) & (enemy_bullet_Y[8] >=-12 & enemy_bullet_Y[8] <=12) )
				begin
					is_enemy_bullet[8] = 1'b1;
					enemy_bullet_addr[80:72] = (DrawY - enemy_bullet_Y_Pos[8] + 12)*17 + (DrawX - enemy_bullet_X_Pos[8]) + 8;
				end
				else
				begin
					is_enemy_bullet[8] = 1'b0;
					enemy_bullet_addr[80:72] = 9'd0;
				end
				
				if( (enemy_bullet_X[9] >= -10 & enemy_bullet_X[9] <= 10) & (enemy_bullet_Y[9] >=-12 & enemy_bullet_Y[9] <=12) )
				begin
					is_enemy_bullet[9] = 1'b1;
					enemy_bullet_addr[89:81] = (DrawY - enemy_bullet_Y_Pos[9] + 12)*17 + (DrawX - enemy_bullet_X_Pos[9]) + 8;
				end
				else
				begin
					is_enemy_bullet[9] = 1'b0;
					enemy_bullet_addr[89:81] = 9'd0;
				end
			//end
			
			for(int i = 0; i < 2; i++)
			begin
			
			if( (bullet_X[i] >= -10 & bullet_X[i] <= 10) & (bullet_Y[i] >=-12 & bullet_Y[i] <=12) )
			begin
				is_ball[i*6+0] = 1'b1;
				bullet_addr[i*54 +0+:9] = (DrawY - bullet_Y_Pos[i] + 12)*17 + (DrawX - bullet_X_Pos[i]) + 8;
			end
			else
			begin
				is_ball[i*6+0] = 1'b0;
				bullet_addr[i*54 +0+:9] = 9'd0;
			end
			
			// bullet 2
			if( (bullet2_X[i] >= -10 & bullet2_X[i] <= 10) & (bullet2_Y[i] >=-12 & bullet2_Y[i] <=12) )
			begin
				is_ball[i*6+1] = 1'b1;
				bullet_addr[i*54 +9+:9] = (DrawY - bullet2_Y_Pos[i] + 12)*17 + (DrawX - bullet2_X_Pos[i]) + 8;
			end
			else
			begin
				is_ball[i*6+1] = 1'b0;
				bullet_addr[i*54 +9+:9] = 9'd0;
			end
			
			// bullet 3
			if( (bullet3_X[i] >= -10 & bullet3_X[i] <= 10) & (bullet3_Y[i] >=-12 & bullet3_Y[i] <=12) )
			begin
				is_ball[i*6+2] = 1'b1;
				bullet_addr[i*54 +18+:9] = (DrawY - bullet3_Y_Pos[i] + 12)*17 + (DrawX - bullet3_X_Pos[i]) + 8;
			end
			else
			begin
				is_ball[i*6+2] = 1'b0;
				bullet_addr[i*54 +18+:9] = 9'd0;
			end
			
			if( (bullet4_X[i] >= -10 & bullet4_X[i] <= 10) & (bullet4_Y[i] >=-12 & bullet4_Y[i] <=12) )
			begin
				is_ball[i*6+3] = 1'b1;
				bullet_addr[i*54 +27+:9] = (DrawY - bullet4_Y_Pos[i] + 12)*17 + (DrawX - bullet4_X_Pos[i]) + 8;
			end
			else
			begin
				is_ball[i*6+3] = 1'b0;
				bullet_addr[i*54 +27+:9] = 9'd0;
			end
			
			if( (bullet5_X[i] >= -10 & bullet5_X[i] <= 10) & (bullet5_Y[i] >=-12 & bullet5_Y[i] <=12) )
			begin
				is_ball[i*6+4] = 1'b1;
				bullet_addr[i*54 +36+:9] = (DrawY - bullet5_Y_Pos[i] + 12)*17 + (DrawX - bullet5_X_Pos[i]) + 8;
			end
			else
			begin
				is_ball[i*6+4] = 1'b0;
				bullet_addr[i*54 +36+:9] = 9'd0;
			end
			
			if( (bullet6_X[i] >= -10 & bullet6_X[i] <= 10) & (bullet6_Y[i] >=-12 & bullet6_Y[i] <=12) )
			begin
				is_ball[i*6+5] = 1'b1;
				bullet_addr[i*54 +45+:9] = (DrawY - bullet6_Y_Pos[i] + 12)*17 + (DrawX - bullet6_X_Pos[i]) + 8;
			end
			else
			begin
				is_ball[i*6+5] = 1'b0;
				bullet_addr[i*54 +45+:9] = 9'd0;
			end
		end
    end
    
endmodule
