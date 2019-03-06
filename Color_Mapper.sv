//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  color_mapper ( input  [11:0]            is_ball,            // Whether current pixel belongs to ball 
                       input  clk, reset, start_game,                         //   or background (computed in ball.sv)
							  input  logic [7:0] finish_game,
                       input  logic [1:0] is_player,
							  input  logic [98:0] mem_addr,
							  input	logic	[107:0] bullet_addr,
							  input  logic [89:0] enemy_bullet_addr,
							  input  logic [8:0] player2_addr,
							  input        [9:0]  DrawX, DrawY, is_enemy, is_enemy_bullet,       // Current pixel coordinates
							  input  logic [7:0]  keycode,
							  input  logic [11:0] bullet_status,
                       output logic [7:0]  VGA_R, VGA_G, VGA_B, // VGA RGB output
							  output collision
                     );
    
    logic [7:0] Red, Green, Blue;
    logic [7:0] r,g,b;
	 logic [9:0] enemy_alive = 10'b1111111111;
	 logic [11:0] bullet_alive = 12'b111111111111;
	 logic [11:0] bullet_alive_in;
	 logic [9:0] enemy_alive_in;
	 logic [1:0] player_alive = 2'b11;
	 logic [1:0] player_alive_in;
	 logic start_game_in = 1'b0;
	 logic [3:0] enemy_shot = 4'd0;
	 logic [3:0] enemy_shot_in;
	 logic		 end_game = 1'b0;
	 
	 //assign end_game = 1'b0;
	 //assign enemy_alive = 1'b1;
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
	 
	 always_ff @(posedge clk)
	 begin
		if(reset)
			enemy_shot <= 4'd0;
		else
			enemy_shot <= enemy_shot_in;
	 end
	 
	 int i = 0;
	 
	 logic [7:0] photo_to_palette;
	 
	 logic [23:0] mem [0:479];
    initial begin 
        $readmemh("space.txt", mem);
    end
	 
	 /*logic [3:0] gameover [0:34943];
	 initial begin
			$readmemh("gameover.mem", gameover);
	 end
	 
	 logic [11:0] gameover_palette [0:15];
	 initial begin
		  $readmemh("gameover_palette.mem", gameover_palette);	
	 end*/

	 logic [3:0] win_screen [0:10464];
	 initial begin
			$readmemh("win.mem", win_screen);
	 end
	 
	 logic [11:0] win_screen_palette [0:1];
	 initial begin
			$readmemh("win_palette.mem", win_screen_palette);
	 end
	 
	 logic [3:0] rocket [0:339];
	 initial begin
			$readmemh("Rocket.mem", rocket);
	 end
	 
	 logic [11:0] rocket_palette [0:15];
	 initial begin
			$readmemh("Rocket_palette.mem", rocket_palette);
	 end
	 
	 logic enemy_hit [0:4927];
	 initial begin
			$readmemh("Enemyshot.mem", enemy_hit);
	 end
	 
	 logic [11:0] enemy_hit_palette [0:15];
	 initial begin
			$readmemh("Enemyshot_palette.mem", enemy_hit_palette);
	 end
	 
	 logic [3:0] enemy_ship [0:459];
	 initial begin
			$readmemh("enemy.mem", enemy_ship);
	 end
	 
	 logic [11:0] enemy_ship_palette [0:15];
	 initial begin
			$readmemh("enemy_palette.mem", enemy_ship_palette);
	 end
	 
	 /*********************************************************/
	 /* ok so read some number images for score keeping here  */
	 /* everytime any enemy dies, decrease the score by 1     */								
	 /*********************************************************/
	 logic [3:0] start_screen [0:3319];						//166 x 20
	 initial begin
			$readmemh("gamestart.mem", start_screen);
	 end
	 
	 logic [11:0] start_screen_palette [0:15];
	 initial begin
			$readmemh("gamestart_palette.mem", start_screen_palette);
	 end
	 
	 logic numbers [0:3199];						//16 x 20 (individual numbers)
	 initial begin
			$readmemh("newnumber.mem", numbers);
	 end
	 
	 logic [11:0] numbers_palette [0:1];
	 initial begin
			$readmemh("newnumber_palette.mem", numbers_palette);
	 end
	 //earth = 48 x 55, mars = 45 x 53, saturn = 58 x 78
	 logic [3:0] earth [0:2639];
	 initial begin
			$readmemh("earth.mem", earth);
	 end
	 
	 logic [11:0] earth_palette [0:12];
	 initial begin
			$readmemh("earth_palette.mem", earth_palette);
	 end
	 
	 logic [3:0] mars [0:2384];
	 initial begin
			$readmemh("mars.mem", mars);
	 end
	 
	 logic [11:0] mars_palette [0:12];
	 initial begin
			$readmemh("mars_palette.mem", mars_palette);
	 end
	 
	 logic [3:0] saturn [0:4523];
	 initial begin
			$readmemh("saturn.mem", saturn);
	 end
	 
	 logic [11:0] saturn_palette [0:15];
	 initial begin
			$readmemh("saturn_palette.mem", saturn_palette);
	 end
	 
	 logic [3:0] rubble [0:1109];
	 initial begin
			$readmemh("rubble.mem", rubble);
	 end
	 
	 logic [11:0] rubble_palette [0:12];
	 initial begin
			$readmemh("rubble_palette.mem", rubble_palette);
	 end
	 
	 logic [3:0] star [0:2349];
	 initial begin
			$readmemh("star.mem", star);
	 end
	 
	 logic [11:0] star_palette [0:11];
	 initial begin
			$readmemh("star_palette.mem", star_palette);
	 end
	 
	 
    always_comb
    begin
		  if(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0)))
		  begin
				Red = 8'h22;
				Green = 8'h55;
				Blue = 8'h11;

				//end_game = 1'b1;
				
				if(DrawX >= 240 & DrawX <= 401 & DrawY >= 208 & DrawY <= 273)
				begin
					if(win_screen_palette[win_screen[(DrawY - 208)*161 + (DrawX-240)]] != 12'hfff)begin
					Red = 8'hfe;//{win_screen_palette[win_screen[(DrawY - 208)*161 + (DrawX-240)]][11:8],win_screen_palette[win_screen[(DrawY - 208)*161 + (DrawX-240)]][11:8]};
					Green = 8'hee;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4]};
					Blue = 8'h89;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0]};
					end
				end
		  end
		  
		  else if(((player_alive[0] == 1'b0)&(player_alive[1] == 1'b0)))
		  begin
		  
				Red = 8'h00;//{start_screen_palette[start_screen[background[DrawX+DrawY*100]]][11:8], start_screen_palette[start_screen[background[DrawX+DrawY*100]]][11:8]};
				Green = 8'h00;//{start_screen_palette[start_screen[background[DrawX+DrawY*100]]][7:4], start_screen_palette[start_screen[background[DrawX+DrawY*100]]][7:4]};
				Blue = 8'h00;//{start_screen_palette[start_screen[background[DrawX+DrawY*100]]][3:0], start_screen_palette[start_screen[background[DrawX+DrawY*100]]][3:0]};
				
				if(DrawX >= 208 & DrawX <= 432 & DrawY >= 162 & DrawY <= 318)
				begin
					Red = 8'hff;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][11:8], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][11:8]};
					Green = 8'hff;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4]};
					Blue = 8'h40;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0]};
				end
		  end
		  
		  else if(~start_game)
		  begin
				Red = 8'h00;//{start_screen_palette[start_screen[background[DrawX+DrawY*100]]][11:8], start_screen_palette[start_screen[background[DrawX+DrawY*100]]][11:8]};
				Green = 8'h00;//{start_screen_palette[start_screen[background[DrawX+DrawY*100]]][7:4], start_screen_palette[start_screen[background[DrawX+DrawY*100]]][7:4]};
				Blue = 8'h00;
			
				if(DrawX >= 237 & DrawX <= 403 & DrawY >= 230 & DrawY <= 250)
				begin
					Red = {start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][11:8], start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][11:8]};
					Green = {start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][7:4], start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][7:4]};
					Blue = {start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][3:0], start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][3:0]};
				end
		  end
		  
		  else
		  begin
		  
		  Red = 8'h00;//{meme[background[DrawX+DrawY*100]][11:8], meme[background[DrawX+DrawY*100]][11:8]};
		  Green = 8'h00;//{meme[background[DrawX+DrawY*100]][7:4], meme[background[DrawX+DrawY*100]][7:4]};
		  Blue = 8'h00;//{meme[background[DrawX+DrawY*100]][3:0], meme[background[DrawX+DrawY*100]][3:0]};
		  
		  if(DrawX >= 0 & DrawX <= 176 & DrawY >= 0 & DrawY <= 28)
		  begin
				if(enemy_hit_palette[enemy_hit[(DrawY)*176 + (DrawX)]] != 12'hfff)
				begin
					Red = 8'h0f;//{enemy_hit_palette[enemy_hit[(DrawY)*176 + (DrawX)]][11:8], enemy_hit_palette[enemy_hit[(DrawY)*92 + (DrawX)]][11:8]};
					Green = 8'hef;//{enemy_hit_palette[enemy_hit[(DrawY)*176 + (DrawX)]][7:4], enemy_hit_palette[enemy_hit[(DrawY)*92 + (DrawX)]][7:4]};
					Blue = 8'hff;//{enemy_hit_palette[enemy_hit[(DrawY)*92 + (DrawX)]][3:0], enemy_hit_palette[enemy_hit[(DrawY)*92 + (DrawX)]][3:0]};
				end
		  end
		  
		  if(DrawX >= 182 & DrawX <= 197 & DrawY >= 0 & DrawY <= 20)
		  begin
				if(numbers_palette[numbers[(DrawY)*160 + (DrawX - 182 + 16*enemy_shot)]] != 12'hfff)begin
				Red = 8'hff;//{numbers_palette[numbers[(DrawY)*160 + (DrawX  - 98 + 10*(enemy_shot))]][11:8], numbers_palette[numbers[(DrawY)*160 + (DrawX - 98 + 10*enemy_shot)]][11:8]};
				Green = 8'h00;//{numbers_palette[numbers[(DrawY)*160 + (DrawX  - 98 + 10*(enemy_shot))]][7:4], numbers_palette[numbers[(DrawY)*160 + (DrawX - 98 + 10*enemy_shot)]][7:4]};
				Blue = 8'hdf;//{numbers_palette[numbers[(DrawY)*160 + (DrawX - 98 + 10*enemy_shot)]][3:0], numbers_palette[numbers[(DrawY)*160 + (DrawX - 98 + 10*enemy_shot)]][3:0]};
				end
		  end
		  //earth = 48 x 55, mars = 45 x 53, saturn = 58 x 78
		  if(DrawX >= 200 & DrawX <= 248 & DrawY >= 105 & DrawY <= 155)
		  begin
				if((earth_palette[earth[(DrawY - 105)*48 + (DrawX - 200)]] != 12'hfff))
				begin
					Red = {earth_palette[earth[(DrawY - 105)*48 + (DrawX - 200)]][11:8], earth_palette[earth[(DrawY - 105)*48 + (DrawX - 200)]][11:8]};
					Green = {earth_palette[earth[(DrawY - 105)*48 + (DrawX - 200)]][7:4], earth_palette[earth[(DrawY - 105)*48 + (DrawX - 200)]][7:4]};
					Blue = {earth_palette[earth[(DrawY - 105)*48 + (DrawX - 200)]][3:0], earth_palette[earth[(DrawY - 105)*48 + (DrawX - 200)]][3:0]};
				end
		  end
		  
		  if(DrawX >= 500 & DrawX <= 545 & DrawY >= 55 & DrawY <= 103)
		  begin
				if(mars_palette[mars[(DrawY - 55)*45 + (DrawX - 500)]] != 12'hfff)
				begin
					Red = {mars_palette[mars[(DrawY - 55)*45 + (DrawX - 500)]][11:8], mars_palette[mars[(DrawY - 55)*45 + (DrawX - 500)]][11:8]};
					Green = {mars_palette[mars[(DrawY - 55)*45 + (DrawX - 500)]][7:4], mars_palette[mars[(DrawY - 55)*45 + (DrawX - 500)]][7:4]};
					Blue = {mars_palette[mars[(DrawY - 55)*45 + (DrawX - 500)]][3:0], mars_palette[mars[(DrawY - 55)*45 + (DrawX - 500)]][3:0]};
				end
		  end
		  //star = 47 x 50, rubble = 37 x 30
		  if(DrawX >= 340 & DrawX <= 387 & DrawY >= 240 & DrawY <= 290)
		  begin
				if(star_palette[star[(DrawY - 240)*47 + (DrawX - 340)]] != 12'hfff)
				begin
					Red = {star_palette[star[(DrawY - 240)*47 + (DrawX - 340)]][11:8], star_palette[star[(DrawY - 240)*47 + (DrawX - 340)]][11:8]};
					Green = {star_palette[star[(DrawY - 240)*47 + (DrawX - 340)]][7:4], star_palette[star[(DrawY - 240)*47 + (DrawX - 340)]][7:4]};
					Blue = {star_palette[star[(DrawY - 240)*47 + (DrawX - 340)]][3:0], star_palette[star[(DrawY - 240)*47 + (DrawX - 340)]][3:0]};
				end
		  end
		  
		  if(DrawX >= 140 & DrawX <= 187 & DrawY >= 300 & DrawY <= 350)
		  begin
				if(star_palette[star[(DrawY - 300)*47 + (DrawX - 140)]] != 12'hfff)
				begin
					Red = {star_palette[star[(DrawY - 300)*47 + (DrawX - 140)]][11:8], star_palette[star[(DrawY - 300)*47 + (DrawX - 140)]][11:8]};
					Green = {star_palette[star[(DrawY - 300)*47 + (DrawX - 140)]][7:4], star_palette[star[(DrawY - 300)*47 + (DrawX - 140)]][7:4]};
					Blue = {star_palette[star[(DrawY - 300)*47 + (DrawX - 140)]][3:0], star_palette[star[(DrawY - 300)*47 + (DrawX - 140)]][3:0]};
				end
		  end
		  
		  if(DrawX >= 540 & DrawX <= 587 & DrawY >= 390 & DrawY <= 440)
		  begin
				if(star_palette[star[(DrawY - 390)*47 + (DrawX - 540)]] != 12'hfff)
				begin
					Red = {star_palette[star[(DrawY - 390)*47 + (DrawX - 540)]][11:8], star_palette[star[(DrawY - 390)*47 + (DrawX - 540)]][11:8]};
					Green = {star_palette[star[(DrawY - 390)*47 + (DrawX - 540)]][7:4], star_palette[star[(DrawY - 390)*47 + (DrawX - 540)]][7:4]};
					Blue = {star_palette[star[(DrawY - 390)*47 + (DrawX - 540)]][3:0], star_palette[star[(DrawY - 390)*47 + (DrawX - 540)]][3:0]};
				end
		  end
		  
		  if(DrawX >= 100 & DrawX <= 137 & DrawY >= 103 & DrawY <= 130)
		  begin
				if(rubble_palette[rubble[(DrawY - 103)*37 + (DrawX - 100)]] != 12'hfff)
				begin
					Red = {rubble_palette[rubble[(DrawY - 103)*37 + (DrawX - 100)]][11:8], rubble_palette[rubble[(DrawY - 103)*37 + (DrawX - 100)]][11:8]};
					Green = {rubble_palette[rubble[(DrawY - 103)*37 + (DrawX - 100)]][7:4], rubble_palette[rubble[(DrawY - 103)*37 + (DrawX - 100)]][7:4]};
					Blue = {rubble_palette[rubble[(DrawY - 103)*37 + (DrawX - 100)]][3:0], rubble_palette[rubble[(DrawY - 103)*37 + (DrawX - 100)]][3:0]};
				end
		  end
		  
		  if(DrawX >= 290 & DrawX <= 327 & DrawY >= 313 & DrawY <= 340)
		  begin
				if(rubble_palette[rubble[(DrawY - 313)*37 + (DrawX - 290)]] != 12'hfff)
				begin
					Red = {rubble_palette[rubble[(DrawY - 313)*37 + (DrawX - 290)]][11:8], rubble_palette[rubble[(DrawY - 313)*37 + (DrawX - 290)]][11:8]};
					Green = {rubble_palette[rubble[(DrawY - 313)*37 + (DrawX - 290)]][7:4], rubble_palette[rubble[(DrawY - 313)*37 + (DrawX - 290)]][7:4]};
					Blue = {rubble_palette[rubble[(DrawY - 313)*37 + (DrawX - 290)]][3:0], rubble_palette[rubble[(DrawY - 313)*37 + (DrawX - 290)]][3:0]};
				end
		  end
		  
		  if(DrawX >= 50 & DrawX <= 87 & DrawY >= 343 & DrawY <= 370)
		  begin
				if(rubble_palette[rubble[(DrawY - 343)*37 + (DrawX - 50)]] != 12'hfff)
				begin
					Red = {rubble_palette[rubble[(DrawY - 343)*37 + (DrawX - 50)]][11:8], rubble_palette[rubble[(DrawY - 343)*37 + (DrawX - 50)]][11:8]};
					Green = {rubble_palette[rubble[(DrawY - 343)*37 + (DrawX - 50)]][7:4], rubble_palette[rubble[(DrawY - 343)*37 + (DrawX - 50)]][7:4]};
					Blue = {rubble_palette[rubble[(DrawY - 343)*37 + (DrawX - 50)]][3:0], rubble_palette[rubble[(DrawY - 343)*37 + (DrawX - 50)]][3:0]};
				end
		  end
		  
        if ((is_player[0] == 1'b1)&player_alive[0]) 
        begin
            // White ball
				if(mem [mem_addr[8:0]] != 24'hffffff)
				begin
            Red = /*mem [mem_addr[8:0]][7:0] ;*/8'hff;
            Green = mem [mem_addr[8:0]][15:8] ;//8'hff;
            Blue = mem [mem_addr[8:0]][23:16];//8'hff;
				end
        end
		  
		  if ((is_player[1] == 1'b1)&player_alive[1]) 
        begin
            // White ball
				if(mem [player2_addr[8:0]] != 24'hffffff)
				begin
            Red = mem [player2_addr[8:0]][7:0] ;//8'hff;
            Green = mem [player2_addr[8:0]][15:8] ;//8'hff;
            Blue = /*mem [player2_addr[8:0]][23:16];*/8'hff;
				end
        end
		  
		  if ((is_enemy[0] == 1'b1) & enemy_alive[0])
		  begin
				if( enemy_ship_palette[enemy_ship[mem_addr[17:9]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[17:9]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[17:9]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[17:9]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[17:9]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[17:9]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[17:9]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[1] == 1'b1) & enemy_alive[1])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[26:18]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[26:18]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[26:18]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[26:18]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[26:18]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[26:18]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[26:18]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[2] == 1'b1) & enemy_alive[2])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[35:27]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[35:27]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[35:27]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[35:27]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[35:27]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[35:27]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[35:27]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[3] == 1'b1) & enemy_alive[3])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[44:36]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[44:36]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[44:36]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[44:36]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[44:36]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[44:36]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[44:36]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[4] == 1'b1) & enemy_alive[4])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[53:45]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[53:45]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[53:45]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[53:45]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[53:45]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[53:45]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[53:45]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[5] == 1'b1) & enemy_alive[5])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[62:54]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[62:54]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[62:54]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[62:54]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[62:54]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[62:54]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[62:54]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[6] == 1'b1) & enemy_alive[6])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[71:63]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[71:63]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[71:63]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[71:63]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[71:63]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[71:63]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[71:63]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[7] == 1'b1) & enemy_alive[7])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[80:72]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[80:72]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[80:72]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[80:72]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[80:72]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[80:72]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[80:72]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[8] == 1'b1) & enemy_alive[8])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[89:81]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[89:81]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[89:81]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[89:81]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[89:81]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[89:81]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[89:81]]][3:0]};//8'hff;
				end
		  end
		  
		  if ((is_enemy[9] == 1'b1) & enemy_alive[9])
		  begin
				if(enemy_ship_palette[enemy_ship[mem_addr[98:90]]] != 12'h000)
				begin
				Red = {enemy_ship_palette[enemy_ship[mem_addr[98:90]]][11:8], enemy_ship_palette[enemy_ship[mem_addr[98:90]]][11:8]};//8'hff;
            Green = {enemy_ship_palette[enemy_ship[mem_addr[98:90]]][7:4], enemy_ship_palette[enemy_ship[mem_addr[98:90]]][7:4]};//8'hff;
            Blue = {enemy_ship_palette[enemy_ship[mem_addr[98:90]]][3:0], enemy_ship_palette[enemy_ship[mem_addr[98:90]]][3:0]};//8'hff;
				end
		  end
		  end//************************
		  
		  for(i = 0; i < 10; i++)
		  begin
				if(is_enemy_bullet[i] == 1'b1)
				begin
					if((rocket_palette[rocket[enemy_bullet_addr[i*9 +:9]]] != 12'hfff) & enemy_alive[i] & (~is_enemy[i]))
					begin
					Red = {rocket_palette[rocket[enemy_bullet_addr[i*9 +:9]]][3:0], rocket_palette[rocket[enemy_bullet_addr[i*9 +:9]]][3:0]};
					Green = {rocket_palette[rocket[enemy_bullet_addr[i*9 +:9]]][7:4], rocket_palette[rocket[enemy_bullet_addr[i*9 +:9]]][7:4]};
					Blue = {rocket_palette[rocket[enemy_bullet_addr[i*9 +:9]]][11:8], rocket_palette[rocket[enemy_bullet_addr[i*9 +:9]]][11:8]};
					end
				end
		  end
		  
		  for(i = 0; i < 2; i++)
		  begin
		  
				if(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0)))
				begin
					Red = 8'h22;
					Green = 8'hff;
					Blue = 8'h11;
					
					//player_alive_in[1] = 1'b0;
					//end_game = 1'b1;
					
					if(DrawX >= 240 & DrawX <= 401 & DrawY >= 208 & DrawY <= 273)
					begin
						if(win_screen_palette[win_screen[(DrawY - 208)*161 + (DrawX-240)]] != 12'hfff)begin
						Red = 8'hfe;//{win_screen_palette[win_screen[(DrawY - 208)*161 + (DrawX-240)]][11:8],win_screen_palette[win_screen[(DrawY - 208)*161 + (DrawX-240)]][11:8]};
						Green = 8'hee;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4]};
						Blue = 8'h89;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0]};
						end
					end
				end
		  
				else if(((player_alive[0] == 1'b0)&(player_alive[1] == 1'b0)))
				begin
					Red = 8'h00;
					Green = 8'h00;
					Blue = 8'h00;
					if(DrawX >= 208 & DrawX <= 432 & DrawY >= 162 & DrawY <= 318)
					begin
						Red = 8'hff;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][11:8], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][11:8]};
						Green = 8'hff;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][7:4]};
						Blue = 8'h40;//{gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0], gameover_palette[gameover[(DrawY - 162)*224 + (DrawX-208)]][3:0]};
					end
				end
			
				else if(~start_game)
				begin
					Red = 8'h00;//{start_screen_palette[start_screen[background[DrawX+DrawY*100]]][11:8], start_screen_palette[start_screen[background[DrawX+DrawY*100]]][11:8]};
					Green = 8'h00;//{start_screen_palette[start_screen[background[DrawX+DrawY*100]]][7:4], start_screen_palette[start_screen[background[DrawX+DrawY*100]]][7:4]};
					Blue = 8'h00;
				
					if(DrawX >= 237 & DrawX <= 403 & DrawY >= 230 & DrawY <= 250)
					begin
						Red = {start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][11:8], start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][11:8]};
						Green = {start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][7:4], start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][7:4]};
						Blue = {start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][3:0], start_screen_palette[start_screen[(DrawY - 230)*166 + (DrawX - 237)]][3:0]};
					end
				end
			
		  else
		  begin
		  
		  if ((is_ball[i*6+0] == 1'b1)&player_alive[i]&bullet_alive[i*6]&(~is_player[i])&~(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0))))
		  begin
				if(rocket_palette[rocket[bullet_addr[i*54 +0 +:9]]] != 12'hffffff)
				begin
				Red = {rocket_palette[rocket[bullet_addr[i*54 +0 +:9]]][3:0], rocket_palette[rocket[bullet_addr[i*54 +0 +:9]]][3:0]};
            Green = {rocket_palette[rocket[bullet_addr[i*54 +0 +:9]]][7:4], rocket_palette[rocket[bullet_addr[i*54 +0 +:9]]][7:4]};
            Blue = {rocket_palette[rocket[bullet_addr[i*54 +0 +:9]]][11:8], rocket_palette[rocket[bullet_addr[i*54 +0 +:9]]][11:8]};
				end
		  end
		  
		  if ((is_ball[i*6+1] == 1'b1)&player_alive[i]&bullet_alive[i*6+1]&(~is_player[i])&~(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0))))
		  begin
				if(rocket_palette[rocket[bullet_addr[i*54 +9 +:9]]] != 12'hffffff)
				begin
				Red = {rocket_palette[rocket[bullet_addr[i*54 +9 +:9]]][3:0], rocket_palette[rocket[bullet_addr[i*54 +9 +:9]]][3:0]};
            Green = {rocket_palette[rocket[bullet_addr[i*54 +9 +:9]]][7:4], rocket_palette[rocket[bullet_addr[i*54 +9 +:9]]][7:4]};
            Blue = {rocket_palette[rocket[bullet_addr[i*54 +9 +:9]]][11:8], rocket_palette[rocket[bullet_addr[i*54 +9 +:9]]][11:8]};
				end
		  end
		  
		  if ((is_ball[i*6+2] == 1'b1)&player_alive[i]&bullet_alive[i*6+2]&(~is_player[i])&~(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0))))
		  begin
				if(rocket_palette[rocket[bullet_addr[i*54 +18 +:9]]] != 12'hffffff)
				begin
				Red = {rocket_palette[rocket[bullet_addr[i*54 +18 +:9]]][3:0], rocket_palette[rocket[bullet_addr[i*54 +18 +:9]]][3:0]};
            Green = {rocket_palette[rocket[bullet_addr[i*54 +18 +:9]]][7:4], rocket_palette[rocket[bullet_addr[i*54 +18 +:9]]][7:4]};
            Blue = {rocket_palette[rocket[bullet_addr[i*54 +18 +:9]]][11:8], rocket_palette[rocket[bullet_addr[i*54 +18 +:9]]][11:8]};
				end
		  end
		  
		  if ((is_ball[i*6+3] == 1'b1)&player_alive[i]&bullet_alive[i*6+3]&(~is_player[i])&~(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0))))
		  begin
				if(rocket_palette[rocket[bullet_addr[i*54 +27 +:9]]] != 12'hffffff)
				begin
				Red = {rocket_palette[rocket[bullet_addr[i*54 +27 +:9]]][3:0], rocket_palette[rocket[bullet_addr[i*54 +27 +:9]]][3:0]};
            Green = {rocket_palette[rocket[bullet_addr[i*54 +27 +:9]]][7:4], rocket_palette[rocket[bullet_addr[i*54 +27 +:9]]][7:4]};
            Blue = {rocket_palette[rocket[bullet_addr[i*54 +27 +:9]]][11:8], rocket_palette[rocket[bullet_addr[i*54 +27 +:9]]][11:8]};
				end
		  end
		  
		  if ((is_ball[i*6+4] == 1'b1)&player_alive[i]&bullet_alive[i*6+4]&(~is_player[i])&~(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0))))
		  begin
				if(rocket_palette[rocket[bullet_addr[i*54 +36 +:9]]] != 12'hffffff)
				begin
				Red = {rocket_palette[rocket[bullet_addr[i*54 +36 +:9]]][3:0], rocket_palette[rocket[bullet_addr[i*54 +36 +:9]]][3:0]};
            Green = {rocket_palette[rocket[bullet_addr[i*54 +36 +:9]]][7:4], rocket_palette[rocket[bullet_addr[i*54 +36 +:9]]][7:4]};
            Blue = {rocket_palette[rocket[bullet_addr[i*54 +36 +:9]]][11:8], rocket_palette[rocket[bullet_addr[i*54 +36 +:9]]][11:8]};
				end
		  end
		  
		  if ((is_ball[i*6+5] == 1'b1)&player_alive[i]&bullet_alive[i*6+5]&(~is_player[i])&~(((enemy_alive[0] == 1'b0)&(enemy_alive[1] == 1'b0)&(enemy_alive[2] == 1'b0)&(enemy_alive[3] == 1'b0)&(enemy_alive[4] == 1'b0)&(enemy_alive[5] == 1'b0)&(enemy_alive[6] == 1'b0)&(enemy_alive[7] == 1'b0)&(enemy_alive[8] == 1'b0)&(enemy_alive[9] == 1'b0))))
		  begin
				if(rocket_palette[rocket[bullet_addr[i*54 +45 +:9]]] != 12'hffffff)
				begin
				Red = {rocket_palette[rocket[bullet_addr[i*54 +45 +:9]]][3:0], rocket_palette[rocket[bullet_addr[i*54 +45 +:9]]][3:0]};
            Green = {rocket_palette[rocket[bullet_addr[i*54 +45 +:9]]][7:4], rocket_palette[rocket[bullet_addr[i*54 +45 +:9]]][7:4]};
            Blue = {rocket_palette[rocket[bullet_addr[i*54 +45 +:9]]][11:8], rocket_palette[rocket[bullet_addr[i*54 +45 +:9]]][11:8]};
				end
		  end
		
		  /*for(int i = 0; i < 12; i++)
		  begin
				bullet_alive[i] = 1'b1;
		  end*/
		//end
		end
		end
		end
	 
	 always_ff @(posedge clk)
	 begin
		if(reset)
			begin
			for (int i = 0; i <10 ; i++)begin
				enemy_alive[i] <= 1'b1;
			end
			for(int i = 0; i < 2; i++)begin
				player_alive[i] <= 1'b1;
			end
			for(int i = 0; i < 12; i++)begin
				bullet_alive[i] <= 1'b1;
			end
			end
		else
			begin
			for(int i =0 ; i < 10; i++)begin
				enemy_alive[i] <= enemy_alive_in[i];
			end
			for(int i = 0; i < 2; i++)begin
					player_alive[i] <= player_alive_in[i];
			end
			for(int i = 0; i < 12; i++)begin
				bullet_alive[i] <= bullet_alive_in[i];
			end
			end
	 end
	 
    always_comb
	 begin
		for(int i = 0; i <10; i++)begin
			enemy_alive_in[i] = enemy_alive[i];
		end
		
		for(int i = 0; i < 2; i++)begin
				player_alive_in[i] = player_alive[i];
		end
		
		for(int i = 0; i < 12; i++)begin
			if(bullet_status[i])begin
			bullet_alive_in[i] = 1'b1;						//0 ~ 5 player 1 and 6 ~ 11 is player 2
			end
			else
			bullet_alive_in[i] = bullet_alive[i];
		end
		
		for(int i = 0; i < 10; i++)begin
			if(start_game)
			begin
				if(is_enemy_bullet[i] & is_player[0] & enemy_alive[i])
					begin
						if(!(mem[mem_addr[8:0]] == enemy_bullet_addr[i*9+:9]))
							player_alive_in[0] = 1'b0;	
					end
				if(is_enemy_bullet[i] & is_player[1] & enemy_alive[i])
					begin
						if(!(mem[player2_addr[8:0]] == enemy_bullet_addr[i*9+:9]))
							player_alive_in[1] = 1'b0;
					end
			end
		end
		enemy_shot_in = enemy_shot;
		
		for(int i = 0; i <10; i++)begin
		
		
		if(start_game)begin
			 
			if((is_ball[0] & is_enemy[i] & bullet_alive[0] & enemy_alive[i] & player_alive[0]))
				begin
					if((!(mem[bullet_addr[8:0]] == mem[mem_addr[17:9]]))&bullet_alive[0])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[0] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[1] & is_enemy[i] & bullet_alive[1] & enemy_alive[i] & player_alive[0]))
				begin
					if((!(mem[bullet_addr[17:9]] == mem[mem_addr[17:9]]))&bullet_alive[1])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[1] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[2] & is_enemy[i] & bullet_alive[2] & enemy_alive[i] & player_alive[0]))
				begin
					if((!(mem[bullet_addr[26:18]] == mem[mem_addr[17:9]]))&bullet_alive[2])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[2] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[3] & is_enemy[i] & bullet_alive[3] & enemy_alive[i] & player_alive[0]))
				begin
					if((!(mem[bullet_addr[35:27]] == mem[mem_addr[17:9]]))&bullet_alive[3])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[3] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[4] & is_enemy[i] & bullet_alive[4] & enemy_alive[i] & player_alive[0]))
				begin
					if((!(mem[bullet_addr[44:36]] == mem[mem_addr[17:9]]))&bullet_alive[4])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[4] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[5] & is_enemy[i] & bullet_alive[5] & enemy_alive[i] & player_alive[0]))
				begin
					if((!(mem[bullet_addr[53:45]] == mem[mem_addr[17:9]]))&bullet_alive[5])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[5] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[6] & is_enemy[i] & bullet_alive[6] & enemy_alive[i] & player_alive[1]))
				begin
					if((!(mem[bullet_addr[62:54]] == mem[mem_addr[17:9]]))&bullet_alive[6])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[6] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[7] & is_enemy[i] & bullet_alive[7] & enemy_alive[i] & player_alive[1]))
				begin
					if((!(mem[bullet_addr[71:63]] == mem[mem_addr[17:9]]))&bullet_alive[7])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[7] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[8] & is_enemy[i] & bullet_alive[8] & enemy_alive[i] & player_alive[1]))
				begin
					if((!(mem[bullet_addr[80:72]] == mem[mem_addr[17:9]]))&bullet_alive[8])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[8] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[9] & is_enemy[i] & bullet_alive[9] & enemy_alive[i] & player_alive[1]))
				begin
					if((!(mem[bullet_addr[89:81]] == mem[mem_addr[17:9]]))&bullet_alive[9])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[9] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[10] & is_enemy[i] & bullet_alive[10] & enemy_alive[i] & player_alive[1]))
				begin
					if((!(mem[bullet_addr[98:90]] == mem[mem_addr[17:9]]))&bullet_alive[10])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[10] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			if((is_ball[11] & is_enemy[i] & bullet_alive[11] & enemy_alive[i] & player_alive[1]))
				begin
					if((!(mem[bullet_addr[107:99]] == mem[mem_addr[17:9]]))&bullet_alive[11])begin
						enemy_alive_in[i] = 1'b0;
						bullet_alive_in[11] = 1'b0;
						enemy_shot_in = enemy_shot + 4'd1;
					end
				end
			end
		end
	 end
endmodule
