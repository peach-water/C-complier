id = 0
have_letter = False

def isDigital(input):
    try:
        ret = int(input)
    except:
        ret = input
    return ret


def compute(a, b, symbol):
    if symbol == '+':
        return a+b
    elif symbol == '-':
        return a-b
    elif symbol == '*':
        return a*b
    elif symbol == '/':
        return a/b
    raise "symbol errror, not in +-*/"


def generate(equal):
    global id
    global have_letter
    if not have_letter:
        try:
            a = int(equal[0])
            b = int(equal[2])
            ret = [equal[1], a, b, compute(a, b, equal[1])]
        except:
            id += 1
            have_letter = True
            ret = [equal[1], equal[0], equal[2], "T"+str(id)]
    else:
        id += 1
        ret = [equal[1], equal[0], equal[2], "T"+str(id)]
    return ret


def quat(equal: list):
    print(equal)
    print(len(equal))

    simplo_stack = []
    quate_ret = []

    index = 0
    while index < len(equal):
        temp = isDigital(equal[index])
        index += 1
        if type(temp) is int or temp not in "+-*/()":
            simplo_stack.append(temp)
            if len(simplo_stack) > 2 and simplo_stack[-2] in "+-*/":
                if simplo_stack[-2] in "*/" or (equal[index] not in "*/"):
                    q = generate(simplo_stack[-3:])
                    simplo_stack = simplo_stack[:-3]
                    simplo_stack.append(q[-1])
                    print(q)

        else:
            if temp in "+-*/(":
                simplo_stack.append(temp)
            elif temp == ')' and simplo_stack[-2] == '(':
                temp = simplo_stack[-1]
                simplo_stack = simplo_stack[:-2]
                simplo_stack.append(temp)

    while len(simplo_stack) > 1:
        if simplo_stack[-2] in "+-*/":
            q = generate(simplo_stack[-3:])
            simplo_stack = simplo_stack[:-3]
            print(q)
            simplo_stack.append(q[-1])

    return simplo_stack[0]

if __name__ == "__main__":
    equal = []
    with open("./test/equal.txt", "r") as fp:
        equal = fp.readlines()
    fp.close()
    temp = equal[0].split()

    print(quat(temp))
