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

# farm = stack(readlines(IOBuffer(inp_ex)); dims=1)
farm = stack(readlines(joinpath(@__DIR__, "21.txt")); dims=1)

start = findfirst(==('S'), farm)
positions = Set{CI{2}}((start,))
newpositions = Set{CI{2}}()
nsteps = 64
for i in 1:nsteps
    while !isempty(positions)
        pos = pop!(positions)
        for dir in (RIGHT, DOWN, LEFT, UP)
            newpos = pos + dir
            checkbounds(Bool, farm, newpos) || continue
            farm[newpos] == '#' && continue
            push!(newpositions, newpos)
        end
    end
    newpositions, positions = positions, newpositions
    # display([p in positions ? 'O' : farm[p] for p in CartesianIndices(farm)])
end

println("Answer (Part 1): ", length(positions))
