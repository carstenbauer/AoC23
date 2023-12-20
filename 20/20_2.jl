function parse_input(inp)
    modules = Dict()
    for line in eachsplit(inp, "\n")
        nt, ts = strip.(split(line, "->"))
        type = nt[1]
        name = nt[2:end]
        targets = strip.(split(ts, ','))
        if type == 'b'
            name = "broadcaster"
            mod = (; name, type, targets)
        elseif type == '%'
            mod = (; name, type, state=false, targets)
        elseif type == '&'
            mod = (; name, type, memory=Dict(), targets)
        end
        modules[name] = mod
    end

    conj_modules = filter(p -> p[2].type == '&', modules)
    for (n, m) in modules
        for t in m.targets
            if t in keys(conj_modules)
                conj_modules[t].memory[n] = false
            end
        end
    end
    return modules
end

function count_rx(modules; verbose=false)
    # Idea from HyperNeutrino (not obvious at all from the instructions 😠)
    feed = only(n for (n, m) in modules if "rx" in m.targets)
    seen = Dict(n => 0 for (n, m) in modules if feed in m.targets)
    cycle_lengths = Dict()

    cnt = 0
    while true
        cnt += 1
        Q = [(; from="button", to="broadcaster", pulse=false)]
        while !isempty(Q)
            (; from, to, pulse) = popfirst!(Q)
            !haskey(modules, to) && continue
            m = modules[to]

            if m.name == feed && pulse
                seen[from] += 1
                if !haskey(cycle_lengths, from)
                    cycle_lengths[from] = cnt
                else
                    @assert cnt == seen[from] * cycle_lengths[from]
                end

                if all(>(0), values(seen))
                    return lcm(values(cycle_lengths)...)
                end
            end

            if m.type == 'b'
                newpulse = pulse
            elseif m.type == '%'
                !pulse || continue # don't trigger on high pulse
                newm = (m..., state=!m.state)
                modules[m.name] = newm
                newpulse = !m.state
            elseif m.type == '&'
                m.memory[from] = pulse
                newpulse = !all(values(m.memory))
            end
            for t in m.targets
                push!(Q, (; from=m.name, to=t, pulse=newpulse))
            end
        end
    end
    return nothing
end

inp = read(joinpath(@__DIR__, "20.txt"), String);
modules = parse_input(inp)
println("Answer (Part 2): ", count_rx(modules)) # 246006621493687
