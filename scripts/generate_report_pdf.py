import os
import sys
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import (
    SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, PageBreak, KeepTogether, HRFlowable
)
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

# Türkçe Font Kaydı
arial_path = '/System/Library/Fonts/Supplemental/Arial.ttf'
arial_bold_path = '/System/Library/Fonts/Supplemental/Arial Bold.ttf'

pdfmetrics.registerFont(TTFont('Arial', arial_path))
pdfmetrics.registerFont(TTFont('Arial-Bold', arial_bold_path))

pdf_filename = "/Users/emirhansapmaz/Documents/GitHub/SoftITO-MobileDeveloper-Akilli-Tarim-Platformu-TeamWork-Two-Member-/EMIRHAN_GELISTIRME_RAPORU.pdf"

class NumberedCanvas(canvas.Canvas):
    def __init__(self, *args, **kwargs):
        super(NumberedCanvas, self).__init__(*args, **kwargs)
        self._saved_page_states = []

    def showPage(self):
        self._saved_page_states.append(dict(self.__dict__))
        self._startPage()

    def save(self):
        num_pages = len(self._saved_page_states)
        for state in self._saved_page_states:
            self.__dict__.update(state)
            self.draw_page_decorations(num_pages)
            super(NumberedCanvas, self).showPage()
        super(NumberedCanvas, self).save()

    def draw_page_decorations(self, page_count):
        self.saveState()
        self.setFont('Arial', 9)
        self.setFillColor(colors.HexColor('#555555'))
        
        # Üst Bilgi (Sayfa 1 hariç)
        if self._pageNumber > 1:
            self.drawString(54, 800, "Bereket Ovası — Akıllı Tarım ve Hayvancılık Platformu")
            self.drawRightString(541, 800, "feature/emirhan Geliştirme Raporu")
            self.setStrokeColor(colors.HexColor('#D9D6C8'))
            self.setLineWidth(0.8)
            self.line(54, 792, 541, 792)
            
        # Alt Bilgi
        page_str = f"Sayfa {self._pageNumber} / {page_count}"
        self.drawRightString(541, 35, page_str)
        self.drawString(54, 35, "SoftITO Mobil Geliştirme — Emirhan Sapmaz")
        self.setStrokeColor(colors.HexColor('#D9D6C8'))
        self.setLineWidth(0.8)
        self.line(54, 48, 541, 48)
        self.restoreState()

