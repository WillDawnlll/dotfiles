#!/usr/bin/env python3
import io,subprocess,os

# True  -> screenshot show OCR result edit window 
# False -> screenshot then goldendict popup
IS_GUI=True
IS_WIN= os.name == 'nt'

strocr=""
goldendict_win=r'C:\\bin\GoldenDict-1.5.0_.QT_5123.64bit\GoldenDict\GoldenDict.exe "'
goldendict_linux=r'goldendict "'
goldendict_path=goldendict_win if IS_WIN else goldendict_linux  

#linux wayland
def getOCR_wl():
    str1=subprocess.check_output(r'grimshot --notify save area -|tesseract - - -l chi_sim',shell=True).decode('utf8')
    r=str1.replace('-\n','').replace('-\r','').replace('\n',' ').replace('\r',' ')
    print(goldendict_linux+r+'"')
    subprocess.call(goldendict_linux+r+'"',shell=True)
    return r

def getOCR_win():
    import win32clipboard
    import pytesseract
    subprocess.call(r'C:\\Windows\System32\SnippingTool.exe /clip',shell=True)
    #os.system(r'C:\\Windows\System32\SnippingTool.exe /clip')
    
    win32clipboard.OpenClipboard()
    data = None
    if win32clipboard.IsClipboardFormatAvailable(win32clipboard.CF_DIB):
        data = win32clipboard.GetClipboardData(win32clipboard.CF_DIB)
    
    i= io.BytesIO(data)
    from PIL import Image
    image = Image.open(i).convert("L")
    #print(image)
    win32clipboard.CloseClipboard()
    
    pytesseract.pytesseract.tesseract_cmd ="C:/Program Files/Tesseract-OCR/tesseract.exe"
    str1=pytesseract.image_to_string(image)
    r=str1.replace('-\n','').replace('-\r','').replace('\n',' ').replace('\r',' ')
    print(goldendict_win+r+'"')
    subprocess.call(goldendict_win+r+'"',shell=True)
    return r


getOCR=getOCR_win if IS_WIN else getOCR_wl
strocr=getOCR()
if not IS_GUI:
    os._exit(0)

#GUI WINDOW

from tkinter import *
root=Tk()
root.geometry("300x300")
root.title("tesseract OCR GoldenDICT")
root.attributes("-topmost",True)
o=Text(root)
o.insert("1.0",strocr)

def sed2dict():
    #global o
    selstr=o.get(*o.tag_ranges("sel"))
    subprocess.call(goldendict_path+selstr+'"',shell=True)

bo=Button(root,text='ocr2dict',command=lambda :o.insert("1.0",getOCR()+'\n\n'))
bo.pack()
b=Button(root,text='sel2dict',command=sed2dict)
b.pack()
o.pack()
mainloop()
