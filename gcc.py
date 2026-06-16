print("\033c\033[47;31m")
print("give me a string to convert ...")
a=input()
print("give me a var name ...")
b=input().strip()
print("int "+b,end="[]={")
counter=0
backs=False
for aa in a:
  if aa=="\\":
      print(ord("\n"),end=",")
  else:
      print(ord(aa),end=",")
          
          
  counter=counter+1

print("0};")