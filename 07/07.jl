### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 3f5c1196-661b-4c9d-addf-80b7e2afc601
using Test

# ╔═╡ 7114947e-9749-11ee-12ce-4bc7119e1b68
md"# Day 07"

# ╔═╡ f8d72de3-a7c8-486a-8e1e-3747e546e38c
begin
	const cardvals       = Dict(['2':'9'; "TJQKA"...] .=> 1:13)
	const cardvals_part2 = Dict(['2':'9'; "TJQKA"...] .=> [1:9; 0; 11:13])
end

# ╔═╡ 1d98a596-b80a-4a75-b2ac-2f7ce8293623
begin
	struct Hand
		cards::Vector{Int64}
		bid::Int64
		cardcounts::Vector{Int64} # sorted by card value (desc)
	end

	function Hand(cards_str::AbstractString, bid_str::AbstractString; part2)
		bid = parse(Int, bid_str)
		if !part2
			cards = [cardvals[c] for c in cards_str]
			cardcounts = sort!([count(==(c), cards) for c in unique(cards)]; rev=true)
			return Hand(cards, bid, cardcounts)
		else
			cards = [cardvals_part2[c] for c in cards_str]
			cards_noj = filter(!iszero, cards)
			cardcounts = sort!([count(==(c), cards_noj) for c in unique(cards_noj)]; rev=true)
			njokers = count(iszero, cards)
			if njokers == 5 # all cards are jokers
				cardcounts = [5]
			else
				cardcounts[1] += njokers
			end
			return Hand(cards, bid, cardcounts)
		end
	end
	
	Base.show(io::IO, h::Hand) = print(io, "Hand($(h.cards), $(h.bid))")
	
	function Base.isless(h1::Hand, h2::Hand)
		if h1.cardcounts == h2.cardcounts
			h1.cards < h2.cards
		else
			h1.cardcounts < h2.cardcounts
		end
	end
end

# ╔═╡ c8deb233-6b0b-4ede-9a91-5b6f89e064e9
parse_input(inp; part2=false) = [Hand(cards, bid; part2) for (cards, bid) in split.(split(inp, '\n'))]

# ╔═╡ 3a478e93-e6dd-4578-9fec-d95724e5e304
function total_winnings(hands)
	sh = sort(hands)
	return sum(i * h.bid for (i, h) in pairs(sh))
end

# ╔═╡ 96a365c2-4267-4fd5-93de-1f72c03e95f4
@testset "day 07" begin
	inp = """32T3K 765
			 T55J5 684
			 KK677 28
			 KTJJT 220
			 QQQJA 483"""
	hands = parse_input(inp)
	@test total_winnings(hands) == 6440

	hands2 = parse_input(inp; part2=true)
	@test total_winnings(hands2) == 5905
end

# ╔═╡ 542c458c-2132-4203-8d45-fcff2e0f0b64
let
	inp = read("07.txt", String)
	hands = parse_input(inp)
	println("Answer (Part 1): ", total_winnings(hands))
	hands2 = parse_input(inp; part2=true)
	println("Answer (Part 2): ", total_winnings(hands2))
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
# ╟─7114947e-9749-11ee-12ce-4bc7119e1b68
# ╠═3f5c1196-661b-4c9d-addf-80b7e2afc601
# ╠═96a365c2-4267-4fd5-93de-1f72c03e95f4
# ╠═1d98a596-b80a-4a75-b2ac-2f7ce8293623
# ╠═f8d72de3-a7c8-486a-8e1e-3747e546e38c
# ╠═c8deb233-6b0b-4ede-9a91-5b6f89e064e9
# ╠═3a478e93-e6dd-4578-9fec-d95724e5e304
# ╠═542c458c-2132-4203-8d45-fcff2e0f0b64
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
