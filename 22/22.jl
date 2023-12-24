inp = """1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9"""

function parse_input(inp)
    blocks = Vector{Vector{Int}}[]
    for line in eachline(inp)
        coords = map(x -> parse.(Int, x), split.(split(line, '~'), ','))
        push!(blocks, coords)
    end
    return sort!(blocks; by=b -> b[1][3])
end

function overlap(x, y)
    return max(x[1][1], y[1][1]) <= min(x[2][1], y[2][1]) &&
           max(x[1][2], y[1][2]) <= min(x[2][2], y[2][2])
end

function fall!(blocks)
    for (i, b) in enumerate(blocks)
        zm = 1
        for c in blocks[begin:i-1]
            if overlap(b, c)
                zm = max(zm, c[2][3] + 1)
            end
        end
        b[2][3] -= b[1][3] - zm
        b[1][3] = zm
    end
    return sort!(blocks; by=b -> b[1][3])
end

function supportmaps(blocks)
    supports = Dict(i => Set() for i in eachindex(blocks))
    supportedby = Dict(i => Set() for i in eachindex(blocks))

    for (j, u) in enumerate(blocks)
        for (i, l) in enumerate(blocks[begin:j-1])
            if overlap(l, u) && u[1][3] == (l[2][3] + 1)
                push!(supports[i], j)
                push!(supportedby[j], i)
            end
        end
    end
    return supports, supportedby
end

function count_disint(blocks)
    supports, supportedby = supportmaps(blocks)
    cnt = count(eachindex(blocks)) do i
        all(length(supportedby[s]) >= 2 for s in supports[i])
    end
    return cnt
end

function count_wouldfall(blocks)
    supports, supportedby = supportmaps(blocks)
    cnt = 0
    for i in eachindex(blocks)
        Q = [j for j in supports[i] if length(supportedby[j]) == 1]
        F = Set(Q)
        push!(F, i)

        while !isempty(Q)
            j = popfirst!(Q)
            for k in setdiff(supports[j], F)
                if supportedby[k] <= F
                    push!(Q, k)
                    push!(F, k)
                end
            end
        end
        cnt += length(F) - 1
    end
    return cnt
end

# blocks = parse_input(IOBuffer(inp))
blocks = parse_input(joinpath(@__DIR__, "22.txt"));
fall!(blocks);
println("Answer (Part 1): ", count_disint(blocks))
println("Answer (Part 2): ", count_wouldfall(blocks))
