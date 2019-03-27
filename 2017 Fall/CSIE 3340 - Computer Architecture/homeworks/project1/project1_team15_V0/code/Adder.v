module Adder(
    data1_i, 
    data2_i, 
    data_o
);

    input   [31:0]  data1_i, data2_i;
    output  [31:0]  data_o;

    assign  data_o = data1_i + data2_i;

endmodule
