module sadd (
    input clk,
    input rst_b,
    input a,
    input b,
    output reg m
);

  localparam S0_ST = 1'b0;
  localparam S1_ST = 1'b1;

  reg [1:0] st;
  reg [1:0] st_next;

  always @(*) begin
    m = 1'b0;
    case (st)
      S0_ST:
      if (a && b) begin
        st_next = S1_ST;
        m = 1'b0;
      end else if (!a && !b) begin
        st_next = S0_ST;
        m = 1'b0;
      end else begin
        st_next = S0_ST;
        m = 1'b1;
      end
      S1_ST:
      if (a && b) begin
        st_next = S1_ST;
        m = 1'b1;
      end else if (!a && !b) begin
        st_next = S0_ST;
        m = 1'b1;
      end else begin
        st_next = S1_ST;
        m = 1'b0;
      end
    endcase
  end
  always @(posedge clk, negedge rst_b)
    if (!rst_b) st <= S0_ST;
    else st <= st_next;
endmodule

module sadd_tb;
  reg clk;
  reg rst_b;
  reg [3:0] X;
  reg [3:0] Y;
  reg a;
  reg b;
  wire m;

  sadd uut (
      .clk(clk),
      .rst_b(rst_b),
      .a(a),
      .b(b),
      .m(m)
  );

  initial begin
    clk = 0;
    rst_b = 0;
    X = 4'b0110;
    Y = 4'b0011;

    {a, b} = 'b01;
    #100{a, b} = 'b11;
    #100{a, b} = 'b10;
    #100{a, b} = 'b00;

    #20 $finish;
  end
  always #20 clk = ~clk;
endmodule
