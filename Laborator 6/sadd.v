module compare (
    input a,    // Bitul din operandul A
    input b,    // Bitul din operandul B
    output o    // Ieșirea comparației (1 dacă a și b sunt egali, 0 altfel)
);
    assign o = (a & b);  // Dacă a și b sunt egali, ieșirea o este 1
endmodule


module sadd (
    input clk,
    input rst_b,
    input [3:0] a,  // Operandul A pe 4 biți
    input [3:0] b,  // Operandul B pe 4 biți
    output reg m,    // Bitul de sumă pentru fiecare poziție
    output reg carry_o  // Transportul (carry) pentru fiecare poziție
);

localparam S0_ST = 1'b0;
localparam S1_ST = 1'b1;

reg [1:0] st;
reg [1:0] st_next;

// Instanțierea comparatoarelor pentru fiecare bit
wire compare_result0, compare_result1, compare_result2, compare_result3;  // Rezultatele comparării pentru fiecare bit

// Instanțierea comparatoarelor pentru fiecare bit
compare comp0 (.a(a[0]), .b(b[0]), .o(compare_result0));  // Compară primul bit
compare comp1 (.a(a[1]), .b(b[1]), .o(compare_result1));  // Compară al doilea bit
compare comp2 (.a(a[2]), .b(b[2]), .o(compare_result2));  // Compară al treilea bit
compare comp3 (.a(a[3]), .b(b[3]), .o(compare_result3));  // Compară al patrulea bit

// Calculul sumei și carry-ului pe baza comparațiilor
always @(*) begin
    m = 1'b0;
    carry_o = 1'b0;
    case (st)
        S0_ST: begin
            if (compare_result0 == 0) begin  // Dacă bitii a[0] și b[0] nu sunt egali
                m = 1'b1;
                st_next = S0_ST;
            end
            else begin
                m = 1'b0;
                st_next = S1_ST;
            end
        end
        S1_ST: begin
            if (compare_result1 == 0) begin  // Dacă bitii a[1] și b[1] nu sunt egali
                m = 1'b1;
                st_next = S1_ST;
            end
            else begin
                m = 1'b0;
                st_next = S0_ST;
            end
        end
        default: begin
            st_next = S0_ST;
        end
    endcase
    carry_o = (st == S1_ST);  // Dacă suntem în starea S1, există carry
end

// Resetarea stării
always @(posedge clk or negedge rst_b) begin
    if (!rst_b)
        st <= S0_ST;
    else
        st <= st_next;
end

endmodule

`timescale 1ns / 1ps

module sadd_tb;

    reg clk;
    reg rst_b;
    reg [3:0] X;  // Primul operand pe 4 biți
    reg [3:0] Y;  // Al doilea operand pe 4 biți
    wire m;        // Bit de sumă pentru fiecare poziție
    wire carry_o;  // Transport (carry) pentru fiecare poziție

    // Instanțierea modulului sadd
    sadd uut (
        .clk(clk),
        .rst_b(rst_b),
        .a(X),  // Conectăm tot vectorul X
        .b(Y),  // Conectăm tot vectorul Y
        .m(m),
        .carry_o(carry_o)
    );

    integer i;  // Contor pentru pozițiile de bit

    // Inițializare semnale
    initial begin
        clk = 0;
        rst_b = 0;
        X = 4'b0110; // Valoare pentru X
        Y = 4'b0011; // Valoare pentru Y

        // Resetare
        #5 rst_b = 1;

        // Testarea adunării bit cu bit
        for (i = 0; i < 4; i = i + 1) begin
            #10;  // Pausă pentru a permite schimbarea valorilor

            // Afișare rezultatul parțial
            $display("Timp: %0t | Bit %0d | X: %b | Y: %b | Suma (m): %b | Carry: %b", 
                $time, i, X[i], Y[i], m, carry_o);
        end

        // Încheiere simulare
        #20 $finish;
    end

    // Generare semnal de ceas
    always #5 clk = ~clk;

endmodule
