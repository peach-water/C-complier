# https://www.bilibili.com/video/BV1tJ411k7h7?from=search&seid=12553938159732964604
# 1 S->E
# 2 E->E+T
# 3 E->E-T
# 4 E->T
# 5 T->T*F
# 6 T->T/F
# 7 T->F
# 8 F->i
# 9 F->(E)

#使用已经建立好的分析表

def addtwodimdict(thedict, key_a, key_b, val): 
    if key_a in thedict:
        thedict[key_a].update({key_b: val})
    else:
        thedict.update({key_a:{key_b: val}})
    
action=dict()
goto=dict()
equal_table = ['','SE','EE+T','EE-T','ET','TT*F','TT/F','TF','Fi','F(E)']

def buildTable():
    # 这里是在手动构建 LR 分析表
    addtwodimdict(action,0,'i','s4')
    addtwodimdict(action,0,'(','s5')
    addtwodimdict(goto,0,'S','s16')
    addtwodimdict(goto,0,'E','s1')
    addtwodimdict(goto,0,'T','s2')
    addtwodimdict(goto,0,'F','s3')

    addtwodimdict(action,1,'+','s6')
    addtwodimdict(action,1,'-','s7')
    addtwodimdict(action,1,'$','r1')

    addtwodimdict(action,2,'+','r4')
    addtwodimdict(action,2,'-','r4')
    addtwodimdict(action,2,'*','s10')
    addtwodimdict(action,2,'/','s11')
    addtwodimdict(action,2,')','r4')
    addtwodimdict(action,2,'$','r4')

    addtwodimdict(action,3,'+','r7')
    addtwodimdict(action,3,'-','r7')
    addtwodimdict(action,3,'*','r7')
    addtwodimdict(action,3,'/','r7')
    addtwodimdict(action,3,')','r7')
    addtwodimdict(action,3,'$','r7')

    addtwodimdict(action,4,'+','r8')
    addtwodimdict(action,4,'-','r8')
    addtwodimdict(action,4,'*','r8')
    addtwodimdict(action,4,'/','r8')
    addtwodimdict(action,4,')','r8')
    addtwodimdict(action,4,'$','r8')

    addtwodimdict(action,5,'i','s4')
    addtwodimdict(action,5,'(','s5')
    addtwodimdict(goto,5,'E','s14')
    addtwodimdict(goto,5,'T','s2')
    addtwodimdict(goto,5,'F','s3')

    addtwodimdict(action,6,'i','s4')
    addtwodimdict(action,6,'(','s5')
    addtwodimdict(goto,6,'T','s8')
    addtwodimdict(goto,6,'F','s3')

    addtwodimdict(action,7,'i','s4')
    addtwodimdict(action,7,'(','s5')
    addtwodimdict(goto,7,'T','s9')
    addtwodimdict(goto,7,'F','s3')

    addtwodimdict(action,8,'+','r2')
    addtwodimdict(action,8,'-','r2')
    addtwodimdict(action,8,'*','s10')
    addtwodimdict(action,8,'/','s11')
    addtwodimdict(action,8,')','r2')
    addtwodimdict(action,8,'$','r2')

    addtwodimdict(action,9,'+','r3')
    addtwodimdict(action,9,'-','r3')
    addtwodimdict(action,9,'*','s10')
    addtwodimdict(action,9,'/','s11')
    addtwodimdict(action,9,')','r3')
    addtwodimdict(action,9,'$','r3')

    addtwodimdict(action,10,'i','s4')
    addtwodimdict(action,10,'(','s5')
    addtwodimdict(goto,10,'F','s12')

    addtwodimdict(action,11,'i','s4')
    addtwodimdict(action,11,'(','s5')
    addtwodimdict(goto,11,'F','s13')

    addtwodimdict(action,12,'+','r5')
    addtwodimdict(action,12,'-','r5')
    addtwodimdict(action,12,'*','r5')
    addtwodimdict(action,12,'/','r5')
    addtwodimdict(action,12,')','r5')
    addtwodimdict(action,12,'$','r5')

    addtwodimdict(action,13,'+','r6')
    addtwodimdict(action,13,'-','r6')
    addtwodimdict(action,13,'*','r6')
    addtwodimdict(action,13,'/','r6')
    addtwodimdict(action,13,')','r6')
    addtwodimdict(action,13,'$','r6')

    addtwodimdict(action,14,'+','s6')
    addtwodimdict(action,14,'-','s7')
    addtwodimdict(action,14,')','s15')

    addtwodimdict(action,15,'+','r9')
    addtwodimdict(action,15,'-','r9')
    addtwodimdict(action,15,'*','r9')
    addtwodimdict(action,15,'/','r9')
    addtwodimdict(action,15,')','r9')
    addtwodimdict(action,15,'$','r9')

    addtwodimdict(action,16,'$','acc')

def isNumber(num):
    if num[0] >= '0' and num[0] <= '9':
        return 'i'
    if num[0] >= 'a' and num[0] <= 'z':
        return 'i'
    return num

def printable_stack(stack):
    ret = ""
    for i in range(0,len(stack),2):
        ret += stack[i]
    return ret

def LR(equal):
    stack = ['$',0]
    print_equal = ""
    for i in equal:
        print_equal += i
    print_equal += '$'
    index = 0
    print("%4s%10s%20s%30s"%("步骤","规约式","剩余","栈顶"))

    while index < len(equal):
        c = isNumber(equal[index])
        try:
            temp = action[stack[-1]][c]
        except:
            print("error")
            return
        if temp[0] == 'r':
            # 表示规约
            resolveIndex = int(temp[1:]) # 规约的等式
            print("%4s"%("规约"),end='')
            print("%4s->%6s"%(equal_table[resolveIndex][0],equal_table[resolveIndex][1:]),end='  ')
            for i in range(2*len(equal_table[resolveIndex])-2):
                stack.pop(-1)
            temp = goto[stack[-1]][equal_table[resolveIndex][0]]
            state = int(temp[1:])
            stack.append(equal_table[resolveIndex][0])
            stack.append(state)
            print("%20s"%(print_equal[index:]),end='  ')
            print(printable_stack(stack))
        elif temp[0] == 's':
            # 表示状态转移
            state = int(temp[1:])
            stack.append(c)
            stack.append(state)
            index += 1
            print("%4s"%("移进"),end='')
            print("%12s"%(''),end='  ')
            print("%20s"%(print_equal[index:]),end='  ')
            print(printable_stack(stack))

    while len(stack) > 2:
        try:
            temp = action[stack[-1]]['$']
        except:
            print("error")
            return
        if temp[0] == 'r':
            # 表示规约
            resolveIndex = int(temp[1:]) # 规约的等式
            print("%4s"%("规约"),end='')
            print("%4s->%6s"%(equal_table[resolveIndex][0],equal_table[resolveIndex][1:]),end='  ')
            for i in range(2*len(equal_table[resolveIndex])-2):
                stack.pop(-1)
            temp = goto[stack[-1]][equal_table[resolveIndex][0]]
            state = int(temp[1:])
            stack.append(equal_table[resolveIndex][0])
            print("%20s"%("$"),end='  ')
            stack.append(state)
            print(printable_stack(stack))
        elif temp == 'acc':
            print("accept !!!")
            break
        


if __name__ == "__main__":
    buildTable()
    with open("./test/equal.txt", "r") as fp:
        equal = fp.readlines()
    fp.close()
    for i in range(len(equal)):
        print(f"分析 %s"%(equal[i]))
        temp = equal[i].split()
        LR(equal=temp)
        print()