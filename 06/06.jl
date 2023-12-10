### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 40584350-3407-4e8f-91c8-de4c1f42dd3c
using Test

# ╔═╡ e560ebd0-9743-11ee-0766-4f20c144f6ac
md"# Day 06"

# ╔═╡ efb688a6-f7b9-4188-94b9-62aae892610f
function parse_input(inp) # inp -> races
	num_strs = split.(strip.(getindex.(split.(split(inp, '\n'), ':'), 2)), ' '; keepempty=false)
	return [(time=parse(Int, num_strs[1][r]), dist=parse(Int, num_strs[2][r])) for r in 1:length(num_strs[1])]
end

# ╔═╡ 51e20e01-6e80-4987-8233-2260270b6719
function parse_input_part2(inp)
	num_strs = split.(strip.(getindex.(split.(split(inp, '\n'), ':'), 2)), ' '; keepempty=false)
	nums = parse.(Int, join.(num_strs))
	return (time=nums[1], dist=nums[2])
end

# ╔═╡ 4b8c6c8c-87b5-4d4f-ae7a-2000a411c94a
function count_winning_strategies(race)
	mapreduce(+, 0:race.time) do t_button
		(race.time - t_button) * t_button > race.dist
	end
end

# ╔═╡ a21db14c-d47e-42f1-bad6-33f869e8e0a1
@testset "day06" begin
	test_inp = """Time:      7  15   30
				  Distance:  9  40  200"""

	races = parse_input(test_inp)
	@test count_winning_strategies.(races) == [4, 8, 9]
	@test prod(count_winning_strategies.(races)) == 288

	#part2
	@test prod(count_winning_strategies(parse_input_part2(test_inp))) == 71503
end

# ╔═╡ 88960dac-3aab-4d3e-8d2d-4e5589531169
let
	inp = read("06.txt", String)
	races = parse_input(inp)
	println("Answer (Part 1): ", prod(count_winning_strategies.(races)))

	#part2
	race = parse_input_part2(inp)
	println("Answer (Part 2): ", prod(count_winning_strategies(race)))
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
# ╟─e560ebd0-9743-11ee-0766-4f20c144f6ac
# ╠═40584350-3407-4e8f-91c8-de4c1f42dd3c
# ╟─a21db14c-d47e-42f1-bad6-33f869e8e0a1
# ╠═efb688a6-f7b9-4188-94b9-62aae892610f
# ╠═51e20e01-6e80-4987-8233-2260270b6719
# ╠═4b8c6c8c-87b5-4d4f-ae7a-2000a411c94a
# ╠═88960dac-3aab-4d3e-8d2d-4e5589531169
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
