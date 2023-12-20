function parse_input(inp)
    workflow_lines, _ = split(inp, "\n\n")
    workflows = Dict()
    for line in eachsplit(workflow_lines, '\n')
        name, rest = split(line, '{')
        rules = split(rest, ',')
        default = pop!(rules)[1:end-1]
        wrules = []
        for rule in rules
            r, next = split(rule, ':')
            prop = r[1]
            op = r[2]
            n = parse(Int, r[3:end])
            push!(wrules, (; prop, op, n, next))
        end
        workflows[name] = (; rules=wrules, default)
    end
    return workflows
end

function count_accepted(ranges, workflow; workflows)
    if workflow == "R"
        return 0
    elseif workflow == "A"
        return prod(length.(values(ranges)))
    end

    cnt = 0
    early_stop = false
    (; rules, default) = workflows[workflow]
    for (; prop, op, n, next) in rules
        r = ranges[prop]
        if op == '<'
            rt = r.start:(n-1)
            rf = n:r.stop
        elseif op == '>'
            rt = (n+1):r.stop
            rf = r.start:n
        end
        if !isempty(rt)
            rngs = copy(ranges)
            rngs[prop] = rt
            cnt += count_accepted(rngs, next; workflows)
            # break?
        end
        if !isempty(rf)
            ranges = copy(ranges)
            ranges[prop] = rf
        else
            early_stop = true
            break
        end
    end
    if !early_stop
        cnt += count_accepted(ranges, default; workflows)
    end
    return cnt
end

# let
#     inp_ex = """px{a<2006:qkq,m>2090:A,rfg}
# pv{a>1716:R,A}
# lnx{m>1548:A,A}
# rfg{s<537:gd,x>2440:R,A}
# qs{s>3448:A,lnx}
# qkq{x<1416:A,crn}
# crn{x>2662:A,R}
# in{s<1351:px,qqz}
# qqz{s>2770:qs,m<1801:hdj,R}
# gd{a>3333:R,R}
# hdj{m>838:A,pv}

# {x=787,m=2655,a=1222,s=2876}
# {x=1679,m=44,a=2067,s=496}
# {x=2036,m=264,a=79,s=2244}
# {x=2461,m=1339,a=466,s=291}
# {x=2127,m=1623,a=2188,s=1013}"""

#     workflows = parse_input(inp_ex)
#     input_ranges = Dict(prop => 1:4000 for prop in "xmas")
#     count_accepted(input_ranges, "in"; workflows) # 167409079868000
# end

let
    workflows = parse_input(read(joinpath(@__DIR__, "19.txt"), String))
    input_ranges = Dict(prop => 1:4000 for prop in "xmas")
    println("Answer (Part 2): ", count_accepted(input_ranges, "in"; workflows)) # 141882534122898
end
