`timescale 1ns / 1ps


module Pixel_Digital(Shift, Phase3,Ser_in, Sh_clk, clr_FF, Pix_clk, Ser_Out);
    input Shift, Phase3,Ser_in, Sh_clk, clr_FF, Pix_clk;
    output Ser_Out;
    
    wire NOR_in, XNOR_out, Gated_sh_clk, Mux1_out, Sft_reg_Clk, Sft_in, Q6_out; 
    
    SR_ff SRF(.s(Pix_clk),
              .r(clr_FF),
              .q(NOR_in)
              );

    nor n1(Gated_sh_clk, NOR_in, ~Sh_clk);
        
    mux_2by1 M1(.Y(Mux1_out), 
                .D0(Pix_clk), 
                .D1(Gated_sh_clk), 
                .S(Phase3)
                );
        
    mux_2by1 M2(.Y(Sft_reg_Clk), 
                .D0(Mux1_out), 
                .D1(Sh_clk), 
                .S(Shift)
                );
    xnor xn(XNOR_out, Ser_Out, Q6_out);            
    
    mux_2by1 M3(.Y(Sft_in), 
                .D0(XNOR_out), 
                .D1(Ser_in), 
                .S(Shift)
                );
                
    shift_Reg_10bit SftR(.Clk(Sft_reg_Clk),
                         .SI(Sft_in), 
                         .Q6_out(Q6_out), 
                         .SO(Ser_Out)
                         );
endmodule


module shift_Reg_10bit(Clk, SI, Q6_out, SO); 
input  Clk, SI; 
output SO;
output Q6_out;
 
reg [9:0] tmp; 
 
  always@(posedge Clk) 
        tmp = {tmp[8:0],SI}; 

  assign SO  = tmp[9];
  assign Q6_out  = tmp[6]; 
endmodule 


module SR_ff(s,r,q);
input s,r;
output q;
wire s,r,clk;
reg q,q_bar;

always@(s,r) 
begin
   case({s,r})
    {1'b0,1'b0}: begin q<=q;    q_bar<=q_bar; end
    {1'b0,1'b1}: begin q<=1'b0; q_bar<=1'b1;  end
    {1'b1,1'b0}: begin q<=1'b1; q_bar<=1'b0;  end
    {1'b1,1'b1}: begin q<=1'bx; q_bar<=1'bx;  end
   endcase
end
endmodule


module mux_2by1(Y, D0, D1, S);
output Y;
input D0, D1, S;

wire T1, T2, Sbar;

and a1(T1, D1, S), 
    a2(T2, D0, Sbar);
not n1(Sbar, S);
or o1(Y, T1, T2);

endmodule