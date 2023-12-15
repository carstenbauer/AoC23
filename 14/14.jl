### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ c870982e-9bc1-462e-ab56-989f3388a06b
using Test

# ╔═╡ 0567c71c-ac17-4981-9ca8-6e70fad9b270
using BenchmarkTools

# ╔═╡ 6a6aa804-9a55-11ee-3746-b31295a027e0
md"# Day 14"

# ╔═╡ 71cd39a3-98d7-495b-b401-e19d59d37a06
function update!(platform)
	nr = size(platform, 1)
	for (c, col) in enumerate(eachcol(platform))
		hs = findall(==('#'), col)
		pushfirst!(hs, 0) # put cube rocks at 0th and nr+1th row to mark bounds
		push!(hs, nr+1)
		nh = length(hs)
		for i in eachindex(hs)
			start = i > 0 ? hs[i]+1 : 1
			stop  = i < nh ? hs[i+1]-1 : nh
			stop < start && continue
			no = count(==('O'), @view(col[start:stop]))
			no == 0 && continue
			col[start:(start+no-1)] .= 'O'
			col[(start+no):stop] .= '.'
		end
	end
	return platform
end

# ╔═╡ 8d4d96f3-c79c-4455-87dc-a2deb9d1f2d9
function cycle(platform)
	p = copy(platform)
	# North
	update!(p)
	# West
	p = rotr90(p)
	update!(p)
	# South
	p = rotr90(p)
	update!(p)
	# East
	p = rotr90(p)
	update!(p)
	# back to North
	p = rotr90(p)
	return p
end

# ╔═╡ 277899e8-537f-47d4-a228-39990d6cbdf9
function compute_north_load(platform)
	n = size(platform, 1)
	load_values = reverse(1:n)
	return mapreduce(+, enumerate(eachrow(platform))) do (i, row)
		count(==('O'), row) * load_values[i]
	end
end

# ╔═╡ a5103c7f-6b55-45f8-a96a-f1b6e73cc05c
function solution_part2(p; N=1_000_000_000)
	seen        = Tuple{Matrix{Char}, Int}[]
	cycle_start = nothing
	cycle_len   = nothing
	i = 0
	while i < N
		p = cycle(p)
		i += 1
		cycle_start = findfirst(x -> x[1] == p, seen)
		if !isnothing(cycle_start)
			cycle_len = i - cycle_start
			break
		end
		push!(seen, (p, compute_north_load(p)))
	end
	@assert !isnothing(cycle_start)
	cycle_i_final = mod1(N - i, cycle_len)
	load = seen[cycle_start + cycle_i_final][2]
	return load
end

# ╔═╡ 3fd7cee4-604b-4540-84a3-8c4fb0083ff7
function solution_part1(platform)
	load = 0
	nr = size(platform, 1)
	for col in eachcol(platform)
		hs = findall(==('#'), col)
		pushfirst!(hs, 0) # put cube rocks at 0th and nr+1th row to mark bounds
		push!(hs, nr+1)
		nh = length(hs)
		for i in eachindex(hs)
			start = i > 0 ? hs[i]+1 : 1
			stop  = i < nh ? hs[i+1]-1 : nh
			stop < start && continue
			no = count(==('O'), @view(col[start:stop]))
			no == 0 && continue
			load += sum(nr - start + 1 - i for i in 0:no-1)
		end
	end
	return load
end

# ╔═╡ bb8d06cf-99c4-4f6e-99d1-cd143f3600a5
function parse_input(inp)
	!isfile(inp) && (inp = IOBuffer(inp))
	return stack(readlines(inp); dims=1)
end

# ╔═╡ 9119bb64-d888-45f4-b5a2-b8780231188d
let
	inp = """O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#...."""

	platform = parse_input(inp)
	@testset "day14" begin
		@test solution_part1(platform) == 136
		@test solution_part2(platform) == 64
	end
end

# ╔═╡ 5e1627ed-b220-4aac-84b2-bcb1c51750df
let
	platform = parse_input("14.txt")
	println("Answer (Part 1): ", solution_part1(platform)) # 105249
	println("Answer (Part 2): ", solution_part2(platform)) # 88680
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[compat]
BenchmarkTools = "~1.4.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-rc2"
manifest_format = "2.0"
project_hash = "8f93676e131a79379fcb3966301ff44441e4e119"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "f1f03a9fa24271160ed7e73051fba3c1a759b53f"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.4.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.5+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.4.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.6.4+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

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

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.23+2"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "a935806434c9d4c506ba941871b327b96d41f2bf"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

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

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"
version = "1.10.0"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.10.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "7.2.1+1"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.8.0+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─6a6aa804-9a55-11ee-3746-b31295a027e0
# ╠═c870982e-9bc1-462e-ab56-989f3388a06b
# ╠═0567c71c-ac17-4981-9ca8-6e70fad9b270
# ╟─9119bb64-d888-45f4-b5a2-b8780231188d
# ╠═8d4d96f3-c79c-4455-87dc-a2deb9d1f2d9
# ╠═71cd39a3-98d7-495b-b401-e19d59d37a06
# ╠═277899e8-537f-47d4-a228-39990d6cbdf9
# ╠═a5103c7f-6b55-45f8-a96a-f1b6e73cc05c
# ╠═3fd7cee4-604b-4540-84a3-8c4fb0083ff7
# ╠═bb8d06cf-99c4-4f6e-99d1-cd143f3600a5
# ╠═5e1627ed-b220-4aac-84b2-bcb1c51750df
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
