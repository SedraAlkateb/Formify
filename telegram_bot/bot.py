"""Telegram bot that collects a user's contact/profile info step by step.

Flow: /start -> name -> phone -> email -> place -> specialty -> user type -> notes.
The result is sent as JSON to ADMIN_CHAT_ID and, optionally, to a Google
Apps Script web app (SHEETS_URL) that appends it as a row in Google Sheets.
"""
import json
import logging
import os
import re

import requests
from telegram import InlineKeyboardButton, InlineKeyboardMarkup, Update
from telegram.ext import (
    ApplicationBuilder,
    CallbackQueryHandler,
    CommandHandler,
    ContextTypes,
    ConversationHandler,
    MessageHandler,
    filters,
)

BOT_TOKEN = os.environ["TELEGRAM_BOT_TOKEN"]
ADMIN_CHAT_ID = os.environ.get("ADMIN_CHAT_ID")  # who receives the data
SHEETS_URL = os.environ.get("SHEETS_URL")  # optional Apps Script web app URL

# Edit these to match your real user types.
USER_TYPES = ["طبيب", "صيدلاني", "ممثل", "أخرى"]

logging.basicConfig(level=logging.INFO)

NAME, PHONE, EMAIL, PLACE, SPECIALTY, USER_TYPE, NOTES = range(7)
EMAIL_RE = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")
PHONE_RE = re.compile(r"^\+?[0-9\s\-]{7,15}$")


def skip_kb():
    return InlineKeyboardMarkup([[InlineKeyboardButton("⏭ تخطي", callback_data="skip")]])


async def begin(update: Update, context: ContextTypes.DEFAULT_TYPE):
    context.user_data.clear()
    await update.message.reply_text("أهلاً بك! لنبدأ بجمع بياناتك. /cancel للإلغاء.\n\nما اسمك الكامل؟")
    return NAME


async def get_name(update, context):
    context.user_data["name"] = update.message.text.strip()
    await update.message.reply_text("ما رقم هاتفك؟")
    return PHONE


async def get_phone(update, context):
    text = update.message.text.strip()
    if not PHONE_RE.match(text):
        await update.message.reply_text("رقم غير صحيح، أعد الإدخال.")
        return PHONE
    context.user_data["phone"] = text
    await update.message.reply_text("ما بريدك الإلكتروني؟")
    return EMAIL


async def get_email(update, context):
    text = update.message.text.strip()
    if not EMAIL_RE.match(text):
        await update.message.reply_text("بريد غير صحيح، أعد الإدخال.")
        return EMAIL
    context.user_data["email"] = text
    await update.message.reply_text("ما المكان (المدينة/المنطقة)؟")
    return PLACE


async def get_place(update, context):
    context.user_data["place"] = update.message.text.strip()
    await update.message.reply_text("ما اختصاصك؟")
    return SPECIALTY


async def get_specialty(update, context):
    context.user_data["specialty"] = update.message.text.strip()
    rows = [[InlineKeyboardButton(t, callback_data=f"type:{t}")] for t in USER_TYPES]
    await update.message.reply_text("ما نوع المستخدم؟", reply_markup=InlineKeyboardMarkup(rows))
    return USER_TYPE


async def get_type(update, context):
    cq = update.callback_query
    await cq.answer()
    context.user_data["user_type"] = cq.data.removeprefix("type:")
    await cq.edit_message_reply_markup(None)
    await cq.message.reply_text("هل لديك ملاحظات؟ اكتبها أو اضغط تخطي.", reply_markup=skip_kb())
    return NOTES


async def get_notes(update, context):
    context.user_data["notes"] = update.message.text.strip()
    return await finish(update, context)


async def skip_notes(update, context):
    cq = update.callback_query
    await cq.answer()
    await cq.edit_message_reply_markup(None)
    context.user_data["notes"] = ""
    return await finish(update, context)


async def finish(update: Update, context: ContextTypes.DEFAULT_TYPE):
    user = update.effective_user
    data = {
        "telegram_id": user.id,
        "username": user.username or "",
        **context.user_data,
    }
    msg = update.effective_message
    ok = True

    if SHEETS_URL:
        try:
            r = requests.post(SHEETS_URL, data=json.dumps(data), headers={"Content-Type": "application/json"}, timeout=20)
            r.raise_for_status()
        except Exception:
            logging.exception("sheets failed")
            ok = False

    if ADMIN_CHAT_ID:
        try:
            await context.bot.send_message(
                ADMIN_CHAT_ID,
                "📥 بيانات جديدة:\n" + json.dumps(data, ensure_ascii=False, indent=2),
            )
        except Exception:
            logging.exception("admin send failed")
            ok = False

    await msg.reply_text("شكرًا لك! تم حفظ بياناتك ✅" if ok else "حدث خطأ أثناء الحفظ، حاول لاحقًا.")
    return ConversationHandler.END


async def cancel(update, context):
    context.user_data.clear()
    await update.message.reply_text("تم الإلغاء.")
    return ConversationHandler.END


def text_handler(fn):
    return MessageHandler(filters.TEXT & ~filters.COMMAND, fn)


if __name__ == "__main__":
    app = ApplicationBuilder().token(BOT_TOKEN).build()
    app.add_handler(ConversationHandler(
        entry_points=[CommandHandler("start", begin), CommandHandler("form", begin)],
        states={
            NAME: [text_handler(get_name)],
            PHONE: [text_handler(get_phone)],
            EMAIL: [text_handler(get_email)],
            PLACE: [text_handler(get_place)],
            SPECIALTY: [text_handler(get_specialty)],
            USER_TYPE: [CallbackQueryHandler(get_type, pattern="^type:")],
            NOTES: [text_handler(get_notes), CallbackQueryHandler(skip_notes, pattern="^skip$")],
        },
        fallbacks=[CommandHandler("cancel", cancel)],
    ))
    app.run_polling()
