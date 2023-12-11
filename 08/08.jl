### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ ae9fc67c-aa9f-4de1-b10c-d0c324f1281e
using Test

# ╔═╡ 2ef2b944-97f9-11ee-18d6-09c00c37f28d
md"# Day 08"

# ╔═╡ 983fd31c-ecf6-4e82-b692-3a3ab1ea7504
function traverse_count(ins, nmap; startnode = "AAA", condition = ==("ZZZ"))
	inscyc = Iterators.cycle(ins)
	curr = startnode
	stepcnt = 0
	for i in inscyc # infinite loop
		stepcnt += 1
		nodes = nmap[curr]
		curr = i == 'L' ? nodes[1] : nodes[2]
		if condition(curr)
			break
		end
	end
	return stepcnt
end

# ╔═╡ 625ed8e3-3237-4982-9239-3b514d4696fe
# first naive attempt is too slow... :)
#
# function traverse_count(ins, nmap; startnodes = ["AAA"])
# 	inscyc = Iterators.cycle(ins)
# 	curr = collect(startnodes)
# 	stepcnt = 0
# 	for i in inscyc # infinite loop
# 		stepcnt += 1
# 		for j in eachindex(curr)
# 			nodes = nmap[curr[j]]
# 			curr[j] = i == 'L' ? nodes[1] : nodes[2]
# 		end
# 		if all(endswith("Z"), curr)
# 			break
# 		end
# 	end
# 	return stepcnt
# end

# ╔═╡ a2a100f6-2a43-45de-9ec1-176799b88aa9
function parse_input(inp)
	lines = readlines(inp)
	ins = collect(lines[1])
	nodemap = Dict{String, Tuple{String, String}}()
	for l in @view(lines[3:end])
		node, rest... = split(l)
		lnode = rest[2][begin+1:end-1]
		rnode = rest[3][begin:end-1]
		nodemap[node] = (lnode, rnode)
	end
	return ins, nodemap
end

# ╔═╡ b4cffe1e-0506-42d2-8548-8b74e3112e99
@testset "day08" begin
	inp1 = """RL
			  
			  AAA = (BBB, CCC)
			  BBB = (DDD, EEE)
			  CCC = (ZZZ, GGG)
			  DDD = (DDD, DDD)
			  EEE = (EEE, EEE)
			  GGG = (GGG, GGG)
			  ZZZ = (ZZZ, ZZZ)"""

	inp2 = """LLR
			  
			  AAA = (BBB, BBB)
			  BBB = (AAA, ZZZ)
			  ZZZ = (ZZZ, ZZZ)"""

	ins1, nodemap1 = parse_input(IOBuffer(inp1))
	@test traverse_count(ins1, nodemap1) == 2

	ins2, nodemap2 = parse_input(IOBuffer(inp2))
	@test traverse_count(ins2, nodemap2) == 6

	# part 2
	inp3 = """LR
			  
			  11A = (11B, XXX)
			  11B = (XXX, 11Z)
			  11Z = (11B, XXX)
			  22A = (22B, XXX)
			  22B = (22C, 22C)
			  22C = (22Z, 22Z)
			  22Z = (22B, 22B)
			  XXX = (XXX, XXX)"""

	ins3, nodemap3 = parse_input(IOBuffer(inp3))
	startnodes = collect(filter(endswith("A"), keys(nodemap3)))
	steps_per_node = map(startnodes) do snode
		traverse_count(ins3, nodemap3; startnode=snode, condition=endswith("Z"))
	end
	@test lcm(steps_per_node) == 6
end

# ╔═╡ 7c12caf0-313b-426e-b348-8e0ca164cc68
let
	ins, nodemap = parse_input("08.txt")
	println("Answer (Part 1): ", traverse_count(ins, nodemap))
	
	# first naive attempt is too slow... :)
	# startnodes = filter(endswith("A"), keys(nodemap))
	# println("Answer (Part 2): ", traverse_count(ins, nodemap; startnodes))

	# utilize subcycling of each individual start node
	startnodes = collect(filter(endswith("A"), keys(nodemap)))
	steps_per_node = map(startnodes) do snode
		traverse_count(ins, nodemap; startnode=snode, condition=endswith("Z"))
	end
	println("Answer (Part 2): ", lcm(steps_per_node))
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
# ╟─2ef2b944-97f9-11ee-18d6-09c00c37f28d
# ╠═ae9fc67c-aa9f-4de1-b10c-d0c324f1281e
# ╠═b4cffe1e-0506-42d2-8548-8b74e3112e99
# ╠═983fd31c-ecf6-4e82-b692-3a3ab1ea7504
# ╠═625ed8e3-3237-4982-9239-3b514d4696fe
# ╠═a2a100f6-2a43-45de-9ec1-176799b88aa9
# ╠═7c12caf0-313b-426e-b348-8e0ca164cc68
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
