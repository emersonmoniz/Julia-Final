using Base.Threads;
using Distributed;

import Statistics

@everywhere function computeDotProduct(N)
    #=
    Computes dot product of N
    Returns the sum of Dot Product
    =#
    a=fill(2.0,N)
    b=fill(2.0,N)
    result = 0
    for i = 1:N
        result += a[i] .* b[i]
    end
    return result
end

N=100000000
nt = nthreads()
println("The number of threads : $nt")
println("N is: $N")
smallDotProducts = zeros(nt)
timeZ = zeros(nt)
numS = convert(Int64,N/nt)
@sync @distributed for i=1:nt
    timestart = time()
	smallDotProducts[i] = computeDotProduct(numS)
    timeZ[i] = time() -timestart
end
elapsed = Statistics.mean(timeZ)
totalResult = convert(Int64,sum(smallDotProducts))
println("The sum for all dot products is: $totalResult")
println("The elapsed time : $elapsed seconds")
