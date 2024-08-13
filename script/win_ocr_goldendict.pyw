#use windows screenshot tool select rect to ocr, then show GoldenDict popup window
#pyw extension to hide python window
import win32clipboard
import pytesseract
import io,subprocess
#import io,os
from PIL import Image

#shell=true hide console window
subprocess.call(r'C:\\Windows\System32\SnippingTool.exe /clip',shell=True)
#os.system(r'C:\\Windows\System32\SnippingTool.exe /clip')

win32clipboard.OpenClipboard()
data = None
if win32clipboard.IsClipboardFormatAvailable(win32clipboard.CF_DIB):
    data = win32clipboard.GetClipboardData(win32clipboard.CF_DIB)

i= io.BytesIO(data)
image = Image.open(i).convert("L")
#print(image)
win32clipboard.CloseClipboard()

pytesseract.pytesseract.tesseract_cmd ="C:/Program Files/Tesseract-OCR/tesseract.exe"
str1=pytesseract.image_to_string(image)
print("C:\\bin\\GoldenDict-1.5.0_.QT_5123.64bit\\GoldenDict\\GoldenDict.exe "+str1)
subprocess.call(r'C:\\bin\GoldenDict-1.5.0_.QT_5123.64bit\GoldenDict\GoldenDict.exe \"'+str1+'"',shell=True)
#os.system(r'C:\\bin\GoldenDict-1.5.0_.QT_5123.64bit\GoldenDict\GoldenDict.exe \"'+str1+'"')

