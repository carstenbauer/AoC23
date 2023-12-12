### A Pluto.jl notebook ###
# v0.19.32

using Markdown
using InteractiveUtils

# ╔═╡ c27c2420-551f-45ef-9c30-a8b98febefd4
using Test

# ╔═╡ 69eda1ea-982a-11ee-0ef8-eb4cd0938fd1
md"# Day 10"

# ╔═╡ d7f4ad05-dad1-4223-9d42-6eb29a4c432c
check_bounds(idx; board) = 0 < idx[1] <= size(board, 1) && 0 < idx[2] <= size(board, 2)

# ╔═╡ 3b05d1a8-020f-4c6d-9a24-07e2cdd6777c
begin
	const down = CartesianIndex(1,0)
	const up = CartesianIndex(-1,0)
	const right = CartesianIndex(0,1)
	const left = CartesianIndex(0,-1)

	const pipes = Dict{Tuple{Char, typeof(down)}, typeof(down)}(
		('|', down)  => down,
		('|', up)    => up,
		('-', left)  => left,
		('-', right) => right,
		('L', down)  => right,
		('L', left)  => up,
		('J', down)  => left,
		('J', right) => up,
		('7', up)    => left,
		('7', right) => down,
		('F', up)    => right,
		('F', left)  => down,
	)
end

# ╔═╡ ffae1512-db4c-4040-a409-c34d8c8c65e8
function find_possible_directions(pos; board)
	dirs = typeof(down)[]
	for dir in (down, left, up, right)
		newpos = pos + dir
		check_bounds(newpos; board) || continue
		c = board[newpos]
		haskey(pipes, (c, dir)) && push!(dirs, dir)
	end
	if isempty(dirs)
		error("Couldn't find a way to get off the starting title!")
	end
	return dirs
end

# ╔═╡ 52f4c4ec-2d9c-4906-8d22-7ed67692515e
function make_move!(pos, dir; board, path)
	newpos = pos + dir
	push!(path, newpos)
	c = board[newpos]
	if haskey(pipes, (c, dir))
		newdir = pipes[(c, dir)]
		return (newpos, newdir)
	end
	return (newpos, nothing)
end

# ╔═╡ 52cbdcab-e3aa-4799-9ba8-55cf4948b506
function move_along_loop!(pos, dir; board, path)
	while true
		pos, dir = make_move!(pos, dir; board, path)
		isnothing(dir) && break
	end
	return path
end

# ╔═╡ 134365ba-ef39-4117-91aa-5da789b97d31
parse_input(inp) = stack(readlines(inp); dims=1)

# ╔═╡ 6740f2b6-605e-49e6-95aa-1116ef2ba6e6
function replace_S_by_element!(board)
	spos = findfirst(==('S'), board)
	sdirs = find_possible_directions(spos; board)
	p = filter(pipes) do (k,v)
		v in sdirs
	end
	elements = first.(keys(p))
	el = first(x for x in elements if count(==(x), elements) > 1)
	board[spos] = el
	return nothing
end

# ╔═╡ 4bde1b24-57b9-4fae-99d9-623ed7ac24d5
function integrate(; board, path)
	# create "marker" board which only has the valid loop
	markers = Union{Char, Int}[' ' for i in axes(board, 1), j in axes(board, 2)]
	for p in path
		markers[p] = board[p]
	end
	replace_S_by_element!(markers)

	# figure out area elements column-by-column
	for col in eachcol(markers)
		inside = false
		path_start = nothing
		area_start = nothing
		if first(col) != ' '
			path_start = 1
		else
			area_start = 1
		end
		for (i, c) in pairs(col)
			if c != ' ' # we're on a path element
				c == '|' && continue

				if i > 1
					prevc = col[i-1]
					if prevc == ' ' # area -> path
						col[area_start:i-1] .= inside ? 'I' : 'O'
						area_start = nothing
						path_start = i
					end
				end

				if i < length(col)
					nextc = col[i+1]
					if nextc == ' ' # path -> area
						if !(string(col[path_start], c) in  ("FL", "7J"))
							inside = !inside
						end
						area_start = i+1
						path_start = nothing
					elseif c in ('L', 'J', '-') # path -> new path
						if !(string(col[path_start], c) in  ("FL", "7J"))
							inside = !inside
						end
						path_start = i+1
					end
				end
			end
		end
	end
	count(==('I'), markers), markers
