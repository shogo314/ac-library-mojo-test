trait CSRElement(CollectionElement, Defaultable):
    pass


struct CSR[E: CSRElement]:
    var start: List[Int]
    var elist: List[E]

    fn __init__(out self, n: Int, edges: List[(Int, E)]):
        self.start = List[Int](0) * (n + 1)
        self.elist = List[E](E()) * len(edges)
        for e in edges:
            self.start[e[][0] + 1] += 1
        for i in range(1, n + 1):
            self.start[i] += self.start[i - 1]
        var counter = self.start
        for e in edges:
            self.elist[counter[e[][0]]] = e[][1]
            counter[e[][0]] += 1
