# verification-helper: PROBLEM https://judge.yosupo.jp/problem/convolution_mod

from atcoder.io import IO
from atcoder.modint import modint998244353
from atcoder.convolution import convolution

alias mint = modint998244353


fn main() raises:
    var io = IO()
    var N = io.nextInt()
    var M = io.nextInt()
    var a = io.nextList[mint](N)
    var b = io.nextList[mint](M)
    var ans = convolution(a, b)
    IO.print(ans)
