### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 57b725d0-f696-4f67-822d-e289ba799dfe
using Test

# ╔═╡ 38badd0a-99cd-11ee-3d0e-1b48afb2c443
md"# Day 13"

# ╔═╡ e6e3b02d-7adf-405c-bd9f-ab9634d331ec
function find_reflections_dim(p, dim)
	reflections = Int64[]
	n = size(p, dim)
	for c in 1:n-1
		i = 0
		isrefl = true
		while true
			l = c-i
			r = c+1+i
			if l < 1 || r > n # boundary
				break
			end
			if dim == 1
				cond = @view(p[l, :]) != @view(p[r,:])
			elseif dim == 2
				cond = @view(p[:,l]) != @view(p[:,r])
			end
			if cond
				isrefl = false
				break
			end
			i += 1
		end
		isrefl && push!(reflections, c)
	end
	return reflections
end

# ╔═╡ a66cc1e8-3b90-4e6d-9344-21ca2cad6708
function find_reflections(p)
	return (find_reflections_dim(p, 1), find_reflections_dim(p, 2))
end

# ╔═╡ 2fe5e31a-fb36-4f9c-a61c-c5a7984e4c23
function solution(patterns)
	return sum(patterns) do p
		r,c = find_reflections(p)
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
		@test find_reflections_dim(patterns[1], 1) == []
		@test find_reflections_dim(patterns[1], 2) == [5]
		@test find_reflections_dim(patterns[2], 1) == [4]
		@test find_reflections_dim(patterns[2], 2) == []

		@test solution(patterns) == 405
	end
end

# ╔═╡ b01408fc-851d-4607-b9a4-7dbbd6acf6bb
let
	patterns = parse_input("13.txt")
	println("Answer (Part 1): ", solution(patterns))
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
# ╠═791e453b-ac78-4ece-8c8d-6385fdfbbc69
# ╠═2fe5e31a-fb36-4f9c-a61c-c5a7984e4c23
# ╠═a66cc1e8-3b90-4e6d-9344-21ca2cad6708
# ╠═e6e3b02d-7adf-405c-bd9f-ab9634d331ec
# ╠═743e7571-9fa1-44cf-9f19-690964539802
# ╠═b01408fc-851d-4607-b9a4-7dbbd6acf6bb
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
