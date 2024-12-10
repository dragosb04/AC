module patt (
	input clk, rst_b, x,
	output reg q
);

	localparam S0 = 3'b000;
	localparam S1 = 3'b001;
	localparam S2 = 3'b010;
	localparam S3 = 3'b011;
	localparam S4 = 3'b100;

	reg[2:0] state;

	always @(posedge clk, negedge rst_b) begin
		$monitor("%3b\t", state);
		if (!rst_b) begin
			state <= S0;
		end
		case (state)
			S0: begin
				if (x == 1'b0)
					state <= S0;
				else
					state <= S1;
			end
			S1: begin
				if (x == 1'b0)
					state <= S2;
				else
					state <= S1;
			end
			S2: begin
				if (x == 1'b0)
					state <= S0;
				else
					state <= S3;
			end
			S3: begin
				if (x == 1'b0)
					state <= S2;
				else
					state <= S4;
			end
			S4: begin
				if (x == 1'b0)
					state <= S2;
				else
					state <= S1;
			end
		endcase
	end

	always @(*) begin
		q = (state == S4);
	end	

endmodule

module patt_tb;
	
	reg clk, rst_b, i;
	wire q;

	localparam CLK_PERIOD = 50;
	localparam RST_PULSE = 25;
	localparam CLK_CYCLES = 8;
	
	patt uut (
		.clk(clk),
		.rst_b(rst_b),
		.x(i),
		.q(q)
	);
	
	initial begin
		clk = 1'b0;
		forever #(CLK_PERIOD) clk = ~clk;
	end

	initial begin
		rst_b = 1'b0;
		#(RST_PULSE) rst_b = ~rst_b;
	end

	initial begin
        i = 1'b1;
        #(CLK_PERIOD*2)   i = 1'b0;           // 10
        #(CLK_PERIOD*2)   i = 1'b1;           // 101
        #(CLK_PERIOD*2)   i = 1'b1;           // 1011
        #(CLK_PERIOD*2)   i = 1'b0;           // 10110
        #(CLK_PERIOD*2)   i = 1'b1;           // 101101
        #(CLK_PERIOD*2)   i = 1'b1;           // 1011011
        #(CLK_PERIOD*2)   $finish; 
	end

endmodule
