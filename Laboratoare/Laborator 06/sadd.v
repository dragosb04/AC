module sadd (
	input clk, rst_b, x, y,
	output reg o
);
	
	reg carry;
	reg state;

	localparam S0_ST = 1'b0;
	localparam S1_ST = 1'b1;

	always @ (posedge clk or negedge rst_b) begin
		if (!rst_b) begin
			state <= S0_ST;
			carry <= 1'b0;
		end
		else begin
			
			case (state)
				S0_ST: begin
					if (x == 0 && y == 0) begin
						state <= S0_ST;
						carry <= 1'b0;
					end
					else if (x == 0 && y == 1) begin
						state <= S0_ST;
						carry <= 1'b0;
					end
					else if (x == 1 && y == 0) begin
						state <= S0_ST;
						carry <= 1'b0;
					end
					else begin
						state <= S1_ST;
						carry <= 1'b1;
					end
				end
				S1_ST: begin
					if (x == 0 && y == 0) begin
						state <= S0_ST;
						carry <= 1'b0;
					end else if ((x == 0 && y == 1) || (x == 1 && y == 0)) begin
						state <= S1_ST;
						carry <= 1'b1;
					end else if (x == 1 && y == 1) begin
						state <= S1_ST;
						carry <= 1'b1;
					end					
				end
			endcase 
		end
	end
	
	always @(*) begin
		o = x ^ y ^ carry;
	end
endmodule

module sadd_tb;

	reg clk, rst_b, x, y;
	wire o;

	localparam CLK_CYCLES = 5;
	localparam CLK_PERIOD = 50;
	localparam RST_PULSE = 25;

	sadd uut (
		.clk(clk),
		.rst_b(rst_b),
		.x(x),
		.y(y),
		.o(o)
	);

	initial begin
		clk = 1'b0;
		repeat (CLK_CYCLES*2) #(CLK_PERIOD) clk = ~clk; 
	end

	initial begin
		rst_b = 1'b0;
		#RST_PULSE rst_b = 1'b1;
	end

	initial begin
		x = 1'b0;
		y = 1'b1;

		#(CLK_PERIOD*2) x = 1'b1;
		#(CLK_PERIOD*2) y = 1'b0;
		
		#(CLK_PERIOD*2) x = 1'b0;

	end

endmodule
