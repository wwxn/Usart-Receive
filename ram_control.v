module ram_control
(
	input clk,
	input rst_n,
	input [7:0] data_input,
	input rx_valid,
	output  [27:0]freq_out,
	output reg set_flag
);

reg [27:0] freq_reg;
reg [5:0] state;
assign freq_out=(set_flag)?freq_reg:freq_out;

always@(posedge clk)
begin
	if(!rst_n)
	begin
		freq_reg<=28'd0;
		state<=6'd1;
		set_flag<=1'd0;
	end
	else if(!state)
		state<=6'd1;
	else if(rx_valid)
		case(state)
		1:
		begin
			if(data_input==8'hff)
			begin
				set_flag=1'b0;
				state<=state+1'b1;
				freq_reg<=28'd0;
				
			end
			else
			begin
				
				set_flag<=1'b1;
			end
		end
		2:
		begin
			if(data_input==8'hfe)
				state<=6'd1;
			else
				freq_reg<=(freq_reg<<8)|data_input;
		end
		endcase
end



endmodule 