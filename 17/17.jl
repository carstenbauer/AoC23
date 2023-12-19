using DataStructures
const CI = CartesianIndex
const RIGHT = CI(0, 1)
const DOWN = CI(1, 0)
const LEFT = -RIGHT
const UP = -DOWN

struct PartialState
    pos::CI{2}  # current position
    dir::CI{2}  # direction from which we reached the position
    ndir::Int   # how often we have stepped in the same direction
end
struct State
    p::PartialState
    heat::Int # current heat loss
end
State(pos, dir, ndir, heat) = State(PartialState(pos, dir, ndir), heat)
Base.isless(s1::State, s2::State) = s1.heat < s2.heat

function dijkstra(grid; min=1, max=3)
    init_state = State(CI(1, 1), CI(0, 0), 0, 0)
    dest = CI(size(grid))
    seen = Set{PartialState}()
    Q = BinaryMinHeap([init_state])
    while !isempty(Q)
        st = pop!(Q)

        if st.p.pos == dest # we're done
            return st.heat
        end
        st.p in seen && continue
        push!(seen, st.p)

        for dir in (RIGHT, DOWN, LEFT, UP)
            pos = st.p.pos + dir
            checkbounds(Bool, grid, pos) || continue
            dir == -st.p.dir && continue
            if dir == st.p.dir
                (st.p.ndir >= max || st.p.dir == CI(0, 0)) && continue
                ndir = st.p.ndir + 1
            else
                st.p.dir != CI(0,0) && st.p.ndir < min && continue
                ndir = 1
            end
            heat = st.heat + grid[pos]
            push!(Q, State(pos, dir, ndir, heat))
        end
    end
    error("Couldn't find shortest path...")
end

function parse_input(inp)
    !isfile(inp) && (inp = IOBuffer(inp))
    return parse.(Int, stack(readlines(inp); dims=1))
end


# ----------------------
# let
#     inp_ex = """2413432311323
#     3215453535623
#     3255245654254
#     3446585845452
#     4546657867536
#     1438598798454
#     4457876987766
#     3637877979653
#     4654967986887
#     4564679986453
#     1224686865563
#     2546548887735
#     4322674655533"""

#     grid = parse_input(inp_ex)
#     heat = dijkstra(grid) # 102
#     heat = dijkstra(grid; min=4, max=10) # 94
# end

@time let
    grid = parse_input(joinpath(@__DIR__, "17.txt"))
    println("Answer (Part 1): ", dijkstra(grid)) # 668
    println("Answer (Part 2): ", dijkstra(grid; min=4, max=10)) # 788
end
