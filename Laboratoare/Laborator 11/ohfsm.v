module ohfsm (
	input clk, rst_b, a, b, c,
	output m, n
);
	
	localparam S0 = 2'b00;
	localparam S1 = 2'b01;
	localparam S2 = 2'b10;
	localparam S3 = 2'b11;

	reg [3:0] state;
	wire [3:0] state_nxt;
	
	assign state_nxt[S0] = (state[S0] & ~a) | (state[S3] & b);
	assign state_nxt[S1] = (state[S0] & (a & ~b)) | (state[S2] & ~c); 
	assign state_nxt[S2] = (state[S1]) | (state[S0] & (a & b));
	assign state_nxt[S3] = (state[S2] & c) | (state[S3] & ~b);

	assign m = (state[S0] & ~a) | (state[S0] & a & ~b) | state[S1];
	assign n = (state[S0] & ~b) | (state[S0] & a & b) | (state[S2] & c) | (state[S3] & ~b) | (state[S3] & b);
	
	always @(posedge clk, negedge rst_b) begin
		if (!rst_b) begin
			state <= S0;
			state[S0] <= 1;
		end
		else
			state <= state_nxt;
	end
	
endmodule
