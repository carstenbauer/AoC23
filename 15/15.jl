### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 2db3b557-12ad-49c9-a743-8da6327db926
using Test

# ╔═╡ 9b8cc7e8-9c18-11ee-1dbb-999d758b57a2
md"# Day 15"

# ╔═╡ 12f77dfe-57d9-48e3-938b-df9a9897aed7
function parse_input(inp)
	isfile(inp) && (inp = read(inp, String))
	seq = replace(inp, "\n" => "")
	return split(seq, ',')
end

# ╔═╡ 6aa088e0-683e-4848-823d-789b70dd9636
function hash_alg(str)
	val = 0
	for c in str
		val += Int(c)
		val *= 17
		val = rem(val, 256)
	end
	return val
end

# ╔═╡ 9f60df4d-05c6-4e81-809b-a325b5a088ce
begin
	struct Lens
		label::String
		focal_length::Int
	end
	
	get_label(l::Lens) = l.label
	get_focal_length(l::Lens) = l.focal_length
end

# ╔═╡ dc8b4b3a-4a28-4374-a4f7-96f94cb73b7a
function step!(boxes, str)
	i = findfirst(c -> c == '=' || c == '-', str)
	label = str[1:i-1]
	op = str[i]
	box = boxes[hash_alg(label)+1]
	if op == '-'
		j = findfirst(l->get_label(l) == label, box)
		if !isnothing(j)
			deleteat!(box, j)
		end
	else
		focal_length = parse(Int, str[i+1:end])
		l = Lens(label, focal_length)
		j = findfirst(l->get_label(l) == label, box)
		if !isnothing(j)
			box[j] = l
		else
			push!(box, l)
		end
	end
	return nothing
end

# ╔═╡ 0ea5e7c1-b1d1-4535-99fe-81dd689ebdfa
function solution_part2(steps)
	boxes = [Lens[] for _ in 0:255]
	for s in steps
		step!(boxes, s)
	end
	focusing_power = 0
	for (b, box) in enumerate(boxes)
		for (l, lens) in enumerate(box)
			focusing_power += b * l * get_focal_length(lens)
		end
	end
	return focusing_power
end

# ╔═╡ 71ff3e4c-f2f4-476f-80d2-6744635abce8
let
	inp = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
	steps = parse_input(inp)
	@testset "day15" begin
		@test hash_alg("HASH") == 52
		@test sum(hash_alg, steps) == 1320
		@test solution_part2(steps) == 145
	end
end

# ╔═╡ c8218fec-d555-4303-97c9-48b703e4ccbc
let
	steps = parse_input("15.txt")
	println("Answer (Part 1): ", sum(hash_alg, steps))
	println("Answer (Part 2): ", solution_part2(steps))
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
# ╟─9b8cc7e8-9c18-11ee-1dbb-999d758b57a2
# ╠═2db3b557-12ad-49c9-a743-8da6327db926
# ╠═71ff3e4c-f2f4-476f-80d2-6744635abce8
# ╠═12f77dfe-57d9-48e3-938b-df9a9897aed7
# ╠═6aa088e0-683e-4848-823d-789b70dd9636
# ╠═9f60df4d-05c6-4e81-809b-a325b5a088ce
# ╠═0ea5e7c1-b1d1-4535-99fe-81dd689ebdfa
# ╠═dc8b4b3a-4a28-4374-a4f7-96f94cb73b7a
# ╠═c8218fec-d555-4303-97c9-48b703e4ccbc
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
