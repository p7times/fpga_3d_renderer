module add_q_16_16(
    input  signed [31:0] a, b,      // operanzi in format Q16.16 (32-bit signed fixed-point)
    output               overflow,  // flag de overflow (folosit pentru debug / monitorizare)
    output signed [31:0] sum        // rezultat Q16.16 cu saturatie
);

    // Limitele maxime si minime pe 32 de biti semnati.
    // In format Q16.16 acestea reprezinta valorile extreme
    // la care rezultatul este saturat in caz de overflow.
    localparam signed [31:0] MAX = 32'sh7FFF_FFFF;
    localparam signed [31:0] MIN = 32'sh8000_0000;

    // Rezultatul brut al adunarii (fara saturatie)
    wire signed [31:0] raw_sum;

    // Flag intern pentru detectarea overflow-ului
    wire add_overflow;

    // Adunare aritmetica pe 32 de biti semnati
    assign raw_sum = a + b;

    // Detectarea overflow-ului la adunare:
    // - overflow apare doar daca a si b au acelasi semn
    // - iar semnul rezultatului difera de semnul operanzilor
    // Formula este cea clasica pentru adunare in doi complementi
    assign add_overflow = (~(a[31] ^ b[31])) & (raw_sum[31] ^ a[31]);

    // Aplicarea saturatiei:
    // - fara overflow -> rezultatul brut este valid
    // - cu overflow:
    //     * a pozitiv  -> suma reala depaseste MAX -> saturatie la MAX
    //     * a negativ  -> suma reala sub MIN       -> saturatie la MIN
    // Semnul lui a (egal cu al lui b) indica directia overflow-ului
    assign sum = add_overflow ? (a[31] ? MIN : MAX) : raw_sum;

    // Exportam flag-ul de overflow pentru debug sau logica externa
    assign overflow = add_overflow;

endmodule
