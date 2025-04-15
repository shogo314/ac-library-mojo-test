from testing import assert_true

from atcoder.internal_bit import countr_zero, bit_ceil
from atcoder.method_traits import (
    HasAdd,
    HasMul,
    HasSub,
    HasInitInt,
    HasInitUInt64,
)
from atcoder.internal_math import _primitive_root
from atcoder.modint import StaticModint


trait ModintTrait(
    CollectionElement,
    Defaultable,
    HasInitInt,
    HasInitUInt64,
    HasAdd,
    HasMul,
    HasSub,
):
    @staticmethod
    fn mod() -> Int:
        pass

    @staticmethod
    fn modu64() -> UInt64:
        pass

    fn val(self) -> Int:
        pass

    fn valu64(self) -> UInt64:
        pass

    fn pow(self, x: Int) raises -> Self:
        pass

    fn inv(self) raises -> Self:
        pass


struct _FFTInfo[mint: ModintTrait]:
    var root: List[mint]
    var iroot: List[mint]
    var rate2: List[mint]
    var irate2: List[mint]
    var rate3: List[mint]
    var irate3: List[mint]

    fn __init__(out self) raises:
        var g = _primitive_root(mint.mod())
        var rank2 = countr_zero(mint.mod() - 1)

        self.root = List[mint](mint()) * (rank2 + 1)
        self.iroot = List[mint](mint()) * (rank2 + 1)
        self.rate2 = List[mint](mint()) * max(0, rank2 - 1)
        self.irate2 = List[mint](mint()) * max(0, rank2 - 1)
        self.rate3 = List[mint](mint()) * max(0, rank2 - 2)
        self.irate3 = List[mint](mint()) * max(0, rank2 - 2)

        self.root[rank2] = mint(g).pow((mint.mod() - 1) >> rank2)
        self.iroot[rank2] = self.root[rank2].inv()
        for i in reversed(range(rank2)):
            self.root[i] = self.root[i + 1] * self.root[i + 1]
            self.iroot[i] = self.iroot[i + 1] * self.iroot[i + 1]

        var prod = mint(1)
        var iprod = mint(1)
        for i in range(rank2 - 1):
            self.rate2[i] = self.root[i + 2] * prod
            self.irate2[i] = self.iroot[i + 2] * iprod
            prod = prod * self.iroot[i + 2]
            iprod = iprod * self.root[i + 2]

        prod = mint(1)
        iprod = mint(1)
        for i in range(rank2 - 2):
            self.rate3[i] = self.root[i + 3] * prod
            self.irate3[i] = self.iroot[i + 3] * iprod
            prod = prod * self.iroot[i + 3]
            iprod = iprod * self.root[i + 3]


fn _butterfly[mint: ModintTrait](mut a: List[mint]) raises:
    var n = len(a)
    var h = countr_zero(n)
    var info = _FFTInfo[mint]()
    var ln = 0
    while ln < h:
        if h - ln == 1:
            var p = 1 << (h - ln - 1)
            var rot = mint(1)
            for s in range(1 << ln):
                var offset = s << (h - ln)
                for i in range(p):
                    var l = a[i + offset]
                    var r = a[i + offset + p] * rot
                    a[i + offset] = l + r
                    a[i + offset + p] = l - r
                if s + 1 != (1 << ln):
                    rot = rot * info.rate2[countr_zero(~UInt32(s))]
            ln += 1
        else:
            var p = 1 << (h - ln - 2)
            var rot = mint(1)
            var imag = info.root[2]
            for s in range(1 << ln):
                var rot2 = rot * rot
                var rot3 = rot2 * rot
                var offset = s << (h - ln)
                for i in range(p):
                    var mod2 = mint.modu64() * mint.modu64()
                    var a0 = a[i + offset].valu64()
                    var a1 = a[i + offset + p].valu64() * rot.valu64()
                    var a2 = a[i + offset + 2 * p].valu64() * rot2.valu64()
                    var a3 = a[i + offset + 3 * p].valu64() * rot3.valu64()
                    var a1na3imag = mint(
                        a1 + mod2 - a3
                    ).valu64() * imag.valu64()
                    var na2 = mod2 - a2
                    a[i + offset] = mint(a0 + a2 + a1 + a3)
                    a[i + offset + 1 * p] = mint(
                        a0 + a2 + (2 * mod2 - (a1 + a3))
                    )
                    a[i + offset + 2 * p] = mint(a0 + na2 + a1na3imag)
                    a[i + offset + 3 * p] = mint(a0 + na2 + (mod2 - a1na3imag))
                if s + 1 != (1 << ln):
                    rot = rot * info.rate3[countr_zero(~UInt32(s))]
            ln += 2


