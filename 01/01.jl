### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 9be4c587-3338-4f27-8f92-511c36617201
using Test

# ╔═╡ 9a6678de-0710-472f-bac9-011d1efe2255
md"# Day 01"

# ╔═╡ 4abeba38-9905-4011-8e3e-21dfc62853d5
md"## Part I"

# ╔═╡ 187356e0-9017-11ee-1c63-1d7caf87f6e1
function getnumber(line)
    i = findfirst(isdigit, line)
    j = findlast(isdigit, line)
    return parse(Int, string(line[i],line[j]))
end

# ╔═╡ 0f670d4e-851b-4a50-b267-421814088475
@testset "getnumber" begin
	@test getnumber("1abc2") == 12
	@test getnumber("pqr3stu8vwx") == 38
	@test getnumber("a1b2c3d4e5f") == 15
	@test getnumber("treb7uchet") == 77
end

# ╔═╡ a4c8e948-fdb5-45e9-a17a-1cdf5af672d0
let
    lines = readlines("01.txt")
    println("Answer: ", sum(getnumber, lines))
end

# ╔═╡ f3dcb094-9401-49bb-8f89-64c25f12f052
md"## Part II"

# ╔═╡ ea9f4acb-cd1c-4255-94f4-672d09edcc7c
function try_get_num_from_string(str)
	startswith(str, "one") && return 1
	startswith(str, "two") && return 2
	startswith(str, "three") && return 3
	startswith(str, "four") && return 4
	startswith(str, "five") && return 5
	startswith(str, "six") && return 6
	startswith(str, "seven") && return 7
	startswith(str, "eight") && return 8
	startswith(str, "nine") && return 9
	return nothing
end

# ╔═╡ 6950fa4b-b388-419d-bc79-b1aefe9506a4
function getnumber_part2(line)
	num_first = nothing
	num_last  = nothing
	for (i, c) in pairs(line)
		if isdigit(c)
			num = parse(Int, c)
		else
			num = try_get_num_from_string(@view line[i:end])
			isnothing(num) && continue
		end
		
		if isnothing(num_first)
			num_first = num
		end
		num_last = num
	end
    return num_first * 10 + num_last
end

# ╔═╡ 64aaf9cd-ed6e-4303-ab74-28aa0132c3a0
@testset "getnumber_part2" begin
	@test getnumber_part2("two1nine") == 29
	@test getnumber_part2("eightwothree") == 83
	@test getnumber_part2("abcone2threexyz") == 13
	@test getnumber_part2("xtwone3four") == 24
	@test getnumber_part2("4nineeightseven2") == 42
	@test getnumber_part2("zoneight234") == 14
	@test getnumber_part2("7pqrstsixteen") == 76		
end

# ╔═╡ d835b47b-ac55-4adc-a027-cb7682c89548
let
    lines = readlines("01.txt")
    println("Answer: ", sum(getnumber_part2, lines))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-rc1"
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
# ╟─9a6678de-0710-472f-bac9-011d1efe2255
# ╠═9be4c587-3338-4f27-8f92-511c36617201
# ╟─4abeba38-9905-4011-8e3e-21dfc62853d5
# ╠═187356e0-9017-11ee-1c63-1d7caf87f6e1
# ╠═0f670d4e-851b-4a50-b267-421814088475
# ╠═a4c8e948-fdb5-45e9-a17a-1cdf5af672d0
# ╟─f3dcb094-9401-49bb-8f89-64c25f12f052
# ╠═ea9f4acb-cd1c-4255-94f4-672d09edcc7c
# ╠═6950fa4b-b388-419d-bc79-b1aefe9506a4
# ╠═64aaf9cd-ed6e-4303-ab74-28aa0132c3a0
# ╠═d835b47b-ac55-4adc-a027-cb7682c89548
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
