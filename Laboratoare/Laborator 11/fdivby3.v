module fdivby3 (
	input clk, rst_b, clr, c_up,
	output fdclk
);
	
	localparam S0 = 3'b000;
	localparam S1 = 3'b001;
	localparam S2 = 3'b010;

	reg [2:0] state;
	wire [2:0] state_nxt;

	always @(posedge clk or negedge rst_b) begin
		if (!rst_b) begin
			state <= S0;
			state[S0] <= 3'b001;
		end
		else
			state <= state_nxt;
	end

	assign state_nxt[S0] = (state[S0] & (~c_up | clr)) | (state[S1] & clr) | (state[S2] & (c_up | clr));
	assign state_nxt[S1] = (state[S1] & (~c_up & ~clr)) | (state[S0] & (c_up & ~clr));
	assign state_nxt[S2] = (state[S1] & (c_up & ~clr)) | (state[S2] & (~c_up & ~clr)); 
	
	assign fdclk = (state[S0] == 1);

endmodule

module fdivby3_tb;

	localparam CLK_PERIOD = 100;
	localparam CLK_CYCLES = 15;
	localparam RST_PULSE = 25;

	reg clk, rst_b, clr, c_up;
	wire fdclk;
	
	fdivby3 uut (
		.clk(clk),
		.rst_b(rst_b),
		.clr(clr),
		.c_up(c_up),
		.fdclk(fdclk)
	);

  	initial begin
		clk = 1'b0;
		repeat (2 * CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
	end	

	initial begin
		rst_b = 1'b0;
		#(RST_PULSE) rst_b = 1'b1;
	end


	initial begin
		clr = 1'b0;
		c_up = 1'b1;
		#(4 * CLK_PERIOD) clr = 1'b1;
		#(CLK_PERIOD) clr = 1'b0;
		#(CLK_PERIOD) c_up = 1'b0;
		#(CLK_PERIOD) c_up = 1'b1;
		#(4 * CLK_PERIOD) c_up = 1'b0;
		#(CLK_PERIOD) c_up = 1'b1;
  end
endmodule
