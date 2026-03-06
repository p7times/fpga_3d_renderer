module mult_data #(
    parameter N = 8
)(
    input ck,
    input reset_n,
    input ld,
    input signed [N-1:0] deinmultit,
    input signed [N-1:0] inmultitor,
    output reg done,
    output reg signed [2*N-1:0] produs
);

reg signed [N-1:0] A;  
reg signed [2*N:0] booth;
reg signed [N-1:0] M, Q;
reg Q_1;
reg [255:0] cnt; // count

always @(posedge ck or negedge reset_n) begin
    if (!reset_n) begin
        A <= 0; M <= 0; Q <= 0; Q_1 <= 0;
        cnt <= 0; done <= 0; produs <= 0;
    end
    else if (ld) begin
        A <= 0;
        M <= deinmultit;
        Q <= inmultitor;
        Q_1 <= 0;
        cnt <= 0;
        done <= 0;
    end
    else if (!done) begin
        booth = {A, Q, Q_1};
        case ({Q[0], Q_1})
            2'b01: booth = {A + M, Q, Q_1} >>> 1;
            2'b10: booth = {A - M, Q, Q_1} >>> 1;
            default: booth = {A, Q, Q_1};
        endcase
        
        booth = booth >>> 1;
        {A, Q, Q_1} = booth;

        cnt = cnt + 1;

        if (cnt == N-1) begin
            produs = booth[2*N:1];
            done = 1;
        end
    end
end

endmodule