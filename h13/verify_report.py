from pathlib import Path
import json,re
import win32com.client
import pymupdf
from PIL import Image,ImageDraw
from shutil import copy2
root=Path(__file__).resolve().parent
src=root/'Laporan Praktikum Modul 12.docx'
out=root/'Laporan Praktikum Modul 12.pdf'
a=win32com.client.DispatchEx('Word.Application');a.Visible=False;a.DisplayAlerts=0;a.AutomationSecurity=3
try:
 d=a.Documents.Open(str(src),ReadOnly=True,AddToRecentFiles=False)
 d.Repaginate();d.ExportAsFixedFormat(str(out),17);d.Close(False)
finally:a.Quit()
pdf=pymupdf.open(out); dest=root/'report_pages';dest.mkdir(exist_ok=True)
summary=[]; thumbs=[]
for i,p in enumerate(pdf):
 text=p.get_text().strip()
 summary.append({'page':i+1,'chars':len(text),'start':text[:120],'end':text[-160:]})
 p.get_pixmap(matrix=pymupdf.Matrix(1.3,1.3)).save(dest/f'page_{i+1:02}.png')
 im=Image.open(dest/f'page_{i+1:02}.png').convert('RGB');im.thumbnail((300,424))
 thumb=Image.new('RGB',(320,460),'white');thumb.paste(im,((320-im.width)//2,24));ImageDraw.Draw(thumb).text((10,4),str(i+1),fill='black');thumbs.append(thumb)
 assert len(re.sub(r'Halaman\s+\d+','',text).strip())>0, f'Blank page {i+1}'
sheet=Image.new('RGB',(960,460*((len(thumbs)+2)//3)),(220,220,220))
for i,im in enumerate(thumbs):sheet.paste(im,((i%3)*320,(i//3)*460))
sheet.save(root/'report_contact_sheet.png')
(root/'pdf_page_audit.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2),encoding='utf-8')
formal=root/'240605110088_Erai_Bagusalim_Mobile_Programming_Practicum_A_Modul_12_Akses_Lokasi_GPS.pdf'
copy2(out,formal)
print(json.dumps(summary,ensure_ascii=False,indent=2))
