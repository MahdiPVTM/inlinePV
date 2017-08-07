local URL = require "socket.url"
local https = require "ssl.https"
local serpent = require "serpent"
local json = (loadfile "/home/username/inlinePV/JSON.lua")()
local token = '430928901:AAEeiFZHaKNXe0yv843ga1c7D6ia5k40oCY' --token
local url = 'https://api.telegram.org/bot' .. token
local offset = 0
local redis = require('redis')
local redis = redis.connect('127.0.0.1', 6379)
local SUDO = 372897257
function is_mod(chat,user)
sudo = {372897257}
  local var = false
  for v,_user in pairs(sudo) do
    if _user == user then
      var = true
    end
  end
 local hash = redis:sismember(SUDO..'owners:'..chat,user)
 if hash then
 var = true
 end
  local hash = redis:sismember(SUDO..'helpsudo:',user)
 if hash then
 var = true
 end
 local hash2 = redis:sismember(SUDO..'mods:'..chat,user)
 if hash2 then
 var = true
 end
 return var
 end
local function getUpdates()
  local response = {}
  local success, code, headers, status  = https.request{
    url = url .. '/getUpdates?timeout=20&limit=1&offset=' .. offset,
    method = "POST",
    sink = ltn12.sink.table(response),
  }

  local body = table.concat(response or {"no response"})
  if (success == 1) then
    return json:decode(body)
  else
    return nil, "Request Error"
  end
end

function vardump(value)
  print(serpent.block(value, {comment=false}))
end

function sendmsg(chat,text,keyboard)
if keyboard then
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text='..URL.escape(text)..'&parse_mode=html&reply_markup='..URL.escape(json:encode(keyboard))
else
urlk = url .. '/sendMessage?chat_id=' ..chat.. '&text=' ..URL.escape(text)..'&parse_mode=html'
end
https.request(urlk)
end
 function edit( message_id, text, keyboard)
  local urlk = url .. '/editMessageText?&inline_message_id='..message_id..'&text=' .. URL.escape(text)
    urlk = urlk .. '&parse_mode=Markdown'
  if keyboard then
    urlk = urlk..'&reply_markup='..URL.escape(json:encode(keyboard))
  end
    return https.request(urlk)
  end
function Canswer(callback_query_id, text, show_alert)
	local urlk = url .. '/answerCallbackQuery?callback_query_id=' .. callback_query_id .. '&text=' .. URL.escape(text)
	if show_alert then
		urlk = urlk..'&show_alert=true'
	end
  https.request(urlk)
	end
  function answer(inline_query_id, query_id , title , description , text , keyboard)
  local results = {{}}
         results[1].id = query_id
         results[1].type = 'article'
         results[1].description = description
         results[1].title = title
         results[1].message_text = text
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  if keyboard then
   results[1].reply_markup = keyboard
  urlk = url .. '/answerInlineQuery?inline_query_id=' .. inline_query_id ..'&results=' .. URL.escape(json:encode(results))..'&parse_mode=Markdown&cache_time=' .. 1
  end
    https.request(urlk)
  end
