### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 57b725d0-f696-4f67-822d-e289ba799dfe
using Test

# ╔═╡ 38badd0a-99cd-11ee-3d0e-1b48afb2c443
md"# Day 13"

# ╔═╡ 40d5823a-9a3e-4914-a493-72a024868976
count_diff(a, b) = count(i -> @inbounds(a[i] != b[i]), eachindex(a))

# ╔═╡ 3c5b7f2c-071c-427b-92e5-ede231d2f38d
function find_reflections_dim(p, dim)
	reflections = Int64[]
	smudge_reflection = 0
	n = size(p, dim)
	for c in 1:n-1
		i = 0
		isrefl = true
		ndiff = 0
		while true
			l = c-i
			r = c+1+i
			if l < 1 || r > n # boundary
				break
			end
			if dim == 1
				ndiff += count_diff(@view(p[l, :]), @view(p[r, :]))
			elseif dim == 2
				ndiff += count_diff(@view(p[:, l]), @view(p[:, r]))
			end
			if ndiff > 0
				isrefl = false
			end
			i += 1
		end
		isrefl && push!(reflections, c)
		ndiff == 1 && (smudge_reflection = c)
	end
	return (; reflections, smudge_reflection)
end

# ╔═╡ 554e0fa0-46a0-40b3-b0fa-2abf76a1cbb8
function solution_part2(patterns)
	return sum(patterns) do p
		r = find_reflections_dim(p, 1).smudge_reflection
		c = find_reflections_dim(p, 2).smudge_reflection
		100 * r + c
	end
end

# ╔═╡ 2fe5e31a-fb36-4f9c-a61c-c5a7984e4c23
function solution_part1(patterns)
	return sum(patterns) do p
		r = find_reflections_dim(p, 1).reflections
		c = find_reflections_dim(p, 2).reflections
		100 * sum(r) + sum(c)
	end
end

# ╔═╡ 743e7571-9fa1-44cf-9f19-690964539802
function parse_input(inp)
	isfile(inp) && (inp = read(inp, String))
	patterns = Matrix{Char}[]
	for block in eachsplit(inp, "\n\n")
		push!(patterns, stack(split(block, '\n'); dims=1))
	end
	return patterns
end

# ╔═╡ 791e453b-ac78-4ece-8c8d-6385fdfbbc69
let
	inp = """#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#"""

	patterns = parse_input(inp)
	@testset "day13" begin
		p11 = find_reflections_dim(patterns[1], 1)
		p12 = find_reflections_dim(patterns[1], 2)
		p21 = find_reflections_dim(patterns[2], 1)
		p22 = find_reflections_dim(patterns[2], 2)
		
		@test p11.reflections == []
		@test p12.reflections == [5]
		@test p21.reflections == [4]
		@test p22.reflections == []
		@test solution_part1(patterns) == 405

		@test p11.smudge_reflection == 3
		@test p12.smudge_reflection == 0
		@test p21.smudge_reflection == 1
		@test p22.smudge_reflection == 0
		@test solution_part2(patterns) == 400
	end
end

# ╔═╡ b01408fc-851d-4607-b9a4-7dbbd6acf6bb
let
	patterns = parse_input("13.txt")
	println("Answer (Part 1): ", solution_part1(patterns))
	println("Answer (Part 2): ", solution_part2(patterns))
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
# ╟─38badd0a-99cd-11ee-3d0e-1b48afb2c443
# ╠═57b725d0-f696-4f67-822d-e289ba799dfe
# ╟─791e453b-ac78-4ece-8c8d-6385fdfbbc69
# ╠═554e0fa0-46a0-40b3-b0fa-2abf76a1cbb8
# ╠═2fe5e31a-fb36-4f9c-a61c-c5a7984e4c23
# ╠═40d5823a-9a3e-4914-a493-72a024868976
# ╠═3c5b7f2c-071c-427b-92e5-ede231d2f38d
# ╠═743e7571-9fa1-44cf-9f19-690964539802
# ╠═b01408fc-851d-4607-b9a4-7dbbd6acf6bb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
