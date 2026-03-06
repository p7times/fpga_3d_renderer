module sub_q_16_16(
    input  signed [31:0] a, b,     // operanzi in format Q16.16 (32-bit signed fixed-point)
    output               overflow, // flag de overflow (pentru debug / saturatie)
    output signed [31:0] dif       // rezultat Q16.16, cu saturatie
);

    // Limitele pe 32 de biti semnati.
    // In format Q16.16 acestea corespund valorilor maxime/minime reprezentabile
    // dupa saturatie (nu limitelor matematice ±32768).
    localparam signed [31:0] MAX = 32'sh7FFF_FFFF;
    localparam signed [31:0] MIN = 32'sh8000_0000;

    // Rezultatul brut al scaderii (fara saturatie)
    wire signed [31:0] raw_dif;

    // Scadere propriu-zisa (aritmetica pe 32 de biti semnati)
    assign raw_dif = a - b;

    // Detectarea overflow-ului la scadere:
    // - overflow poate aparea doar daca a si b au semne diferite
    // - iar semnul rezultatului difera de semnul lui a
    // Formula este echivalenta cu analiza clasica a overflow-ului
    // pentru a + (-b)
    assign overflow = (a[31] ^ b[31]) & (raw_dif[31] ^ a[31]);

    // Aplicarea saturatiei:
    // - daca overflow = 0 -> rezultatul brut este valid
    // - daca overflow = 1:
    //     * a pozitiv  -> rezultat prea mare  -> saturatie la MAX
    //     * a negativ  -> rezultat prea mic   -> saturatie la MIN
    // Semnul lui a indica directia reala a overflow-ului
    assign dif = overflow ? (a[31] ? MIN : MAX) : raw_dif;

endmodule
