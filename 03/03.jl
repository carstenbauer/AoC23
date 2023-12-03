### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ 9be4c587-3338-4f27-8f92-511c36617201
using Test

# ╔═╡ 9a6678de-0710-472f-bac9-011d1efe2255
md"# Day 02"

# ╔═╡ 4abeba38-9905-4011-8e3e-21dfc62853d5
md"## Part I"

# ╔═╡ 4945c8c9-128f-4860-a867-e9a68196de72
issym(c::Char) = c != '.' && !isdigit(c)

# ╔═╡ 8cc3fc7d-cf97-4154-bac6-9bb29cbd87d3
function contains_symbol(line, numstart, numend)
	lstart = max(numstart-1, 1)
	lend = min(numend+1, length(line))
	return any(issym, @view(line[lstart:lend]))
end

# ╔═╡ ac0d93b7-fa80-456f-acad-3b9824487ec0
function look_for_symbol(lines, l, numstart, numend)
	line = lines[l]
	# check next char
	if numend < length(line) && issym(line[numend+1])
		return true
	end
	# check prev char
	if numstart > 1 && issym(line[numstart-1])
		return true
	end
	# check line above
	if l > 1 && contains_symbol(lines[l-1], numstart, numend)
		return true
	end
	# check line below
	if l < length(lines) && contains_symbol(lines[l+1], numstart, numend)
		return true
	end
	return false
end

# ╔═╡ 3ee6cf94-0acc-4942-8b04-52b551542f60
function extract_part_numbers(lines)
	part_nums = Int[]
	for (l, line) in pairs(lines)
		numstart = -1
		numend   = -1
		lend = length(line)
		for (i, c) in pairs(line)
			if numstart == -1
				if isdigit(c)
					numstart = i
				end
			else
				if isdigit(c)
					if i < lend
						continue
					else
						numend = i
					end
				else
					numend = i-1
				end
				num = parse(Int, @view(line[numstart:numend]))
				# check if adjacent to a symbol
				if look_for_symbol(lines, l, numstart, numend)
					push!(part_nums, num)
				end
				numstart = -1
				numend   = -1
			end
		end
	end
	return part_nums
end

# ╔═╡ 76943b97-834f-49ef-a813-367b5b160a09
@testset "part1" begin
	test_input = raw"""467..114..
					   ...*......
					   ..35..633.
					   ......#...
					   617*......
					   .....+.58.
					   ..592.....
					   ......755.
					   ...$.*....
					   .664.598.."""
	test_lines = readlines(IOBuffer(test_input))
	@test sum(extract_part_numbers(test_lines)) == 4361
end

# ╔═╡ 3578cb56-f0b8-4afd-b62d-29b3f42995d8
let
    lines = readlines("03.txt")
	answer = sum(extract_part_numbers(lines))
    println("Answer: ", answer) # 520135
end

# ╔═╡ f3dcb094-9401-49bb-8f89-64c25f12f052
md"## Part II"

# ╔═╡ bf7715d0-5106-47b7-bcd9-f5fb660f233b
function issym2(c::Char; memory, num, l, i)
	if c != '.' && !isdigit(c)
		if !haskey(memory, (l,i))
			memory[(l,i)] = (num, )
		else
			memory[(l,i)] = (memory[(l,i)]..., num)
		end
		return true
	end
	return false
end

# ╔═╡ 63362a10-284d-4d3a-b0b5-420f5a497ff8
function contains_symbol2(line, numstart, numend; memory, num, l)
	lstart = max(numstart-1, 1)
	lend = min(numend+1, length(line))
	# any(issym2, @view(line[lstart:lend]))
	sym_found = false
	for i in lstart:lend
		c = line[i]
		if issym2(c; memory, num, l, i)
			sym_found = true
		end
	end
	return sym_found
end

# ╔═╡ 1b667246-59b1-4138-8478-9b9c9ae519ea
function look_for_symbol2(lines, l, numstart, numend; memory, num)
	line = lines[l]
	# check next char
	if numend < length(line) && issym2(line[numend+1]; memory, num, l, i=numend+1)
		return true
	end
	# check prev char
	if numstart > 1 && issym2(line[numstart-1]; memory, num, l, i=numstart-1)
		return true
	end
	# check line above
	if l > 1 && contains_symbol2(lines[l-1], numstart, numend; memory, num, l=l-1)
		return true
	end
	# check line below
	if l < length(lines) && contains_symbol2(lines[l+1], numstart, numend; memory, num, l=l+1)
		return true
	end
	return false
end

# ╔═╡ 9a1c51c9-898c-4922-ae4f-b27068015316
function extract_part_numbers2(lines)
	memory = Dict()
	part_nums = Int[]
	for (l, line) in pairs(lines)
		numstart = -1
		numend   = -1
		lend = length(line)
		for (i, c) in pairs(line)
			if numstart == -1
				if isdigit(c)
					numstart = i
				end
			else
				if isdigit(c)
					if i < lend
						continue
					else
						numend = i
					end
				else
					numend = i-1
				end
				num = parse(Int, @view(line[numstart:numend]))
				# check if adjacent to a symbol
				if look_for_symbol2(lines, l, numstart, numend; memory, num)
					push!(part_nums, num)
				end
				numstart = -1
				numend   = -1
			end
		end
	end
	return part_nums, memory
end

# ╔═╡ 72a2f8bb-a35f-41d9-a91e-229ae85e0c72
function sum_of_gear_ratios(memory)
	s = 0
	for (k,v) in memory
		if length(v) == 2
			s += prod(v)
		end
	end
	return s
end

# ╔═╡ 341f9fee-eb15-4705-8e40-e311d697e155
@testset "part2" begin
	test_input = raw"""467..114..
					   ...*......
					   ..35..633.
					   ......#...
					   617*......
					   .....+.58.
					   ..592.....
					   ......755.
					   ...$.*....
					   .664.598.."""
	test_lines = readlines(IOBuffer(test_input))
	part_nums, memory = extract_part_numbers2(test_lines)
	@test sum(part_nums) == 4361
	@test sum_of_gear_ratios(memory) == 467835
end

# ╔═╡ f7323af5-9064-4fc6-a79a-d3bcba424434
let
    lines = readlines("03.txt")
	part_nums, memory = extract_part_numbers2(lines)
    println("Answer (Part I): ", sum(part_nums)) # 520135
	println("Answer (Part II): ", sum_of_gear_ratios(memory)) # 72514855
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
# ╠═4945c8c9-128f-4860-a867-e9a68196de72
# ╠═8cc3fc7d-cf97-4154-bac6-9bb29cbd87d3
# ╠═ac0d93b7-fa80-456f-acad-3b9824487ec0
# ╠═3ee6cf94-0acc-4942-8b04-52b551542f60
# ╠═76943b97-834f-49ef-a813-367b5b160a09
# ╠═3578cb56-f0b8-4afd-b62d-29b3f42995d8
# ╟─f3dcb094-9401-49bb-8f89-64c25f12f052
# ╠═bf7715d0-5106-47b7-bcd9-f5fb660f233b
# ╠═63362a10-284d-4d3a-b0b5-420f5a497ff8
# ╠═1b667246-59b1-4138-8478-9b9c9ae519ea
# ╠═9a1c51c9-898c-4922-ae4f-b27068015316
# ╠═72a2f8bb-a35f-41d9-a91e-229ae85e0c72
# ╠═341f9fee-eb15-4705-8e40-e311d697e155
# ╠═f7323af5-9064-4fc6-a79a-d3bcba424434
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
