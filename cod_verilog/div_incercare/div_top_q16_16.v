// ======================================================
// Modul top-level pentru divizor Q16.16
// Leaga controlerul de datapath
// Expune interfata valid/ready
// ======================================================
module div_top_q16_16 (
    input  wire clk,
    input  wire reset_n,

    // Intrare
    input  wire in_valid,
    output wire in_ready,
    input  wire [31:0] a,
    input  wire [31:0] b,

    // Iesire
    output wire out_valid,
    input  wire out_ready,
    output wire [31:0] q,
    output wire overflow
);

    // Semnale interne
    wire ld, step, done;

    // Control FSM
    div_control CTRL (
        .clk(clk),
        .reset_n(reset_n),
        .in_valid(in_valid),
        .in_ready(in_ready),
        .done(done),
        .out_ready(out_ready),
        .ld(ld),
        .step(step),
        .out_valid(out_valid)
    );

    // Datapath
    div_data_q16_16 DATA (
        .clk(clk),
        .reset_n(reset_n),
        .ld(ld),
        .step(step),
        .a(a),
        .b(b),
        .done(done),
        .q(q),
        .overflow(overflow)
    );

endmodule