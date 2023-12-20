# inp1 = """broadcaster -> a, b, c
# %a -> b
# %b -> c
# %c -> inv
# &inv -> a"""

# inp2 = """broadcaster -> a
# %a -> inv, con
# &inv -> b
# %b -> con
# &con -> output"""

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

function push_button(modules; verbose=false)
    verbose && println()
    nlo = 0
    nhi = 0
    Q = [(; from="button", to="broadcaster", pulse=false)]
    while !isempty(Q)
        (; from, to, pulse) = popfirst!(Q)
        verbose && println(from, " -", pulse ? "high" : "low", "-> ", to)
        if pulse
            nhi += 1
        else
            nlo += 1
        end
        !haskey(modules, to) && continue
        m = modules[to]

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
    verbose && @info("", nlo, nhi)
    verbose && println()
    return [nlo, nhi]
end

function prod_lohi(inp; n=1000, verbose=false)
    modules = parse_input(inp)
    nlo, nhi = sum((_)->push_button(modules; verbose), 1:n)
    verbose && @info("", nlo, nhi, nlo*nhi)
    return nlo*nhi
end

# prod_lohi(inp2; n=4, verbose=true);
# prod_lohi(inp1);
# prod_lohi(inp2);
inp = read(joinpath(@__DIR__, "20.txt"), String);
println("Answer (Part 1): ", prod_lohi(inp)) # 841763884
