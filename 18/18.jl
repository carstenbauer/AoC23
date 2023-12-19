const CI = CartesianIndex

function exec_ins(ins; transform=false)
    pos = CI(1, 1)
    path = [pos]
    for j in ins
        i = transform ? ins_transform(j) : j
        if i.ins == "R"
            dir = CI(0, 1)
        elseif i.ins == "L"
            dir = CI(0, -1)
        elseif i.ins == "D"
            dir = CI(1, 0)
        elseif i.ins == "U"
            dir = CI(-1, 0)
        end
        for _ in 1:i.cnt
            newpos = pos + dir
            push!(path, newpos)
            pos = newpos
        end
    end
    @assert last(path) == first(path) # we have a loop
    pop!(path)
    return path
end

function parse_input(inp)
    !isfile(inp) && (inp = IOBuffer(inp))
    return map(eachline(inp)) do line
        ins, cnt, color = split(line)
        return (; ins, cnt=parse(Int, cnt), color=color[3:end-1])
    end
end

function show_path(path)
    maxr = maximum(x -> x[1], path)
    maxc = maximum(x -> x[2], path)
    grid = fill('.', (maxr, maxc))
    for p in path
        grid[p] = '#'
    end
    return grid
end

function compute_volume(path)
    # Strategy:
    #   - compute inner area (Aₛₗ) via Shoelace formula
    #   - use Pick's theorem to get the num. of interior points (i) from Aₛₗ and the num. of boundary points (b)
    #   - total number of points (== num. of 1 m³ holes) is then just i + b
    b = length(path) # num of boundary points

    # Variant of the Shoelace formula
    # A = 1/2 ∑ᵢ₌₁ⁿ xᵢ(yᵢ₊₁ - yᵢ₋₁)
    x(i) = path[mod1(i, b)][1]
    y(i) = path[mod1(i, b)][2]
    Aₛₗ = abs(sum(x(i) * (y(i + 1) - y(i - 1)) for i in 1:b)) ÷ 2

    # Pick's theorem:
    # A = i + b/2 - 1
    # => i = A - b/2 + 1
    i = Aₛₗ - b ÷ 2 + 1 # num of interior point
    return i + b
end

function ins_transform(i)
    cnt = parse(Int, i.color[1:end-1]; base=16)
    ins_int = parse(Int, i.color[end])
    if ins_int == 0
        ins = "R"
    elseif ins_int == 1
        ins = "D"
    elseif ins_int == 2
        ins = "L"
    elseif ins_int == 3
        ins = "U"
    end
    return (; ins, cnt, color=i.color)
end

# ---------------
# let
#     dig_plan = """R 6 (#70c710)
#     D 5 (#0dc571)
#     L 2 (#5713f0)
#     D 2 (#d2c081)
#     R 2 (#59c680)
#     D 2 (#411b91)
#     L 5 (#8ceee2)
#     U 2 (#caa173)
#     L 1 (#1b58a2)
#     U 2 (#caa171)
#     R 2 (#7807d2)
#     U 3 (#a77fa3)
#     L 2 (#015232)
#     U 2 (#7a21e3)"""

#     ins = parse_input(dig_plan)
#     display(ins)
#     path = exec_ins(ins)
#     display(show_path(path))
#     compute_volume(path)

#     path = exec_ins(ins; transform=true)
#     compute_volume(path)
# end

let
    ins = parse_input(joinpath(@__DIR__, "18.txt"))
    path = exec_ins(ins)
    println("Answer (Part 1): ", compute_volume(path)) # 61661
    path2 = exec_ins(ins; transform=true)
    println("Answer (Part 2): ", compute_volume(path2)) # 111131796939729
end
