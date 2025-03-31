# trait CSRElement(CollectionElement,Defaultable):
#     pass

# struct CSR[E: CSRElement]:
#     var start: List[Int]
#     var elist: List[E]
#     fn __init__(self, n: Int, edges: List[(Int, E)]):
#         self.start = List[Int](0) * (n + 1)
#         self.elist = List[E](E()) * (n + 1)
