id = 0
have_letter = False


def identify(string):
    if string[0] >= '0' and string[0] <= '9':
        return True
    if string[0] >= 'a' and string[0] <= 'z':
        return True
    return False


def compute(a, b, symbol):
    if symbol == '+':
        return a+b
    elif symbol == '-':
        return a-b
    elif symbol == '*':
        return a*b
    elif symbol == '/':
        return a/b
    raise "symbol error not in +-*/"

# states = ['E','E1','T','T1','F']


def nextState(state, input):
    if state == 'E':
        if identify(input):
            return ['T', 'E1']
        elif input == '(':
            return ['T', 'E1']
    elif state == 'E1':
        if input == '+' or input == '-':
            if input == '+':
                return ['+', 'T', 'E1']
            return ['-', 'T', 'E1']
        elif input == ')' or input == '#':
            return ['#']
    elif state == 'T':
        if identify(input) or input == '(':
            return ['F', 'T1']
    elif state == 'T1':
        if input == '+' or input == '-' or input == ')' or input == '#':
            return ['#']
        elif input == '*' or input == '/':
            if input == '*':
                return ['*', 'F', 'T1']
            return ['/', 'F', 'T1']
    elif state == 'F':
        if identify(input):
            return ['identify']
        elif input == '(':
            return ['(', 'E', ')']
    elif state == ')' and input == ')':
        return ['#']
    raise "error"


def generate(equal):
    global id
    global have_letter
    if not have_letter:
        try:
            a = float(equal[0])
            b = float(equal[2])
            ret = [equal[1], a, b, compute(a, b, equal[1])]
        except:
            id += 1
            have_letter = True
            ret = [equal[1], equal[0], equal[2], "T"+str(id)]
    else:
        id += 1
        ret = [equal[1], equal[0], equal[2], "T"+str(id)]
    return ret


def LL(equal):
    # print("%20s%10s" % ("规约式", "栈顶"))
    print("四元式计算过程")

    index = 0
    stack = ['#', 'E']
    sematic_stack = []

    while index < len(equal):
        try:
            if stack[-1] in "+-*/":
                q = generate([sematic_stack[-2], stack[-1], sematic_stack[-1]])
                stack.pop(-1)
                sematic_stack = sematic_stack[:-2]
                sematic_stack.append(q[3])
                print(q)
            temp = nextState(stack[-1], equal[index])
            # print("%2s -> %18s" % (stack[-1], str(temp)), end='  ')
            # print(stack)
            if temp[0] == 'identify' and identify(equal[index]) or equal[index] == temp[0]:
                if identify(equal[index]):
                    sematic_stack.append(equal[index])
                    temp.pop(0)
                elif temp[0] in "+/-*":
                    swap = temp[0]
                    temp[0] = temp[1]
                    temp[1] = swap
                elif temp[0] == '(':
                    temp.pop(0)
                index += 1
            elif equal[index] == ')' and stack[-1] == ')':
                index += 1

            stack.pop(-1)
            for i in range(len(temp)-1, -1, -1):
                if temp[i] != '#':
                    stack.append(temp[i])
        except:
            return

    while stack[-1] != '#':
        # 规约
        try:
            if stack[-1] in "+-*/":
                q = generate([sematic_stack[-2], stack[-1], sematic_stack[-1]])
                stack.pop(-1)
                sematic_stack = sematic_stack[:-2]
                sematic_stack.append(q[3])
                print(q)
            temp = nextState(stack[-1], '#')
            # print("%2s -> %18s" % (stack[-1], str(temp)), end='  ')
            # print(stack)
            stack.pop(-1)
            for i in range(len(temp)-1, -1, -1):
                if temp[i] != '#':
                    stack.append(temp[i])
        except:
            break

    if index < len(equal) or stack[-1] != '#':
        # 最后检查规约失败
        if stack[-1] != ')':
            print("表达式不完整")
        else:
            print("括号不匹配")
        return

    print("accept !!!")


if __name__ == "__main__":
    with open("./test/equal.txt", "r") as fp:
        equal = fp.readlines()
    fp.close()

    # print("分析 %s" % (equal[0]))
    # temp = equal[0].split()
    # LL(equal=temp)
    # print()

    for i in range(len(equal)):
        id = 0
        have_letter = False
        print("分析 %s" % (equal[i]))
        temp = equal[i].split()
        LL(equal=temp)
        print()
