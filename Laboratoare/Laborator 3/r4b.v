module r4b (
  input clk,
  input rst_b,
  input ld,
  input sh,
  input sh_in,
  input [3:0] d,
  output reg [3:0] q
);
  always @(posedge clk or negedge rst_b) begin
    if (!rst_b) begin
      q <= 4'b0000;
    end else begin
      if (ld) begin
        q <= d;
      end else if (sh) begin
        q <= {sh_in, q[3:1]};
      end
    end
  end
endmodule

module r4b_tb;
  reg clk, rst_b, ld, sh, sh_in;
  reg [3:0] d;
  wire [3:0] q;

  r4b r4b_i (.clk(clk), .rst_b(rst_b), .ld(ld), .sh(sh), .sh_in(sh_in), .d(d), .q(q));

  initial begin
    {clk, rst_b} = 0;
    #5 rst_b = 1;
    #45 clk = 1;
    repeat (40)
      #50 clk = ~clk;
  end

  integer k, l;
  initial begin
    $display("Time\top\td\tsh_in\tq");
    {d, sh_in} = 0; {ld, sh} = 0;
    for (k = 0; k < 32; k = k + 1) begin
      $display("%0t\t%s\t%b\t%b\t%b", $time, (ld) ? "LOAD" : (sh) ? "SHIFT" : "NO_OP", d, sh_in, q);
      #100 l = $urandom; {d, sh_in} = l[6:2]; {ld, sh} = l[1:0] % 3;
    end
    $display("%0t\t%s\t%b\t%b\t%b", $time, (ld) ? "LOAD" : (sh) ? "SHIFT" : "NO_OP", d, sh_in, q);
  end
endmodule
