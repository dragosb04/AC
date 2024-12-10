module pktmux (
  input [63:0] pkt,
  input [63:0] msg_len,
  input pad_pkt,
  input zero_pkt,
  input mgln_pkt,
  output reg [63:0] o
);
  always @(*) begin
    if (pad_pkt)
      o = 64'h8000000000000000;
    else if (zero_pkt)
      o = 64'h0000000000000000;
    else if (mgln_pkt)
      o = msg_len;
    else
      o = pkt;
  end
endmodule

module pktmux_tb;
  reg [63:0] pkt, msg_len;
  reg pad_pkt, zero_pkt, mgln_pkt;
  wire [63:0] o;
  
  pktmux uut (.pkt(pkt), .msg_len(msg_len), .pad_pkt(pad_pkt), .zero_pkt(zero_pkt), .mgln_pkt(mgln_pkt), .o(o));
  
  task urand64 (output reg [63:0] r);
    begin
      r[63:32] = $urandom;
      r[31:0] = $urandom;
    end
  endtask
  
  initial begin
    pad_pkt = 0;
    zero_pkt = 0;
    mgln_pkt = 0;
    
    urand64(pkt);
    urand64(msg_len);
    
    #10 pad_pkt = 1;
    #10 pad_pkt = 0;
    
    #10 zero_pkt = 1;
    #10 zero_pkt = 0;
    
    #10 mgln_pkt = 1;
    #10 mgln_pkt = 0;
    
    #10 $finish;
  end
endmodule
