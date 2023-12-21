inp_ex = """...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
..........."""

const CI = CartesianIndex
const RIGHT = CI(0, 1)
const DOWN = CI(1, 0)
const UP = -DOWN
const LEFT = -RIGHT

function walk_farm(farm, nsteps)
    nr, nc = size(farm)
    start = findfirst(==('S'), farm)
    positions = Set{CI{2}}((start,))
    newpositions = Set{CI{2}}()
    for i in 1:nsteps
        while !isempty(positions)
            pos = pop!(positions)
            for dir in (RIGHT, DOWN, LEFT, UP)
                newpos = pos + dir
                # periodic boundary conditions
                r = mod1(newpos[1], nr)
                c = mod1(newpos[2], nc)
                farm[CI(r, c)] == '#' && continue
                push!(newpositions, newpos)
            end
        end
        newpositions, positions = positions, newpositions
    end
    return length(positions)
end

farm = stack(readlines(IOBuffer(inp_ex)); dims=1)

@time walk_farm(farm, 6)
@time walk_farm(farm, 10)
@time walk_farm(farm, 50)
@time walk_farm(farm, 100)
@time walk_farm(farm, 500)

# way too slow...
# farm = stack(readlines(joinpath(@__DIR__, "21.txt")); dims=1)
# walk_farm(farm, 26_501_365)
# println("Answer (Part 2): ", length(positions))
