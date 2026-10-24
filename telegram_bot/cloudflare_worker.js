// Cloudflare Worker: relays Telegram webhooks to the Google Apps Script web app.
// Telegram rejects Apps Script's 302 reply, so this answers 200 immediately and
// forwards the update (following Google's redirect) in the background.

// Your deployed web app URL ending in /exec, followed by ?secret=<WEBHOOK_SECRET>
const GAS_URL = "PASTE_WEB_APP_EXEC_URL_HERE?secret=PASTE_WEBHOOK_SECRET_HERE";

export default {
  async fetch(request, env, ctx) {
    if (request.method !== "POST") return new Response("ok");
    const body = await request.text();
    ctx.waitUntil(
      fetch(GAS_URL, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body,
        redirect: "follow",
      })
    );
    return new Response("ok");
  },
};
