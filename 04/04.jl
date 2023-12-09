### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ de3d3a57-75c4-4ec5-8b40-1d652e731b65
using Test

# ╔═╡ 71e97bb6-928b-11ee-0cba-4d6045fbe011
md"# Day 04"

# ╔═╡ bac4e18e-1c9d-4252-bd55-52b44bfe8018
get_integers(str) = Tuple(parse(Int, m.match) for m in eachmatch(r"\d+", str))

# ╔═╡ 7bf411b1-f7e7-4403-a056-0af0375d7a60
function parse_card(str)
	s = split(str, '|')
	cardnr, winning_nums... = get_integers(s[1])
	our_nums = get_integers(s[2])
	return (nr=cardnr, wnums=winning_nums, onums=our_nums)
end

# ╔═╡ 94de49b0-2ced-47f0-bdc9-1dc7ac1143a8
function count_winners(card)
	nunique = length(union(Set(card.wnums), Set(card.onums)))
	return length(card.wnums) + length(card.onums) - nunique
end

# ╔═╡ 42ac9468-878c-42ee-917e-c9d886128d7a
function calc_card_points(card)
	nwin = count_winners(card)
	return nwin > 0 ? 2^(nwin-1) : 0
end

# ╔═╡ c242830a-d956-4eb4-8a6b-b5d5749d352f
@testset "part1" begin
	test_input = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
					Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
					Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
					Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
					Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
					Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"""
	lines = readlines(IOBuffer(test_input))
	cards = parse_card.(lines)
	@test calc_card_points.(cards) == [8, 2, 2, 1, 0, 0]
end

# ╔═╡ 0003bec4-b507-4ad9-b3d1-cd8cd1fab6ed
let
	lines = readlines("04.txt")
	cards = parse_card.(lines)
	println("Answer: ", sum(calc_card_points, cards))
end

# ╔═╡ 4c34c6e6-b6f5-44e8-bf55-bc4a199e91a2
md"## Part 2"

# ╔═╡ ad6b7939-11fa-4da3-b3e2-eb73f7e19fad
function count_copied_scratchcards(nr, cards)
	n = count_winners(cards[nr])
	n == 0 && return 0
	return n+sum(i->count_copied_scratchcards(i, cards), nr+1:nr+n)
end

# ╔═╡ a66c3802-8958-428c-9bca-7ba6bfb21833
function count_all_scratchcards(cards)
	return length(cards) + sum(i->count_copied_scratchcards(i,cards), 1:length(cards))
end

# ╔═╡ 412941b9-0420-4bba-aee1-22e826abbc22
@testset "part2" begin
	test_input = """Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
					Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
					Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
					Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
					Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
					Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"""
	lines = readlines(IOBuffer(test_input))
	cards = parse_card.(lines)
	@test count_all_scratchcards(cards) == 30
end

# ╔═╡ 52fe43cc-ed93-443b-8505-23f3ed647fa7
let
	lines = readlines("04.txt")
	cards = parse_card.(lines)
	println("Answer: ", count_all_scratchcards(cards))
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Test = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.4"
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
deps = ["SHA", "Serialization"]
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
# ╟─71e97bb6-928b-11ee-0cba-4d6045fbe011
# ╠═de3d3a57-75c4-4ec5-8b40-1d652e731b65
# ╠═c242830a-d956-4eb4-8a6b-b5d5749d352f
# ╠═bac4e18e-1c9d-4252-bd55-52b44bfe8018
# ╠═7bf411b1-f7e7-4403-a056-0af0375d7a60
# ╠═94de49b0-2ced-47f0-bdc9-1dc7ac1143a8
# ╠═42ac9468-878c-42ee-917e-c9d886128d7a
# ╠═0003bec4-b507-4ad9-b3d1-cd8cd1fab6ed
# ╟─4c34c6e6-b6f5-44e8-bf55-bc4a199e91a2
# ╠═ad6b7939-11fa-4da3-b3e2-eb73f7e19fad
# ╠═a66c3802-8958-428c-9bca-7ba6bfb21833
# ╠═412941b9-0420-4bba-aee1-22e826abbc22
# ╠═52fe43cc-ed93-443b-8505-23f3ed647fa7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
