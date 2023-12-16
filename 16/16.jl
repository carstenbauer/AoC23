function parse_input(inp)
    !isfile(inp) && (inp = IOBuffer(inp))
    stack(readlines(inp); dims=1)
end

const RIGHT = CartesianIndex(0, 1)
const LEFT = CartesianIndex(0, -1)
const DOWN = CartesianIndex(1, 0)
const UP = CartesianIndex(-1, 0)

const MOVES = Dict(
    (RIGHT, '/') => (UP,),
    (LEFT, '/') => (DOWN,),
    (UP, '/') => (RIGHT,),
    (DOWN, '/') => (LEFT,),
    (RIGHT, '\\') => (DOWN,),
    (LEFT, '\\') => (UP,),
    (UP, '\\') => (LEFT,),
    (DOWN, '\\') => (RIGHT,),
    (RIGHT, '-') => (RIGHT,),
    (LEFT, '-') => (LEFT,),
    (UP, '|') => (UP,),
    (DOWN, '|') => (DOWN,),
    (LEFT, '.') => (LEFT,),
    (RIGHT, '.') => (RIGHT,),
    (DOWN, '.') => (DOWN,),
    (UP, '.') => (UP,),
    (LEFT, '|') => (UP, DOWN),
    (RIGHT, '|') => (UP, DOWN),
    (UP, '-') => (LEFT, RIGHT),
    (DOWN, '-') => (LEFT, RIGHT),
)

function count_energized(grid; start=(CartesianIndex(1, 1), RIGHT))
    @assert size(grid, 1) == size(grid, 2)
    n = size(grid, 1)
    todo = [start]
    log = typeof(start)[]

    while !isempty(todo)
        pos, dir = pop!(todo)
        if (pos, dir) in log
            # we have already been here...
            continue
        else
            push!(log, (pos, dir))
        end
        c = grid[pos]
        newdirs = get(MOVES, (dir, c), nothing)
        isnothing(newdirs) && error("Unknown direction/char combo!")
        for d in newdirs
            newpos = pos + d
            if 1 <= newpos[1] <= n && 1 <= newpos[2] <= n
                push!(todo, (newpos, d))
            end
        end
    end
    return length(unique(getindex.(log, 1)))
end

function solution_part2(grid)
    @assert allequal(size(grid))
    n = size(grid, 1)
    cnt_1 = maximum(1:n) do i
        max(count_energized(grid; start=(CartesianIndex(i, 1), RIGHT)),
            count_energized(grid; start=(CartesianIndex(i, n), LEFT)))
    end
    cnt_2 = maximum(1:n) do i
        max(count_energized(grid; start=(CartesianIndex(1, i), DOWN)),
            count_energized(grid; start=(CartesianIndex(n, i), UP)))
    end
    return max(cnt_1, cnt_2)
end

inp = raw""".|...\....
|.-.\.....
.....|-...
........|.
..........
.........\
..../.\\..
.-.-/..|..
.|....-|.\
..//.|...."""
grid_ex = parse_input(inp)
cnt = count_energized(grid_ex)

grid = parse_input("16.txt")
println("Answer (Part 1): ", count_energized(grid))
println("Answer (Part 2): ", solution_part2(grid))
