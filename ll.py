

# states = ['E','E1','T','T1','F']

def nextState(state, input):
    if state == 'E':
        if input == 'identify':
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
        if input == 'identify' or input == '(':
            return ['F', 'T1']
    elif state == 'T1':
        if input == '+' or input == '-' or input == ')' or input == '#':
            return ['#']
        elif input == '*' or input == '/':
            if input == '*':
                return ['*', 'F', 'T1']
            return ['/', 'F', 'T1']
    elif state == 'F':
        if input == 'identify':
            return ['identify']
        elif input == '(':
            return ['(', 'E', ')']
    elif state == ')' and input == ')':
        return ['#']
    raise "error"


def identify(string):
    if string[0] >= '0' and string[0] <= '9':
        return True
    if string[0] >= 'a' and string[0] <= 'z':
        return True
    return False





def LL(equal):
    print("%20s%10s"%("规约式","栈顶"))
    for i in range(len(equal)):
        if identify(equal[i]):
            equal[i] = 'identify'
    index = 0
    stack = ['#', 'E']
    while index < len(equal):
        try:
            temp = nextState(stack[-1], equal[index])
            print("%2s -> %18s" % (stack[-1], str(temp)), end='  ')
            print(stack)
            if temp[0] == equal[index]:
                index += 1
                temp.pop(0)
            elif equal[index] == ')' and stack[-1] == ')':
                index += 1
            stack.pop(-1)
            for i in range(len(temp)-1, -1, -1):
                if temp[i] != '#':
                    stack.append(temp[i])
        except:
            print("errro")
            return

    while stack[-1] != '#':
        # 规约
        try:
            temp = nextState(stack[-1], '#')
            stack.pop(-1)
            for i in range(len(temp)-1, -1, -1):
                if temp[i] != '#':
                    stack.append(temp[i])
        except:
            break

    if index < len(equal) or stack[-1] != '#':
        # 最后检查规约失败
        print("error")
        return
    print("accept !!!")


if __name__ == "__main__":
    with open("./test/equal.txt", "r") as fp:
        equal = fp.readlines()
    fp.close()
    for i in range(len(equal)):
        print("分析 %s"%(equal[i]))
        temp = equal[i].split()
        LL(equal=temp)
        print()

