inp = """jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr"""

using Graphs, MetaGraphsNext

G = MetaGraph(Graph(); label_type=String)

# for l in eachsplit(inp, '\n')
for l in eachline(joinpath(@__DIR__, "25.txt"))
    l, r = split(l, ':')
    l in labels(G) || add_vertex!(G, l)
    for node in strip.(split(r))
        node in labels(G) || add_vertex!(G, node)
        add_edge!(G, l, node)
        # add_edge!(G, node, l)
    end
end

while true
    cut = karger_min_cut(G)
    edges = karger_cut_edges(G, cut)
    length(edges) != 3 && continue
    eins = count(isone, cut)
    println("Answer: ", (length(vertices(G)) - eins) * eins)
    break
end
