### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 9be4c587-3338-4f27-8f92-511c36617201
using Test

# ╔═╡ be424a6f-25a9-4ff9-bcb4-39bf975ca7f9
using StaticArrays

# ╔═╡ 9a6678de-0710-472f-bac9-011d1efe2255
md"# Day 02"

# ╔═╡ 4abeba38-9905-4011-8e3e-21dfc62853d5
md"## Part I"

# ╔═╡ 8f1006e5-176e-4706-ae6d-7a9a9d27cae8
function parse_game(line)
	i = findfirst(' ', line)
	j = findfirst(':', line)
	gameid = parse(Int, @view(line[i+1:j-1]))

	confs = MVector{3, Int}[]
	for draw in eachsplit(@view(line[j+2:end]), "; ")
		c = @MVector zeros(Int, 3)
		for conf in eachsplit(draw, ", ")
			s = findfirst(' ', conf)
			cnt = parse(Int, @view(conf[begin:s-1]))
			kind = @view(conf[s+1:end])
			if kind == "red"
				c[1] += cnt
			elseif kind == "green"
				c[2] += cnt
			elseif kind == "blue"
				c[3] += cnt
			end
		end
		push!(confs, c)
	end
	return gameid, confs
end

# ╔═╡ 3cc60b69-5a9b-4cf2-aead-659918500ce7
function ispossible(game, bag)
	for conf in game[2]
		for i in eachindex(conf)
			if conf[i] > bag[i]
				return false
			end
		end
	end
	return true
end

# ╔═╡ 0f670d4e-851b-4a50-b267-421814088475
@testset "getnumber" begin
	test_lines = readlines("02_test.txt")
	bag = [12, 13, 14]
	games = parse_game.(test_lines)
	@test getindex.(games, 1) == 1:5 # test game ids
	@test ispossible.(games, Ref(bag)) == [true, true, false, false, true]
	@test sum(test_lines) do l
		game = parse_game(l)
		ispossible(game, bag) ? game[1] : 0
	end == 8
end

# ╔═╡ a4c8e948-fdb5-45e9-a17a-1cdf5af672d0
let
    lines = readlines("02.txt")
	games = parse_game.(lines)
	bag = [12, 13, 14]
	answer = sum(lines) do l
		game = parse_game(l)
		ispossible(game, bag) ? game[1] : 0
	end
	println("Answer: ", answer)
end

# ╔═╡ f3dcb094-9401-49bb-8f89-64c25f12f052
md"## Part II"

# ╔═╡ 0f7e94c6-07d1-4359-984a-482e0096ad2b
function calc_power(game)
	return prod(reduce((x,y)->max.(x,y), game[2]))
end

# ╔═╡ 2c3708c8-6740-4c6d-a685-08f1c90a0f9f
@testset "getnumber" begin
	test_lines = readlines("02_test.txt")
	games = parse_game.(test_lines)
	@test calc_power(games[1]) == 48
	@test calc_power(games[2]) == 12
	@test calc_power(games[3]) == 1560
	@test calc_power(games[4]) == 630
	@test calc_power(games[5]) == 36
	@test sum(calc_power, games) == 2286
end

# ╔═╡ 3578cb56-f0b8-4afd-b62d-29b3f42995d8
let
    lines = readlines("02.txt")
	games = parse_game.(lines)
    println("Answer: ", sum(calc_power, games))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
StaticArrays = "~1.7.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-rc1"
manifest_format = "2.0"
project_hash = "a927c75e2c68bc5b36169bf0e9fc522d30f4ba28"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "03b4c25b43cb84cee5c90aa9b5ea0a78fd848d2f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.0"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "00805cd429dcb4870060ff49ef443486c262e38e"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "PrecompileTools", "Random", "StaticArraysCore"]
git-tree-sha1 = "5ef59aea6f18c25168842bded46b16662141ab87"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.7.0"

    [deps.StaticArrays.extensions]
    StaticArraysStatisticsExt = "Statistics"

    [deps.StaticArrays.weakdeps]
    Statistics = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StaticArraysCore]]
git-tree-sha1 = "36b3d696ce6366023a0ea192b4cd442268995a0d"
uuid = "1e83bf80-4336-4d27-bf5d-d5a4f845583c"
version = "1.4.2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"
"""

# ╔═╡ Cell order:
# ╟─9a6678de-0710-472f-bac9-011d1efe2255
# ╠═9be4c587-3338-4f27-8f92-511c36617201
# ╠═be424a6f-25a9-4ff9-bcb4-39bf975ca7f9
# ╟─4abeba38-9905-4011-8e3e-21dfc62853d5
# ╠═8f1006e5-176e-4706-ae6d-7a9a9d27cae8
# ╠═3cc60b69-5a9b-4cf2-aead-659918500ce7
# ╟─0f670d4e-851b-4a50-b267-421814088475
# ╠═a4c8e948-fdb5-45e9-a17a-1cdf5af672d0
# ╟─f3dcb094-9401-49bb-8f89-64c25f12f052
# ╠═0f7e94c6-07d1-4359-984a-482e0096ad2b
# ╟─2c3708c8-6740-4c6d-a685-08f1c90a0f9f
# ╠═3578cb56-f0b8-4afd-b62d-29b3f42995d8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
