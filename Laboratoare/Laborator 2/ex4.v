module ex4 (
	input [5:0] i,
	output is6
);

	assign is6 = (i / 10 == 6) ? 1 : 0;

endmodule

module ex4_tb;

	reg [5:0] i;
	wire is6;

	ex4 uut (
		.i(i),
		.is6(is6)
	);
		
	integer k;

	initial begin
		$display("Time\ti\to");
		$monitor("%0t\t%d\t%b", $time, i, is6);
		i = 0;
		for (k = 0; k < 64; k = k + 1)
			#10 i = k; 
	end

endmodule
