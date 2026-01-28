`timescale 1ns / 1ps

module simulation;

integer k;

reg [1:0] inputData;
wire [1:0] outputData;

reg clk;

always #10 clk = ~clk;

reg [1:0] data[9:0];

test_module UUT(
    .inputData(inputData),
    .outputData(outputData)
);

initial
begin
clk = 0;
k = 0;
// read data from file

$readmemb("input.data", data);
#20
for (k = 0; k < 10; k = k+1)
begin
    @(posedge clk);
        inputData <= data[k];
end


end

endmodule
