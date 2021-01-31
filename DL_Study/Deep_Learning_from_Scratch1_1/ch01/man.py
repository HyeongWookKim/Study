class Man:
    """샘플 클래스"""

    def __init__(self, name):
        self.name = name
        print("Initilized!")

    def hello(self):
        print("Hello, " + self.name + '!')

    def goodbye(self):
        print("Good-bye, " + self.name + '!')

m = Man("Brian")
m.hello()
m.goodbye()