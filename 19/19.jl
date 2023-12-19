struct Part
    x::Int
    m::Int
    a::Int
    s::Int
end
Base.sum(p::Part) = p.x + p.m + p.a + p.s

struct Workflow
    name::String
    rules::Vector{Function}
end

function process_part(p, ws)
    w = ws["in"]
    while true
        for r in w.rules
            (b, next_workflow) = r(p)
            if b
                if next_workflow == "A"
                    return true
                elseif next_workflow == "R"
                    return false
                else
                    w = ws[next_workflow]
                    break
                end
            end
        end
    end
end

function parse_rule(rstr)
    if contains(rstr, ':')
        cond, next_workflow = split(rstr, ':')
        category = Symbol(cond[1])
        op = cond[2] == '<' ? (<) : (>)
        num = parse(Int, cond[3:end])
        f = (p) -> begin
            b = op(getfield(p, category), num)
            (b, next_workflow)
        end
    else
        f = (p) -> (true, rstr)
    end
    return f
end

function parse_workflow(wstr)
    name, rest = split(wstr, '{')
    rstrs = split(@view(rest[1:end-1]), ',')
    # rules = Tuple(parse_rule(rstr) for rstr in @view(rstrs[1:end-1]))
    rules = [parse_rule(rstr) for rstr in rstrs]
    # return Workflow(string(name), rules, string(last(rstrs)))
    return Workflow(string(name), rules)
end

function parse_part(pstr)
    nums = parse.(Int, last.(split.(split(@view(pstr[2:end-1]), ','), '=')))
    return Part(nums...)
end

function parse_input(inp)
    workflow_lines, part_lines = split(inp, "\n\n")
    # workflows
    ws = Dict{String,Workflow}()
    for l in eachsplit(workflow_lines, '\n')
        w = parse_workflow(l)
        push!(ws, w.name => w)
    end
    # parts
    parts = Part[]
    for l in eachsplit(part_lines, '\n')
        push!(parts, parse_part(l))
    end
    return ws, parts
end

# ---------------
let
    inp_ex = """px{a<2006:qkq,m>2090:A,rfg}
    pv{a>1716:R,A}
    lnx{m>1548:A,A}
    rfg{s<537:gd,x>2440:R,A}
    qs{s>3448:A,lnx}
    qkq{x<1416:A,crn}
    crn{x>2662:A,R}
    in{s<1351:px,qqz}
    qqz{s>2770:qs,m<1801:hdj,R}
    gd{a>3333:R,R}
    hdj{m>838:A,pv}

    {x=787,m=2655,a=1222,s=2876}
    {x=1679,m=44,a=2067,s=496}
    {x=2036,m=264,a=79,s=2244}
    {x=2461,m=1339,a=466,s=291}
    {x=2127,m=1623,a=2188,s=1013}"""

    workflows, parts = parse_input(inp_ex)
    mask = process_part.(parts, Ref(workflows))
    mapreduce(sum, +, @view(parts[mask])) # 19114
end

let
    workflows, parts = parse_input(read(joinpath(@__DIR__, "19.txt"), String))
    mask = process_part.(parts, Ref(workflows))
    total_rating = mapreduce(sum, +, @view(parts[mask]))
    println("Answer (Part 1): ", total_rating)
end
