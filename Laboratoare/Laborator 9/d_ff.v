module d_ff (
	input clk, rst_b, set_b, d,
	output reg q
);
	
	always @(posedge clk or negedge rst_b or negedge set_b) begin
		if (!set_b)
			q <= 1'b1;
		else if (!rst_b)
			q <= 1'b0;
		else
			q <= d;
	end
endmodule
