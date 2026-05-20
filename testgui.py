import tkinter as tk
from tkinter import ttk
import starttime

class myapps:
    def __init__(self,root:tk.Tk):
        self.root=root
        self.root.title("timer library")
        self.root.geometry("640x480")
        self.root.configure(background="black")
        self.process=ttk.Progressbar(variable=0,value=0,orient="horizontal")
        self.process.pack(padx=10,pady=10)
        self.value=0
        self.time= starttime.stimes(0.50,self.hello)
    def hello(self):
        self.process.step(3)
        self.value=self.value+3
        print(self.value)
        if self.value>100:
            self.value=100
            self.time.sstops()
        
        


root=tk.Tk()
apps=myapps(root)
root.mainloop()
apps.time.sstops()