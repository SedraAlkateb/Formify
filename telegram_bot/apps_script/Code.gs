/**
 * Telegram bot that adds doctors to a Google Sheet, running entirely on
 * Google Apps Script (free). Telegram calls doPost() for every message;
 * each finished doctor is appended to the "Doctors" sheet of the
 * spreadsheet this script is bound to.
 *
 * Script Properties (Project Settings -> Script properties):
 *   BOT_TOKEN       token from @BotFather
 *   ADMIN_CHAT_ID   chat that receives a copy of each doctor (and errors)
 *   WEBHOOK_SECRET  any random string, protects the webhook URL
 *   WORKER_URL      your Cloudflare Worker URL (the webhook target)
 *   SPREADSHEET_ID  (optional) id of the sheet, from its URL: /d/<ID>/edit
 */

var SHEET_NAME = 'Doctors';
var HEADERS = ['Date', 'Added by (Telegram ID)', 'Added by (username)', 'Name',
               'Phone', 'Email', 'Area / Address', 'Specialty', 'User type', 'Notes'];

// Only "name" is required, every other step can be skipped.
var STEPS = ['name', 'phone', 'email', 'place', 'specialty', 'user_type', 'notes'];
var PROMPTS = {
  name: 'اسم الطبيب؟ (إلزامي)',
  phone: 'رقم الطبيب؟',
  email: 'إيميل الطبيب؟',
  place: 'المنطقة أو العنوان؟',
  specialty: 'الاختصاص؟',
  user_type: 'نوع المستخدم؟',
  notes: 'ملاحظات؟'
};

// Buttons show `ar`; the sheet stores `en`.
var USER_TYPES = [
  { en: 'specialist', ar: 'مختص' },
  { en: 'student', ar: 'طالب' },
  { en: 'pharmacist', ar: 'صيدلي' },
  { en: 'resident', ar: 'مقيم' },
  { en: 'other', ar: 'غير ذلك' },
  { en: 'importantDoctor', ar: 'طبيب مهم' }
];

var EMAIL_RE = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;
var PHONE_RE = /^\+?[0-9\s\-]{7,15}$/;

// ---------- entry points ----------

function doGet() {
  return ContentService.createTextOutput('ok');
}

function doPost(e) {
  log('doPost received: ' + (e && e.postData ? e.postData.contents : 'no postData'));
  var props = PropertiesService.getScriptProperties();
  if (!e || !e.parameter || e.parameter.secret !== props.getProperty('WEBHOOK_SECRET')) {
    log('forbidden: wrong or missing secret');
    return ContentService.createTextOutput('forbidden');
  }
  var lock = LockService.getScriptLock();
  lock.waitLock(25000);
  var update = null;
  try {
    update = JSON.parse(e.postData.contents);
    var cache = CacheService.getScriptCache();
    // Telegram re-sends an update if we answer slowly; ignore duplicates.
    if (cache.get('u' + update.update_id)) {
      log('duplicate update ' + update.update_id);
      return ContentService.createTextOutput('dup');
    }
    cache.put('u' + update.update_id, '1', 21600);
    handleUpdate(update);
  } catch (err) {
    log(err.stack || err);
    reportError(update, err);
  } finally {
    lock.releaseLock();
  }
  return ContentService.createTextOutput('ok');
}

/** Tells the admin (and the user who triggered it) what went wrong. */
function reportError(update, err) {
  try {
    var msg = '⚠️ خطأ في البوت:\n' + (err.stack || err);
    var admin = PropertiesService.getScriptProperties().getProperty('ADMIN_CHAT_ID');
    if (admin) send(admin, msg);
    var chat = update && (update.message ? update.message.chat.id :
      (update.callback_query ? update.callback_query.message.chat.id : null));
    if (chat && String(chat) !== String(admin)) send(chat, 'حدث خطأ، حاول مجددًا بإرسال /start');
  } catch (ignored) {}
}

// ---------- conversation ----------

function handleUpdate(update) {
  var chatId, from, text, isCallback = false;
  if (update.callback_query) {
    var cq = update.callback_query;
    isCallback = true;
    chatId = cq.message.chat.id;
    from = cq.from;
    text = cq.data;
    tg('answerCallbackQuery', { callback_query_id: cq.id });
    tg('editMessageReplyMarkup', {
      chat_id: chatId, message_id: cq.message.message_id,
      reply_markup: { inline_keyboard: [] }
    });
  } else if (update.message && update.message.text) {
    chatId = update.message.chat.id;
    from = update.message.from;
    text = update.message.text.trim();
  } else {
    log('ignored update without text');
    return;
  }

  // Start (or restart) adding a doctor: /start, /form or the "add another" button.
  if ((!isCallback && /^\/(start|form)/.test(text)) || (isCallback && text === 'again')) {
    setState(chatId, { step: 'name', data: {} });
    send(chatId, PROMPTS.name + '\n(/cancel للإلغاء)');
    return;
  }
  if (!isCallback && /^\/cancel/.test(text)) {
    clearState(chatId);
    send(chatId, 'تم الإلغاء. أرسل /start لإضافة طبيب.');
    return;
  }

  var state = getState(chatId);
  if (!state) {
    log('no state for chat ' + chatId);
    send(chatId, 'أرسل /start لإضافة طبيب.');
    return;
  }

  var step = state.step;
  log('step=' + step + ' callback=' + isCallback + ' text=' + text);

  if (isCallback) {
    if (step === 'name') return; // name can't be skipped
    if (text === 'skip') {
      state.data[step] = '';
    } else if (step === 'user_type' && text.indexOf('type:') === 0 &&
               USER_TYPES.some(function (t) { return t.en === text.substring(5); })) {
      state.data.user_type = text.substring(5);
    } else {
      return;
    }
  } else {
    if (step === 'user_type') {
      send(chatId, 'اختر من الأزرار أو اضغط تخطي.', userTypeKeyboard());
      return;
    }
    if (step === 'phone' && !PHONE_RE.test(text)) {
      send(chatId, 'رقم غير صحيح، أعد الإدخال أو اضغط تخطي.', skipKeyboard());
      return;
    }
    if (step === 'email' && !EMAIL_RE.test(text)) {
      send(chatId, 'إيميل غير صحيح، أعد الإدخال أو اضغط تخطي.', skipKeyboard());
      return;
    }
    state.data[step] = text;
  }

  var next = STEPS[STEPS.indexOf(step) + 1];
  if (!next) {
    save(chatId, from, state.data);
    clearState(chatId);
    return;
  }
  state.step = next;
  setState(chatId, state);
  send(chatId, PROMPTS[next], next === 'user_type' ? userTypeKeyboard() : skipKeyboard());
}

