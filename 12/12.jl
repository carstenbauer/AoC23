### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ dbfde17e-f959-4608-bae7-b6671ab7445d
using Test

# ╔═╡ 4c9a1614-98ff-11ee-1cca-a50b82630dbd
md"# Day 12"

# ╔═╡ c8a81a54-630a-48cb-abd6-ab88c5c62ffd
function parse_input(inp)
	map(eachline(inp)) do line
		conf, num_str = split(line)
		nums = parse.(Int, split(num_str, ','))
		(; conf, nums)
	end
end

# ╔═╡ 8f5f0c7a-b12b-4bdb-b6b8-2b2a6353c8b3
function _count_arrangements(conf, nums; memory)
	nchars = length(conf)
	nnums = length(nums)
	if isempty(nums) # no requests anymore
		return contains(conf, '#') ? 0 : 1
	elseif nchars == 0 # not chars left
		return 0
	elseif nchars < nnums - 1 + sum(nums) # nchars < ndots + n
		return 0
	end

	cnt = 0
	c = first(conf)
	n, nrest... = nums

	if c in ('?', '#') # can start now?
		cond1 = !contains(@view(conf[1:n]), '.') # not crossing dots?
		cond2 = nchars == n || conf[n+1] != '#'  # not ending in front of '#'?
		if cond1 && cond2
			cnt += count_arrangements(@view(conf[begin+n+1:end]), nrest; memory)
		end
	end
	if c in ('?', '.') # can postpone?
		cnt += count_arrangements(@view(conf[begin+1:end]), nums; memory)
	end
	return cnt
end

# ╔═╡ 072e6b13-81bd-4f2e-92a1-809dea97da0f
function count_arrangements(conf, nums; memory=Dict())
	return get!(memory, (conf, nums)) do
		_count_arrangements(conf, nums; memory)
	end
end

# ╔═╡ ee2bc294-25a1-49cd-99ac-4fdeee9352d4
function unfold(r)
	conf = join((r.conf for _ in 1:5), '?')
	nums = repeat(r.nums, 5)
	return (; conf, nums)
end

# ╔═╡ ee270817-b21f-4119-b8df-7f88722c61ec
let
	inp = """???.### 1,1,3
			 .??..??...?##. 1,1,3
			 ?#?#?#?#?#?#?#? 1,3,1,6
			 ????.#...#... 4,1,1
			 ????.######..#####. 1,6,5
			 ?###???????? 3,2,1"""

	records = parse_input(IOBuffer(inp))
	s = sum(records) do r
		count_arrangements(r.conf, r.nums)
	end

	@testset "day12" begin
		@test s == 21
		@test unfold((conf="???.###", nums=[1,1,3])) == (conf="???.###????.###????.###????.###????.###", nums=[1,1,3,1,1,3,1,1,3,1,1,3,1,1,3])
	end
end

# ╔═╡ b4777b7e-1630-4e65-ab8c-1a65404af7b3
let
	records = parse_input("12.txt")
	s = sum(records) do r
		count_arrangements(r.conf, r.nums)
	end
	println("Answer (Part 1): ", s) # 7670

	records = parse_input("12.txt")
	s = sum(records) do r
		rr = unfold(r)
		count_arrangements(rr.conf, rr.nums)
	end
	println("Answer (Part 2): ", s)
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
# ╟─4c9a1614-98ff-11ee-1cca-a50b82630dbd
# ╠═dbfde17e-f959-4608-bae7-b6671ab7445d
# ╟─ee270817-b21f-4119-b8df-7f88722c61ec
# ╠═c8a81a54-630a-48cb-abd6-ab88c5c62ffd
# ╠═072e6b13-81bd-4f2e-92a1-809dea97da0f
# ╠═8f5f0c7a-b12b-4bdb-b6b8-2b2a6353c8b3
# ╠═ee2bc294-25a1-49cd-99ac-4fdeee9352d4
# ╠═b4777b7e-1630-4e65-ab8c-1a65404af7b3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
