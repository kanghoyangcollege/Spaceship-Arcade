/************************************************************************
Avalon-MM Interface for AES Decryption IP Core

Dong Kai Wang, Fall 2017

For use with ECE 385 Experiment 9
University of Illinois ECE Department

Register Map:

 0-3 : 4x 32bit AES Key
 4-7 : 4x 32bit AES Encrypted Message
 8-11: 4x 32bit AES Decrypted Message
   12: Not Used
	13: Not Used
   14: 32bit Start Register
   15: 32bit Done Register

************************************************************************/

module avalon_aes_interface (
	// Avalon Clock Input
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input  logic AVL_READ,					// Avalon-MM Read
	input  logic AVL_WRITE,					// Avalon-MM Write
	input  logic AVL_CS,						// Avalon-MM Chip Select
	input  logic [3:0] AVL_BYTE_EN,		// Avalon-MM Byte Enable
	input  logic [3:0] AVL_ADDR,			// Avalon-MM Address
	input  logic [31:0] AVL_WRITEDATA,	// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,	// Avalon-MM Read Data
	
	// Exported Conduit
	output logic [31:0] EXPORT_DATA		// Exported Conduit Signal to LEDs
);

	logic [31:0] write_data, key0_data, key1_data, key2_data, key3_data, en0_data, en1_data, en2_data, en3_data,
					 de0_data, de1_data, de2_data, de3_data, start_data, done_data;	
	logic [31:0] aes_key0, aes_key1, aes_key2, aes_key3, aes_msg_en0, aes_msg_en1, aes_msg_en2, aes_msg_en3,
					 aes_msg_de0, aes_msg_de1, aes_msg_de2, aes_msg_de3, aes_start, aes_done;
	logic [127:0] decrypt_msg;
	logic done;
	
	always_ff @(posedge CLK)
	begin
		key0_data <= aes_key0;
		key1_data <= aes_key1;
		key2_data <= aes_key2;
		key3_data <= aes_key3;
		
		en0_data <= aes_msg_en0;
		en1_data <= aes_msg_en1;
		en2_data <= aes_msg_en2;
		en3_data <= aes_msg_en3;
		
		de0_data <= aes_msg_de0;
		de1_data <= aes_msg_de1;
		de2_data <= aes_msg_de2;
		de3_data <= aes_msg_de3;
		
		start_data <= aes_start;
		done_data <= aes_done;
	end
	
	// Decide which register to read
	always_comb
	begin
		AVL_READDATA = 32'd0;
		if(AVL_CS & AVL_READ)
		begin
			case(AVL_ADDR)
				4'd0: AVL_READDATA = key0_data;
				4'd1: AVL_READDATA = key1_data;
				4'd2: AVL_READDATA = key2_data;
				4'd3: AVL_READDATA = key3_data;
				4'd4: AVL_READDATA = en0_data;
				4'd5: AVL_READDATA = en1_data;
				4'd6: AVL_READDATA = en2_data;
				4'd7: AVL_READDATA = en3_data;
				4'd8: AVL_READDATA = de0_data;
				4'd9: AVL_READDATA = de1_data;
				4'd10: AVL_READDATA = de2_data;
				4'd11: AVL_READDATA = de3_data;
				4'd14: AVL_READDATA = start_data;
				4'd15: AVL_READDATA = done_data;
			endcase
		end
	end

	always_comb
	begin
		write_data = 32'd30;
		if(AVL_CS & AVL_WRITE)
			begin
			if (AVL_BYTE_EN[0])
				write_data[7:0] = AVL_WRITEDATA[7:0];
		
			if (AVL_BYTE_EN[1])
				write_data[15:8] = AVL_WRITEDATA[15:8];
		
			if (AVL_BYTE_EN[2])
				write_data[23:16] = AVL_WRITEDATA[23:16];
		
			if (AVL_BYTE_EN[3])
				write_data[31:24] = AVL_WRITEDATA[31:24];
			end
	end
	assign EXPORT_DATA = {key0_data[31:16], key3_data[15:0]};

	always_comb
	begin
		aes_key0 = key0_data;
		aes_key1 = key1_data;
		aes_key2 = key2_data;
		aes_key3 = key3_data;
	
		aes_msg_en0 = en0_data;
		aes_msg_en1 = en1_data;
		aes_msg_en2 = en2_data;
		aes_msg_en3 = en3_data;
		
		aes_msg_de0 = de0_data;
		aes_msg_de1 = de1_data;
		aes_msg_de2 = de2_data;
		aes_msg_de3 = de3_data;
		
		aes_start = start_data;
		aes_done = done_data;
		
		if(AVL_CS & AVL_WRITE)
		begin
			case(AVL_ADDR)
				4'd0:
					aes_key0 = write_data;
				4'd1:
					aes_key1 = write_data;
				4'd2:
					aes_key2 = write_data;
				4'd3:
					aes_key3 = write_data;
				4'd4:
					aes_msg_en0 = write_data;
				4'd5:
					aes_msg_en1 = write_data;
				4'd6:
					aes_msg_en2 = write_data;
				4'd7:
					aes_msg_en3 = write_data;
				4'd8:
					if(done | start_data[0])
						aes_msg_de3 = decrypt_msg[31:0];
					else
						aes_msg_de3 = write_data;
				4'd9:
					if(done | start_data[0])
						aes_msg_de2 = decrypt_msg[63:32];
					else
						aes_msg_de2 = write_data;
				4'd10:
					if(done | start_data[0])
						aes_msg_de1 = decrypt_msg[95:64];
					else
						aes_msg_de1 = write_data;
				4'd11:
					if(done | start_data[0])
						aes_msg_de0 = decrypt_msg[127:96];
					else
						aes_msg_de0 = write_data;
				4'd14:
					aes_start = write_data;
				4'd15:
					if(done)
						aes_done = 32'd1;
					else
						aes_done = write_data;
			endcase
		end
		else if(done | start_data[0])
		begin
				aes_msg_de3 = decrypt_msg[31:0];
				aes_msg_de2 = decrypt_msg[63:32];
				aes_msg_de1 = decrypt_msg[95:64];
				aes_msg_de0 = decrypt_msg[127:96];
				if(done)
					aes_done = 32'd1;
		end
	end
	
endmodule

