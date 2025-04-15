# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

from atcoder.io import IO
from atcoder.modint import modint998244353
from atcoder.convolution import convolution

alias mint = modint998244353


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var M = io.nextInt()
    var a = List[mint]()
    for _ in range(N):
        a.append(mint(io.nextInt()))
    var b = List[mint]()
    for _ in range(M):
        b.append(mint(io.nextInt()))
    var ans = convolution(a, b)
    IO.print(ans)
