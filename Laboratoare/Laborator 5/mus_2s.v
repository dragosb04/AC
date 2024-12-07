module mux_2s #(
    parameter width = 4
) (
    input [width - 1 : 0] d0,
    input [width - 1 : 0] d1,
    input [width - 1 : 0] d2,
    input [width - 1 : 0] d3,
    input [1:0] s,
    output [width - 1 : 0] o
);

  wire [width - 1 : 0] w;

  assign w =  (s == 2'b00) ? d0 : (s == 2'b01) ? d1 : (s == 2'b10) ? d2 :(s == 2'b11) ? d3 : {width{1'bz}};
  assign o = w;

endmodule

module mux_2s_tb;

  parameter width = 4;

  reg [width - 1 : 0] d0, d1, d2, d3;
  reg [1 : 0] s;
  wire [width - 1 : 0] o;

  integer i;

  mux_2s #(
      .width(width)
  ) uut (
      .d0(d0),
      .d1(d1),
      .d2(d2),
      .d3(d3),
      .s (s),
      .o (o)
  );

  initial begin
    d0 = 4'b0001;
    d1 = 4'b0010;
    d2 = 4'b0100;
    d3 = 4'b1000;

    $display("Test");

    for (i = 0; i < 4; i = i + 1) begin
      s = i[1:0];
      #20;
      $display("s=%b, o=%b (%b)", s, o, (s == 2'b00) ? d0 : (s == 2'b01) ? d1 : (s == 2'b10) ? d2 : d3);
    end

    $finish;
  end

endmodule

