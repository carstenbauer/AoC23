inp = """#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#"""

const CI = CartesianIndex
const RIGHT = CI(0, 1)
const DOWN = CI(1, 0)
const LEFT = -RIGHT
const UP = -DOWN

# grid = stack(readlines(IOBuffer(inp)); dims=1)
grid = stack(readlines(joinpath(@__DIR__, "23.txt")); dims=1)

function get_relevant_pts(grid)
    start = CI(1, findfirst(==('.'), grid[1, :]))
    stop = CI(size(grid, 1), findfirst(==('.'), grid[end, :]))
    junctions = findall(CartesianIndices(grid)) do p
        grid[p] == '#' && return false
        neighs = 0
        for dir in (UP, RIGHT, DOWN, LEFT)
            q = p + dir
            checkbounds(Bool, grid, q) || continue
            grid[q] != '#' || continue
            neighs += 1
        end
        return neighs >= 3
    end
    return vcat(start, stop, junctions)
end

function get_reduced_graph(grid, pts; DIRS=Dict(
    '>' => [RIGHT],
    '<' => [LEFT],
    '^' => [UP],
    'v' => [DOWN],
    '.' => [UP, RIGHT, LEFT, DOWN],
))
    G = Dict(p => Dict{CI{2},Int}() for p in pts)
    for pt in pts
        stack = [(pt, 0)]
        seen = Set((pt,))
        while !isempty(stack)
            p, n = pop!(stack)

            if n > 0 && p in pts
                G[pt][p] = n
                continue
            end

            c = grid[p]
            for dir in DIRS[c]
                q = p + dir
                checkbounds(Bool, grid, q) || continue
                grid[q] != '#' || continue
                !(q in seen) || continue
                push!(stack, (q, n + 1))
                push!(seen, q)
            end
        end
    end
    return G
end

function dfs(G, pt; seen=Set(), stop)
    pt == stop && return 0
    push!(seen, pt)
    m = -Inf
    for n in keys(G[pt])
        n in seen && continue
        m = max(m, dfs(G, n; seen, stop) + G[pt][n])
    end
    delete!(seen, pt)
    return m
end

pts = get_relevant_pts(grid)
start, stop, _ = pts
G = get_reduced_graph(grid, pts)
println("Answer (Part 1): ", Int(dfs(G, start; stop)))

DIRS_part2 = Dict(
    '>' => [UP, RIGHT, LEFT, DOWN],
    '<' => [UP, RIGHT, LEFT, DOWN],
    '^' => [UP, RIGHT, LEFT, DOWN],
    'v' => [UP, RIGHT, LEFT, DOWN],
    '.' => [UP, RIGHT, LEFT, DOWN],
)
G2 = get_reduced_graph(grid, pts; DIRS=DIRS_part2)
println("Answer (Part 2): ", Int(dfs(G2, start; stop)))
