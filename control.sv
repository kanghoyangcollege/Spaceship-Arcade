module control_logic (
		input logic clk,
		input logic reset,
		input logic collision,
		input logic player,
		input logic [3:0] counter_sum,
		input logic [47:0] keycode,
		output logic [2:0] bullet_num,
		output logic finish_game,
		output logic [3:0] counter,
		output logic start_game,
		output logic start_enemy_bullets,
		output logic [5:0] bullet_status
);

	enum logic [4:0] {WAIT, in_game, enemy_fire, first_bullet, first_pause, first_pause2, second_bullet, second_pause,second_pause2, third_bullet, third_pause,third_pause2, 
							fourth_bullet, fourth_pause, fourth_pause2, fifth_bullet, fifth_pause, fifth_pause2, sixth_bullet, sixth_pause, sixth_pause2, bullseye, stall, DONE} curr_state, next_state;
	
	logic inhibit, cnt_reset, inhibit_b, cnt_reset_b;
	logic [3:0] cnt_out;
	logic [2:0] bullet_cnt;
	logic start_game_in;
   logic [7:0] key_cmd;
	logic [5:0] bullet_status_in;
	logic start_enemy_bullets_in;
	
	assign key_cmd = player ? 8'h34:8'h05;
	assign start_game = start_game_in;
	assign start_enemy_bullets = start_enemy_bullets_in;
	
	counter cnt (.inhibit(inhibit), .clk(clk), .reset(cnt_reset), .out(cnt_out));
	bullet_counter b_cnt (.inhibit(inhibit_b), .clk(clk), .reset(cnt_reset), .out(bullet_cnt));
	
	always_ff @(posedge clk)
	begin
		if(reset)
			curr_state = WAIT;
		else
			curr_state = next_state;
	end
	
	//assign bullet_num = bullet_cnt;
	
	always_comb
	begin
		next_state = curr_state;
		
		inhibit = 1'b1;
		cnt_reset = 1'b0;
		inhibit_b = 1'b1;
		cnt_reset_b = 1'b0;
		finish_game = 1'b0;
		bullet_num = 2'b00;
		start_game_in = 1'b0;
		//bullet_status_in = 12'd0;
		bullet_status = 5'd0;
		start_enemy_bullets_in = 1'b0;
		
		
		unique case(curr_state)
			WAIT:
				if((keycode[7:0] == 8'd40)|(keycode[15:8] == 8'd40)|(keycode[23:16] == 8'd40)|(keycode[31:24] == 8'd40)|(keycode[39:32] == 8'd40)|(keycode[47:40] == 8'd40))//if(keycode == 8'd40)
					next_state = enemy_fire;
			enemy_fire:
				if(~((keycode[7:0] == 8'd40)|(keycode[15:8] == 8'd40)|(keycode[23:16] == 8'd40)|(keycode[31:24] == 8'd40)|(keycode[39:32] == 8'd40)|(keycode[47:40] == 8'd40)))
					next_state = in_game;
			in_game:
				if((keycode[7:0] == key_cmd)|(keycode[15:8] == key_cmd)|(keycode[23:16] == key_cmd)|(keycode[31:24] == key_cmd)|(keycode[39:32] == key_cmd)|(keycode[47:40] == key_cmd))//if(keycode == 8'h2c)
					next_state = first_bullet;
			// first bullet 
			first_bullet:
			begin
				//if((keycode[7:0] == 8'h2c)|(keycode[15:8] == 8'h2c)|(keycode[23:16] == 8'h2c)|(keycode[31:24] == 8'h2c))//if(keycode == 8'h2c)
				next_state = first_pause;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			first_pause:
			begin
				if(~(keycode[7:0] == key_cmd)&~(keycode[15:8] == key_cmd)&~(keycode[23:16] == key_cmd)&~(keycode[31:24] == key_cmd)&~(keycode[39:32] == key_cmd)&~(keycode[47:40] == key_cmd))//if(keycode == 8'h00)
					next_state = first_pause2;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			first_pause2:
			begin
				if((keycode[7:0] == key_cmd)|(keycode[15:8] == key_cmd)|(keycode[23:16] == key_cmd)|(keycode[31:24] == key_cmd)|(keycode[39:32] == key_cmd)|(keycode[47:40] == key_cmd))//if(keycode == 8'h2c)
					next_state = second_bullet;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			// second bullet
			second_bullet:
			begin	
				//if((keycode[7:0] == 8'h2c)|(keycode[15:8] == 8'h2c)|(keycode[23:16] == 8'h2c)|(keycode[31:24] == 8'h2c))//if(keycode == 8'h2c)
					next_state = second_pause;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			second_pause:
			begin
				if(~(keycode[7:0] == key_cmd)&~(keycode[15:8] == key_cmd)&~(keycode[23:16] == key_cmd)&~(keycode[31:24] == key_cmd)&~(keycode[39:32] == key_cmd)&~(keycode[47:40] == key_cmd))//if(keycode == 8'h00)
					next_state = second_pause2;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			second_pause2:
			begin
				if((keycode[7:0] == key_cmd)|(keycode[15:8] == key_cmd)|(keycode[23:16] == key_cmd)|(keycode[31:24] == key_cmd)|(keycode[39:32] == key_cmd)|(keycode[47:40] == key_cmd))//if(keycode == 8'h2c)
					next_state = third_bullet;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			// third bullet
			third_bullet:
			begin
				//if((keycode[7:0] == 8'h2c)|(keycode[15:8] == 8'h2c)|(keycode[23:16] == 8'h2c)|(keycode[31:24] == 8'h2c))//if(keycode == 8'h2c)
					next_state = third_pause;
					
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			third_pause:
			begin
				if(~(keycode[7:0] == key_cmd)&~(keycode[15:8] == key_cmd)&~(keycode[23:16] == key_cmd)&~(keycode[31:24] == key_cmd)&~(keycode[39:32] == key_cmd)&~(keycode[47:40] == key_cmd))//if(keycode == 8'h00)
					next_state = third_pause2;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			third_pause2:
			begin
				if((keycode[7:0] == key_cmd)|(keycode[15:8] == key_cmd)|(keycode[23:16] == key_cmd)|(keycode[31:24] == key_cmd)|(keycode[39:32] == key_cmd)|(keycode[47:40] == key_cmd))//if(keycode == 8'h2c)
					next_state = fourth_bullet;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			fourth_bullet:
			begin
				next_state = fourth_pause;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			fourth_pause:
			begin
				if(~(keycode[7:0] == key_cmd)&~(keycode[15:8] == key_cmd)&~(keycode[23:16] == key_cmd)&~(keycode[31:24] == key_cmd)&~(keycode[39:32] == key_cmd)&~(keycode[47:40] == key_cmd))//if(keycode == 8'h00)
					next_state = fourth_pause2;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			fourth_pause2:
			begin
				if((keycode[7:0] == key_cmd)|(keycode[15:8] == key_cmd)|(keycode[23:16] == key_cmd)|(keycode[31:24] == key_cmd)|(keycode[39:32] == key_cmd)|(keycode[47:40] == key_cmd))//if(keycode == 8'h2c)
					next_state = fifth_bullet;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			fifth_bullet:
			begin
				next_state = fifth_pause;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			fifth_pause:
			begin
				if(~(keycode[7:0] == key_cmd)&~(keycode[15:8] == key_cmd)&~(keycode[23:16] == key_cmd)&~(keycode[31:24] == key_cmd)&~(keycode[39:32] == key_cmd)&~(keycode[47:40] == key_cmd))//if(keycode == 8'h00)
					next_state = fifth_pause2;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			fifth_pause2:
			begin
				if((keycode[7:0] == key_cmd)|(keycode[15:8] == key_cmd)|(keycode[23:16] == key_cmd)|(keycode[31:24] == key_cmd)|(keycode[39:32] == key_cmd)|(keycode[47:40] == key_cmd))//if(keycode == 8'h2c)
					next_state = sixth_bullet;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			sixth_bullet:
			begin
			next_state = sixth_pause;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			sixth_pause:
			begin
				if(~(keycode[7:0] == key_cmd)&~(keycode[15:8] == key_cmd)&~(keycode[23:16] == key_cmd)&~(keycode[31:24] == key_cmd)&~(keycode[39:32] == key_cmd)&~(keycode[47:40] == key_cmd))//if(keycode == 8'h00)
					next_state = sixth_pause2;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			sixth_pause2:
			begin
				if((keycode[7:0] == key_cmd)|(keycode[15:8] == key_cmd)|(keycode[23:16] == key_cmd)|(keycode[31:24] == key_cmd)|(keycode[39:32] == key_cmd)|(keycode[47:40] == key_cmd))//if(keycode == 8'h2c)
					next_state = stall;
				if(collision)
					next_state = bullseye;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			stall:
			begin
				next_state = first_bullet;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			bullseye:
			begin
				if(cnt_out[3] & ~cnt_out[2] & cnt_out[1] & ~cnt_out[0])
					next_state = DONE;
				if(counter_sum >= 4'd10)
					next_state = DONE;
			end
			DONE:
				if((keycode[7:0] == 8'd40)|(keycode[15:8] == 8'd40)|(keycode[23:16] == 8'd40)|(keycode[31:24] == 8'd40)|(keycode[39:32] == 8'd40)|(keycode[47:40] == 8'd40))
					next_state = WAIT;
				else
					next_state = DONE;
		endcase
		
		case(curr_state)
			WAIT:
				begin
					cnt_reset = 1'b1;
					cnt_reset_b = 1'b1;
				end
			enemy_fire:
				begin
					start_enemy_bullets_in = 1'b1;
				end
			in_game:
				begin
					cnt_reset_b = 1'b1;
					start_game_in = 1'b1;
					
				end
			first_bullet:
				begin
					//inhibit_b = 1'b0;
					bullet_num = 3'b001;
					start_game_in = 1'b1;
					bullet_status = 6'b000001;
				end
			first_pause:
				begin
					bullet_num = 3'b001;
					start_game_in = 1'b1;
					bullet_status = 6'b100001;
				end
			first_pause2:
				begin
					bullet_num = 3'b001;
					start_game_in = 1'b1;
				end
			second_bullet:
				begin
					//inhibit_b = 1'b0;
					bullet_num = 3'b010;
					start_game_in = 1'b1;
					bullet_status = 6'b000010;
				end
			second_pause:
				begin
					bullet_num = 3'b010;
					start_game_in = 1'b1;
					bullet_status = 6'b000010;
				end
			second_pause2:
				begin
					bullet_num = 3'b010;
					start_game_in = 1'b1;
				end
			third_bullet:
				begin
					//inhibit_b = 1'b0;
					bullet_num = 3'b011;
					start_game_in = 1'b1;
					bullet_status = 6'b000100;
				end
			third_pause:
				begin
					bullet_num = 3'b011;
					start_game_in = 1'b1;
					bullet_status = 6'b000100;
				end
			third_pause2:
				begin
					bullet_num = 3'b011;
					start_game_in = 1'b1;
				end
			fourth_bullet:
				begin
					//inhibit_b = 1'b0;
					bullet_num = 3'b100;
					start_game_in = 1'b1;
					bullet_status = 6'b001000;
				end
			fourth_pause:
				begin
					//inhibit_b = 1'b0;
					bullet_num = 3'b100;
					start_game_in = 1'b1;
					bullet_status = 6'b001000;
				end
			fourth_pause2:
				begin
					//inhibit_b = 1'b0;
					bullet_num = 3'b100;
					start_game_in = 1'b1;
				end
			fifth_bullet:
				begin
					bullet_num = 3'b101;
					start_game_in = 1'b1;
					bullet_status = 6'b010000;
				end
			fifth_pause:
				begin
					bullet_num = 3'b101;
					start_game_in = 1'b1;
					bullet_status = 6'b010000;
				end
			fifth_pause2:
				begin
					bullet_num = 3'b101;
					start_game_in = 1'b1;
				end
			sixth_bullet:
				begin
					bullet_num = 3'b110;
					start_game_in = 1'b1;
					bullet_status = 6'b100000;
				end
			sixth_pause:
				begin
					bullet_num = 3'b110;
					start_game_in = 1'b1;
					bullet_status = 6'b100000;
				end
			sixth_pause2:
				begin
					bullet_num = 3'b110;
					start_game_in = 1'b1;
				end
			stall:
				begin
				   bullet_num = 2'b00;
					start_game_in = 1'b1;
					//cnt_reset_b = 1'b1;
					//bullet_status = 6'b000000;
				end
			bullseye:
				begin
					inhibit = 1'b0;
					start_game_in = 1'b1;
				end
			DONE:
				begin
					finish_game = 1'b1;
					start_game_in = 1'b1;
				end
		endcase
	end
endmodule
	
module counter(input  logic  inhibit,  
					input  logic  clk,  			// clock input
					input  logic  reset,
					output logic  [3:0] out); // Output of the counter
	
	logic[3:0] tmp_cnt;
	
	always_ff @(posedge clk) begin
			out <= tmp_cnt;                         //Seperate logic to reduce ambiguity
		end
		
	always_comb begin
		tmp_cnt = out;
		if(reset) 
			begin
				tmp_cnt = 4'b0;                     //Reset counter
			end
		else if(inhibit) 
			begin
				tmp_cnt = tmp_cnt + 4'b0;           //Do not do anything during an inhibit bit
			end
		else
			begin
				tmp_cnt = tmp_cnt + 4'b0001;        //Else increment the counter
			end
	end
	
endmodule

module bullet_counter(input  logic  inhibit,  
					input  logic  clk,  			// clock input
					input  logic  reset,
					output logic  [1:0] out); // Output of the counter
	
	logic[1:0] tmp_cnt;
	
	always_ff @(posedge clk) begin
			out <= tmp_cnt;                         //Seperate logic to reduce ambiguity
		end
		
	always_comb begin
		tmp_cnt = out;
		if(reset) 
			begin
				tmp_cnt = 2'b00;                     //Reset counter
			end
		else if(inhibit) 
			begin
				tmp_cnt = tmp_cnt + 2'b00;           //Do not do anything during an inhibit bit
			end
		else
			begin
				tmp_cnt = tmp_cnt + 2'b01;        //Else increment the counter
			end
	end
	
endmodule