function settings(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
  if value == 'file' then
      text = 'فیلتر فایل'
   elseif value == 'keyboard' then
    text = 'فیلتردرون خطی(کیبرد شیشه ای)'
  elseif value == 'link' then
    text = 'قفل ارسال لینک(تبلیغات)'
  elseif value == 'game' then
    text = 'فیلتر انجام بازی های(inline)'
    elseif value == 'username' then
    text = 'قفل ارسال یوزرنیم(@)'
   elseif value == 'pin' then
    text = 'قفل پین کردن(پیام)'
    elseif value == 'photo' then
    text = 'فیلتر تصاویر'
    elseif value == 'gif' then
    text = 'فیلتر تصاویر متحرک'
    elseif value == 'video' then
    text = 'فیلتر ویدئو'
    elseif value == 'audio' then
    text = 'فیلتر صدا(audio-voice)'
    elseif value == 'music' then
    text = 'فیلتر آهنگ(MP3)'
    elseif value == 'text' then
    text = 'فیلتر متن'
    elseif value == 'sticker' then
    text = 'قفل ارسال برچسب'
    elseif value == 'contact' then
    text = 'فیلتر مخاطبین'
    elseif value == 'forward' then
    text = 'فیلتر فوروارد'
    elseif value == 'persian' then
    text = 'فیلتر گفتمان(فارسی)'
    elseif value == 'english' then
    text = 'فیلتر گفتمان(انگلیسی)'
    elseif value == 'bot' then
    text = 'قفل ورود ربات(API)'
    elseif value == 'tgservice' then
    text = 'فیلتر پیغام ورود،خروج افراد'
	elseif value == 'groupadds' then
    text = 'تبلیغات'
    elseif value == 'fohsh' then
	text = 'فیلتر فحش'
    end
		if not text then
		return ''
		end
	if redis:get(hash) then
  redis:del(hash)
return text..'  غیرفعال شد.'
		else
		redis:set(hash,true)
return text..'  فعال شد.'
end
    end
function fwd(chat_id, from_chat_id, message_id)
  local urlk = url.. '/forwardMessage?chat_id=' .. chat_id .. '&from_chat_id=' .. from_chat_id .. '&message_id=' .. message_id
  local res, code, desc = https.request(urlk)
  if not res and code then -- if the request failed and a code is returned (not 403 and 429)
  end
  return res, code
end
function sleep(n)
os.execute("sleep " .. tonumber(n))
end
local day = 86400
local function run()
  while true do
    local updates = getUpdates()
    vardump(updates)
    if(updates) then
      if (updates.result) then
        for i=1, #updates.result do
          local msg = updates.result[i]
          offset = msg.update_id + 1
          if msg.inline_query then
            local q = msg.inline_query
						if q.from.id == 386627429 or q.from.id == 372897257 then
            if q.query:match('%d+') then
              local chat = '-'..q.query:match('%d+')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = '🌀group settings🌀', callback_data = 'groupsettings:'..chat} --,{text = '💵Sales💵', callback_data = 'aboute:'..chat}
                },{
				 {text = '🎯Group info📕', callback_data = 'groupinfo:'..chat} --,{text = '⚠️Help⚠️', callback_data = 'helpbot:'..chat}
				},{
				{text = '🔅Help🔅', callback_data = 'helptext:'..chat}
				},{
                 {text = '🔅support👀', callback_data = 'supportbot:'..chat} --,{text = '📝Your Adds📝', callback_data = 'youradds:'..chat} 
                },{
				{text = 'close panel🚫', callback_data = 'close:'..chat}
				}
							}
            answer(q.id,'panel','Group settings',chat,'💠main menu💠 :',keyboard)
            end
            end
						end
          if msg.callback_query then
            local q = msg.callback_query
						local chat = ('-'..q.data:match('(%d+)') or '')
						if is_mod(chat,q.from.id) then
             if q.data:match('_') and not (q.data:match('next_page') or q.data:match('left_page')) then
                Canswer(q.id,"@PVTeaM :D",true)
					elseif q.data:match('lock') then
							local lock = q.data:match('lock (.*)')			
				TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
              MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
			                WARN_MAX = (redis:hget("warn:settings:"..chat,"warnmax") or 3)
							local result = settings(chat,lock)
							if lock == 'photo' or lock == 'audio' or lock == 'video' or lock == 'gif' or lock == 'music' or lock == 'file' or lock == 'link' or lock == 'sticker' or lock == 'text' or lock == 'pin' or lock == 'username' or lock == 'hashtag' or lock == 'contact' or lock == 'fwd' then
							q.data = 'left_page:'..chat
							elseif lock == 'muteall' then
								if redis:get(SUDO..'muteall'..chat) then
								redis:del(SUDO..'muteall'..chat)
									result = "فیلتر تمامی گفتگو ها غیرفعال گردید."
								else
								redis:set(SUDO..'muteall'..chat,true)
									result = "فیلتر تمامی گفتگو ها فعال گردید!"
							end
						 q.data = 'next_page:'..chat
							elseif lock == 'spam' then
							local hash = redis:hget("flooding:settings:"..chat, "flood")
						if hash then
            if redis:hget("flooding:settings:"..chat, "flood") == 'kick' then
         			spam_status = 'مسدود سازی(کاربر)'
							redis:hset("flooding:settings:"..chat, "flood",'ban')
              elseif redis:hget("flooding:settings:"..chat, "flood") == 'ban' then
              spam_status = 'سکوت(کاربر)'
							redis:hset("flooding:settings:"..chat, "flood",'mute')
              elseif redis:hget("flooding:settings:"..chat, "flood") == 'mute' then
              spam_status = '🔓'
							redis:hdel("flooding:settings:"..chat, "flood")
              end
          else
          spam_status = 'اخراج سازی(کاربر)'
					redis:hset("flooding:settings:"..chat, "flood",'kick')
          end
								result = 'عملکرد قفل ارسال هرزنامه : '..spam_status
								
								
								
			 q.data = 'next_page:'..chat
							elseif lock == 'warn' then
							local hash = redis:hget("warn:settings:"..chat, "swarn")
						if hash then
            if redis:hget("warn:settings:"..chat, "swarn") == 'kick' then
         			warn_status = 'مسدود سازی(کاربر)'
							redis:hset("warn:settings:"..chat, "swarn",'ban')
              elseif redis:hget("warn:settings:"..chat, "swarn") == 'ban' then
              warn_status = 'سکوت(کاربر)'
							redis:hset("warn:settings:"..chat, "swarn",'mute')
              elseif redis:hget("warn:settings:"..chat, "swarn") == 'mute' then
              warn_status = '🔓'
							redis:hdel("warn:settings:"..chat, "swarn")
              end
          else
          warn_status = 'اخراج سازی(کاربر)'
					redis:hset("warn:settings:"..chat, "swarn",'kick')
          end
								result = 'عملکرد قفل ارسال هرزنامه : '..warn_status

								q.data = 'next_page:'..chat
								elseif lock == 'MSGMAXup' then
								if tonumber(MSG_MAX) == 20 then
									Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [20] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) + 1
								redis:hset("flooding:settings:"..chat,"floodmax",MSG_MAX)
								q.data = 'next_page:'..chat
							  result = MSG_MAX
								end
								elseif lock == 'MSGMAXdown' then
								if tonumber(MSG_MAX) == 2 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [2] میباشد!',true)
									else
								MSG_MAX = tonumber(MSG_MAX) - 1
								redis:hset("flooding:settings:"..chat,"floodmax",MSG_MAX)
								q.data = 'next_page:'..chat
								result = MSG_MAX
							end
								elseif lock == 'TIMEMAXup' then
								if tonumber(TIME_MAX) == 15 then
								Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [15] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) + 1
								redis:hset("flooding:settings:"..chat ,"floodtime" ,TIME_MAX)
								q.data = 'next_page:'..chat
								result = TIME_MAX
									end
								elseif lock == 'TIMEMAXdown' then
								if tonumber(TIME_MAX) == 5 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [5] میباشد!',true)
									else
								TIME_MAX = tonumber(TIME_MAX) - 1
								redis:hset("flooding:settings:"..chat ,"floodtime" ,TIME_MAX)
								q.data = 'next_page:'..chat
								result = TIME_MAX
									end
									
							    elseif lock == 'WARNMAXup' then
								if tonumber(WARN_MAX) == 20 then
									Canswer(q.id,'حداکثر عدد انتخابی برای این قابلیت [20] میباشد!',true)
									else
								WARN_MAX = tonumber(MSG_MAX) + 1
								redis:hset("warn:settings:"..chat,"warnmax",MSG_MAX)
								q.data = 'next_page:'..chat
							  result = WARN_MAX
								end
								elseif lock == 'WARNMAXdown' then
								if tonumber(WARN_MAX) == 5 then
									Canswer(q.id,'حداقل عدد انتخابی مجاز  برای این قابلیت [5] میباشد!',true)
									else
								WARN_MAX = tonumber(WARN_MAX) - 1
								redis:hset("warn:settings:"..chat,"warnmax",WARN_MAX)
								q.data = 'next_page:'..chat
								result = WARN_MAX
							end
									
								elseif lock == 'welcome' then
								local h = redis:get(SUDO..'status:welcome:'..chat)
								if h == 'disable' or not h then
								redis:set(SUDO..'status:welcome:'..chat,'enable')
         result = 'ارسال پیام خوش آمدگویی فعال گردید.'
								q.data = 'next_page:'..chat
          else
          redis:set(SUDO..'status:welcome:'..chat,'disable')
          result = 'ارسال پیام خوش آمدگویی غیرفعال گردید!'
								q.data = 'next_page:'..chat
									end
								else
								q.data = 'next_page:'..chat
								end
							Canswer(q.id,result)
							end
							-------------------------------------------------------------------------
							if q.data:match('firstmenu') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end
              local keyboard = {}
							keyboard.inline_keyboard = {
								{
                 {text = '🌀group settings🌀', callback_data = 'groupsettings:'..chat} --,{text = '💵Sales💵', callback_data = 'aboute:'..chat}
                },{
				 {text = '🎯Group info📕', callback_data = 'groupinfo:'..chat} --,{text = '⚠️Help⚠️', callback_data = 'helpbot:'..chat}
				},{
				{text = '🔅Help🔅', callback_data = 'helptext:'..chat}
				},{
                 {text = '🔅support👀', callback_data = 'supportbot:'..chat} --,{text = '📝Your Adds📝', callback_data = 'youradds:'..chat}
                },{
				{text = '⭕⭕️close panel🚫', callback_data = 'close:'..chat}
							}
							}
            edit(q.inline_message_id,'🌀 main menu 🌀 :',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('supportbot') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '🛠Technical Team🛠', callback_data = 'teamfani:'..chat},{text = '📝Offer📝', callback_data = 'enteqadvapishnehad:'..chat}
                },{
				 {text = '📱Report a problem📱', callback_data = 'reportproblem:'..chat},{text = '❓Frequently Questions❓', callback_data = 'soalatmotadavel:'..chat}
				 },{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`Welcome To` *Support🌷*\n`Select From` *Menu*👇',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('teamfani') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙Back', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'[🔖Send Your Msg🔖](https://telegram.me/Qowfli_bot)',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('reportproblem') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙Back', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'[✔️Send Your Problem✔️](https://telegram.me/Qowfli_bot)',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('fahedsale') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'تمدید سرویس انتخابی', callback_data = 'tamdidservice:'..chat},{text = 'خرید طرح جدید', callback_data = 'salegroup:'..chat}

                },{
				{text = 'گزارشات مالی', callback_data = 'reportmony:'..chat}

                },{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙Back', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`به بخش خرید گروه،تمدید سرویس،گزارش مالی خوش آمدید.`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('tamdidservice') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙Back', callback_data = 'fahedsale:'..chat}
				}
							}
              edit(q.inline_message_id,'`طرح انتخابی [شما دائمی/مادام العمر(نامحدود روز)] میباشد و نیاز به تمدید طرح ندارید!`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('reportmony') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'fahedsale:'..chat}
				}
							}
              edit(q.inline_message_id,'`🚫Sorry, unfortunately the system is disabled until further notice🚫`',keyboard)
            end
			------------------------------------------------------------------------
							if q.data:match('enteqadvapishnehad') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'[❗️Send Your Offer❗️](https://telegram.me/Qowfli_bot)',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('soalatmotadavel') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'supportbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`🚫Sorry, unfortunately the system is disabled until further notice🚫`',keyboard)
            end
							------------------------------------------------------------------------
						if q.data:match('close') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر❌', callback_data = 'firstmenu:'..chat},{text = '✅بله✅', callback_data = 'closepanel:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️ایا از بستن پنل مطمین هستید؟',keyboard)
            end
			-----------------------------------------------------
						if q.data:match('closepanel') then
                           local chat = '-'..q.data:match('(%d+)$')
			edit(q.inline_message_id,'`⚜️پنل با موفقیت بسته شد✅`')
           end
							------------------------------------------------------------------------
							--[[if q.data:match('groupinfo') thens
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'🚫Sorry, unfortunately the system is disabled until further notice🚫',keyboard)
            end]]
							------------------------------------------------------------------------
							if q.data:match('helpbot') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '📝Text Help📝', callback_data = 'helptext:'..chat}
                },{
				 {text = '🎤Voice Help🎤', callback_data = 'voicehelp:'..chat},{text = '🌆Photo Help🌆', callback_data = 'videohelp:'..chat}
                },{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'`WelCome To` _Help🌷_\n Select From *Menu👇*',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('helptext') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'>[راهنمای مالکین گروه(اصلی-فرعی)](https://telegram.me/PVTeaM)\n*[/#!]options* --دریافت تنظیمات گروه به صورت اینلاین\n*[/#!]setrules text* --تنظیم قوانین گروه\n*[/#!]modset* @username|reply|user-id --تنظیم مالک فرعی جدید برای گروه با یوزرنیم|ریپلی|شناسه -فرد\n*[/#!]moddem* @username|reply|user-id --حذف مالک فرعی از گروه با یوزرنیم|ریپلی|شناسه -فرد\n*[/#!]ownerlist* --دریافت لیست مدیران اصلی\n*[/#!]managers* --دریافت لیست مدیران فرعی گروه\n*[/#!]setlink link* {لینک-گروه} --تنظیم لینک گروه\n*[/#!]link* دریافت لینک گروه\n*[/#!]kick* @username|reply|user-id اخراج کاربر با ریپلی|یوزرنیم|شناسه\n*_______________________*\n>[راهنمای بخش حذف ها](https://telegram.me/PVTeaM)\n*[/#!]delete managers* {حذف تمامی مدیران فرعی تنظیم شده برای گروه}\n*[/#!]delete welcome* {حذف پیغام خوش آمدگویی تنظیم شده برای گروه}\n*[/#!]delete bots* {حذف تمامی ربات های موجود در ابرگروه}\n*[/#!]delete silentlist* {حذف لیست سکوت کاربران}\n*[/#!]delete filterlist* {حذف لیست کلمات فیلتر شده در گروه}\n*_______________________*\n>[راهنمای بخش خوش آمدگویی](https://telegram.me/PVTeaM)\n*[/#!]welcome enable* --(فعال کردن پیغام خوش آمدگویی در گروه)\n*[/#!]welcome disable* --(غیرفعال کردن پیغام خوش آمدگویی در گروه)\n*[/#!]setwelcome text* --(تنظیم پیغام خوش آمدگویی جدید در گروه)\n*_______________________*\n>[راهنمای بخش فیلترگروه](https://telegram.me/PVTeaM)\n*[/#!]mutechat* --فعال کردن فیلتر تمامی گفتگو ها\n*[/#!]unmutechat* --غیرفعال کردن فیلتر تمامی گفتگو ها\n*[/#!]mutechat number(h|m|s)* --فیلتر تمامی گفتگو ها بر حسب زمان[ساعت|دقیقه|ثانیه]\n*_______________________*\n>[راهنمای دستورات حالت سکوت کاربران](https://telegram.me/PVTeaM)\n*[/#!]silentuser* @username|reply|user-id --افزودن کاربر به لیست سکوت با یوزرنیم|ریپلی|شناسه -فرد\n*[/#!]unsilentuser* @username|reply|user-id --افزودن کاربر به لیست سکوت با یوزرنیم|ریپلی|شناسه -فرد\n*[/#!]silentlist* --دریافت لیست کاربران حالت سکوت\n*_______________________*\n>[راهنمای بخش فیلتر-کلمات](https://telegram.me/PVTeaM)\n*[/#!]filter word --افزودن عبارت جدید به لیست کلمات فیلتر شده\n[/#!]unfilter word* --حذف عبارت جدید از لیست کلمات فیلتر شده\n*[/#!]filterlist* --دریافت لیست کلمات فیلتر شده\n*_______________________*\n>[راهنمای بخش تنظیم پیغام مکرر](https://telegram.me/PVTeaM)\n*[/#!]floodmax number* --تنظیم حساسیت نسبت به ارسال پیام مکرر\n*[/#!]floodtime* --تنظیم حساسیت نسبت به ارسال پیام مکرر برحسب زمان',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('videohelp') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'helpbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`⛔️Sorry, currently the system of choice is disabled⛔️`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('voicehelp') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'helpbot:'..chat}
				}
							}
              edit(q.inline_message_id,'`⛔️Sorry, currently the system of choice is disabled⛔️`',keyboard)
            end
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							if q.data:match('groupinfo') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '👮صاحبان گروه👮', callback_data = 'ownerlist:'..chat}
                },{
				{text = '👨‍✈️مدیران گروه👨‍✈️', callback_data = 'managerlist:'..chat}
                },{
				 {text = '➰قوانین گروه➰', callback_data = 'showrules:'..chat}
				 },{
				 {text = '🔗لینک گروه🔗', callback_data = 'linkgroup:'..chat}
				 },{
				 {text = '📒لیست کاربران مسدود⛔️', callback_data = 'banlist:'..chat}
				  },{
				  {text = '📒لیست کلمات فیلتر🚫', callback_data = 'filterlistword:'..chat}
				  },{
				 {text = '📒لیست کاربران میوت🔇', callback_data = 'silentlistusers:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'©اطلاعات گروه :',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('managerlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers(SUDO..'mods:'..chat)
          local t = '*👨‍✈️مدیران گروه👇* \n\n'
          for k,v in pairs(list) do
          t = t..k.." - `"..v.."`\n"
          end
          t = t..'\nبرای مشاهده کاربر از دستور زیر استفاده کنید 👇\n/whois [آیدی کاربر]\nمثال 👇\n /whois 234458457'
          if #list == 0 then
          t = '*👨‍✈️هیچ مدیری در گروه وجود ندارد❌*'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '👨‍✈️پاک سازی مدیران🗑', callback_data = 'removemanagers:'..chat}
				   },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showmanagers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`⛔️Sorry, currently the system of choice is disabled⛔️`',keyboard)
            end
							------------------------------------------------------------------------
							------------------------------------------------------------------------
							if q.data:match('ownerlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers(SUDO..'owners:'..chat)
          local t = '*👮لیست صاحبان گروه👇* \n\n'
          for k,v in pairs(list) do
          t = t..k.." - `"..v.."`\n"
          end
          t = t..'\nبرای مشاهده کاربر از دستور زیر استفاده کنید 👇\n/whois [آیدی کاربر]\nمثال 👇\n /whois 234458457'
          if #list == 0 then
          t = '👮این گروه هیچ صاحبی ندارد❌'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text = '👮پاک سازی صاحبان گروه❌', callback_data = 'removeowners:'..chat}
				   },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showowners') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'ownerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`⛔️Sorry, currently the system of choice is disabled⛔️`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showrules') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local rules = redis:get(SUDO..'grouprules'..chat)
          if not rules then
          rules = '➰قوانینی وجود ندارد❌'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
							{text = '➰پاک سازی قوانین❌', callback_data = 'removerules:'..chat}
				   },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '➰قوانین گروه👇\n\n `'..rules..'`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('linkgroup') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local links = redis:get(SUDO..'grouplink'..chat)
          if not links then
          links = '🌐لینکی وجود ندارد❌'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = '🌐حذف لینک❌', callback_data = 'removegrouplink:'..chat}
				   },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, '🌐لینک گروه👇\n '..links..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('banlist') then
                           local chat = '-'..q.data:match('(%d+)$')
						  local list = redis:smembers(SUDO..'banned'..chat)
          local t = '*⛔️لیست مسدود شدگان👇*\n\n'
          for k,v in pairs(list) do
          t = t..k.." - _"..v.."_\n"
          end
          t = t..'\nبرای مشاهده کاربر از دستور زیر استفاده کنید 👇\n/whois [آیدی کاربر]\nمثال 👇\n /whois 234458457'
          if #list == 0 then
          t = '*⛔️هیچ کاربر مسدودی در این گروه وجود ندارد❌*'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '⛔️پاکسازی کاربران مسدود❌', callback_data = 'removebanlist:'..chat}
				   },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showusers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'banlist:'..chat}
				}
							}
              edit(q.inline_message_id,'`⛔️Sorry, currently the system of choice is disabled⛔️`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('silentlistusers') then
                           local chat = '-'..q.data:match('(%d+)$')
						  local list = redis:smembers(SUDO..'mutes'..chat)
          local t = '🔇لیست کاربران سکوت شده👇 \n\n'
          for k,v in pairs(list) do
          t = t..k.." - _"..v.."_\n"
          end
          t = t..'\nبرای مشاهده کاربر از دستور زیر استفاده کنید 👇\n/whois [آیدی کاربر]\nمثال 👇\n /whois 234458457'
          if #list == 0 then
          t = '🔇هیچ کاربری در لیست سکوت وجود ندارد❌'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔇پاکسازی لیست سکوت❌', callback_data = 'removesilentlist:'..chat}
				   },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('showusersmutelist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'silentlistusers:'..chat}
				}
							}
              edit(q.inline_message_id,'`⛔️Sorry, currently the system of choice is disabled⛔️`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('filterlistword') then
                           local chat = '-'..q.data:match('(%d+)$')
						   local list = redis:smembers(SUDO..'filters:'..chat)
          local t = '📝کلمات فیلتر شده👇 \n\n'
          for k,v in pairs(list) do
          t = t..k.." - _"..v.."_\n"
          end
          if #list == 0 then
          t = '📝لیست کلمات فیلتر شده خالی است❌'
          end
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '📝پاکسازی فیلتر لیست❌', callback_data = 'removefilterword:'..chat}
				   },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'groupinfo:'..chat}
				}
							}
              edit(q.inline_message_id, ''..t..'',keyboard)
            end
							--########################################################################--
							if q.data:match('removemanagers') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر❌', callback_data = 'bgdbdfddhdfhdyumrurmtu:'..chat},{text = '✅بله✅', callback_data = 'hjwebrjb53j5bjh3:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'managerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️آیا از انجام این عملیات مطمین هستید❓',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('hjwebrjb53j5bjh3') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del(SUDO..'mods:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات با موفقیت انجام شد✅',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('bgdbdfddhdfhdyumrurmtu') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات لغو شد🚫',keyboard)
            end
						--########################################################################--
						if q.data:match('removeowners') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر❌', callback_data = 'ncxvnfhfherietjbriurti:'..chat},{text = '✅بله✅', callback_data = 'ewwerwerwer4334b5343:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'ownerlist:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️آیا از انجام این عملیات مطمین هستید❓',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ewwerwerwer4334b5343') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'owners:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات با موفقیت انجام شد✅',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ncxvnfhfherietjbriurti') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات لغو شد🚫',keyboard)
            end
							--########################################################################--
							if q.data:match('removerules') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر❌', callback_data = 'as12310fklfkmgfvm:'..chat},{text = '✅بله✅', callback_data = '3kj5g34ky6g34uy:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'showrules:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️آیا از انجام این عملیات مطمین هستید❓',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('3kj5g34ky6g34uy') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'grouprules'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات با موفقیت انجام شد✅',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('as12310fklfkmgfvm') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات لغو شد🚫',keyboard)
            end
							--########################################################################--
							if q.data:match('removegrouplink') then
                           local chat = '-'..q.data:match('(%d+)$')
						   redis:del(SUDO..'grouplink'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'linkgroup:'..chat}
				}
							}
              edit(q.inline_message_id,'🔗لینک گروه با موفقیت حذف شد✅',keyboard)
            end
							--########################################################################--
								if q.data:match('removebanlist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر❌', callback_data = 'sudfewbhwebr9983243:'..chat},{text = '✅بله✅', callback_data = 'erwetrrefgfhfdhretre:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'banlist:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️آیا از انجام این عملیات مطمین هستید❓',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('erwetrrefgfhfdhretre') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'banned'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات با موفقیت انجام شد✅',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('sudfewbhwebr9983243') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات لغو شد🚫',keyboard)
            end
							--########################################################################--
								if q.data:match('removesilentlist') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر❌', callback_data = 'sadopqwejjbkvw90892:'..chat},{text = '✅بله✅', callback_data = 'ncnvdifeqrhbksdgfid47:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'silentlistusers:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️آیا از انجام این عملیات مطمین هستید❓',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ncnvdifeqrhbksdgfid47') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'mutes'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات با موفقیت انجام شد✅',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('sadopqwejjbkvw90892') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات لغو شد🚫',keyboard)
            end
							--########################################################################--
							if q.data:match('removefilterword') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = '❌خیر❌', callback_data = 'ncxvbcusxsokd9374uid:'..chat},{text = '✅بله✅', callback_data = 'erewigfuwebiebfjdskfbdsugf:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'filterlistword:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️آیا از انجام این عملیات مطمین هستید❓',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('erewigfuwebiebfjdskfbdsugf') then
                           local chat = '-'..q.data:match('(%d+)$')
						  redis:del(SUDO..'filters:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات با موفقیت انجام شد✅',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('ncxvbcusxsokd9374uid') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
				}
							}
              edit(q.inline_message_id,'⚜️عملیات لغو شد🚫',keyboard)
            end
							--########################################################################--
							--#####################################################################--
							if q.data:match('salegroup') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
				 {text = 'مدیریت معمولی گروه', callback_data = 'normalmanage:'..chat}
                },{
				{text = 'مدیریت پیشرفته گروه', callback_data = 'promanage:'..chat}
                },{
				{text = 'مدیریت حرفه ای گروه', callback_data = 'herfeiimanage:'..chat}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '🔙 برگشت به منوی قبلی💠', callback_data = 'fahedsale:'..chat}
				}
							}
              edit(q.inline_message_id,'`در این بخش شما میتوانید نسبت به خرید سرویس/طرح جدید اقدام کنید.`\n`سرویس مورد نظر خود را انتخاب کنید:`',keyboard)
            end
			------------------------------------------------------------------------
							if q.data:match('normalmanage') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'طرح ها و تعرفه ها', callback_data = 'tarhvatarefe:'..chat},{text = 'بررسی قابلیت ها', callback_data = 'baresiqabeliyat:'..chat}
                },{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'salegroup:'..chat}
				}
							}
              edit(q.inline_message_id,'`>سرویس انتخابی شما: [مدیریت معمولی گروه].`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('promanage') then
                           local chat = '-'..q.data:match('(%d+)$')
						  --redis:del(SUDO..'filters:'..chat)
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'طرح ها و تعرفه ها', callback_data = 'tarhpro:'..chat},{text = 'بررسی قابلیت ها', callback_data = 'pishrafteberesi:'..chat}
                },{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'salegroup:'..chat}
				}
							}
              edit(q.inline_message_id,'`>سرویس انتخابی شما: [مدیریت پیشرفته گروه].`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							------------------------------------------------------------------------
							if q.data:match('herfeiimanage') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
								{text = 'طرح ها و تعرفه ها', callback_data = 'herfetarh:'..chat},{text = 'بررسی قابلیت ها', callback_data = 'qabeliyarherfeii:'..chat}
                },{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'salegroup:'..chat}
				}
							}
              edit(q.inline_message_id,'`>سرویس انتخابی شما: [مدیریت حرفه ای گروه].`\n`از منوی زیر انتخاب کنید:`',keyboard)
            end
							--********************************************************************--
							if q.data:match('tarhpro') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'promanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`قیمت طرح های مربوط به این ربات:`\n`ماهانه(30 الی 31 روز کامل)` >  *14900*\n`سالانه(365 روز کامل)` > *34000*\n`دائمی/مادام العمر(نامحدود روز)` > *45000*\n`تمامی قیمت ها به` تومان `میباشد.`',keyboard)
            end
			------------@@@@@@@@@@@@@@@@@@@@@@@@@@------------------
			if q.data:match('tarhvatarefe') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'normalmanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`قیمت طرح های مربوط به این ربات:`\n`ماهانه(30 الی 31 روز کامل)` >  *9900*\n`سالانه(365 روز کامل)` > *23000*\n`دائمی/مادام العمر(نامحدود روز)` > *35000*\n`تمامی قیمت ها به` تومان `میباشد.`',keyboard)
            end
			------------@@@@@@@@@@@@@@@@@@@@@@@@@@------------------
			if q.data:match('herfetarh') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'herfeiimanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`قیمت طرح های مربوط به این ربات:`\n`ماهانه(30 الی 31 روز کامل)` >  *16900*\n`سالانه(365 روز کامل)` > *37500*\n`دائمی/مادام العمر(نامحدود روز)` > *49000*\n`تمامی قیمت ها به` تومان `میباشد.`',keyboard)
            end
							----------------------------------بررسی قابلیت ها--------------------------------------
							if q.data:match('pishrafteberesi') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'promanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`بررسی قابلیت های این سرویس:`\nشرح قابلیت ها: (سرعت بالا در انجام دستورات و موارد تنظیم شده برای گروه خود--دقت در انجام دستورات داده شده: 100%--رابط کاربری فوق العاده و دارای قابلیت و متود های جدید تلگرام(توضیحات بیشتر در پست های بالا موجود میباشد.))',keyboard)
            end
							--********************************************************************--
							if q.data:match('baresiqabeliyat') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙 Back', callback_data = 'normalmanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`بررسی قابلیت های این سرویس:`\nشرح قابلیت ها: (سرعت پایین تر نسبت به ربات بالا(به دلیل زیاد شدن آمار گروه های فعال ربات--عمر ربات: 26 ماه)--دقت در انجام دستورات داده شده: 96%--رابط کاربری فوق العاده و دارای قابلیت های پیشرفته و نسبتا جدید)',keyboard)
            end
							--********************************************************************--
							if q.data:match('qabeliyarherfeii') then
                           local chat = '-'..q.data:match('(%d+)$')
		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                   {text = '🔙 Back To Menu', callback_data = 'firstmenu:'..chat},{text = '🔙Back', callback_data = 'herfeiimanage:'..chat}
				}
							}
              edit(q.inline_message_id,'`بررسی قابلیت های این سرویس:`\nشرح قابلیت ها: (سرعت بالا در انجام دستورات و موارد تنظیم شده برای گروه خود--دقت در انجام دستورات داده شده: 100%--رابط کاربری فوق العاده و دارای قابلیت و متود های جدید تلگرام(توضیحات بیشتر در پست های بالا موجود + مدیریت حرفه ای(دارای پنل مدیریتی خودکار و بدون نیاز به ارسال دستور!)',keyboard)
            end
							--********************************************************************--
							--********************************************************************--
							--********************************************************************--
							------------------------------------------------------------------------
							if q.data:match('groupsettings') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end

