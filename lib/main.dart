
import tkinter as tk
from tkinter import ttk, messagebox
from pathlib import Path

# =====================================
# نور القرآن الكريم
# القارئ: عثمان مشعل الحداد
# =====================================

BG = "#0B3028"
PANEL = "#12463B"
GOLD = "#E8D39A"
WHITE = "#FFFFFF"

BASE = Path(__file__).resolve().parent
AUDIO = BASE / "audio"
AUDIO.mkdir(exist_ok=True)

SURAHS = [
    "الفاتحة", "البقرة", "آل عمران", "النساء",
    "المائدة", "الأنعام", "الأعراف", "الأنفال",
    "التوبة", "يونس", "هود", "يوسف", "الرعد",
    "إبراهيم", "الحجر", "النحل", "الإسراء", "الكهف",
    "مريم", "طه", "الأنبياء", "الحج", "المؤمنون",
    "النور", "الفرقان", "الشعراء", "النمل", "القصص",
    "العنكبوت", "الروم", "لقمان", "السجدة", "الأحزاب",
    "سبأ", "فاطر", "يس", "الصافات", "ص", "الزمر",
    "غافر", "فصلت", "الشورى", "الزخرف", "الدخان",
    "الجاثية", "الأحقاف", "محمد", "الفتح", "الحجرات",
    "ق", "الذاريات", "الطور", "النجم", "القمر",
    "الرحمن", "الواقعة", "الحديد", "المجادلة", "الحشر",
    "الممتحنة", "الصف", "الجمعة", "المنافقون",
    "التغابن", "الطلاق", "التحريم", "الملك", "القلم",
    "الحاقة", "المعارج", "نوح", "الجن", "المزمل",
    "المدثر", "القيامة", "الإنسان", "المرسلات",
    "النبأ", "النازعات", "عبس", "التكوير",
    "الانفطار", "المطففين", "الانشقاق", "البروج",
    "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد",
    "الشمس", "الليل", "الضحى", "الشرح", "التين",
    "العلق", "القدر", "البينة", "الزلزلة", "العاديات",
    "القارعة", "التكاثر", "العصر", "الهمزة", "الفيل",
    "قريش", "الماعون", "الكوثر", "الكافرون", "النصر",
    "المسد", "الإخلاص", "الفلق", "الناس"
]

player = None


def create_player():
    global player
    try:
        import pygame
        if player is None:
            pygame.mixer.init()
            player = pygame
        return player
    except ImportError:
        messagebox.showerror(
            "مكتبة الصوت",
            "ثبّت مكتبة pygame أولًا:\n"
            "python -m pip install pygame"
        )
        return None
    except Exception as error:
        messagebox.showerror("خطأ في الصوت", str(error))
        return None


def get_audio_path():
    index = SURAHS.index(selected.get()) + 1
    return AUDIO / f"{index:03d}.mp3"


def update_surah(*args):
    name = selected.get()
    index = SURAHS.index(name) + 1
    path = get_audio_path()

    title.config(text=f"سورة {name}")

    if path.exists():
        status.config(
            text="ملف التلاوة محفوظ على الجهاز وجاهز للتشغيل دون إنترنت",
            fg=GOLD
        )
    else:
        status.config(
            text=f"أضف ملف الصوت: audio/{index:03d}.mp3",
            fg=WHITE
        )


def play_audio():
    path = get_audio_path()

    if not path.exists():
        messagebox.showwarning(
            "ملف التلاوة غير موجود",
            "لم يتم العثور على ملف السورة.\n\n"
            f"المسار المطلوب:\n{path}\n\n"
            "ضع ملف MP3 الصحيح للقارئ عثمان مشعل الحداد "
            "داخل مجلد audio."
        )
        return

    audio_player = create_player()
    if audio_player is None:
        return

    try:
        audio_player.mixer.music.load(str(path))
        audio_player.mixer.music.play()
        status.config(text="التلاوة تعمل الآن دون إنترنت", fg=GOLD)
    except Exception as error:
        messagebox.showerror("تعذر تشغيل التلاوة", str(error))


def pause_audio():
    if player:
        player.mixer.music.pause()


def resume_audio():
    if player:
        player.mixer.music.unpause()


def stop_audio():
    if player:
        player.mixer.music.stop()
        status.config(text="تم إيقاف التلاوة", fg=WHITE)


# إنشاء الواجهة
root = tk.Tk()
root.title("نور القرآن الكريم")
root.geometry("420x700")
root.configure(bg=BG)

tk.Label(
    root,
    text="۞",
    font=("Arial", 34),
    bg=BG,
    fg=GOLD
).pack(pady=(20, 0))

tk.Label(
    root,
    text="نور القرآن الكريم",
    font=("Arial", 25, "bold"),
    bg=BG,
    fg=GOLD
).pack(pady=5)

tk.Label(
    root,
    text="القرآن الكريم • نور وطمأنينة",
    font=("Arial", 12),
    bg=BG,
    fg=WHITE
).pack(pady=(0, 20))

card = tk.Frame(root, bg=PANEL, padx=18, pady=20)
card.pack(fill="x", padx=18)

tk.Label(
    card,
    text="اختر السورة من القرآن الكريم",
    font=("Arial", 14, "bold"),
    bg=PANEL,
    fg=GOLD
).pack(pady=8)

selected = tk.StringVar(value=SURAHS[0])

menu = ttk.Combobox(
    card,
    textvariable=selected,
    values=SURAHS,
    state="readonly",
    justify="right",
    font=("Arial", 14)
)
menu.pack(fill="x", pady=10)
menu.bind("<<ComboboxSelected>>", update_surah)

title = tk.Label(
    card,
    text="",
    font=("Arial", 22, "bold"),
    bg=PANEL,
    fg=WHITE
)
title.pack(pady=15)

status = tk.Label(
    card,
    text="",
    font=("Arial", 10),
    bg=PANEL,
    fg=GOLD,
    wraplength=330
)
status.pack(pady=8)

buttons = [
    ("▶ تشغيل التلاوة", play_audio),
    ("Ⅱ إيقاف مؤقت", pause_audio),
    ("▶ استكمال التلاوة", resume_audio),
    ("■ إيقاف الصوت", stop_audio),
]

for text, command in buttons:
    tk.Button(
        card,
        text=text,
        command=command,
        font=("Arial", 13, "bold"),
        bg=GOLD,
        fg=BG,
        relief="flat",
        pady=9
    ).pack(fill="x", pady=5)

tk.Label(
    root,
    text="﴿ وَاذْكُر رَبَّكَ كَثِيرًا ﴾",
    font=("Arial", 17),
    bg=BG,
    fg=GOLD
).pack(pady=25)

tk.Label(
    root,
    text="التشغيل دون إنترنت متاح بعد حفظ ملفات الصوت",
    font=("Arial", 10),
    bg=BG,
    fg=WHITE
).pack(pady=5)

update_surah()
root.mainloop()