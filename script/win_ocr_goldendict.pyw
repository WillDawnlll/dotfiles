import win32clipboard
import pytesseract
import io,subprocess
#import io,os

strocr=""

def getOCR():
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
    print(r'C:\\bin\GoldenDict-1.5.0_.QT_5123.64bit\GoldenDict\GoldenDict.exe \"'+r+'"')
    subprocess.call(r'C:\\bin\GoldenDict-1.5.0_.QT_5123.64bit\GoldenDict\GoldenDict.exe "'+r+'"',shell=True)
    return r


    #strocr=pytesseract.image_to_string(image)
    #print("C:\\bin\\GoldenDict-1.5.0_.QT_5123.64bit\\GoldenDict\\GoldenDict.exe "+strocr)
    #subprocess.call(r'C:\\bin\GoldenDict-1.5.0_.QT_5123.64bit\GoldenDict\GoldenDict.exe "'+strocr+'"',shell=True)

strocr=getOCR()



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
    subprocess.call(r'C:\\bin\GoldenDict-1.5.0_.QT_5123.64bit\GoldenDict\GoldenDict.exe "'+selstr+'"',shell=True)

bo=Button(root,text='ocr2dict',command=lambda :o.insert("1.0",getOCR()+'\n\n'))
bo.pack()
b=Button(root,text='sel2dict',command=sed2dict)
b.pack()
o.pack()
mainloop()
