from pathlib import Path
import re
from xml.sax.saxutils import escape

from reportlab.lib import colors
from reportlab.lib.enums import TA_CENTER, TA_JUSTIFY
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, PageBreak, Preformatted, Table, TableStyle, Image,
)

source = Path(__file__).parent / 'LAPORAN_UTS.md'
out = Path(__file__).parent / 'LAPORAN_UTS_DRAFT.pdf'
lines = source.read_text(encoding='utf-8').splitlines()
styles = getSampleStyleSheet()
styles.add(ParagraphStyle(name='CoverTitle', parent=styles['Title'], alignment=TA_CENTER, fontSize=19, leading=25, spaceAfter=16))
styles.add(ParagraphStyle(name='CoverCenter', parent=styles['BodyText'], alignment=TA_CENTER, fontSize=12, leading=18, spaceAfter=8))
styles.add(ParagraphStyle(name='H1x', parent=styles['Heading1'], fontSize=15, leading=19, spaceBefore=13, spaceAfter=7, keepWithNext=True))
styles.add(ParagraphStyle(name='H2x', parent=styles['Heading2'], fontSize=12, leading=16, spaceBefore=10, spaceAfter=5, keepWithNext=True))
styles.add(ParagraphStyle(name='Bodyx', parent=styles['BodyText'], fontSize=9.8, leading=14.2, alignment=TA_JUSTIFY, spaceAfter=6))
styles.add(ParagraphStyle(name='Note', parent=styles['BodyText'], fontSize=9, leading=13, textColor=colors.HexColor('#7541b8'), spaceAfter=5))
styles.add(ParagraphStyle(name='Small', parent=styles['BodyText'], fontSize=7, leading=9, spaceAfter=0))
styles.add(ParagraphStyle(name='Codex', parent=styles['Code'], fontName='Courier', fontSize=7.5, leading=10, leftIndent=8, rightIndent=8, spaceBefore=4, spaceAfter=7))

def inline(text):
    text = escape(text)
    text = re.sub(r'\*\*(.+?)\*\*', r'<b>\1</b>', text)
    text = re.sub(r'\*(.+?)\*', r'<i>\1</i>', text)
    text = re.sub(r'`(.+?)`', r'<font name="Courier">\1</font>', text)
    return text

def footer(canvas, doc):
    canvas.saveState()
    if doc.page > 1:
        canvas.setFont('Helvetica', 8)
        canvas.drawCentredString(A4[0] / 2, 1.05 * cm, f'AniList Mini — Draf UTS — Halaman {doc.page - 1}')
    canvas.restoreState()

story = []
i = 0
cover = True
while i < len(lines):
    line = lines[i].rstrip()
    if not line:
        i += 1
        continue
    if line.startswith('---'):
        story.append(PageBreak())
        cover = False
        i += 1
        continue
    if line.startswith('[SCREENSHOT: '):
        image_path = source.parent / line[len('[SCREENSHOT: '):-1]
        story.append(PageBreak())
        story.append(Image(str(image_path), width=7.5*cm, height=7.5*cm*932/430))
        story.append(Spacer(1, 12))
        i += 1
        continue
    if line.startswith('```'):
        code = []
        i += 1
        while i < len(lines) and not lines[i].startswith('```'):
            code.append(lines[i].rstrip())
            i += 1
        story.append(Preformatted('\n'.join(code), styles['Codex']))
        i += 1
        continue
    if line.startswith('|'):
        table_lines = []
        while i < len(lines) and lines[i].startswith('|'):
            table_lines.append(lines[i])
            i += 1
        rows = []
        for table_line in table_lines:
            cells = [cell.strip() for cell in table_line.strip('|').split('|')]
            if cells and all(re.fullmatch(r':?-{3,}:?', cell.replace(' ', '')) for cell in cells):
                continue
            rows.append([Paragraph(inline(cell), styles['Small']) for cell in cells])
        if rows:
            widths = [1.0*cm, 1.7*cm, 2.6*cm, 3.0*cm, 5.0*cm, 2.0*cm]
            tab = Table(rows, colWidths=widths, repeatRows=1, hAlign='LEFT')
            tab.setStyle(TableStyle([
                ('BACKGROUND',(0,0),(-1,0),colors.HexColor('#30254a')),
                ('GRID',(0,0),(-1,-1),0.35,colors.HexColor('#aaa4b8')),
                ('VALIGN',(0,0),(-1,-1),'TOP'),
                ('ROWBACKGROUNDS',(0,1),(-1,-1),[colors.white,colors.HexColor('#f5f3f9')]),
                ('LEFTPADDING',(0,0),(-1,-1),3),('RIGHTPADDING',(0,0),(-1,-1),3),
                ('TOPPADDING',(0,0),(-1,-1),4),('BOTTOMPADDING',(0,0),(-1,-1),4),
            ]))
            story.append(tab)
            story.append(Spacer(1,7))
        continue
    if line.startswith('# '):
        title = inline(line[2:])
        if cover:
            if 'AniList Mini' in title:
                story.append(Spacer(1, 3.0*cm))
            story.append(Paragraph(title, styles['CoverTitle']))
        else:
            story.append(Paragraph(title, styles['H1x']))
        i += 1
        continue
    if line.startswith('## '):
        story.append(Paragraph(inline(line[3:]), styles['CoverCenter'] if cover else styles['H2x']))
        i += 1
        continue
    if line.startswith('### '):
        story.append(Paragraph(inline(line[4:]), styles['H2x']))
        i += 1
        continue
    if cover:
        if line.startswith('**[Tempatkan'):
            story.append(Spacer(1, 0.8*cm))
        story.append(Paragraph(inline(line), styles['CoverCenter']))
        i += 1
        continue
    style = styles['Note'] if '[PLACEHOLDER' in line or line.startswith('Keterangan: [') else styles['Bodyx']
    if line.startswith('- '):
        story.append(Paragraph('• ' + inline(line[2:]), styles['Bodyx']))
    else:
        story.append(Paragraph(inline(line), style))
    i += 1

doc = SimpleDocTemplate(
    str(out), pagesize=A4, rightMargin=2.0*cm, leftMargin=2.2*cm,
    topMargin=1.9*cm, bottomMargin=1.65*cm,
    title='Laporan UTS AniList Mini', author='Mahasiswa',
)
doc.build(story, onFirstPage=footer, onLaterPages=footer)
print(out)
