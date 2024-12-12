module fsmm (
	input clk, rst_b, A6, X3, I3,
	output o
);

	localparam S0 = 0;
	localparam S1 = 1;
	localparam S2 = 2;
	localparam S3 = 3;

	reg [3:0] state;
	wire [3:0] state_nxt;

	always @(posedge clk, negedge rst_b) begin
		if (!rst_b)
			state <= 4'b0001;
		else
			state <= state_nxt;
	end

	assign state_nxt[S0] = (state[S0] & ((A6 & X3 & I3) | X3)) | (state[S1]);
	assign state_nxt[S1] = (state[S0] & ((I3 & A6) | (I3&X3)));
	assign state_nxt[S2] = (state[S0] & ((I3 & X3) | (A6 & X3& I3))) | (state[S1] & (A6 &I3)) | (state[S2] & ((I3 & A6) | X3)) | ( state[S3] & ((X3 &A6) | (A6 & I3)));
	assign state_nxt[S3] = (state[S0] & X3);

	assign o = state[S0];
endmodule

module fsmm_tb;
  reg clk, rst_b, a6, x3, i3;
  wire o;
  
  localparam CLK_PERIOD = 100;
  localparam CLK_CYCLES = 20;
  localparam RST_PULSE = 75;
  
	fsmm uut (
		.clk(clk),
		.rst_b(rst_b),
		.A6(a6),
		.X3(x3),
		.I3(i3),
		.o(o)
	);	

  initial begin
    rst_b = 1'b0;
    #(RST_PULSE) rst_b = 1'b1;
  end
  
  initial begin 
    clk = 1'b0;
    repeat (2 * CLK_CYCLES) #(CLK_PERIOD/2) clk = ~clk;
  end
  
  initial begin
    a6 = 1'b0;
    x3 = 1'b1;
    i3 = 1'b1;
    
    #(CLK_PERIOD/2) i3 = ~i3;
    #(CLK_PERIOD/2) x3 = ~x3;
    a6 = ~a6;
    #(CLK_PERIOD/2) i3 = ~i3;
    #(CLK_PERIOD/2) a6 = ~a6;
    #(CLK_PERIOD/2) i3 = ~i3;
    x3 = ~x3;
    #(CLK_PERIOD) i3 = ~i3;
    #(CLK_PERIOD/2) i3 = ~x3;
    a6 = ~a6;
    #(CLK_PERIOD/2) i3 = ~i3;
    #(CLK_PERIOD) i3 = ~i3;
    x3 = ~x3;
    #(CLK_PERIOD/2) i3 = ~i3;
    #(CLK_PERIOD/2) x3 = ~x3;
    #(CLK_PERIOD) i3 = ~i3;
    x3 = ~x3;
  end
    
  initial begin 
    #(CLK_CYCLES * CLK_PERIOD) $finish;
  end
endmodule
