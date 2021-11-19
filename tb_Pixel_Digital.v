module SR_ff_tb;
 
reg clk;
reg reset;
reg s,r;
 
wire q;
wire qb;
 
SR_ff srflipflop( .clk(clk), .reset(reset), .s(s), .r(r), .q(q), .q_bar(qb) );
 
initial begin
$monitor(clk,s,r,q,qb,reset);
 
s = 1'b0;
r = 1'b0;
reset = 1;
clk=1;
 
#10
reset=0;
s=1'b1;
r=1'b0;
 
#100
reset=0;
s=1'b0;
r=1'b1;
 
#100
reset=0;
s=1'b1;
r=1'b1;
 
#100
reset=0;
s=1'b0;
r=1'b0;
 
#100
reset=1;
s=1'b1;
r=1'b0;
 
end
always #25 clk <= ~clk;
 
endmodule

module m21(Y, D0, D1, S);

output Y;
input D0, D1, S;
wire T1, T2, Sbar;

and (T1, D1, S), (T2, D0, Sbar);
not (Sbar, S);
or (Y, T1, T2);

endmodule