local function getsettings(value)
       if value == "charge" then
	   local exp = tonumber(redis:get('bot:charge:'..chat))
                if exp == 0 then
				exp_dat = 'Unlimited'
				        return exp_dat
				else
			local now = tonumber(os.time())
      if not now then 
      now = 0 
      end
      if not exp then
      exp = 0
      end
			exp_dat = (math.floor((tonumber(exp) - tonumber(now)) / 86400) + 1)   
        return exp_dat.."Day"	
end
elseif value == 'muteall' then
				local h = redis:ttl(SUDO..'muteall'..chat)
          if h == -1 then
        return '🔒 قفل 🚫'
				elseif h == -2 then
        return '🔓 آزاد ⭕️'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
					local hash = redis:get(SUDO..'status:welcome:'..chat)
        if hash == 'enable' then
         return 'فعال'
          else
          return 'غیرفعال'
          end
        elseif value == 'spam' then
       local hash = redis:get(SUDO..'settings:flood'..chat)
        if hash then
            if redis:get(SUDO..'settings:flood'..chat) == 'kick' then
         return '❎اخراج❎'
             elseif redis:get(SUDO..'settings:flood'..chat) == 'ban' then
              return '❌مسدود❌'
               elseif redis:get(SUDO..'settings:flood'..chat) == 'mute' then
              return '🔇سکوت🔇'
              end
          else
          return '🔓 آزاد ⭕️'
          end
		  
		          elseif value == 'warn' then
       local hash = redis:hget("warn:settings:"..chat ,"swarn")
        if hash then
            if redis:hget("warn:settings:"..chat ,"swarn") == 'kick' then
         return '❎اخراج❎'
             elseif redis:hget("warn:settings:"..chat ,"swarn") == 'ban' then
              return '❌مسدود❌'
               elseif redis:hget("warn:settings:"..chat ,"swarn") == 'mute' then
              return '🔇سکوت🔇'
              end
          else
          return '🔓 آزاد ⭕️'
          end
        elseif is_lock(chat,value) then
          return '🔒 قفل 🚫'
          else
          return '🔓 آزاد ⭕️'
          end
        end
              local keyboard = {}
            	keyboard.inline_keyboard = {
	            	{
                {text=getsettings('photo'),callback_data=chat..':lock photo'}, {text = '⬅️ تصاویر 🌆', callback_data = chat..'_photo'}
                },{
                 {text=getsettings('video'),callback_data=chat..':lock video'}, {text = '⬅️ فیلم 🎥', callback_data = chat..'_video'}
                },{
                 {text=getsettings('audio'),callback_data=chat..':lock audio'}, {text = '⬅️  صدا 🎤', callback_data = chat..'_audio'}
                },{
                 {text=getsettings('gif'),callback_data=chat..':lock gif'}, {text = '⬅️ گیف 🎇', callback_data = chat..'_gif'}
                },{
                 {text=getsettings('music'),callback_data=chat..':lock music'}, {text = '⬅️ موزیک 🎵', callback_data = chat..'_music'}
                },{
                  {text=getsettings('file'),callback_data=chat..':lock file'},{text = '⬅️ فایل 📂', callback_data = chat..'_file'}
                },{
                  {text=getsettings('link'),callback_data=chat..':lock link'},{text = '⬅️ لینک 🌐', callback_data = chat..'_link'}
                },{
                 {text=getsettings('sticker'),callback_data=chat..':lock sticker'}, {text = '⬅️ استیکر 🖼', callback_data = chat..'_sticker'}
                },{
                  {text=getsettings('text'),callback_data=chat..':lock text'},{text = '⬅️ متن 📝', callback_data = chat..'_text'}
                },{
                  {text=getsettings('pin'),callback_data=chat..':lock pin'},{text = '⬅️ پین 🌀', callback_data = chat..'_pin'}
                },{
                 {text=getsettings('username'),callback_data=chat..':lock username'}, {text = '⬅️ یوزنیم 🆔', callback_data = chat..'_username'}
                },{
                  {text=getsettings('contact'),callback_data=chat..':lock contact'},{text = '⬅️ مخاطب 📞', callback_data = chat..'_contact'}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '2️⃣صفحه دوم ➡️', callback_data = 'next_page:'..chat}
                }
              }
            edit(q.inline_message_id,'_⚙️ تنظیمات ⚙️_\n`👈صفحه اول 1️⃣`\n@PVTeaM',keyboard)
            end
			------------------------------------------------------------------------
            if q.data:match('left_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
 end
local function getsettings(value)
       if value == "charge" then
	   local exp = tonumber(redis:get('bot:charge:'..chat))
                if exp == 0 then
				exp_dat = 'Unlimited'
				        return exp_dat
				else
			local now = tonumber(os.time())
      if not now then 
      now = 0 
      end
      if not exp then
      exp = 0
      end
			exp_dat = (math.floor((tonumber(exp) - tonumber(now)) / 86400) + 1)   
        return exp_dat.."Day"	
end
        elseif value == 'spam' then
       local hash = redis:get(SUDO..'settings:flood'..chat)
        if hash then
            if redis:get(SUDO..'settings:flood'..chat) == 'kick' then
         return '❎اخراج❎'
             elseif redis:get(SUDO..'settings:flood'..chat) == 'ban' then
              return '❌مسدود❌'
               elseif redis:get(SUDO..'settings:flood'..chat) == 'mute' then
              return '🔇سکوت🔇'
              end
          else
          return '🔓 آزاد ⭕️'
          end
		  
		          elseif value == 'warn' then
       local hash = redis:hget("warn:settings:"..chat ,"swarn")
        if hash then
            if redis:hget("warn:settings:"..chat ,"swarn") == 'kick' then
         return '❎اخراج❎'
             elseif redis:hget("warn:settings:"..chat ,"swarn") == 'ban' then
              return '❌مسدود❌'
               elseif redis:hget("warn:settings:"..chat ,"swarn") == 'mute' then
              return '🔇سکوت🔇'
              end
          else
          return '🔓 آزاد ⭕️'
          end
        elseif is_lock(chat,value) then
          return '🔒 قفل 🚫'
          else
          return '🔓 آزاد ⭕️'
          end
        end
							local keyboard = {}
							keyboard.inline_keyboard = {
									{
                  {text=getsettings('photo'),callback_data=chat..':lock photo'}, {text = '⬅️ تصاویر 🌆', callback_data = chat..'_photo'}
                },{
                 {text=getsettings('video'),callback_data=chat..':lock video'}, {text = '⬅️ فیلم 🎥', callback_data = chat..'_video'}
                },{
                 {text=getsettings('audio'),callback_data=chat..':lock audio'}, {text = '⬅️  صدا 🎤', callback_data = chat..'_audio'}
                },{
                 {text=getsettings('gif'),callback_data=chat..':lock gif'}, {text = '⬅️ گیف 🎇', callback_data = chat..'_gif'}
                },{
                 {text=getsettings('music'),callback_data=chat..':lock music'}, {text = '⬅️ موزیک 🎵', callback_data = chat..'_music'}
                },{
                  {text=getsettings('file'),callback_data=chat..':lock file'},{text = '⬅️ فایل 📂', callback_data = chat..'_file'}
                },{
                  {text=getsettings('link'),callback_data=chat..':lock link'},{text = '⬅️ لینک 🌐', callback_data = chat..'_link'}
                },{
                 {text=getsettings('sticker'),callback_data=chat..':lock sticker'}, {text = '⬅️ استیکر 🖼', callback_data = chat..'_sticker'}
                },{
                  {text=getsettings('text'),callback_data=chat..':lock text'},{text = '⬅️ متن 📝', callback_data = chat..'_text'}
                },{
                  {text=getsettings('pin'),callback_data=chat..':lock pin'},{text = '⬅️ پین 🌀', callback_data = chat..'_pin'}
                },{
                 {text=getsettings('username'),callback_data=chat..':lock username'}, {text = '⬅️ یوزنیم 🆔', callback_data = chat..'_username'}
                },{
                  {text=getsettings('contact'),callback_data=chat..':lock contact'},{text = '⬅️ مخاطب 📞', callback_data = chat..'_contact'}
                },{
                   {text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat},{text = '2️⃣صفحه دوم ➡️', callback_data = 'next_page:'..chat}
                }
              }
            edit(q.inline_message_id,'_⚙️ تنظیمات ⚙️_\n`👈 برگشتیم به صفحه اول 1 ️⃣`\n@PVTeaM',keyboard)
            end
						if q.data:match('next_page') then
							local chat = '-'..q.data:match('(%d+)$')
							local function is_lock(chat,value)
local hash = SUDO..'settings:'..chat..':'..value
 if redis:get(hash) then
    return true
    else
    return false
    end
  end
local function getsettings(value)
        if value == "charge" then
	   local exp = tonumber(redis:get('bot:charge:'..chat))
                if exp == 0 then
				exp_dat = 'Unlimited'
				        return exp_dat
				else
			local now = tonumber(os.time())
      if not now then 
      now = 0 
      end
      if not exp then
      exp = 0
      end
			exp_dat = (math.floor((tonumber(exp) - tonumber(now)) / 86400) + 1)   
        return exp_dat.."Day"
end
        elseif value == 'muteall' then
        local h = redis:ttl(SUDO..'muteall'..chat)
       if h == -1 then
        return '🔒 قفل 🚫'
    elseif h == -2 then
     return '🔓 آزاد ⭕️'
       else
        return "تا ["..h.."] ثانیه دیگر فعال است"
       end
        elseif value == 'welcome' then
        local hash = redis:get(SUDO..'status:welcome:'..chat)
        if hash == 'enable' then
         return '✅فعال✅'
          else
          return '❌غیر فعال❌'
          end
        elseif value == 'spam' then
       local hash = redis:hget("flooding:settings:"..chat, "flood")
        if hash then
           if redis:hget("flooding:settings:"..chat, "flood") == 'kick' then
         return '❎اخراج❎'
             elseif redis:hget("flooding:settings:"..chat, "flood") == 'ban' then
              return '❌مسدود❌'
              elseif redis:hget("flooding:settings:"..chat, "flood") == 'mute' then
              return '🔇سکوت🔇'
              end
          else
          return '🔓 آزاد ⭕️'
          end
            elseif value == 'warn' then
       local hash = redis:hget("warn:settings:"..chat, "swarn")
        if hash then
           if redis:hget("warn:settings:"..chat, "swarn") == 'kick' then
         return '❎اخراج❎'
             elseif redis:hget("warn:settings:"..chat, "swarn") == 'ban' then
              return '❌مسدود❌'
              elseif redis:hget("warn:settings:"..chat, "swarn") == 'mute' then
              return '🔇سکوت🔇'
              end
          else
          return '🔓 آزاد ⭕️'
          end
    
        elseif is_lock(chat,value) then
          return '🔒 قفل 🚫'
          else
          return '🔓 آزاد ⭕️'
          end
        end
									local MSG_MAX = (redis:hget("flooding:settings:"..chat,"floodmax") or 5)
									local WARN_MAX = (redis:hget("warn:settings:"..chat,"warnmax") or 3)
								local TIME_MAX = (redis:hget("flooding:settings:"..chat,"floodtime") or 3)
         		local keyboard = {}
							keyboard.inline_keyboard = {
								{
                  {text=getsettings('forward'),callback_data=chat..':lock forward'},{text = '⬅️ فروارد 📎', callback_data = chat..'_forward'}
                },{
                  {text=getsettings('bot'),callback_data=chat..':lock bot'},{text = '⬅️ بات 📡', callback_data = chat..'_bot'}
                },{
                  {text=getsettings('game'),callback_data=chat..':lock game'},{text = '⬅️ بازی 👣', callback_data = chat..'_game'}
                },{
                  {text=getsettings('persian'),callback_data=chat..':lock persian'},{text = '⬅️ فارسی 🇹🇯', callback_data = chat..'_persian'}
                },{
                  {text=getsettings('english'),callback_data=chat..':lock english'},{text = '⬅️ انگلیسی 🇬🇧', callback_data = chat..'_english'}
                },{
                  {text=getsettings('keyboard'),callback_data=chat..':lock keyboard'},{text = '⬅️ اینلاین 🔩', callback_data = chat..'_keyboard'}
                },{
                  {text=getsettings('tgservice'),callback_data=chat..':lock tgservice'},{text = '⬅️ پیغام ورود و خروج ⚙️', callback_data = chat..'_tgservice'}
                },{
                 {text=getsettings('muteall'),callback_data=chat..':lock muteall'}, {text = '🔇 چت 🔇', callback_data = chat..'_muteall'}
                },{
                 {text=getsettings('welcome'),callback_data=chat..':lock welcome'}, {text = '✔️ خوش آمدگویی ✔️', callback_data = chat..'_welcome'}
                },{
         {text=getsettings('warn'),callback_data=chat..':lock warn'}, {text = '⬅️ عملکرد اخطار 💠', callback_data = chat..'_warn'}
        },{
          {text = '↙️حداکثر تعداد اخطار↘️ : '..tostring(WARN_MAX)..' wrn', callback_data = chat..'_WARN_MAX'}
                },{
          {text='⬇️',callback_data=chat..':lock WARNMAXdown'},{text='⬆️',callback_data=chat..':lock WARNMAXup'}
                },{
                 {text=getsettings('spam'),callback_data=chat..':lock spam'}, {text = '⬅️ عملکرد اسپم 💠', callback_data = chat..'_spam'}
                },{
                 {text = '↙️حداکثر زمان اسپم↘️ : '..tostring(TIME_MAX)..' Sec', callback_data = chat..'_TIME_MAX'}
                },{
                  {text='⬇️',callback_data=chat..':lock TIMEMAXdown'},{text='⬆️',callback_data=chat..':lock TIMEMAXup'}
                  },{
                 {text = '↗️حداکثر تعداد اسپم↘️ : '..tostring(MSG_MAX)..' Msg', callback_data = chat..'_MSG_MAX'}
                },{
                  {text='⬇️',callback_data=chat..':lock MSGMAXdown'},{text='⬆️',callback_data=chat..':lock MSGMAXup'}
                  },{
                  {text='➰شارژ گروه➰ : '..getsettings('charge'),callback_data=chat..'_charge'}
                },{
                  {text = '🔙 back to one page', callback_data = 'left_page:'..chat},{text = '🌀 back to main menu 🔙', callback_data = 'firstmenu:'..chat}
                }
              }
              edit(q.inline_message_id,'_⚙️ تنظیمات ⚙️_\n`👈صفحه دوم 2 ️⃣`\n@PVTeaM',keyboard)
            end
            else Canswer(q.id,'⚠️Your Not Admin⚠️\n @PVTeaM',true)
						end
						end
          if msg.message and msg.message.date > (os.time() - 5) and msg.message.text then
     end
      end
    end
  end
    end
	end

return run()
