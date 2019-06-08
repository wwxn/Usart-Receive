module order_handle
(
	input fifo_full,
	input fifo_empty,
	input clk,
	input rst_n,
	input [7:0] data_input,
	output reg [15:0] data,
	output reg rdreq
);

reg [15:0] data_buff;

reg [4:0] state;

always@(posedge clk)
begin 
	if(!rst_n)
	begin
		data_buff<=16'b0;
		data<=16'b0;
		state<=5'd1;
		rdreq<=1'b0;
	end
	else if(!state)
	begin
		state<=5'd1;
	end
	else
		case (state)
		1:
		begin
			if(fifo_full)
			begin
				state<=state+1'b1;
			end
		end
		20:
		begin
			if(fifo_empty)
			begin
				
				data<=data_buff[15:12]*1000+data_buff[11:8]*100+data_buff[7:4]*10+data_buff[3:0];
				data_buff<=16'd0;
				state<=5'b1;
				rdreq<=1'b0;
			end
			else
			begin
				rdreq<=1'b1;
				data_buff<=(data_buff<<4)+data_input-8'h30;
			end
		end
		default:
			state<=state+1'b1;
		endcase
end

endmodule 
