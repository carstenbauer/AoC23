inp = """19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3"""

struct Hailstone{T<:Integer}
    x::T
    y::T
    z::T
    vx::T
    vy::T
    vz::T
    α::T
    β::T
    γ::T
end

function Hailstone(p, v)
    x, y, z = p
    vx, vy, vz = v
    α = vy
    β = -vx
    γ = vy * x - vx * y
    return Hailstone{BigInt}(x, y, z, vx, vy, vz, α, β, γ)
end

function intersection_point(h1, h2)
    if h1.α * h2.β ≈ h1.β * h2.α
        # parallel
        return nothing
    end

    Px = (h1.γ * h2.β - h2.γ * h1.β) / (h1.α * h2.β - h2.α * h1.β)
    Py = (h2.γ * h1.α - h1.γ * h2.α) / (h1.α * h2.β - h2.α * h1.β)
    return (x=Px, y=Py)
end

function count_intersects(hs; minlim=200000000000000, maxlim=400000000000000)
    n = length(hs)
    cnt = 0
    for i in 1:n
        for j in 1:(i-1)
            h1 = hs[i]
            h2 = hs[j]
            P = intersection_point(h1, h2)
            if !isnothing(P) && all(t -> minlim <= t <= maxlim, P) &&
               ((P.x - h1.x) * h1.vx >= 0) && ((P.y - h1.y) * h1.vy >= 0) &&
               ((P.x - h2.x) * h2.vx >= 0) && ((P.y - h2.y) * h2.vy >= 0)
                cnt += 1
            end
        end
    end
    cnt
end

# hailstones = map(eachline(IOBuffer(inp))) do l
hailstones = map(eachline(joinpath(@__DIR__, "24.txt"))) do l
    f, s = split(l, '@')
    p = parse.(Int, strip.(split(f, ',')))
    v = parse.(Int, strip.(split(s, ',')))
    return Hailstone(p, v)
end

# println("Answer (Part 1): ", count_intersects(hailstones; minlim=7, maxlim=27))
println("Answer (Part 1): ", count_intersects(hailstones)) # 18651
