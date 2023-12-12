### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ a47f4661-4e39-49a9-9264-3acb128aeefe
using Test

# ╔═╡ 93837c34-98f5-11ee-3769-7dc3a788dd0e
md"# Day 11"

# ╔═╡ 9ede1fc2-6f78-4242-9f91-e5afd38a91a5
parse_input(inp) = stack(readlines(inp); dims=1)

# ╔═╡ 88a5a3b0-d482-4bd5-8ea3-5a9cd6e219a3
function get_galaxy_positions_in_expanded_universe(universe; fac=2)
	galaxy_pos = findall(==('#'), universe)
	shifts = [CartesianIndex(0,0) for _ in galaxy_pos]
	for (c, col) in enumerate(eachcol(universe))
		if allequal(col)
			idcs = findall(x -> x[2] > c, galaxy_pos)
			shifts[idcs] .+= CartesianIndex(0, fac-1)
		end
	end
	for (r, row) in enumerate(eachrow(universe))
		if allequal(row)
			idcs = findall(x -> x[1] > r, galaxy_pos)
			shifts[idcs] .+= CartesianIndex(fac-1, 0)
		end
	end
	return galaxy_pos .+ shifts
end

# ╔═╡ ac5888ae-0dab-4445-93ee-211614eec668
find_shortest_path_length(g1, g2) = sum(abs, Tuple(g1 - g2))

# ╔═╡ 07e72e2c-fe5b-4dad-9ac4-b1d6e2b554f4
function solution(universe; kwargs...)
	galaxy_pos = get_galaxy_positions_in_expanded_universe(universe; kwargs...)

	s = 0
	for g1 in eachindex(galaxy_pos)
		for g2 in g1+1:lastindex(galaxy_pos)
			s += find_shortest_path_length(galaxy_pos[g1], galaxy_pos[g2])
		end
	end
	
	return (; sum=s, galaxy_pos)
end

# ╔═╡ ab5fb0bc-e90c-4188-a122-17e8dee9ad50
let
	inp = """...#......
			 .......#..
			 #.........
			 ..........
			 ......#...
			 .#........
			 .........#
			 ..........
			 .......#..
			 #...#....."""

	universe = parse_input(IOBuffer(inp))
	sol = solution(universe)
	
	@testset "day11" begin
		@test CartesianIndex(3,1) in sol.galaxy_pos
		@test CartesianIndex(12,1) in sol.galaxy_pos
		@test CartesianIndex(7,2) in sol.galaxy_pos
		@test CartesianIndex(1,5) in sol.galaxy_pos
		@test CartesianIndex(12,6) in sol.galaxy_pos
		@test CartesianIndex(6,9) in sol.galaxy_pos
		@test CartesianIndex(2,10) in sol.galaxy_pos
		@test CartesianIndex(11,10) in sol.galaxy_pos
		@test CartesianIndex(8,13) in sol.galaxy_pos

		@test find_shortest_path_length(CartesianIndex(3,1), CartesianIndex(8,13)) == 17
		@test sol.sum == 374
	end
end

# ╔═╡ d79d8fe4-6761-4ace-a206-3b12e19a72bf
let
	universe = parse_input("11.txt")
	sol = solution(universe)
	println("Answer (Part 1): ", sol.sum)

	expfac = 1_000_000
	sol = solution(universe; fac=expfac)
	println("Answer (Part 2): ", sol.sum)
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
# ╟─93837c34-98f5-11ee-3769-7dc3a788dd0e
# ╠═a47f4661-4e39-49a9-9264-3acb128aeefe
# ╟─ab5fb0bc-e90c-4188-a122-17e8dee9ad50
# ╠═07e72e2c-fe5b-4dad-9ac4-b1d6e2b554f4
# ╠═9ede1fc2-6f78-4242-9f91-e5afd38a91a5
# ╠═88a5a3b0-d482-4bd5-8ea3-5a9cd6e219a3
# ╠═ac5888ae-0dab-4445-93ee-211614eec668
# ╠═d79d8fe4-6761-4ace-a206-3b12e19a72bf
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
