module cmp2b (
	input [1:0] x,
	input [1:0] y,
	output eq,
	output lt,
	output gt
);
	assign eq = (x == y);
	assign lt = (x < y);
	assign gt = (x > y);

endmodule

module cmp2b_tb;
	
	reg [1:0] x;
	reg [1:0] y;
	wire eq;
	wire lt;
	wire gt;

	cmp2b uut (.x(x), .y(y), .eq(eq), .lt(lt), .gt(gt));

	integer i;

	initial begin
    $display("x  y  | eq lt gt");
    $display("------|------");
	
		for (i = 0; i < 16; i = i + 1) begin
			{x, y} = i[3:0];
			#20;
        $display("%b %b | %b  %b  %b", x, y, eq, lt, gt);
	end
	end

endmodule
