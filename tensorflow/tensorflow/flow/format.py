# -*- coding: UTF-8 -*-
import os
pathIn='asl_model.json'
pathDst='asl_model_new.json'
f = open(pathIn)             # 返回一个文件对象
line = f.readline()             # 调用文件的 readline()方法
fout = open(pathDst,'w') 

while line:
    #print(line)  
    #print(len(line))
    dstline='aaa'
    if line.find(':')!=-1:
        quoteIdx2=line.find(':')
        #print("line has :, and index =%d" %quoteIdx2)
        linenew=line[:quoteIdx2] + '"' + line[quoteIdx2:]
        quoteIdx1=linenew.rfind(' ',0, quoteIdx2)
        #print("quoteIdx1 %d" %quoteIdx1)
        dstline=linenew[:quoteIdx1+1] + '"' + linenew[quoteIdx1+1:]
        #print(dstline)
        fout.write(dstline+os.linesep) 
    else:
        dstline=line
        fout.write(line) 
        #print("No")
    #print dstline
	
    line = f.readline()

f.close()
fout.close()