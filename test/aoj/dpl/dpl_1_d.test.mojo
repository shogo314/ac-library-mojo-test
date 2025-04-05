# verification-helper: PROBLEM https://onlinejudge.u-aizu.ac.jp/problems/DPL_1_D

from atcoder.io import IO
from atcoder.ext.longest_increasing_subsequence import (
    longest_increasing_subsequence,
)


fn main() raises:
    var io = IO()
    var n = io.nextInt()
    var a = List[Int]()
    for _ in range(n):
        a.append(io.nextInt())
    print(longest_increasing_subsequence(a))
