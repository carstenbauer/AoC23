### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 597056ac-181e-4de2-aa4b-31edee1ee8da
using Test

# ╔═╡ 1d27b4d0-9808-11ee-0557-69e4f82d7479
md"# Day 09"

# ╔═╡ 1f530791-9420-4019-a2f6-ff7fc981b099
parse_input(inp) = (h->parse.(Int, h)).(split.(split(inp, '\n')))

# ╔═╡ e8778f53-17fb-40dc-a4b9-b29e4fbda02b
begin
	predict(h; pick=last, op=+) = op(pick(h), predict_rec(h; pick, op))
	
	function predict_rec(h; pick, op)
		all(iszero, h) && return 0
		d = diff(h)
		return op(pick(d), predict_rec(d; pick, op))
	end
end

# ╔═╡ bb2a98fe-4204-4406-953a-fd93970baa79
@testset "day09" begin
	inp = """0 3 6 9 12 15
			 1 3 6 10 15 21
			 10 13 16 21 30 45"""
	histories = parse_input(inp)
	@test predict.(histories) == [18, 28, 68]
	@test sum(predict, histories) == 114

	@test predict.(histories; pick=first, op=-) == [-3, 0, 5]
	@test sum(h->predict(h; pick=first, op=-), histories) == 2
end

# ╔═╡ 0f246d0b-d523-4602-b6b9-7a04fcfb59b1
let
	histories = parse_input(read("09.txt", String))
	println("Answer (Part 1): ", sum(predict, histories))

	println("Answer (Part 2): ", sum(h->predict(h; pick=first, op=-), histories))
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
# ╟─1d27b4d0-9808-11ee-0557-69e4f82d7479
# ╠═597056ac-181e-4de2-aa4b-31edee1ee8da
# ╟─bb2a98fe-4204-4406-953a-fd93970baa79
# ╠═1f530791-9420-4019-a2f6-ff7fc981b099
# ╠═e8778f53-17fb-40dc-a4b9-b29e4fbda02b
# ╠═0f246d0b-d523-4602-b6b9-7a04fcfb59b1
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