function skipKeyboard() {
  return [[{ text: '⏭ تخطي', callback_data: 'skip' }]];
}

function userTypeKeyboard() {
  var rows = USER_TYPES.map(function (t) {
    return [{ text: t.ar, callback_data: 'type:' + t.en }];
  });
  return rows.concat(skipKeyboard());
}

function save(chatId, from, d) {
  var ss = getSpreadsheet();
  var sheet = ss.getSheetByName(SHEET_NAME) || ss.insertSheet(SHEET_NAME);
  if (sheet.getLastRow() === 0) sheet.appendRow(HEADERS);
  // Phone with a leading apostrophe so Sheets keeps a leading + or 0.
  sheet.appendRow([new Date(), String(from.id), from.username || '', d.name,
                   d.phone ? "'" + d.phone : '', d.email || '', d.place || '',
                   d.specialty || '', d.user_type || '', d.notes || '']);

  send(chatId, '✅ تمت الإضافة: ' + d.name, [[{ text: '➕ إضافة طبيب آخر', callback_data: 'again' }]]);

  var admin = PropertiesService.getScriptProperties().getProperty('ADMIN_CHAT_ID');
  if (admin && String(admin) !== String(chatId)) {
    send(admin, '📥 طبيب جديد:\n' +
      'الاسم: ' + d.name + '\nالرقم: ' + (d.phone || '-') + '\nالإيميل: ' + (d.email || '-') +
      '\nالمنطقة: ' + (d.place || '-') + '\nالاختصاص: ' + (d.specialty || '-') +
      '\nالنوع: ' + (d.user_type || '-') +
      '\nملاحظات: ' + (d.notes || '-') +
      '\nأضافه: ' + (from.username ? '@' + from.username : from.id));
  }
}

// ---------- state (per user, in script properties) ----------

function getState(chatId) {
  var raw = PropertiesService.getScriptProperties().getProperty('s_' + chatId);
  return raw ? JSON.parse(raw) : null;
}
function setState(chatId, s) {
  PropertiesService.getScriptProperties().setProperty('s_' + chatId, JSON.stringify(s));
}
function clearState(chatId) {
  PropertiesService.getScriptProperties().deleteProperty('s_' + chatId);
}

// ---------- Telegram helpers ----------

function tg(method, body) {
  var token = PropertiesService.getScriptProperties().getProperty('BOT_TOKEN');
  var res = UrlFetchApp.fetch('https://api.telegram.org/bot' + token + '/' + method, {
    method: 'post',
    contentType: 'application/json',
    payload: JSON.stringify(body),
    muteHttpExceptions: true
  });
  var out = res.getContentText();
  if (out.indexOf('"ok":true') < 0) log(method + ' failed: ' + out);
  else log(method + ' ok');
  return out;
}

function send(chatId, text, keyboard) {
  var body = { chat_id: chatId, text: text };
  if (keyboard) body.reply_markup = { inline_keyboard: keyboard };
  return tg('sendMessage', body);
}

// ---------- helpers to run by hand from the editor ----------

/** Run once after deploying. Registers this web app as the bot's webhook. */
function setWebhook() {
  var props = PropertiesService.getScriptProperties();
  // Running from the editor returns the /dev URL, which Telegram cannot use,
  // so the deployed /exec URL comes from the WEB_APP_URL script property.
  // Telegram rejects Apps Script's 302 reply, so the webhook must point at the
  // Cloudflare Worker relay (WORKER_URL), which forwards to this web app.
  var url = props.getProperty('WORKER_URL');
  if (!url || url.indexOf('https://') !== 0) throw new Error('Set WORKER_URL to your Cloudflare Worker URL');
  Logger.log(tg('setWebhook', { url: url, drop_pending_updates: true }));
}

/** Shows the webhook status; look for last_error_message. */
function webhookInfo() {
  Logger.log(tg('getWebhookInfo', {}));
}

/** Debug: simulates "/start" from ADMIN_CHAT_ID so errors show in the editor. */
function testStart() {
  var props = PropertiesService.getScriptProperties();
  var id = Number(props.getProperty('ADMIN_CHAT_ID'));
  handleUpdate({
    update_id: 1,
    message: { chat: { id: id }, from: { id: id, username: 'test' }, text: '/start' }
  });
  Logger.log('state: ' + props.getProperty('s_' + id));
}

/** Use if a conversation gets stuck: send /start in the bot (it restarts the flow). */

/** Execution log only (writing every line to a sheet made the bot slow). */
function log(msg) {
  console.log(msg);
}

/** The sheet to write to: SPREADSHEET_ID property if set, else the bound spreadsheet. */
function getSpreadsheet() {
  var id = PropertiesService.getScriptProperties().getProperty('SPREADSHEET_ID');
  return id ? SpreadsheetApp.openById(id) : SpreadsheetApp.getActiveSpreadsheet();
}
