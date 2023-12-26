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

using DataStructures
const CI = CartesianIndex
const RIGHT = CI(0, 1)
const DOWN = CI(1, 0)
const LEFT = -RIGHT
const UP = -DOWN

struct PartialState
    pos::CI{2}       # current position
    hist::Vector{CI{2}} # past positions
end
struct State
    p::PartialState
    len::Int # current length of path
end
State(pos, hist, len) = State(PartialState(pos, hist), len)
Base.isless(s1::State, s2::State) = s1.len < s2.len

function dijkstra(grid)
    S = CI(1, findfirst(==('.'), first(eachrow(grid))))
    F = CI(size(grid, 1), findfirst(==('.'), last(eachrow(grid))))
    init_state = State(S, CI{2}[], 0)
    seen = Set{PartialState}()
    Q = BinaryMaxHeap([init_state])
    # Q = BinaryMinHeap([init_state])
    results = State[]
    while !isempty(Q)
        st = pop!(Q)

        if st.p.pos == F # we're done
            # return st.len, st
            push!(results, st)
        end
        st.p in seen && continue
        push!(seen, st.p)

        for dir in (RIGHT, DOWN, LEFT, UP)
            pos = st.p.pos + dir
            checkbounds(Bool, grid, pos) || continue
            c = grid[pos]
            c == '#' && continue
            pos in st.p.hist && continue
            if dir == RIGHT && c == '<'
                continue
            elseif dir == LEFT && c == '>'
                continue
            elseif dir == UP && c == 'v'
                continue
            elseif dir == DOWN && c == '^'
                continue
            end
            hist = [st.p.hist; st.p.pos]
            push!(Q, State(pos, hist, st.len + 1))
        end
    end
    return results
end

function parse_input(inp)
    return stack(readlines(inp); dims=1)
end

# grid = parse_input(IOBuffer(inp))
grid = parse_input(joinpath(@__DIR__, "23.txt"))
st = dijkstra(grid)

# function visualize(grid, st)
#     G = copy(grid)
#     G[st.p.hist] .= 'O'
#     display(G)
#     println(st.len)
#     return nothing
# end

# visualize(grid, st[2])

println("Answer (Part 1): ", maximum(x -> x.len, st))