fn _butterfly_inv[mint: ModintTrait](mut a: List[mint]) raises:
    var n = len(a)
    var h = countr_zero(n)
    var info = _FFTInfo[mint]()
    var ln = h
    while ln:
        if ln == 1:
            var p = 1 << (h - ln)
            var irot = mint(1)
            for s in range(1 << (ln - 1)):
                var offset = s << (h - ln + 1)
                for i in range(p):
                    var l = a[i + offset]
                    var r = a[i + offset + p]
                    a[i + offset] = l + r
                    a[i + offset + p] = mint(
                        (mint.modu64() + l.valu64() - r.valu64())
                        * irot.valu64()
                    )
                if s + 1 != (1 << (ln - 1)):
                    irot = irot * info.irate2[countr_zero(~UInt32(s))]
            ln -= 1
        else:
            var p = 1 << (h - ln)
            var irot = mint(1)
            var iimag = info.iroot[2]
            for s in range(1 << (ln - 2)):
                var irot2 = irot * irot
                var irot3 = irot2 * irot
                var offset = s << (h - ln + 2)
                for i in range(p):
                    var a0 = a[i + offset + 0 * p].valu64()
                    var a1 = a[i + offset + 1 * p].valu64()
                    var a2 = a[i + offset + 2 * p].valu64()
                    var a3 = a[i + offset + 3 * p].valu64()
                    var a2na3iimag = mint(
                        (mint.mod() + a2 - a3) * iimag.valu64()
                    ).valu64()

                    a[i + offset] = mint(a0 + a1 + a2 + a3)
                    a[i + offset + 1 * p] = mint(
                        (a0 + (mint.modu64() - a1) + a2na3iimag) * irot.valu64()
                    )
                    a[i + offset + 2 * p] = mint(
                        (a0 + a1 + (mint.modu64() - a2) + (mint.modu64() - a3))
                        * irot2.valu64()
                    )
                    a[i + offset + 3 * p] = mint(
                        (
                            a0
                            + (mint.modu64() - a1)
                            + (mint.modu64() - a2na3iimag)
                        )
                        * irot3.val()
                    )
                if s + 1 != (1 << (ln - 2)):
                    irot = irot * info.irate3[countr_zero(~UInt32(s))]
            ln -= 2


fn _convolution_fft[
    mint: ModintTrait
](a_: List[mint], b_: List[mint]) raises -> List[mint]:
    var a = a_
    var b = b_
    var n = len(a)
    var m = len(b)
    var z = Int(bit_ceil(UInt32(n + m - 1)))
    a.resize(z, mint())
    _butterfly(a)
    b.resize(z, mint())
    _butterfly(b)
    for i in range(z):
        a[i] = a[i] * b[i]
    _butterfly_inv(a)
    a.resize(n + m - 1)
    var iz = mint(z).inv()
    for i in range(n + m - 1):
        a[i] = a[i] * iz
    return a


fn convolution[
    mint: ModintTrait
](a: List[mint], b: List[mint]) raises -> List[mint]:
    var n = len(a)
    var m = len(b)
    if n == 0 or m == 0:
        return List[mint]()
    var z = Int(bit_ceil(n + m - 1))
    assert_true((mint.mod() - 1) % z == 0)
    return _convolution_fft(a, b)


# fn convolution_int(a: List[Int], b: List[Int]) raises -> List[Int]:
#     var n = len(a)
#     var m = len(b)
#     if n == 0 or m == 0:
#         return List[Int]()

#     var MOD1 = UInt64(754974721)
#     var MOD2 = UInt64(167772161)
#     var MOD3 = UInt64(469762049)
#     var M2M3 = UInt64(78812994116517889)
#     var M1M3 = UInt64(354658471880163329)
#     var M1M2 = UInt64(126663740442542081)
#     var M1M2M3 = UInt64(560135205046714369)

#     var i1 = UInt64(190329765)
#     var i2 = UInt64(58587104)
#     var i3 = UInt64(187290749)

#     var MAX_AB_BIT = 24
#     assert_true(n + m - 1 <= (1 << MAX_AB_BIT))

#     var c1: List[StaticModint[754974721]]
#     var c2: List[StaticModint[167772161]]
#     var c3: List[StaticModint[469762049]]

#     if True:
#         var am = List[StaticModint[754974721]]()
#         for i in range(n):
#             am.append(StaticModint[754974721](a[i]))
#         var bm = List[StaticModint[754974721]]()
#         for i in range(n):
#             bm.append(StaticModint[754974721](b[i]))
#         c1 = convolution(am, bm)

#     if True:
#         var am = List[StaticModint[167772161]]()
#         for i in range(n):
#             am.append(StaticModint[167772161](a[i]))
#         var bm = List[StaticModint[167772161]]()
#         for i in range(n):
#             bm.append(StaticModint[167772161](b[i]))
#         c2 = convolution(am, bm)
