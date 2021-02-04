# 폴더(디렉터리) 안에 __init__.py 파일이 있으면 해당 폴더는 패키지로 인식됨
# __init__.py 파일은 내용을 비워 둘 수 있음
# 파이썬 3.3 이상부터는 __init__.py 파일이 없어도 패키지로 인식됨
# 하지만 하위 버전에도 호환되도록 __init__.py 파일을 작성하는 것을 권장함


# from . import operation    # 현재 패키지에서 operation 모듈을 가져옴
# from . import geometry     # 현재 패키지에서 geometry 모듈을 가져옴


# 현재 패키지의 operation, geometry 모듈에서 각 함수를 가져옴
# 특정 함수(변수, 클래스)를 지정하지 않고, * 을 사용해서 모든 함수(변수, 클래스)를 가져와도 상관없음
from .operation import add, mul
from .geometry import triangle_area, rectangle_area