end

# ╔═╡ 7b5f1dd4-ba92-4852-87fc-23b47e8fc1ec
function solution(board)
	# part 1
	pos = findfirst(==('S'), board)
	dirs = find_possible_directions(pos; board)
	path = [pos]
	move_along_loop!(pos, first(dirs); board, path)
	
	# part 2
	# ...
	num_inner_tiles, markers = integrate(; board, path)
	
	return (; farthest=ceil(Int, (length(path)-2)/2), markers, num_inner_tiles)
end

# ╔═╡ e8def5fd-a5a4-4350-9e6d-c8160f05b267
@testset "day10" begin
	inp = """7-F7-
			 .FJ|7
			 SJLL7
			 |F--J
			 LJ.LJ"""
	sol = solution(parse_input(IOBuffer(inp)))
	@test sol.farthest == 8

	inp2 = """.....
			  .S-7.
			  .|.|.
			  .L-J.
			  ....."""
	sol = solution(parse_input(IOBuffer(inp2)))
	@test sol.farthest == 4
end

# ╔═╡ ed13c88b-a39b-4149-963e-3a5474569112
@testset "day 10_2" begin
	inp = """...........
			 .S-------7.
			 .|F-----7|.
			 .||.....||.
			 .||.....||.
			 .|L-7.F-J|.
			 .|..|.|..|.
			 .L--J.L--J.
			 ..........."""

	board = parse_input(IOBuffer(inp))
	sol = solution(board)
	@test sol.num_inner_tiles == 4

	inp = """..........
			 .S------7.
			 .|F----7|.
			 .||OOOO||.
			 .||OOOO||.
			 .|L-7F-J|.
			 .|II||II|.
			 .L--JL--J.
			 .........."""

	board = parse_input(IOBuffer(inp))
	sol = solution(board)
	@test sol.num_inner_tiles == 4

	inp = """.F----7F7F7F7F-7....
			 .|F--7||||||||FJ....
			 .||.FJ||||||||L7....
			 FJL7L7LJLJ||LJ.L-7..
			 L--J.L7...LJS7F-7L7.
			 ....F-J..F7FJ|L7L7L7
			 ....L7.F7||L7|.L7L7|
			 .....|FJLJ|FJ|F7|.LJ
			 ....FJL-7.||.||||...
			 ....L---J.LJ.LJLJ..."""

	board = parse_input(IOBuffer(inp))
	sol = solution(board)
	@test sol.num_inner_tiles == 8
end

# ╔═╡ 2986458c-3701-4480-87de-4ca0672b42ba
let
	board = parse_input("10.txt")
	sol = solution(board)

	println("Answer (Part 1): ", sol.farthest)
	println("Answer (Part 2): ", sol.num_inner_tiles)
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
# ╟─69eda1ea-982a-11ee-0ef8-eb4cd0938fd1
# ╠═c27c2420-551f-45ef-9c30-a8b98febefd4
# ╟─e8def5fd-a5a4-4350-9e6d-c8160f05b267
# ╟─ed13c88b-a39b-4149-963e-3a5474569112
# ╠═7b5f1dd4-ba92-4852-87fc-23b47e8fc1ec
# ╠═ffae1512-db4c-4040-a409-c34d8c8c65e8
# ╠═d7f4ad05-dad1-4223-9d42-6eb29a4c432c
# ╠═52cbdcab-e3aa-4799-9ba8-55cf4948b506
# ╠═52f4c4ec-2d9c-4906-8d22-7ed67692515e
# ╠═3b05d1a8-020f-4c6d-9a24-07e2cdd6777c
# ╠═134365ba-ef39-4117-91aa-5da789b97d31
# ╠═6740f2b6-605e-49e6-95aa-1116ef2ba6e6
# ╠═4bde1b24-57b9-4fae-99d9-623ed7ac24d5
# ╠═2986458c-3701-4480-87de-4ca0672b42ba
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
