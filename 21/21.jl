const CI = CartesianIndex
const RIGHT = CI(0, 1)
const DOWN = CI(1, 0)
const UP = -DOWN
const LEFT = -RIGHT

function walk!(farm)
    positions = findall(==('O'), farm)
    farm[positions] .= '.'
    dirs = (RIGHT, DOWN, LEFT, UP)
    for pos in positions, dir in dirs
        if farm[pos+dir] != '#'
            farm[pos+dir] = 'O'
        end
    end
end

function solution_part1(farm, nsteps)
    farm = copy(farm)
    farm[findfirst(==('S'), farm)] = 'O'
    for _ in 1:nsteps
        walk!(farm)
    end
    # return findall(==('O'), farm) |> length
    return count(==('O'), farm)
end

function solution_part2(farm)
    nsteps = 26501365
    S = findfirst(==('S'), farm)
    # some input-based assumptions 😠
    @assert allequal(size(farm))
    sz = size(farm, 1)
    halfsz = sz ÷ 2
    @assert !('#' in @view(farm[S[1], :])) # now stones in the same row as 'S'
    @assert !('#' in @view(farm[:, S[2]])) # now stones in the same col as 'S'
    @assert isinteger((nsteps - halfsz) / sz) # we can reach the exact end of a farm
    fac = (nsteps - halfsz) ÷ sz

    sfarm = copy(farm)
    sfarm[S] = 'O'
    F = [farm farm farm farm farm;
        farm farm farm farm farm;
        farm farm sfarm farm farm;
        farm farm farm farm farm;
        farm farm farm farm farm]

    npos = Int[]
    # walk "to next farm" (half a farm size, because we start in the middle)
    for _ in 1:65
        walk!(F)
    end
    push!(npos, count(==('O'), F))
    # walk "to next farm" again (this time a full farm size)
    for _ in 1:sz
        walk!(F)
    end
    push!(npos, count(==('O'), F))
    # walk "to next farm" again (this time a full farm size)
    for _ in 1:sz
        walk!(F)
    end
    push!(npos, count(==('O'), F))

    # Turns out (see AoC reddit) that the number of reachable positions
    # after `x * sz + halfsz` many steps is a quadratic function `p(x) = ax² + bx + c`.
    #
    #    npos[1] = p(0) = c
    #    npos[2] = p(1) = a + b + c
    #    npos[3] = p(2) = 4a + 2b + c
    #
    #    =>
    #
    #    a = (npos[3] + npos[1] - 2₂) / 2
    #    b = (4 * npos[2] - 3 * npos[1] - npos[3]) / 2
    #    c = npos[1]

    a = (npos[3] - 2 * npos[2] + npos[1]) ÷ 2
    b = (4 * npos[2] - 3 * npos[1] - npos[3]) ÷ 2
    c = npos[1] ÷ 1
    p(x) = a * x^2 + b * x + c
    return p(fac)
end

farm = stack(readlines(joinpath(@__DIR__, "21.txt")); dims=1)
println("Answer (Part 1): ", solution_part1(farm, 64))
println("Answer (Part 2): ", solution_part2(farm))
