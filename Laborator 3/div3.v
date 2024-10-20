module div3 (
    input [3:0] i,
    output reg [2:0] o
);
  always @(*) begin
    if (i < 3) o = 0;
    else if (i < 6) o = 1;
    else if (i < 9) o = 2;
    else if (i < 12) o = 3;
    else if (i < 15) o = 4;
    else o = 5;
  end
endmodule

module div3_tb;
  reg  [3:0] i;
  wire [2:0] o;

  div3 div3_i (
      .i(i),
      .o(o)
  );

  integer k;
  initial begin
    $display("Time\ti\t\to");
    $monitor("%0t\t%b(%2d)\t%b(%0d)", $time, i, i, o, o);
    i = 0;
    for (k = 1; k < 16; k = k + 1) #10 i = k;
  end
endmodule
