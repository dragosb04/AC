module dec_1of4 (
	input e,
	input [1:0] s,
	output reg [3:0] o
);

	always @(*) begin
		if (e)
			case (s)
				2'b00: o = 4'b0001;
				2'b01: o = 4'b0010;
				2'b10: o = 4'b0100;
				2'b11: o = 4'b1000;
		endcase
	end

endmodule

module register_8bit (
	input [7:0] d,
	input ld, clk, rst_b,
	output reg [7:0] q
);

	always @(posedge clk or negedge rst_b) begin
		if (!rst_b)
			q <= 8'b00000000;
		else if (ld)
			q <= d;
	end

endmodule

module mux_4to1 (
	input [7:0] d0, d1, d2, d3,
	input s,
	output reg [7:0] o
);

	always @(*) begin
		case (s)
			2'b00: o = d0;
			2'b01: o = d1;
			2'b10: o = d2;
			2'b11: o = d3;
		endcase
	end

endmodule

module regfl_4x8 (
	input clk, rst_b, wr_e,
	input [1:0] wr_addr, rd_addr,
	input [7:0] wr_data,
	output [7:0] rd_data
);
	wire [3:0] dec_out;
	wire [7:0] reg_out[3:0];

	dec_1of4 uut (
		.e(wr_e),
		.s(wr_addr),
		.o(dec_out)
	);

	genvar i;
	generate
		for (i = 0; i < 4; i = i + 1) begin
			register_8bit cut (
				.d(wr_data),
				.ld(dec_out[i]),
				.clk(clk),
				.rst_b(rst_b),
				.q(reg_out[i])
			);
		end
	endgenerate

	mux_4to1 dut (
		.d0(reg_out[0]),
		.d1(reg_out[1]),
		.d2(reg_out[2]),
		.d3(reg_out[3]),
		.s(rd_addr),
		.o(rd_data)
	);

endmodule

module regfl_4x8_tb;

	localparam CLK_PERIOD = 100;
	localparam CLK_CYCLES = 9;
	localparam RST_PULSE = 5;

	reg clk, rst_b, wr_e;
	reg [1:0] wr_addr, rd_addr;
	reg [7:0] wr_data;
	wire [7:0] rd_data;

	regfl_4x8 uut (
		.clk(clk),
		.rst_b(rst_b),
		.wr_e(wr_e),
		.wr_addr(wr_addr),
		.rd_addr(rd_addr),
		.wr_data(wr_data),
		.rd_data(rd_data)
	);

	initial begin
		clk = 1'b0;
		repeat (2* CLK_CYCLES) #(CLK_PERIOD / 2) clk = ~clk;
	end

	initial begin
		rst_b = 1'b0;
		#RST_PULSE rst_b = 1'b1;
	end

	initial begin
		// Inițializare
		wr_e = 1'b0;
		wr_addr = 2'b00;
		rd_addr = 2'b00;
		wr_data = 8'b00000000;

		// Scrierea în registre conform cerinței
		#(CLK_PERIOD / 2) wr_e = 1'b1; wr_addr = 2'h0; wr_data = 8'ha2; // Scrie 0xA2 în registrul 0
		#CLK_PERIOD wr_addr = 2'h2; wr_data = 8'h2e; // Scrie 0x2E în registrul 2
		#CLK_PERIOD wr_addr = 2'h1; wr_data = 8'h98; // Scrie 0x98 în registrul 1
		#CLK_PERIOD wr_addr = 2'h3; wr_data = 8'h55; // Scrie 0x55 în registrul 3
		#CLK_PERIOD wr_addr = 2'h0; wr_data = 8'h20; // Scrie 0x20 în registrul 0
		#CLK_PERIOD wr_addr = 2'h1; wr_data = 8'hff; // Scrie 0xFF în registrul 1
		#CLK_PERIOD wr_addr = 2'h3; wr_data = 8'hc7; // Scrie 0xC7 în registrul 3
		#CLK_PERIOD wr_addr = 2'h2; wr_data = 8'hb5; // Scrie 0xB5 în registrul 2
		#CLK_PERIOD wr_addr = 2'h3; wr_data = 8'h91; // Scrie 0x91 în registrul 3

		// Dezactivează scrierea
		#CLK_PERIOD wr_e = 1'b0;

		// Citirea din registre conform cerinței
		#(CLK_PERIOD / 2) rd_addr = 2'h3; // Citește registrul 3
		#CLK_PERIOD rd_addr = 2'h0; // Citește registrul 0
		#CLK_PERIOD rd_addr = 2'h1; // Citește registrul 1
		#CLK_PERIOD rd_addr = 2'h2; // Citește registrul 2
		#CLK_PERIOD rd_addr = 2'h0; // Citește registrul 0
		#CLK_PERIOD rd_addr = 2'h3; // Citește registrul 3
		#CLK_PERIOD rd_addr = 2'h1; // Citește registrul 1
		#CLK_PERIOD rd_addr = 2'h2; // Citește registrul 2
		#CLK_PERIOD rd_addr = 2'h3; // Citește registrul 3

		// Finalizează simularea
		#CLK_PERIOD $finish;
	end

endmodule