def build_pdf():
    doc = SimpleDocTemplate(
        pdf_filename,
        pagesize=A4,
        leftMargin=54,
        rightMargin=54,
        topMargin=60,
        bottomMargin=60
    )

    styles = getSampleStyleSheet()
    
    # Özel Stiller
    c_forest = colors.HexColor('#214A3D')
    c_gold = colors.HexColor('#B88422')
    c_olive = colors.HexColor('#566D36')
    c_earth = colors.HexColor('#75503B')
    c_ink = colors.HexColor('#1F2721')
    c_canvas = colors.HexColor('#F7F1E5')
    c_milk = colors.HexColor('#FFFDF8')

    style_title = ParagraphStyle(
        'DocTitle',
        fontName='Arial-Bold',
        fontSize=24,
        leading=28,
        textColor=c_forest,
        spaceAfter=6
    )
    
    style_subtitle = ParagraphStyle(
        'DocSubTitle',
        fontName='Arial',
        fontSize=13,
        leading=17,
        textColor=c_gold,
        spaceAfter=14
    )

    style_h1 = ParagraphStyle(
        'Heading1_Custom',
        fontName='Arial-Bold',
        fontSize=15,
        leading=19,
        textColor=c_forest,
        spaceBefore=14,
        spaceAfter=8,
        keepWithNext=True
    )

    style_h2 = ParagraphStyle(
        'Heading2_Custom',
        fontName='Arial-Bold',
        fontSize=12,
        leading=16,
        textColor=c_earth,
        spaceBefore=10,
        spaceAfter=6,
        keepWithNext=True
    )

    style_body = ParagraphStyle(
        'Body_Custom',
        fontName='Arial',
        fontSize=10,
        leading=14.5,
        textColor=c_ink,
        spaceAfter=6
    )

    style_bullet = ParagraphStyle(
        'Bullet_Custom',
        fontName='Arial',
        fontSize=9.5,
        leading=13.5,
        textColor=c_ink,
        leftIndent=14,
        spaceAfter=4
    )

    style_code = ParagraphStyle(
        'Code_Custom',
        fontName='Arial-Bold',
        fontSize=9,
        leading=12,
        textColor=colors.HexColor('#1B3D32'),
        backColor=colors.HexColor('#EFEAE1'),
        borderPadding=4,
        spaceAfter=6
    )

    style_table_cell = ParagraphStyle(
        'TableCell',
        fontName='Arial',
        fontSize=8.5,
        leading=11.5,
        textColor=c_ink
    )

    style_table_cell_bold = ParagraphStyle(
        'TableCellBold',
        fontName='Arial-Bold',
        fontSize=8.5,
        leading=11.5,
        textColor=colors.white
    )

    story = []

    # KAPAK / BAŞLIK BÖLÜMÜ
    story.append(Paragraph("🌾 AKILLI TARIM & HAYVANCILIK PLATFORMU", style_title))
    story.append(Paragraph("<b>feature/emirhan</b> Geliştirme, Mimari ve Modül Dokümantasyonu", style_subtitle))
    
    meta_data = [
        [
            Paragraph("<b>Geliştirici:</b> Emirhan Sapmaz", style_table_cell),
            Paragraph("<b>Branch:</b> feature/emirhan", style_table_cell)
        ],
        [
            Paragraph("<b>Ortak Proje Ekibi:</b> Emirhan & Ayberk", style_table_cell),
            Paragraph("<b>Platform / Sürüm:</b> Flutter 3.x / Dart 3.x", style_table_cell)
        ],
        [
            Paragraph("<b>Efor Dağılımı:</b> %50 (60 Efor Puanı)", style_table_cell),
            Paragraph("<b>Veri Depolama:</b> Hive Yerel Depolama (Offline MVP)", style_table_cell)
        ]
    ]
    meta_table = Table(meta_data, colWidths=[240, 240])
    meta_table.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,-1), colors.HexColor('#F4EFE6')),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor('#D9D6C8')),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor('#E2DDD1')),
        ('TOPPADDING', (0,0), (-1,-1), 6),
        ('BOTTOMPADDING', (0,0), (-1,-1), 6),
        ('LEFTPADDING', (0,0), (-1,-1), 8),
        ('RIGHTPADDING', (0,0), (-1,-1), 8),
    ]))
    story.append(meta_table)
    story.append(Spacer(1, 14))

    # GİRİŞ & İŞ BÖLÜMÜ KURALLARI
    story.append(Paragraph("1. Genel Mimari ve İş Bölümü Sözleşmesi", style_h1))
    story.append(Paragraph(
        "Proje, iki kişilik dengeli iş paylaşımı ilkesine göre yürütülmüştür. <b>feature/emirhan</b> branch'i "
        "kapsamında geliştirilen tüm özellikler, ortak mimariye tam sadakatle ve Ayberk'in çekirdek alanlarına "
        "(<code>lib/app</code>, <code>lib/core</code>, <code>lib/main.dart</code>, <code>pubspec.yaml</code>, "
        "<code>assets/mock_farms.json</code>, <code>marketplace</code>) <b>kesinlikle doğrudan dokunulmadan</b> "
        "oluşturulmuştur.", style_body
    ))
    story.append(Paragraph(
        "Her modül; <b>Feature-First</b> yaklaşımıyla, <b>SOLID</b>, <b>DRY</b>, <b>KISS</b>, <b>YAGNI</b> ve <b>SRP</b> "
        "(Tek Sorumluluk Prensibi) ilkelerine uygun olarak ortalama 150–250 satırlık bağımsız parçalara bölünmüştür.", style_body
    ))

    # GÖRSEL KİMLİK
    story.append(Paragraph("2. Ortak Görsel Kimlik ve Bezemeler", style_h1))
    story.append(Paragraph(
        "Uygulama genelinde 'Gerçekçi Çiftlik + Hafif Fantastik Kırsal Lüks' teması uygulanmıştır. Olmayan harici "
        "asset dosyalarına referans verilmemesi kuralına tam uyulmuş; görsel zenginlik <b>CustomPainter</b> "
        "(Flutter Canvas) vektörel çizimleri ile sağlanmıştır:", style_body
    ))
    story.append(Paragraph("• <b>WheatCornicePainter:</b> Sayfa ve kart başlıklarına zarif altın hasat başağı kornişi çizer.", style_bullet))
    story.append(Paragraph("• <b>RusticFarmBadge:</b> İşletme ve sürü kartlarında kullanılan damga (wax seal) tarzı kırsal rozet.", style_bullet))
    story.append(Paragraph("• <b>Erişilebilirlik & Kontrast:</b> Metin kontrastı WCAG standartlarına uygun (en az 4.5:1), buton dokunma alanları minimum ~48px ve 360px ekranlarda taşma koruması sağlanmıştır.", style_bullet))

    story.append(Spacer(1, 10))

    # E1: HAYVAN YÖNETİMİ
    story.append(Paragraph("3. E1 Modülü: Hayvan Kayıtları ve Sürü Yönetimi", style_h1))
    story.append(Paragraph(
        "<b>Dizin:</b> <code>lib/features/farm_management/</code><br/>"
        "<b>Public Ekran:</b> <code>FarmDashboardScreen</code>", style_code
    ))
    story.append(Paragraph(
        "Üreticinin büyükbaş ve küçükbaş hayvanlarını kayıt altına alıp aşı ve gebelik takiplerini gerçekleştirdiği operasyonel paneldir.", style_body
    ))
    
    e1_files = [
        [Paragraph("Dosya", style_table_cell_bold), Paragraph("Görevi ve Açıklaması", style_table_cell_bold)],
        [Paragraph("<b>farm_dashboard_screen.dart</b>", style_table_cell), Paragraph("Modülün ana vitrini. Sürü özeti, segment geçişleri ve seralarla birleşik dashboard sunar.", style_table_cell)],
        [Paragraph("<b>animal_controller.dart</b>", style_table_cell), Paragraph("Hayvan listesi, istatistik sayaçları (toplam, aşılı, gebe), validasyon ve Hive storage işlemlerini yönetir.", style_table_cell)],
        [Paragraph("<b>animal_card.dart</b>", style_table_cell), Paragraph("Küpe no, tür ikonu, gebelik rozeti ve son aşı tarihini gösteren yüksek kontrastlı kart.", style_table_cell)],
        [Paragraph("<b>add_animal_sheet.dart</b>", style_table_cell), Paragraph("Yeni hayvan ekleme modal formu. Boş küpe no, mükerrer küpe no ve hatalı tarih kontrollerini yapar.", style_table_cell)],
        [Paragraph("<b>animal_detail_sheet.dart</b>", style_table_cell), Paragraph("Hayvan kartına tıklandığında açılan detay ve silme sayfası. Tıbbi takvim uydurmaz, veteriner tavsiyesi hatırlatır.", style_table_cell)],
        [Paragraph("<b>farm_summary_header.dart</b>", style_table_cell), Paragraph("Koyu yeşil & altın yaldızlı başlık; sürü adedi, aşılı hayvan ve aktif sera ünitelerini özetler.", style_table_cell)]
    ]
    t_e1 = Table(e1_files, colWidths=[150, 330])
    t_e1.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_forest),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor('#D9D6C8')),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor('#E2DDD1')),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
    ]))
    story.append(t_e1)

    story.append(Spacer(1, 10))

    # E2: SERA İZLEME VE SENSÖR SİMÜLASYONU
    story.append(Paragraph("4. E2 Modülü: Sera İzleme ve Sanal Sensör Simülasyonu", style_h1))
    story.append(Paragraph(
        "<b>Controller & Bileşenler:</b> <code>GreenhouseSimulatorController</code>, <code>GreenhouseCard</code>, <code>GreenhouseSection</code>", style_code
    ))
    story.append(Paragraph(
        "Fiziksel IoT veya canlı MQTT sunucusu varmış gibi davranmadan, gerçekçi çiftlik ortamını simüle eden sanal sensör motorudur:", style_body
    ))
    story.append(Paragraph("• <b>Simülasyon Döngüsü:</b> <code>Timer.periodic</code> ile yaklaşık 5 saniyede bir sıcaklık ±0.5 °C, hava nemi ±2.0 puan dalgalanır.", style_bullet))
    story.append(Paragraph("• <b>Değer Sınırlandırması (Clamping):</b> Nem değeri matematiksel olarak <code>0.0 – 100.0</code> aralığına kilitlenmiştir; mantıksız değerler oluşamaz.", style_bullet))
    story.append(Paragraph("• <b>Zorunlu Simülasyon Etiketi:</b> Her sera kartında belirgin sarı rozetle <i>'Simüle sensör verisi (5 sn döngülü)'</i> ibaresi yer alır.", style_bullet))
    story.append(Paragraph("• <b>Bellek Emniyeti:</b> <code>dispose()</code> içerisinde timer kapatılır; ekranda değilken <code>setState</code> veya gereksiz Hive diske yazım yapılmaz.", style_bullet))

    story.append(Spacer(1, 10))

    # E3: HİZMET REHBERİ
    story.append(Paragraph("5. E3 Modülü: Tarımsal Hizmet ve Destek Rehberi", style_h1))
    story.append(Paragraph(
        "<b>Dizin:</b> <code>lib/features/services/</code><br/>"
        "<b>Public Ekran:</b> <code>ServiceProvidersScreen</code>", style_code
    ))
    story.append(Paragraph(
        "Bölgedeki veteriner hekimler, traktör/biçerdöver kiralama ve soğuk zincir lojistik firmalarının listelendiği rehber modülüdür.", style_body
    ))
    story.append(Paragraph("• <b>Kategoriler:</b> <code>veterinary</code>, <code>tractor</code>, <code>harvester</code>, <code>logistics</code> türleri özel ikon ve renklerle ayrıştırılmıştır.", style_bullet))
    story.append(Paragraph("• <b>Çoklu Filtreleme Motoru:</b> Sağlayıcı adı/açıklaması ile serbest metin arama + Kategori filtresi + Şehir seçimi aynı anda eşgüdümlü çalışır.", style_bullet))
    story.append(Paragraph("• <b>Telefon Çağrı Entegrasyonu (ServiceCallHelper):</b> <code>url_launcher</code> paketiyle <code>tel:</code> şeması tetiklenir. Telefon numarası boşsa buton pasifleşir; açılamazsa kullanıcıya hata uyarısı verilir.", style_bullet))
    story.append(Paragraph("• <b>Boş Durum (Empty State):</b> Arama sonucu bulunamadığında kullanıcıyı yönlendiren ve tek tıkla filtreleri sıfırlayan ekran sunulur.", style_bullet))

    story.append(Spacer(1, 10))

    # E4: TEKLİF VE TALEP SİSTEMİ
    story.append(Paragraph("6. E4 Modülü: Teklif / Talep Sistemi", style_h1))
    story.append(Paragraph(
        "<b>Dizin:</b> <code>lib/features/offers/</code><br/>"
        "<b>Public Ekranlar:</b> <code>OffersScreen</code> ve <code>OfferFormScreen(productId: ...)</code>", style_code
    ))
    story.append(Paragraph(
        "Alıcıların üretici ilanlarına 'Şu üründen X kg almak istiyorum' talebi gönderebilmesini ve üreticinin bu teklifleri yönetmesini sağlar.", style_body
    ))
    story.append(Paragraph("• <b>Teklif Verme Formu (OfferFormScreen):</b> İlan detayından <code>productId</code> parametresi ile açılır. İlandaki mevcut stok miktarından (ör. 500 kg elma) fazla teklif verilmesi engellenir. 0 veya eksi miktar girilemez.", style_bullet))
    story.append(Paragraph("• <b>Kalıcılık:</b> Teklifler <code>Offer(status: 'pending')</code> biçiminde Hive <code>offers</code> kutusuna kalıcı yazılır.", style_bullet))
    story.append(Paragraph("• <b>Üretici Sözleşmesi Filtresi:</b> Üretici modunda sadece <code>demo_producer_001</code> kullanıcısının ilanlarına gelen teklifler listelenir.", style_bullet))
    story.append(Paragraph("• <b>Yerel Durum Değişimi:</b> Üretici teklifleri 'Kabul Et' (accepted) veya 'Reddet' (rejected) yapabilir. Diyalogda <i>'Bu işlem yerel bir durum değişikliğidir, gerçek ödeme/sipariş tamamlama değildir'</i> açıklaması yer alır.", style_bullet))

    story.append(Spacer(1, 10))

    # E5: PROFİL VE ROL YÖNETİMİ
    story.append(Paragraph("7. E5 Modülü: Profil ve Rol Arayüzü", style_h1))
    story.append(Paragraph(
        "<b>Dizin:</b> <code>lib/features/profile/</code><br/>"
        "<b>Public Ekran:</b> <code>ProfileScreen</code>", style_code
    ))
    story.append(Paragraph(
        "Tek cihazda hem üretici hem de tüketici gözüyle platformu deneyimlemeyi sağlayan merkezi kontrol ekranıdır.", style_body
    ))
    story.append(Paragraph("• <b>Tek RoleController Entegrasyonu:</b> İkinci bir rol servisi yazılmamış; Ayberk'in <code>RoleController</code>'ına bağlanarak tercih Hive <code>settings</code> kutusunda korunmuştur.", style_bullet))
    story.append(Paragraph("• <b>Rol Kısıt Koruması (ProfileActionTile):</b> Örneğin Tüketici modundayken Çiftlik Paneline tıklanırsa uygulama çökmez; 'Bu özellik Üretici moduna özeldir, moda geçmek ister misiniz?' onay diyaloğu açılır.", style_bullet))
    story.append(Paragraph("• <b>Hızlı Modül Erişimi:</b> İlan verme, çiftlik paneli, gelen/verilen teklifler, pazar yeri ve hizmet rehberine doğrudan geçiş butonları içerir.", style_bullet))

    story.append(Spacer(1, 10))

    # E6: TESTLER VE DOĞRULAMA
    story.append(Paragraph("8. E6 Modülü: Kalite Kontrol ve Birim Testleri", style_h1))
    story.append(Paragraph(
        "Tüm iş mantığı, validasyonlar ve durum geçişleri için 5 adet bağımsız test dosyası yazılmıştır:", style_body
    ))

    test_table_data = [
        [Paragraph("Test Dosyası", style_table_cell_bold), Paragraph("Test Edilen Senaryolar", style_table_cell_bold)],
        [Paragraph("<b>animal_test.dart</b>", style_table_cell), Paragraph("Boş küpe no reddi, mükerrer küpe no engeli, YYYY-AA-GG tarih doğrulama, hayvan silme, aşı ve gebelik sayaçları.", style_table_cell)],
        [Paragraph("<b>greenhouse_simulator_test.dart</b>", style_table_cell), Paragraph("En az 2 sera kontrolü, 5 sn tick simülasyonu, 0-100 nem sınırlaması, start/stop ve dispose timer yaşam döngüsü.", style_table_cell)],
        [Paragraph("<b>services_filter_test.dart</b>", style_table_cell), Paragraph("Kategori filtresi, şehir filtresi, ikisinin eşzamanlı çalışması, metin arama ve filtreleri sıfırlama.", style_table_cell)],
        [Paragraph("<b>offers_logic_test.dart</b>", style_table_cell), Paragraph("İlan stoğunu aşan teklif reddi, 0 miktar engeli, pending kayıt, demo_producer_001 ilişkilendirmesi, kabul/ret durumları.", style_table_cell)],
        [Paragraph("<b>profile_role_test.dart</b>", style_table_cell), Paragraph("Üretici/tüketici mod değişimi, settings kutusuna yazım ve uygulama yeniden açıldığında rolün korunması (kalıcılık).", style_table_cell)],
        [Paragraph("<b>fake_json_box_repository.dart</b>", style_table_cell), Paragraph("Testlerde Hive disk bağımlılığı olmadan bellek içi izole test koşturmayı sağlayan sahte depo altyapısı.", style_table_cell)]
    ]
    t_test = Table(test_table_data, colWidths=[160, 320])
    t_test.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), c_olive),
        ('BOX', (0,0), (-1,-1), 1, colors.HexColor('#D9D6C8')),
        ('INNERGRID', (0,0), (-1,-1), 0.5, colors.HexColor('#E2DDD1')),
        ('TOPPADDING', (0,0), (-1,-1), 4),
        ('BOTTOMPADDING', (0,0), (-1,-1), 4),
    ]))
    story.append(t_test)

    story.append(Spacer(1, 10))

    # AYBERK ENTEGRASYON NOTLARI
    story.append(Paragraph("9. Ayberk'e Bildirim ve Entegrasyon Özeti", style_h1))
    story.append(Paragraph(
        "Ayberk'in projeyi birleştirmesi için gereken tüm hazır unsurlar aşağıdadır:", style_body
    ))
    story.append(Paragraph(
        "<b>1. Rota Eşleştirmesi (<code>lib/app/app_router.dart</code>):</b><br/>"
        "• <code>AppRoutes.farm</code> ➔ <code>const FarmDashboardScreen()</code><br/>"
        "• <code>AppRoutes.services</code> ➔ <code>const ServiceProvidersScreen()</code><br/>"
        "• <code>AppRoutes.offers</code> ➔ <code>const OffersScreen()</code><br/>"
        "• <code>AppRoutes.offerForm</code> ➔ <code>OfferFormScreen(productId: args as String)</code><br/>"
        "• <code>AppRoutes.profile</code> ➔ <code>const ProfileScreen()</code>", style_code
    ))
    story.append(Paragraph(
        "<b>2. Toolchain Tavsiyesi (<code>pubspec.yaml</code>):</b><br/>"
        "Sistemdeki Dart SDK snapshot uyumsuzluğu nedeniyle <code>objective_c: 9.6.2</code> paketinin build.dart kancası "
        "hata verebilmektedir. Ayberk <code>pubspec.yaml</code> dosyasına:<br/>"
        "<code>dependency_overrides:<br/>&nbsp;&nbsp;objective_c: 9.1.0</code><br/>"
        "eklediğinde tüm test ve derleme süreçleri sorunsuz koşacaktır.", style_body
    ))
    story.append(Paragraph(
        "<b>3. Git Durumu:</b> Sadece <code>feature/emirhan</code> branch'inde çalışılmıştır; otomatik push/merge/force push yapılmamıştır.", style_body
    ))

    # Belgeyi Oluştur
    doc.build(story, canvasmaker=NumberedCanvas)
    print("PDF oluşturuldu:", pdf_filename)

if __name__ == '__main__':
    build_pdf()
