module bcm (
	input [2:0] d,
	output reg [1:0] o
);

	always @(*) begin
		case (d)
			3'b000: o = 2'b01;
			3'b001: o = 2'b11;
			3'b010: o = 2'b00;
			3'b011: o = 2'b10;
			3'b100: o = 2'b01;
			3'b101: o = 2'b10;
			3'b110: o = 2'b11;
			3'b111: o = 2'b01;
		endcase
	end

endmodule

module bcm_tb;

	reg [2:0] d;
	wire [1:0] o;

	integer i;
	
	bcm uut (
		.d(d),
		.o(o)
	);
	
	initial begin
		d = 0;
		for (i = 1; i < 8; i = i + 1)
			#10 d = i; 
	end

endmodule
