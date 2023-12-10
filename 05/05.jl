### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 2fea657e-969e-11ee-22e3-611572403c01
using Test

# ╔═╡ a0f06642-f67b-4b8a-bad3-69425ea90d14
md"# Day 5"

# ╔═╡ 66f198d2-f9a5-4abf-b07b-4cada1225611
begin
	struct Map
		range_pairs::Vector{Pair{UnitRange{Int64}, UnitRange{Int64}}}
	end

	function Map(str::AbstractString)
		mp = Dict{Int64, Int64}()
		lines = split(str, "\n"; keepempty=false)[2:end]
		range_pairs = Pair{UnitRange{Int64}, UnitRange{Int64}}[]
		for l in lines
			dst, src, len = parse.(Int, split(l, ' '))
			dstr = range(start=dst, length=len)
			srcr = range(start=src, length=len)
			push!(range_pairs, srcr => dstr)
		end
		return Map(range_pairs)
	end

	function (m::Map)(i::Integer) # part 1 (works but too inefficient for part 2)
		for (srcr, dstr) in m.range_pairs
			for idx in eachindex(srcr)
				@inbounds if i == srcr[idx]
					return dstr[idx]
				end
			end
		end
		return i
	end

	function (m::Map)(rngs::AbstractVector{<:UnitRange}) # part 2
		mapped_rngs = UnitRange{Int64}[]
		while !isempty(rngs)
			mapped = false
			r = pop!(rngs)
			for (srcr, dstr) in m.range_pairs
				intsc = intersect(r, srcr)
				isempty(intsc) && continue
				stval = first(intsc)
				len = length(intsc)
				i = findfirst(isequal(stval), srcr)
				push!(mapped_rngs, dstr[i:i+len-1])
				if stval != first(r)
					j = findfirst(isequal(stval), r)
					push!(rngs, r[begin:j-1])
				end
				mapped = true
			end
			!mapped && push!(mapped_rngs, r)
		end
		return mapped_rngs
	end
end

# ╔═╡ 07d3fb84-93c5-4c3c-ad40-2f18841c7b16
begin
	function apply_all_maps!(xs::Vector{Int64}, maps)
		for m in maps
			for i in eachindex(xs)
				@inbounds xs[i] = m(xs[i])
			end
		end
		return xs
	end
	
	function apply_all_maps!(xs::AbstractVector{<:UnitRange}, maps)
		rngs = xs
		for m in maps
			rngs = m(rngs)
		end
		return rngs
	end
end

# ╔═╡ 312840be-3624-4869-a454-d02b649e3cd3
function parse_input(inp)
	seed_line, rem_lines... = split(read(inp, String), "\n\n")
	seed_nrs = parse.(Int, split(seed_line)[2:end])
	all_maps = Tuple(Map(l) for l in rem_lines)
	return seed_nrs, all_maps
end

# ╔═╡ 078abedc-cb17-4407-a6b9-de7fd2d57cf7
@testset "day5" begin
	test_input="""seeds: 79 14 55 13
				
				seed-to-soil map:
				50 98 2
				52 50 48
				
				soil-to-fertilizer map:
				0 15 37
				37 52 2
				39 0 15
				
				fertilizer-to-water map:
				49 53 8
				0 11 42
				42 0 7
				57 7 4
				
				water-to-light map:
				88 18 7
				18 25 70
				
				light-to-temperature map:
				45 77 23
				81 45 19
				68 64 13
				
				temperature-to-humidity map:
				0 69 1
				1 0 69
				
				humidity-to-location map:
				60 56 37
				56 93 4"""

	map_block="""seed-to-soil map:
			 50 98 2
			 52 50 48"""
	seed_soild_map = Map(map_block)
	@test seed_soild_map(98) == 50
	@test seed_soild_map(99) == 51
	@test seed_soild_map(53) == 55
	@test seed_soild_map(10) == 10
	@test seed_soild_map(0) == 0
	@test seed_soild_map(79) == 81
	@test seed_soild_map(14) == 14
	@test seed_soild_map(55) == 57
	@test seed_soild_map(13) == 13

	seed_nrs, all_maps = parse_input(IOBuffer(test_input))
	@test apply_all_maps!([79,14,55,13], all_maps) == [82, 43, 86, 35]
	@test minimum(apply_all_maps!([79,14,55,13], all_maps)) == 35

	# part 2	
	rngs = UnitRange{Int64}[]
	for (start, length) in Iterators.partition(seed_nrs, 2)
		push!(rngs, range(; start, length))
	end
	dst_rngs = apply_all_maps!(rngs, all_maps)
	
	@test mapreduce(minimum, min, dst_rngs) == 46
end

# ╔═╡ cb4212c7-666d-44de-ad6c-efe8ccc0f48f
let
	# part 1
	nrs, all_maps = parse_input("05.txt")
	# @time apply_all_maps!([n:n for n in nrs], all_maps)
	apply_all_maps!(nrs, all_maps)
	println("Answer (Part 1): ", minimum(nrs))
end

# ╔═╡ 57a5a2b4-89ed-4649-b498-0615af051e33
let
	# part 2
	nrs, all_maps = parse_input("05.txt")

	rngs = UnitRange{Int64}[]
	for (start, length) in Iterators.partition(nrs, 2)
		push!(rngs, range(; start, length))
	end
	dst_rngs = apply_all_maps!(rngs, all_maps)
	
	println("Answer (Part 2): ", mapreduce(minimum, min, dst_rngs))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-rc2"
manifest_format = "2.0"
project_hash = "71d91126b5a1fb1020e1098d9d492de2a4438fd2"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ Cell order:
# ╟─a0f06642-f67b-4b8a-bad3-69425ea90d14
# ╠═2fea657e-969e-11ee-22e3-611572403c01
# ╟─078abedc-cb17-4407-a6b9-de7fd2d57cf7
# ╠═66f198d2-f9a5-4abf-b07b-4cada1225611
# ╠═07d3fb84-93c5-4c3c-ad40-2f18841c7b16
# ╠═312840be-3624-4869-a454-d02b649e3cd3
# ╠═cb4212c7-666d-44de-ad6c-efe8ccc0f48f
# ╠═57a5a2b4-89ed-4649-b498-0615af051e33
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
