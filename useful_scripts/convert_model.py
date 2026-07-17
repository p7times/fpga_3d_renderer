import sys, math

FRACTIONAL_BITS = 12  
TOTAL_BITS = 28
HEX_CHARS = TOTAL_BITS // 4
MASK = (1 << TOTAL_BITS) - 1

def clog2(n):
    return 0 if n <= 1 else (n - 1).bit_length()

def float_to_q_hex(val):
    scaled = int(round(val * (1 << FRACTIONAL_BITS))) & MASK
    return f"{scaled:0{HEX_CHARS}x}"

def pack_hex(a, b, bits):
    combined = (a << bits) | b
    hex_width = -(-(2 * bits) // 4)
    return f"{combined:0{hex_width}x}"

def convert_obj_to_mem(obj_filepath, vertices_out, edges_out, header_out):
    vertices, raw_edges = [], []

    with open(obj_filepath) as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#') or line.startswith('o'):
                continue
            parts = line.split()
            if parts[0] == 'v':
                vertices.append(tuple(float(p) for p in parts[1:4]))
            elif parts[0] == 'l':
                v1 = int(parts[1].split('/')[0]) - 1
                v2 = int(parts[2].split('/')[0]) - 1
                raw_edges.append((v1, v2))

    num_vertices = len(vertices)
    num_edges    = len(raw_edges)

    vert_addr = max(clog2(num_vertices + 1), 1)
    edge_addr = max(clog2(num_edges + 1), 1)

    vertices_mem = [
        float_to_q_hex(x) + float_to_q_hex(y) + float_to_q_hex(z)
        for (x, y, z) in vertices
    ]
    edges_mem = [pack_hex(v1, v2, vert_addr) for (v1, v2) in raw_edges]

    with open(vertices_out, 'w') as fv:
        fv.write('\n'.join(vertices_mem) + '\n')
    with open(edges_out, 'w') as fe:
        fe.write('\n'.join(edges_mem) + '\n')

    # Header Verilog, generata din acelasi run
    with open(header_out, 'w') as fh:
        fh.write("// Generat automat - nu edita manual!\n")
        fh.write(f"`define NUM_VERTICES_AUTO {num_vertices}\n")
        fh.write(f"`define NUM_EDGES_AUTO {num_edges}\n")
        fh.write(f"`define VERT_ADDR_AUTO {vert_addr}\n")
        fh.write(f"`define EDGE_ADDR_AUTO {edge_addr}\n")

    print(f"Vartfuri: {num_vertices} (VERT_ADDR={vert_addr})")
    print(f"Muchii:   {num_edges} (EDGE_ADDR={edge_addr})")

if __name__ == "__main__":
    convert_obj_to_mem("model.obj", "vertices_model.mem","edges_model.mem", "model_params.vh")
