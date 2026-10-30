__AuraFixUtil = __AuraFixUtil or {}
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local MPS = game:GetService("MarketplaceService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local TextService = game:GetService("TextService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local okVU, VU = pcall(game.GetService,
    game,
    "VirtualUser")

local lp = Players.LocalPlayer
local pgui = lp:WaitForChild("PlayerGui")
local genv = (getgenv and getgenv()) or _G
if genv.AuraUnload then pcall(genv.AuraUnload) end
if pgui:FindFirstChild("AuraMenu") then pgui.AuraMenu:Destroy() end
if SoundService:FindFirstChild("AuraSound") then SoundService.AuraSound:Destroy() end
for _, v in ipairs(Lighting:GetChildren()) do
    if v.Name == "AuraBlur" or v.Name == "AuraEnvBloom" or v.Name == "AuraEnvColor"
        or v.Name == "AuraEnvRays" or v.Name == "AuraEnvDOF" or v.Name == "AuraEnvAtmosphere"
        or v.Name == "AuraEnvSky" then
        pcall(function() v:Destroy() end)
    end
end
local oldAuraClouds = workspace:FindFirstChildOfClass("Terrain") and workspace.Terrain:FindFirstChild("AuraEnvClouds")
if oldAuraClouds then pcall(function() oldAuraClouds:Destroy() end) end
local oldAuraAmbient = workspace:FindFirstChild("AuraAmbientFX")
if oldAuraAmbient then pcall(function() oldAuraAmbient:Destroy() end) end

local WIN_W, WIN_H, TOP, SB = 420, 270, 36, 96
local EASE, DIR = Enum.EasingStyle, Enum.EasingDirection
local WHITE = Color3.new(1,
    1,
    1)
local C = {
	bg = Color3.fromRGB(13,
	    13,
	    20),
	    bar = Color3.fromRGB(19,
	    19,
	    28),
	    card = Color3.fromRGB(25,
	    25,
	    37),
	    card2 = Color3.fromRGB(38,
	    38,
	    55),
	    card3 = Color3.fromRGB(31,
	    31,
	    46),
	    border = Color3.fromRGB(73,
	    73,
	    104),
	    text = Color3.fromRGB(238,
	    238,
	    248),
	    sub = Color3.fromRGB(140,
	    140,
	    168),
	    off = Color3.fromRGB(52,
	    52,
	    72),
	    bad = Color3.fromRGB(255,
	    95,
	    105),
	    good = Color3.fromRGB(80,
	    225,
	    140),
	    warn = Color3.fromRGB(255,
	    190,
	    80),
	    softBlue = Color3.fromRGB(95,
	    180,
	    255),
}
local accent = Color3.fromRGB(130,
    100,
    255)
local reg, conns, trReg, ctl = {}, {}, {}, {}
local rainbow, hue = false, 0
local lang = "Русский"
local cfg = {}

local EN = {
	["Музыка"] = "Music",
	    ["Эффекты"] = "Effects",
	    ["Визуал"] = "Visuals",
	    ["Разное"] = "Misc",
	    ["Настройки"] = "Settings",
	    ["ПЛЕЕР"] = "PLAYER",
	    ["Вставьте ID песни"] = "Paste song ID",
	    ["Играть"] = "Play",
	    ["Пауза"] = "Pause",
	    ["Стоп"] = "Stop",
	    ["-10с"] = "-10s",
	    ["+10с"] = "+10s",
	    ["Трек"] = "Track",
	    ["Повтор трека"] = "Repeat track",
	    ["СКОРОСТЬ И ТОНАЛЬНОСТЬ"] = "SPEED & PITCH",
	    ["Скорость"] = "Speed",
	    ["Менять тон со скоростью"] = "Pitch follows speed",
	    ["Тональность"] = "Pitch",
	    ["пт"] = "st",
	    ["ГРОМКОСТЬ"] = "VOLUME",
	    ["Усиление"] = "Gain",
	    ["Сбросить всё"] = "Reset all",
	    ["ПРЕСЕТЫ"] = "PRESETS",
	    ["Сброс"] = "Reset",
	    ["ЭКВАЛАЙЗЕР"] = "EQUALIZER",
	    ["Низкие"] = "Low",
	    ["Средние"] = "Mid",
	    ["Высокие"] = "High",
	    ["ПРОСТРАНСТВО"] = "SPACE",
	    ["Реверберация"] = "Reverb",
	    ["Эхо"] = "Echo",
	    ["Клуб"] = "Club",
	    ["Кино"] = "Cinematic",
	    ["Радио"] = "Radio",
	    ["Тёплый"] = "Warm",
	    ["Яркий звук"] = "Bright Sound",
	    ["Больше пространства"] = "Wide Space",
	    ["Эхо-задержка"] = "Echo delay",
	    ["Обратная связь эха"] = "Echo feedback",
	    ["Длина реверберации"] = "Reverb decay",
	    ["Сброс аудио"] = "Reset audio",
	    ["ВЫРАЗИТЕЛЬНОСТЬ ЗВУКА"] = "SOUND SHAPING",
	    ["НАСТРОЙКИ ПРОСТРАНСТВА"] = "SPACE SETTINGS",
	    ["ОТОБРАЖЕНИЕ"] = "DISPLAY",
	    ["Подсветка игроков"] = "Player highlight",
	    ["Скелет"] = "Skeleton",
	    ["Имена"] = "Names",
	    ["Дистанция"] = "Distance",
	    ["Дальность"] = "Range",
	    ["Стиль"] = "Style",
	    ["Контур"] = "Outline",
	    ["Заливка"] = "Fill",
	    ["Градиент"] = "Gradient",
	    ["ст."] = "studs",
	    ["ОБЩЕЕ"] = "GENERAL",
	    ["Анти-АФК"] = "Anti-AFK",
	    ["Показывать FPS"] = "Show FPS",
	    ["Авто-перезаход"] = "Auto rejoin",
	    ["Поле зрения"] = "Field of view",
	    ["Язык"] = "Language",
	    ["Сохранить конфиг"] = "Save config",
	    ["Загрузить конфиг"] = "Load config",
	    ["ЦВЕТ АКЦЕНТА"] = "ACCENT COLOR",
	    ["Оттенок"] = "Hue",
	    ["ОКНО"] = "WINDOW",
	    ["Прозрачность"] = "Transparency",
	    ["Размер меню"] = "Menu size",
	    ["Размытие фона"] = "Background blur",
	    ["Сбросить позицию"] = "Reset position",
	    ["Выгрузить меню"] = "Unload menu",
	    ["Ничего не играет"] = "Nothing playing",
	    ["Введите ID и нажмите «Играть»"] = "Enter an ID and press Play",
	    ["Введите числовой ID"] = "Enter a numeric ID",
	    ["Загрузка..."] = "Loading...",
	    ["Играет"] = "Playing",
	    ["На паузе"] = "Paused",
	    ["Остановлено"] = "Stopped",
	    ["Трек закончился"] = "Track ended",
	    ["Ошибка"] = "Error",
	    ["Не загрузилось: ID закрыт или неверный"] = "Failed to load: ID is private or invalid",
	    ["Трек загружен"] = "Track loaded",
	    ["Не удалось загрузить ID"] = "Could not load ID",
	    ["Пресет: "] = "Preset: ",
	    ["Всё сброшено"] = "Everything reset",
	    ["Акцент изменён"] = "Accent changed",
	    ["Радужный режим"] = "Rainbow mode",
	    ["Радуга выключена"] = "Rainbow off",
	    ["Конфиг сохранён"] = "Config saved",
	    ["Сохранение недоступно"] = "Saving unavailable",
	    ["Конфиг загружен"] = "Config loaded",
	    ["Конфиг не найден"] = "Config not found",
	    ["Переподключение..."] = "Reconnecting...",
	    ["AURA загружено"] = "AURA loaded",
	    ["Найти"] = "Search",
	    ["Поиск..."] = "Searching...",
	    ["Введите хотя бы 2 символа"] = "Enter at least 2 characters",
	    ["Ничего не найдено"] = "No results found",
	    ["Поиск недоступен в этой среде"] = "Search is unavailable here; try an audio ID",
	    ["Пуск / пауза"] = "Play / Pause",
	    ["Ночной"] = "Night",
	    ["Замедленный"] = "Slowed",
	    ["Бас"] = "Bass",
	    ["Золотой час"] = "Golden Hour",
	    ["Ужас"] = "Horror",
	    ["Под водой"] = "Underwater",
	    ["Научная фантастика"] = "Sci-Fi",
	    ["Северное сияние"] = "Aurora",
	    ["Отключить эффекты"] = "Disable effects",
	    ["ВИЗУАЛЬНЫЕ ЭФФЕКТЫ"] = "VISUAL EFFECTS",
	    ["Мягкое свечение и цвет"] = "Soft bloom & color",
	    ["Интенсивность эффекта"] = "Effect intensity",
	    ["ПРЕСЕТЫ ОКРУЖЕНИЯ"] = "ENVIRONMENT PRESETS",
	    ["Толщина скелета"] = "Skeleton thickness",
	    ["Эффект сброшен"] = "Effect reset",
	    ["Активен эффект: "] = "Active effect: ",
	    ["ОЧЕРЕДЬ"] = "QUEUE",
	    ["Очередь пуста"] = "Queue is empty",
	    ["Очередь"] = "Queue",
	    ["В очереди"] = "In queue",
	    ["Очистить очередь"] = "Clear queue",
	    ["Добавить в очередь"] = "Add to queue",
	    ["Играть сейчас"] = "Play now",
	    ["Удалить"] = "Remove",
	    ["Автор неизвестен"] = "Unknown artist",
	    ["ВИЗУАЛЬНЫЙ ESP"] = "VISUAL ESP",
	    ["Рамка игрока"] = "Player box",
	    ["Полоса здоровья"] = "Health bar",
	    ["Трассеры"] = "Tracers",
	    ["Проверка команды"] = "Team check",
	    ["Здоровье в имени"] = "Health in label",
	    ["ЦВЕТ И ПЛАВНОСТЬ"] = "COLOR & SMOOTHNESS",
	    ["Плавность анимаций"] = "Animation smoothness",
	    ["Яркость ESP"] = "ESP brightness",
	    ["Размер подписей"] = "Label size",
	    ["Толщина рамки"] = "Box thickness",
	    ["ИНФОРМАЦИЯ О ПЛЕЕРЕ"] = "PLAYER INFO",
	    ["Треков в очереди"] = "Tracks queued",
	    ["Очередь обновлена"] = "Queue updated",
	    ["Добавлено в очередь"] = "Added to queue",
	    ["Авто-скрытие после выбора"] = "Auto-hide after starting playback",
	    ["Скорость анимаций"] = "Animation speed",
	    ["Сбросить конфиг"] = "Reset settings",
	    ["Всё включить"] = "Enable all",
	    ["Всё скрыть"] = "Hide all",
	    ["Уже в очереди"] = "Already queued",
	    ["Список очищен"] = "List cleared",
	    ["ОКРУЖЕНИЕ"] = "ENVIRONMENT",
	    ["Мягкое свечение"] = "Soft bloom",
	    ["Сила свечения"] = "Bloom strength",
	    ["Цветовой стиль"] = "Color style",
	    ["Солнечные лучи"] = "Sun rays",
	    ["Кино"] = "Cinematic",
	    ["Яркий"] = "Vivid",
	    ["Микшер"] = "Mixer",
	    ["Быстрые настройки"] = "Quick controls",
	    ["Тихо"] = "Quiet",
	    ["Обычный"] = "Normal",
	    ["Громко"] = "Loud",
	    ["Максимум"] = "Maximum",
	    ["Сменить трек"] = "Change track",
	    ["Отмена"] = "Cancel",
	    ["Включено"] = "Enabled",
	    ["Выключено"] = "Disabled",
	    ["БЫСТРЫЕ НАСТРОЙКИ"] = "QUICK SETTINGS",
	    ["ВИЗУАЛИЗАТОР"] = "VISUALIZER",
	    ["Пульсация акцента"] = "Accent pulse",
	    ["Авто-очередь"] = "Auto queue",
	    ["Исходный вид"] = "Original look",
	    ["Кинематограф"] = "Cinematic",
	    ["Неоновые сумерки"] = "Neon Dusk",
	    ["Лавандовый сон"] = "Lavender Dream",
	    ["Изумрудный туман"] = "Emerald Mist",
	    ["Кристальный лёд"] = "Crystal Ice",
	    ["Призматическая аврора"] = "Prismatic Aurora",
	    ["Эффекты окружения"] = "ENVIRONMENT EFFECTS",
	    ["Плавные переходы"] = "Smooth transitions",
	    ["Эффекты отключены"] = "Effects disabled",
	    ["Поиск недоступен в этой среде"] = "Search is unavailable in this client; enter an audio ID",
		    ["Помощь"] = "Help",
	    ["ESP"] = "ESP",
	    ["Напиши вопрос..."] = "Ask a question...",
	    ["Отправить"] = "Send",
		    ["Локально + веб-поиск"] = "Local + web lookup",
    ["Код / Luau"] = "Code / Luau",
    ["Помощь"] = "Help",
	    ["Спросить о функции"] = "Ask about a feature",
	    ["Примеры вопросов"] = "Example questions",
	    ["Очистить чат"] = "Clear chat",
	    ["Свернуть"] = "Minimize",
	    ["Закрыть"] = "Close",
}


-- Spanish localization: any legacy key not listed here falls back to English,
-- so the interface never abruptly switches back to Russian while Español is active.
local ES = {
    ["Музыка"]="Música",
        ["Эффекты"]="Efectos",
        ["Визуал"]="Visuales",
        ["Разное"]="Varios",
        ["Настройки"]="Ajustes",
        ["ПЛЕЕР"]="REPRODUCTOR",
        ["Вставьте ID песни"]="Introduce el ID de la canción",
        ["Играть"]="Reproducir",
        ["Пауза"]="Pausar",
        ["Стоп"]="Detener",
        ["-10с"]="-10 s",
        ["+10с"]="+10 s",
        ["Трек"]="Pista",
        ["Повтор трека"]="Repetir pista",
        ["СКОРОСТЬ И ТОНАЛЬНОСТЬ"]="VELOCIDAD Y TONO",
        ["Скорость"]="Velocidad",
        ["Менять тон со скоростью"]="Cambiar tono con la velocidad",
        ["Тональность"]="Tono",
        ["пт"]="st",
        ["ГРОМКОСТЬ"]="VOLUMEN",
        ["Усиление"]="Ganancia",
        ["Сбросить всё"]="Restablecer todo",
        ["ПРЕСЕТЫ"]="PREAJUSTES",
        ["Сброс"]="Restablecer",
        ["ЭКВАЛАЙЗЕР"]="ECUALIZADOR",
        ["Низкие"]="Graves",
        ["Средние"]="Medios",
        ["Высокие"]="Agudos",
        ["ПРОСТРАНСТВО"]="ESPACIO",
        ["Реверберация"]="Reverberación",
        ["Эхо"]="Eco",
        ["Клуб"]="Club",
        ["Кино"]="Cine",
        ["Радио"]="Radio",
        ["Тёплый"]="Cálido",
        ["Яркий звук"]="Sonido brillante",
        ["Больше пространства"]="Más amplitud",
        ["Эхо-задержка"]="Retardo del eco",
        ["Обратная связь эха"]="Realimentación del eco",
        ["Длина реверберации"]="Duración de reverberación",
        ["Сброс аудио"]="Restablecer audio",
        ["ВЫРАЗИТЕЛЬНОСТЬ ЗВУКА"]="MOLDEADO DEL SONIDO",
        ["НАСТРОЙКИ ПРОСТРАНСТВА"]="AJUSTES ESPACIALES",
        ["ОТОБРАЖЕНИЕ"]="VISUALIZACIÓN",
        ["Подсветка игроков"]="Resaltar jugadores",
        ["Скелет"]="Esqueleto",
        ["Имена"]="Nombres",
        ["Дистанция"]="Distancia",
        ["Дальность"]="Alcance",
        ["Стиль"]="Estilo",
        ["Контур"]="Contorno",
        ["Заливка"]="Relleno",
        ["Градиент"]="Degradado",
        ["ст."]="studs",
        ["ОБЩЕЕ"]="GENERAL",
        ["Анти-АФК"]="Anti-AFK",
        ["Показывать FPS"]="Mostrar FPS",
        ["Авто-перезаход"]="Reconexión automática",
        ["Поле зрения"]="Campo de visión",
        ["Язык"]="Idioma",
        ["Сохранить конфиг"]="Guardar configuración",
        ["Загрузить конфиг"]="Cargar configuración",
        ["ЦВЕТ АКЦЕНТА"]="COLOR DE ACENTO",
        ["Оттенок"]="Tono de color",
        ["ОКНО"]="VENTANA",
        ["Прозрачность"]="Transparencia",
        ["Размер меню"]="Tamaño del menú",
        ["Размытие фона"]="Desenfoque del fondo",
        ["Сбросить позицию"]="Restablecer posición",
        ["Выгрузить меню"]="Cerrar menú",
        ["Ничего не играет"]="No se está reproduciendo nada",
        ["Введите ID и нажмите «Играть»"]="Introduce un ID y pulsa Reproducir",
        ["Введите числовой ID"]="Introduce un ID numérico",
        ["Загрузка..."]="Cargando...",
        ["Играет"]="Reproduciendo",
        ["На паузе"]="En pausa",
        ["Остановлено"]="Detenido",
        ["Трек закончился"]="La pista terminó",
        ["Ошибка"]="Error",
        ["Не загрузилось: ID закрыт или неверный"]="No se pudo cargar: ID privado o no válido",
        ["Трек загружен"]="Pista cargada",
        ["Не удалось загрузить ID"]="No se pudo cargar el ID",
        ["Пресет: "]="Preajuste: ",
        ["Всё сброшено"]="Todo restablecido",
        ["Акцент изменён"]="Acento cambiado",
        ["Радужный режим"]="Modo arcoíris",
        ["Радуга выключена"]="Arcoíris desactivado",
        ["Конфиг сохранён"]="Configuración guardada",
        ["Сохранение недоступно"]="Guardado no disponible",
        ["Конфиг загружен"]="Configuración cargada",
        ["Конфиг не найден"]="No se encontró la configuración",
        ["Переподключение..."]="Reconectando...",
        ["AURA загружено"]="AURA cargado",
        ["Найти"]="Buscar",
        ["Поиск..."]="Buscando...",
        ["Введите хотя бы 2 символа"]="Introduce al menos 2 caracteres",
        ["Ничего не найдено"]="No se encontraron resultados",
        ["Поиск недоступен в этой среде"]="La búsqueda no está disponible aquí; introduce un ID de audio",
        ["Пуск / пауза"]="Reproducir / pausar",
        ["Ночной"]="Nocturno",
        ["Замедленный"]="Ralentizado",
        ["Бас"]="Graves",
        ["Золотой час"]="Hora dorada",
        ["Ужас"]="Terror",
        ["Под водой"]="Bajo el agua",
        ["Научная фантастика"]="Ciencia ficción",
        ["Северное сияние"]="Aurora boreal",
        ["Отключить эффекты"]="Desactivar efectos",
        ["ВИЗУАЛЬНЫЕ ЭФФЕКТЫ"]="EFECTOS VISUALES",
        ["Мягкое свечение и цвет"]="Brillo suave y color",
        ["Интенсивность эффекта"]="Intensidad del efecto",
        ["ПРЕСЕТЫ ОКРУЖЕНИЯ"]="PREAJUSTES DEL ENTORNO",
        ["Толщина скелета"]="Grosor del esqueleto",
        ["Эффект сброшен"]="Efecto restablecido",
        ["Активен эффект: "]="Efecto activo: ",
        ["ОЧЕРЕДЬ"]="COLA",
        ["Очередь пуста"]="La cola está vacía",
        ["Очередь"]="Cola",
        ["В очереди"]="En la cola",
        ["Очистить очередь"]="Vaciar cola",
        ["Добавить в очередь"]="Añadir a la cola",
        ["Играть сейчас"]="Reproducir ahora",
        ["Удалить"]="Eliminar",
        ["Автор неизвестен"]="Artista desconocido",
        ["ВИЗУАЛЬНЫЙ ESP"]="ESP VISUAL",
        ["Рамка игрока"]="Caja del jugador",
        ["Полоса здоровья"]="Barra de salud",
        ["Трассеры"]="Trazadores",
        ["Проверка команды"]="Comprobar equipo",
        ["Здоровье в имени"]="Salud en la etiqueta",
        ["ЦВЕТ И ПЛАВНОСТЬ"]="COLOR Y SUAVIDAD",
        ["Плавность анимаций"]="Suavidad de animación",
        ["Яркость ESP"]="Brillo del ESP",
        ["Размер подписей"]="Tamaño de etiquetas",
        ["Толщина рамки"]="Grosor de caja",
        ["ИНФОРМАЦИЯ О ПЛЕЕРЕ"]="INFORMACIÓN DEL JUGADOR",
        ["Треков в очереди"]="Pistas en la cola",
        ["Очередь обновлена"]="Cola actualizada",
        ["Добавлено в очередь"]="Añadido a la cola",
        ["Авто-скрытие после выбора"]="Ocultar automáticamente al iniciar",
        ["Скорость анимаций"]="Velocidad de animación",
        ["Сбросить конфиг"]="Restablecer ajustes",
        ["Всё включить"]="Activar todo",
        ["Всё скрыть"]="Ocultar todo",
        ["Уже в очереди"]="Ya está en la cola",
        ["Список очищен"]="Lista vaciada",
        ["ОКРУЖЕНИЕ"]="ENTORNO",
        ["Мягкое свечение"]="Brillo suave",
        ["Сила свечения"]="Intensidad del brillo",
        ["Цветовой стиль"]="Estilo de color",
        ["Солнечные лучи"]="Rayos solares",
        ["Яркий"]="Intenso",
        ["Микшер"]="Mezclador",
        ["Быстрые настройки"]="Controles rápidos",
        ["Тихо"]="Bajo",
        ["Обычный"]="Normal",
        ["Громко"]="Alto",
        ["Максимум"]="Máximo",
        ["Сменить трек"]="Cambiar pista",
        ["Отмена"]="Cancelar",
        ["Включено"]="Activado",
        ["Выключено"]="Desactivado",
        ["БЫСТРЫЕ НАСТРОЙКИ"]="AJUSTES RÁPIDOS",
        ["ВИЗУАЛИЗАТОР"]="VISUALIZADOR",
        ["Пульсация акцента"]="Pulso del acento",
        ["Авто-очередь"]="Cola automática",
        ["Исходный вид"]="Aspecto original",
        ["Кинематограф"]="Cinematográfico",
        ["Неоновые сумерки"]="Crepúsculo neón",
        ["Лавандовый сон"]="Sueño lavanda",
        ["Изумрудный туман"]="Niebla esmeralda",
        ["Кристальный лёд"]="Hielo cristalino",
        ["Призматическая аврора"]="Aurora prismática",
        ["Эффекты окружения"]="EFECTOS DEL ENTORNO",
        ["Плавные переходы"]="Transiciones suaves",
        ["Эффекты отключены"]="Efectos desactivados",
        ["Сила реверберации"]="Intensidad de reverberación",
        ["Мягкий"]="Suave",
        ["Пики"]="Picos",
        ["Спектр"]="Espectro",
        ["Помощь"]="Ayuda",
        ["ESP"]="ESP",
        ["Напиши вопрос..."]="Escribe una pregunta...",
        ["Отправить"]="Enviar",
        ["Локально + веб-поиск"]="Modo local + búsqueda web",
        ["Код / Luau"]="Código / Luau",
        ["Спросить о функции"]="Pregunta por una función",
        ["Примеры вопросов"]="Ejemplos de preguntas",
        ["Очистить чат"]="Borrar chat",
        ["Свернуть"]="Minimizar",
        ["Закрыть"]="Cerrar",
}

local function T(s)
    if lang == "English" then return EN[s] or s end
    if lang == "Español" then return ES[s] or EN[s] or s end
    return s
end

local function bind(o, s, prop)
	prop = prop or "Text"
	o[prop] = T(s)
	trReg[#trReg + 1] = function() o[prop] = T(s) end
end

local function setLang(i)
	lang = i == 2 and "English" or (i == 3 and "Español" or "Русский")
	cfg.lang = i
    pcall(__AuraFixUtil.saveCfg)
	for _, f in ipairs(trReg) do f() end
	for _, o in pairs(ctl) do if o.Refresh then o.Refresh() end end
end

local function cn(sig, fn)
	local c = sig:Connect(fn)
	conns[#conns + 1] = c
	return c
end

function __AuraFix_tw(o,
    p,
    t,
    st,
    dr)
	local speed = 1
	local duration = math.max(.06,
	    ((t or .2) / speed) * 1.42)
	__AuraFix_activeTweens = __AuraFix_activeTweens or setmetatable({},
	    {__mode = "k"})
	local records = __AuraFix_activeTweens[o]
	if not records then records = {}; __AuraFix_activeTweens[o] = records end
	for i = #records, 1, -1 do
		local rec, overlap = records[i], false
		for property in pairs(p) do if rec.props[property] then overlap = true; break end end
		if overlap then table.remove(records,
		    i); pcall(function() rec.tween:Cancel() end) end
	end
	local tween = TS:Create(o,
	    TweenInfo.new(duration,
	    st or EASE.Quint,
	    dr or DIR.Out),
	    p)
	local record = {tween = tween,
	    props = p}
	records[#records + 1] = record
	tween.Completed:Connect(function()
		local current = __AuraFix_activeTweens and __AuraFix_activeTweens[o]
		if current then
			for i = #current, 1, -1 do if current[i] == record then table.remove(current, i) end end
			if #current == 0 then __AuraFix_activeTweens[o] = nil end
		end
	end)
	tween:Play()
	return tween
end
local tw = __AuraFix_tw

local lo = 0
function __AuraFixUtil.new(class,
    props,
    parent)
	local o = Instance.new(class)
	if o:IsA("GuiObject") then o.BorderSizePixel = 0 end
	if class == "UIListLayout" then o.SortOrder = Enum.SortOrder.LayoutOrder end
	for k, v in pairs(props) do o[k] = v end
	if parent then
		if o:IsA("GuiObject") and parent:FindFirstChildOfClass("UIListLayout") then lo += 1; o.LayoutOrder = lo end
		o.Parent = parent
	end
	return o
end

function __AuraFixUtil.round(o,
    r) __AuraFixUtil.new("UICorner",
    {CornerRadius = UDim.new(0,
    r or 8)},
    o) end
function __AuraFixUtil.stroke(p,
    th,
    col,
    tr)
	return __AuraFixUtil.new("UIStroke",
	    {Thickness = th,
	    Color = col,
	    Transparency = tr,
	    ApplyStrokeMode = Enum.ApplyStrokeMode.Border},
	    p)
end
function __AuraFixUtil.isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end

function __AuraFixUtil.acc(o,
    prop,
    get)
	get = get or function() return accent end
	o[prop] = get()
	reg[#reg + 1] = function(instant)
		if instant then o[prop] = get() else tw(o,
		    {[prop] = get()},
		    .35) end
	end
end

function __AuraFixUtil.light(c) return c:Lerp(WHITE,
    .65) end
function __AuraFixUtil.dark(c) return c:Lerp(Color3.new(0,
    0,
    0),
    .8) end
function __AuraFixUtil.shift(c)
	local h, s, v = c:ToHSV()
	return Color3.fromHSV((h + .18) % 1,
	    s,
	    v)
end
function __AuraFixUtil.loop(o,
    props,
    t)
	TS:Create(o,
	    TweenInfo.new(t,
	    EASE.Linear,
	    DIR.InOut,
	    -1),
	    props):Play()
end

function __AuraFixUtil.grad(parent,
    mk,
    props)
	local g = __AuraFixUtil.new("UIGradient",
	    props or {},
	    parent)
	g.Color = mk()
	reg[#reg + 1] = function() g.Color = mk() end
	return g
end

function __AuraFixUtil.lbl(parent,
    text,
    size,
    color,
    extra)
	local p = {BackgroundTransparency = 1,
	    TextSize = size or 13,
	    TextColor3 = color or C.text,
	    Font = Enum.Font.GothamMedium,
	    TextXAlignment = Enum.TextXAlignment.Left,
	    Size = UDim2.fromScale(1,
	    1),
	    TextTruncate = Enum.TextTruncate.AtEnd}
	for k, v in pairs(extra or {}) do p[k] = v end
	local o = __AuraFixUtil.new("TextLabel",
	    p,
	    parent)
	if text ~= "" then bind(o,
	    text) end
	return o
end

function __AuraFixUtil.press(b,
    flat)
	local s = __AuraFixUtil.new("UIScale",
	    {Name = "Pop"},
	    b)
	b.ClipsDescendants = true
	local cr = b:FindFirstChildOfClass("UICorner")
	local ov = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    BackgroundTransparency = 1,
	    Size = UDim2.fromScale(1,
	    1),
	    ZIndex = 4},
	    b)
	if cr then __AuraFixUtil.new("UICorner",
	    {CornerRadius = cr.CornerRadius},
	    ov) end
	cn(b.MouseEnter,
	    function()
		tw(ov,
		    {BackgroundTransparency = .88},
		    .18,
		    EASE.Sine)
		if not flat then tw(s,
		    {Scale = 1.025},
		    .18,
		    EASE.Quad) end
	end)
	cn(b.MouseLeave,
	    function()
		tw(ov,
		    {BackgroundTransparency = 1},
		    .24,
		    EASE.Sine)
		if not flat then tw(s,
		    {Scale = 1},
		    .2,
		    EASE.Quad) end
	end)
	cn(b.InputBegan,
	    function(i)
		if not __AuraFixUtil.isPress(i) then return end
		tw(s,
		    {Scale = .94},
		    .09,
		    EASE.Quad)
		local sz = b.AbsoluteSize
		if flat or sz.X < 1 then return end
		local k = math.max(sz.X,
		    sz.Y) * 2.2
		local rp = __AuraFixUtil.new("Frame",
		    {BackgroundColor3 = WHITE,
		    BackgroundTransparency = .75,
		    AnchorPoint = Vector2.new(.5,
		    .5),
		    Position = UDim2.fromScale((i.Position.X - b.AbsolutePosition.X) / sz.X,
		    (i.Position.Y - b.AbsolutePosition.Y) / sz.Y),
		    Size = UDim2.fromOffset(0,
		    0),
		    ZIndex = 5},
		    b)
		__AuraFixUtil.round(rp,
		    200)
		tw(rp,
		    {Size = UDim2.fromOffset(k,
		    k),
		    BackgroundTransparency = 1},
		    .55).Completed:Connect(function() rp:Destroy() end)
	end)
	cn(b.InputEnded,
	    function(i) if __AuraFixUtil.isPress(i) then tw(s,
	    {Scale = 1},
	    .24,
	    EASE.Back) end end)
end

local CFG_FILE = "AuraMenu.json"
function __AuraFixUtil.loadCfg()
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CFG_FILE)) end)
	if ok and type(data) == "table" then cfg = data return true end
	return false
end
function __AuraFixUtil.saveCfg()
	return pcall(function() writefile(CFG_FILE,
	    HttpService:JSONEncode(cfg)) end)
end
__AuraFixUtil.loadCfg()
if type(cfg.accent) == "table" and cfg.accent[3] then accent = Color3.new(cfg.accent[1],
    cfg.accent[2],
    cfg.accent[3]) end
rainbow = cfg.rainbow == true
lang = cfg.lang == 2 and "English" or (cfg.lang == 3 and "Español" or "Русский")

local gui = __AuraFixUtil.new("ScreenGui",
    {Name = "AuraMenu",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 100},
    pgui)

-- Fixed dark palette; accent color remains user-adjustable in Settings.
local blur = __AuraFixUtil.new("BlurEffect",
    {Name = "AuraBlur",
    Size = 0},
    Lighting)
local blurOn = true
local skelLayer = __AuraFixUtil.new("Frame",
    {Name = "ESP",
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1,
    1)},
    gui)

local toastF, toastToken = nil, 0
function __AuraFixUtil.toast(message,
    col)
    local messageText = tostring(T(message) or message or "")
    toastToken += 1
    local myToken = toastToken
    if toastF and toastF.Parent then pcall(function() toastF:Destroy() end) end
    local camera = workspace.CurrentCamera
    local maxWidth = math.max(180,
        math.min(460,
        (camera and camera.ViewportSize.X or 520) - 24))
    local measured = TextService:GetTextSize(messageText,
        14,
        Enum.Font.GothamMedium,
        Vector2.new(maxWidth - 56,
        80))
    local width = math.clamp(measured.X + 58,
        180,
        maxWidth)
    local height = math.clamp(measured.Y + 20,
        42,
        76)
    local f = __AuraFixUtil.new("TextLabel",
        {
        Name = "AuraToast",
            AnchorPoint = Vector2.new(.5,
            0),
            Position = UDim2.new(.5,
            0,
            0,
            -height - 8),
            Size = UDim2.fromOffset(width,
            height),
            BackgroundColor3 = C.bar,
            BackgroundTransparency = .04,
            BorderSizePixel = 0,
            Text = messageText,
            TextColor3 = C.text,
            TextSize = 14,
            Font = Enum.Font.GothamMedium,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.None,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 250,
            Visible = true,
            },
            gui)
    toastF = f
    __AuraFixUtil.round(f,
        14)
    __AuraFixUtil.stroke(f,
        1.5,
        col or accent,
        .12)
    local scale = __AuraFixUtil.new("UIScale",
        {Scale = .92},
        f)
    TS:Create(f,
        TweenInfo.new(.32,
        EASE.Quint,
        DIR.Out),
        {Position = UDim2.new(.5,
        0,
        0,
        14)}):Play()
    TS:Create(scale,
        TweenInfo.new(.34,
        EASE.Back,
        DIR.Out),
        {Scale = 1}):Play()
    task.delay(2.8,
        function()
        if f.Parent and myToken == toastToken then
            TS:Create(f,
                TweenInfo.new(.28,
                EASE.Quint,
                DIR.In),
                {Position = UDim2.new(.5,
                0,
                0,
                -height - 8),
                TextTransparency = 1,
                BackgroundTransparency = 1}):Play()
            task.delay(.32,
                function() if f.Parent then f:Destroy() end; if toastF == f then toastF = nil end end)
        end
    end)
end

function __AuraFixUtil.drag(handle,
    target,
    bounds)
	local st = {moved = false}
	local active, inp, origin, start
	local function settle()
		active = false
		local windowMotion = target:FindFirstChild("MainWindow")
		if windowMotion then tw(windowMotion,
		    {Rotation = 0},
		    .34,
		    EASE.Back,
		    DIR.Out) end
	end
	cn(handle.InputBegan,
	    function(i)
		if __AuraFixUtil.isPress(i) then
			active,
			    inp,
			    origin,
			    start,
			    st.moved = true,
			    i,
			    i.Position,
			    target.Position,
			    false
			local windowMotion = target:FindFirstChild("MainWindow")
			if windowMotion then tw(windowMotion,
			    {Rotation = 0},
			    .12,
			    EASE.Sine,
			    DIR.Out) end
			i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then settle() end end)
		end
	end)
	cn(UIS.InputChanged,
	    function(i)
		if active and (i == inp or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = i.Position - origin
			if d.Magnitude > 6 then st.moved = true end
			if not st.moved then return end
			local W, H = gui.AbsoluteSize.X,
			    gui.AbsoluteSize.Y
			local x0, x1, y0, y1 = bounds(W,
			    H)
			local nx = math.clamp(start.X.Scale * W + start.X.Offset + d.X,
			    x0,
			    x1) - start.X.Scale * W
			local ny = math.clamp(start.Y.Scale * H + start.Y.Offset + d.Y,
			    y0,
			    y1) - start.Y.Scale * H
			tw(target,
			    {Position = UDim2.new(start.X.Scale,
			    nx,
			    start.Y.Scale,
			    ny)},
			    .075,
			    EASE.Quart,
			    DIR.Out)
			local windowMotion = target:FindFirstChild("MainWindow")
			if windowMotion then tw(windowMotion,
			    {Rotation = math.clamp(d.X / 28,
			    -3.5,
			    3.5)},
			    .11,
			    EASE.Sine,
			    DIR.Out) end
		end
	end)
	return st
end

local cam0 = workspace.CurrentCamera
local vp = cam0 and cam0.ViewportSize or Vector2.new(800,
    400)
if vp.Y < 150 then vp = Vector2.new(800,
    400) end
local baseScale = math.clamp(math.min((vp.Y - 40) / WIN_H,
    (vp.X - 16) / WIN_W),
    .52,
    1)
local baseGT, opened, openTok = 0, false, 0
local startPos = UDim2.new(.5,
    0,
    0,
    math.max(6,
    (vp.Y - WIN_H * baseScale) / 2))

local holder = __AuraFixUtil.new("Frame",
    {Name = "Holder",
    Size = UDim2.fromOffset(WIN_W,
    WIN_H),
    AnchorPoint = Vector2.new(.5,
    0),
    Position = startPos,
    BackgroundTransparency = 1},
    gui)
local main = __AuraFixUtil.new("CanvasGroup",
    {Name = "MainWindow",
    AnchorPoint = Vector2.new(.5,
    0),
    Position = UDim2.fromScale(.5,
    0),
    Size = UDim2.fromScale(1,
    1),
    BackgroundColor3 = C.bg,
    GroupTransparency = 1,
    Visible = false,
    ClipsDescendants = true},
    holder)
__AuraFixUtil.round(main,
    12)
local mscale = __AuraFixUtil.new("UIScale",
    {Scale = baseScale},
    main)
local mstroke = __AuraFixUtil.stroke(main,
    2,
    WHITE,
    .15)
__AuraFixUtil.loop(__AuraFixUtil.grad(mstroke,
    function() return ColorSequence.new({ColorSequenceKeypoint.new(0,
    accent),
    ColorSequenceKeypoint.new(.5,
    __AuraFixUtil.dark(accent)),
    ColorSequenceKeypoint.new(1,
    accent)}) end),
    {Rotation = 360},
    5)

local tint = __AuraFixUtil.new("Frame",
    {Size = UDim2.fromScale(1,
    1)},
    main)
__AuraFixUtil.acc(tint,
    "BackgroundColor3")
__AuraFixUtil.new("UIGradient",
    {Rotation = 90,
    Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,
    .88),
    NumberSequenceKeypoint.new(1,
    1)})},
    tint)

for k = 1, 2 do
	local o = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(.5,
	    .5),
	    Size = UDim2.fromOffset(220,
	    220),
	    BackgroundTransparency = .93,
	    Position = UDim2.fromScale(k == 1 and .1 or .95,
	    k == 1 and .05 or .98)},
	    main)
	__AuraFixUtil.round(o,
	    110); __AuraFixUtil.acc(o,
	    "BackgroundColor3")
	TS:Create(o,
	    TweenInfo.new(7 + k * 2,
	    EASE.Sine,
	    DIR.InOut,
	    -1,
	    true),
	    {Position = UDim2.fromScale(k == 1 and .3 or .75,
	    k == 1 and .25 or .8),
	    BackgroundTransparency = .97}):Play()
end

for _ = 1, 14 do
	local sz, d = math.random(3,
	    6), math.random(60,
	    120) / 10
	local pt = __AuraFixUtil.new("Frame",
	    {BackgroundTransparency = .9,
	    Size = UDim2.fromOffset(sz,
	    sz),
	    AnchorPoint = Vector2.new(.5,
	    .5),
	    Position = UDim2.fromScale(math.random(),
	    1.05)},
	    main)
	__AuraFixUtil.round(pt,
	    3); __AuraFixUtil.acc(pt,
	    "BackgroundColor3")
	TS:Create(pt,
	    TweenInfo.new(d,
	    EASE.Linear,
	    DIR.Out,
	    -1),
	    {Position = UDim2.fromScale(math.random(),
	    -.05)}):Play()
	TS:Create(pt,
	    TweenInfo.new(d / 2,
	    EASE.Sine,
	    DIR.InOut,
	    -1,
	    true),
	    {BackgroundTransparency = .55}):Play()
end

local top = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1,
    0,
    0,
    TOP),
    BackgroundColor3 = C.bar},
    main)
local title = __AuraFixUtil.lbl(top,
    "AURA",
    16,
    WHITE,
    {Position = UDim2.fromOffset(12,
    0),
    Size = UDim2.fromOffset(56,
    TOP),
    Font = Enum.Font.GothamBlack})
__AuraFixUtil.loop(__AuraFixUtil.grad(title,
    function() return ColorSequence.new({ColorSequenceKeypoint.new(0,
    accent),
    ColorSequenceKeypoint.new(.5,
    __AuraFixUtil.light(accent)),
    ColorSequenceKeypoint.new(1,
    accent)}) end,
    {Offset = Vector2.new(-.5,
    0)}),
    {Offset = Vector2.new(.5,
    0)},
    1.8)
local line = __AuraFixUtil.new("Frame",
    {Position = UDim2.new(0,
    0,
    1,
    -2),
    Size = UDim2.new(1,
    0,
    0,
    2)},
    top)
__AuraFixUtil.acc(line,
    "BackgroundColor3")
__AuraFixUtil.loop(__AuraFixUtil.new("UIGradient",
    {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,
    .9),
    NumberSequenceKeypoint.new(.5,
    0),
    NumberSequenceKeypoint.new(1,
    .9)}),
    Offset = Vector2.new(-1,
    0)},
    line),
    {Offset = Vector2.new(1,
    0)},
    2.2)

local mini = {}
local miniF = __AuraFixUtil.new("Frame",
    {BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1,
    .5),
    Position = UDim2.new(1,
    -84,
    .5,
    0),
    Size = UDim2.fromOffset(16,
    12)},
    top)
for k = 1, 3 do
	local b = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(0,
	    1),
	    Position = UDim2.new(0,
	    (k - 1) * 6,
	    1,
	    0),
	    Size = UDim2.fromOffset(4,
	    3)},
	    miniF)
	__AuraFixUtil.round(b,
	    2); __AuraFixUtil.acc(b,
	    "BackgroundColor3")
	mini[k] = {f = b,
	    h = 3}
end

function __AuraFixUtil.topBtn(txt,
    n)
	local b = __AuraFixUtil.new("TextButton",
	    {Text = txt,
	    Font = Enum.Font.GothamBold,
	    TextSize = 16,
	    TextColor3 = C.text,
	    AutoButtonColor = false,
	    BackgroundColor3 = C.card2,
	    Size = UDim2.fromOffset(28,
	    22),
	    AnchorPoint = Vector2.new(1,
	    .5),
	    Position = UDim2.new(1,
	    -8 - (n - 1) * 34,
	    .5,
	    -1)},
	    top)
	__AuraFixUtil.round(b,
	    6); __AuraFixUtil.press(b)
	return b
end
local closeB, colB = __AuraFixUtil.topBtn("×",
    1), __AuraFixUtil.topBtn("–",
    2)
cn(closeB.MouseEnter,
    function() tw(closeB,
    {BackgroundColor3 = C.bad},
    .2) end)
cn(closeB.MouseLeave,
    function() tw(closeB,
    {BackgroundColor3 = C.card2},
    .25) end)

__AuraFixUtil.drag(top,
    holder,
    function(W,
    H) return 40,
    W - 40,
    0,
    H - 40 end)

local side = __AuraFixUtil.new("Frame",
    {Position = UDim2.fromOffset(6,
    TOP + 8),
    Size = UDim2.new(0,
    SB,
    1,
    -TOP - 14),
    BackgroundTransparency = 1},
    main)
local sideDivider = __AuraFixUtil.new("Frame",
    {Position = UDim2.fromOffset(SB + 7,
    TOP + 14),
    Size = UDim2.new(0,
    1,
    1,
    -TOP - 28),
    BackgroundColor3 = WHITE,
    BackgroundTransparency = .92},
    main)
local CPOS = UDim2.fromOffset(SB + 12,
    TOP + 8)
local content = __AuraFixUtil.new("CanvasGroup",
    {Position = CPOS,
    Size = UDim2.new(1,
    -SB - 18,
    1,
    -TOP - 14),
    BackgroundTransparency = 1},
    main)
local isCollapsed, collapseToken = false, 0
local fullMainSize = UDim2.fromScale(1,
    1)
local collapsedMainSize = UDim2.new(1,
    0,
    0,
    TOP)

function __AuraFixUtil.setOpen(v)
    if opened == v then return end
    opened = v; openTok += 1
    local my = openTok
    local resting = UDim2.fromScale(.5,
        0)
    if v then
        if isCollapsed then
            isCollapsed = false
            collapseToken += 1
            colB.Text = "–"
            main.Size = fullMainSize
            content.Visible = true
            content.GroupTransparency = 0
            side.Visible = true
            sideDivider.Visible = true
        end
        main.Visible = true
        main.Position = resting + UDim2.fromOffset(0,
            22)
        main.Rotation = -2.2
        main.GroupTransparency = 1
        mscale.Scale = baseScale * .82
        tw(blur,
            {Size = blurOn and 13 or 0},
            .72,
            EASE.Sine)
        tw(main,
            {GroupTransparency = baseGT,
            Position = resting,
            Rotation = 0},
            .68,
            EASE.Quint,
            DIR.Out)
        tw(mscale,
            {Scale = baseScale},
            .72,
            EASE.Back,
            DIR.Out)
    else
        tw(main,
            {GroupTransparency = 1,
            Position = resting + UDim2.fromOffset(0,
            22),
            Rotation = 2.2},
            .46,
            EASE.Quint,
            DIR.In)
        tw(blur,
            {Size = 0},
            .48,
            EASE.Sine)
        tw(mscale,
            {Scale = baseScale * .86},
            .46,
            EASE.Quint,
            DIR.In)
        task.delay(.48,
            function() if openTok == my then main.Visible = false; main.Rotation = 0 end end)
    end
end
cn(closeB.Activated,
    function() __AuraFixUtil.setOpen(false) end)

-- The minus button minimizes the window to its title bar; it does not close it.
local function setCollapsed(value)
    if isCollapsed == value then return end
    isCollapsed = value
    collapseToken += 1
    local token = collapseToken
    colB.Text = value and "+" or "–"
    if value then
        -- Fade the content slightly before clipping it to the title bar.
        tw(content,
            {GroupTransparency = 1},
            .14,
            EASE.Sine)
        tw(main,
            {Size = collapsedMainSize},
            .32,
            EASE.Quint,
            DIR.Out)
        task.delay(.16,
            function()
            if collapseToken == token and isCollapsed then
                content.Visible = false
                side.Visible = false
                sideDivider.Visible = false
            end
        end)
    else
        content.Visible = true
        side.Visible = true
        sideDivider.Visible = true
        content.GroupTransparency = 1
        tw(main,
            {Size = fullMainSize},
            .38,
            EASE.Back,
            DIR.Out)
        tw(content,
            {GroupTransparency = 0},
            .3,
            EASE.Quint,
            DIR.Out)
    end
end
cn(colB.Activated,
    function()
    if not opened then return end
    setCollapsed(not isCollapsed)
end)

local fab = __AuraFixUtil.new("TextButton",
    {Text = "A",
    Font = Enum.Font.GothamBlack,
    TextSize = 20,
    TextColor3 = WHITE,
    AutoButtonColor = false,
    Size = UDim2.fromOffset(46,
    46),
    Position = UDim2.new(0,
    14,
    .5,
    -23)},
    gui)
__AuraFixUtil.round(fab,
    23); __AuraFixUtil.acc(fab,
    "BackgroundColor3"); __AuraFixUtil.press(fab,
    true)
local fs = __AuraFixUtil.stroke(fab,
    2,
    accent,
    .5); __AuraFixUtil.acc(fs,
    "Color")
TS:Create(fs,
    TweenInfo.new(1.4,
    EASE.Sine,
    DIR.InOut,
    -1,
    true),
    {Thickness = 6,
    Transparency = .9}):Play()
local fabDrag = __AuraFixUtil.drag(fab,
    fab,
    function(W,
    H) return 0,
    W - 46,
    0,
    H - 46 end)
cn(fab.Activated,
    function()
	if fabDrag.moved then return end
	__AuraFixUtil.setOpen(not opened)
	tw(fab,
	    {Rotation = fab.Rotation + 360},
	    .7,
	    EASE.Back)
end)

local cols = {Color3.fromRGB(130,
    100,
    255),
    Color3.fromRGB(0,
    200,
    255),
    Color3.fromRGB(255,
    85,
    150),
    Color3.fromRGB(60,
    220,
    130),
    Color3.fromRGB(255,
    160,
    50),
    Color3.fromRGB(255,
    75,
    85)}
local swb = {}
function __AuraFixUtil.mark(idx)
	for k, b in pairs(swb) do tw(b.S,
	    {Transparency = k == idx and 0 or 1},
	    .25) end
end
function __AuraFixUtil.setAccent(col,
    idx,
    instant)
	accent = col
	cfg.accent = {col.R,
	    col.G,
	    col.B}
	for _, f in ipairs(reg) do f(instant) end
	__AuraFixUtil.mark(idx)
end

function __AuraFixUtil.card(p,
    h)
	local f = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1,
	    0,
	    0,
	    h),
	    BackgroundColor3 = C.card},
	    p)
	__AuraFixUtil.round(f,
	    8)
	return f, __AuraFixUtil.stroke(f,
	    1,
	    WHITE,
	    .93)
end

function __AuraFixUtil.hov(b,
    f,
    st)
	cn(b.MouseEnter,
	    function() tw(st,
	    {Transparency = .75},
	    .2); tw(f,
	    {BackgroundColor3 = C.card:Lerp(WHITE,
	    .035)},
	    .2) end)
	cn(b.MouseLeave,
	    function() tw(st,
	    {Transparency = .93},
	    .25); tw(f,
	    {BackgroundColor3 = C.card},
	    .25) end)
end

function __AuraFixUtil.section(p,
    text)
	local f = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1,
	    0,
	    0,
	    18),
	    BackgroundTransparency = 1},
	    p)
	local bar = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(0,
	    .5),
	    Position = UDim2.new(0,
	    1,
	    .5,
	    1),
	    Size = UDim2.fromOffset(3,
	    10)},
	    f)
	__AuraFixUtil.round(bar,
	    2); __AuraFixUtil.acc(bar,
	    "BackgroundColor3")
	__AuraFixUtil.lbl(f,
	    text,
	    11,
	    C.sub,
	    {Position = UDim2.fromOffset(10,
	    0),
	    Size = UDim2.new(1,
	    -10,
	    1,
	    0),
	    Font = Enum.Font.GothamBold})
	return f
end

function __AuraFixUtil.row(p,
    h)
	local f = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1,
	    0,
	    0,
	    h),
	    BackgroundTransparency = 1},
	    p)
	__AuraFixUtil.new("UIListLayout",
	    {FillDirection = Enum.FillDirection.Horizontal,
	    Padding = UDim.new(0,
	    6)},
	    f)
	return f
end

function __AuraFixUtil.button(p,
    text,
    cb,
    primary,
    size)
	local b = __AuraFixUtil.new("TextButton",
	    {Font = Enum.Font.GothamBold,
	    TextSize = 13,
	    TextColor3 = C.text,
	    AutoButtonColor = false,
	    BackgroundColor3 = C.card2,
	    Size = size or UDim2.new(1,
	    0,
	    0,
	    32)},
	    p)
	bind(b,
	    text)
	__AuraFixUtil.round(b,
	    8); __AuraFixUtil.press(b)
	if primary then __AuraFixUtil.acc(b,
	    "BackgroundColor3") end
	if cb then cn(b.Activated,
	    cb) end
	return b
end

function __AuraFixUtil.toggle(p,
    text,
    def,
    cb,
    key)
	local originalDef = def and true or false
	local f, st = __AuraFixUtil.card(p,
	    36)
	__AuraFixUtil.lbl(f,
	    text,
	    13,
	    nil,
	    {Position = UDim2.fromOffset(10,
	    0),
	    Size = UDim2.new(1,
	    -60,
	    1,
	    0)})
	local b = __AuraFixUtil.new("TextButton",
	    {Text = "",
	    AutoButtonColor = false,
	    BackgroundTransparency = 1,
	    Size = UDim2.fromScale(1,
	    1)},
	    f)
	local fromCfg = key and cfg[key] ~= nil
	local on = def and true or false
	if fromCfg then on = cfg[key] and true or false end
	local sw = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(1,
	    .5),
	    Position = UDim2.new(1,
	    -10,
	    .5,
	    0),
	    Size = UDim2.fromOffset(38,
	    20)},
	    f)
	__AuraFixUtil.round(sw,
	    10)
	__AuraFixUtil.acc(sw,
	    "BackgroundColor3",
	    function() return on and accent or C.off end)
	local knob = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    AnchorPoint = Vector2.new(0,
	    .5),
	    Size = UDim2.fromOffset(14,
	    14),
	    Position = UDim2.new(0,
	    3,
	    .5,
	    0)},
	    sw)
	__AuraFixUtil.round(knob,
	    7)
	local held = false
	local function place(fast)
		local w = held and 18 or 14
		local props = {Size = UDim2.fromOffset(w,
		    14),
		    Position = UDim2.new(0,
		    on and 35 - w or 3,
		    .5,
		    0)}
		if fast then for k, v in pairs(props) do knob[k] = v end else tw(knob,
		    props,
		    .3,
		    EASE.Back) end
	end
	place(true)
	local obj = {Default = originalDef}
	function obj.Set(v,
	    silent)
		on = v and true or false
		if key then cfg[key] = on end
		tw(sw,
		    {BackgroundColor3 = on and accent or C.off},
		    .2)
		place()
		if not silent and cb then cb(on) end
	end
	cn(b.InputBegan,
	    function(i) if __AuraFixUtil.isPress(i) then held = true; place() end end)
	cn(b.InputEnded,
	    function(i) if __AuraFixUtil.isPress(i) then held = false; place() end end)
	cn(b.Activated,
	    function() obj.Set(not on) end)
	__AuraFixUtil.hov(b,
	    f,
	    st)
	if key then ctl[key] = obj; cfg[key] = on end
	if fromCfg and cb then cb(on) end
	return obj
end

function __AuraFixUtil.slider(p,
    text,
    min,
    max,
    def,
    fmt,
    cb,
    step,
    key,
    commit)
	local originalDef = def
	local f, st = __AuraFixUtil.card(p,
	    50)
	__AuraFixUtil.lbl(f,
	    text,
	    13,
	    nil,
	    {Position = UDim2.fromOffset(10,
	    5),
	    Size = UDim2.new(1,
	    -90,
	    0,
	    20)})
	local val = __AuraFixUtil.lbl(f,
	    "",
	    12,
	    C.sub,
	    {AnchorPoint = Vector2.new(1,
	    0),
	    Position = UDim2.new(1,
	    -10,
	    0,
	    5),
	    Size = UDim2.fromOffset(76,
	    20),
	    TextXAlignment = Enum.TextXAlignment.Right})
	local hit = __AuraFixUtil.new("TextButton",
	    {Text = "",
	    AutoButtonColor = false,
	    BackgroundTransparency = 1,
	    Position = UDim2.fromOffset(0,
	    26),
	    Size = UDim2.new(1,
	    0,
	    0,
	    24)},
	    f)
	local track = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = C.card2,
	    AnchorPoint = Vector2.new(0,
	    .5),
	    Position = UDim2.new(0,
	    10,
	    .5,
	    0),
	    Size = UDim2.new(1,
	    -20,
	    0,
	    6)},
	    hit)
	__AuraFixUtil.round(track,
	    3)
	local fill = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    Size = UDim2.fromScale(0,
	    1)},
	    track)
	__AuraFixUtil.round(fill,
	    3)
	__AuraFixUtil.grad(fill,
	    function() return ColorSequence.new(accent:Lerp(Color3.new(0,
	    0,
	    0),
	    .3),
	    accent) end)
	local knob = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    AnchorPoint = Vector2.new(.5,
	    .5),
	    Size = UDim2.fromOffset(14,
	    14),
	    Position = UDim2.fromScale(0,
	    .5),
	    ZIndex = 2},
	    track)
	__AuraFixUtil.round(knob,
	    7)
	local ks = __AuraFixUtil.stroke(knob,
	    0,
	    accent,
	    .55); __AuraFixUtil.acc(ks,
	    "Color")
	local fromCfg = key and cfg[key] ~= nil
	if fromCfg then def = cfg[key] end
	local obj = {Label = val,
	    Dragging = false,
	    Default = originalDef}
	local cur = def
	local function set(v, silent, instant)
		v = math.clamp(v,
		    min,
		    max)
		if step then v = math.floor(v / step + .5) * step end
		cur = v
		if key then cfg[key] = v end
		local a = (v - min) / (max - min)
		if instant then
			fill.Size = UDim2.fromScale(a,
			    1); knob.Position = UDim2.fromScale(a,
			    .5)
		else
			tw(fill,
			    {Size = UDim2.fromScale(a,
			    1)},
			    .12,
			    EASE.Quad)
			tw(knob,
			    {Position = UDim2.fromScale(a,
			    .5)},
			    .12,
			    EASE.Quad)
		end
		local s = fmt and fmt(v) or tostring(v)
		if val.Text ~= s then val.Text = s end
		if not silent and cb and not (commit and obj.Dragging) then cb(v) end
	end
	local function fromX(x)
		set(min + (max - min) * math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X,
		    0,
		    1))
	end
	cn(hit.InputBegan,
	    function(i)
		if not __AuraFixUtil.isPress(i) then return end
		obj.Dragging = true
		local sf = f:FindFirstAncestorOfClass("ScrollingFrame")
		if sf then sf.ScrollingEnabled = false end
		fromX(i.Position.X)
		tw(knob,
		    {Size = UDim2.fromOffset(19,
		    19)},
		    .15); tw(ks,
		    {Thickness = 5},
		    .2); tw(val,
		    {TextColor3 = accent},
		    .15)
		local conn
		conn = UIS.InputChanged:Connect(function(c)
			if c == i or c.UserInputType == Enum.UserInputType.MouseMovement then fromX(c.Position.X) end
		end)
		i.Changed:Connect(function()
			if i.UserInputState == Enum.UserInputState.End then
				conn:Disconnect(); obj.Dragging = false
				if sf then sf.ScrollingEnabled = true end
				if commit and cb then cb(cur) end
				tw(knob,
				    {Size = UDim2.fromOffset(14,
				    14)},
				    .25,
				    EASE.Back); tw(ks,
				    {Thickness = 0},
				    .3); tw(val,
				    {TextColor3 = C.sub},
				    .3)
			end
		end)
	end)
	__AuraFixUtil.hov(hit,
	    f,
	    st)
	obj.Set = set
	function obj.Refresh() set(cur,
	    true,
	    true) end
	set(def,
	    not fromCfg,
	    true)
	if key then ctl[key] = obj end
	return obj
end

function __AuraFixUtil.segment(p,
    text,
    opts,
    cb,
    def,
    key)
	local originalDef = def or 1
	local f, st = __AuraFixUtil.card(p,
	    36)
	__AuraFixUtil.lbl(f,
	    text,
	    13,
	    nil,
	    {Position = UDim2.fromOffset(10,
	    0),
	    Size = UDim2.new(.34,
	    -10,
	    1,
	    0)})
	local seg = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = C.card2,
	    AnchorPoint = Vector2.new(1,
	    .5),
	    Position = UDim2.new(1,
	    -8,
	    .5,
	    0),
	    Size = UDim2.new(.66,
	    -12,
	    0,
	    24)},
	    f)
	__AuraFixUtil.round(seg,
	    6)
	local n = #opts
	local ind = __AuraFixUtil.new("Frame",
	    {Size = UDim2.new(1 / n,
	    -4,
	    1,
	    -4),
	    Position = UDim2.new(0,
	    2,
	    0,
	    2)},
	    seg)
	__AuraFixUtil.round(ind,
	    5); __AuraFixUtil.acc(ind,
	    "BackgroundColor3")
	local btns, cur = {}, 1
	local obj = {Default = originalDef}
	function obj.Set(i,
	    silent,
	    fast)
		i = math.clamp(math.floor(i + .5),
		    1,
		    n)
		cur = i
		if key then cfg[key] = i end
		local pos = UDim2.new((i - 1) / n,
		    2,
		    0,
		    2)
		if fast then ind.Position = pos else tw(ind,
		    {Position = pos},
		    .35,
		    EASE.Back) end
		for k, b in ipairs(btns) do
			local c = k == i and WHITE or C.sub
			if fast then b.TextColor3 = c else tw(b,
			    {TextColor3 = c},
			    .2) end
		end
		if not silent and cb then cb(i) end
	end
	for k, o in ipairs(opts) do
		local b = __AuraFixUtil.new("TextButton",
		    {Font = Enum.Font.GothamBold,
		    TextSize = n > 2 and 10 or 11,
		    TextColor3 = C.sub,
		    BackgroundTransparency = 1,
		    AutoButtonColor = false,
		    Position = UDim2.fromScale((k - 1) / n,
		    0),
		    Size = UDim2.fromScale(1 / n,
		    1),
		    ZIndex = 2},
		    seg)
		bind(b,
		    o)
		btns[k] = b
		cn(b.Activated,
		    function() if cur ~= k then obj.Set(k) end end)
		cn(b.MouseEnter,
		    function() tw(st,
		    {Transparency = .75},
		    .2) end)
		cn(b.MouseLeave,
		    function() tw(st,
		    {Transparency = .93},
		    .25) end)
	end
	local fromCfg = key and cfg[key] ~= nil
	obj.Set(fromCfg and cfg[key] or def or 1,
	    not fromCfg,
	    true)
	if key then ctl[key] = obj end
	return obj
end

local pages, order = {}, {"Музыка",
    "Эффекты",
    "Визуал",
    "Разное",
    "Настройки"}
function __AuraFixUtil.page(name)
	local p = __AuraFixUtil.new("ScrollingFrame",
	    {Name = name,
	    Size = UDim2.fromScale(1,
	    1),
	    BackgroundTransparency = 1,
	    ScrollBarThickness = 3,
	    CanvasSize = UDim2.new(),
	    AutomaticCanvasSize = Enum.AutomaticSize.Y,
	    ScrollingDirection = Enum.ScrollingDirection.Y,
	    Visible = false,
	    ScrollBarImageTransparency = .3},
	    content)
	__AuraFixUtil.new("UIListLayout",
	    {Padding = UDim.new(0,
	    6)},
	    p)
	__AuraFixUtil.new("UIPadding",
	    {PaddingRight = UDim.new(0,
	    6),
	    PaddingBottom = UDim.new(0,
	    6),
	    PaddingTop = UDim.new(0,
	    2)},
	    p)
	__AuraFixUtil.acc(p,
	    "ScrollBarImageColor3")
	pages[name] = p
	return p
end

function __AuraFixUtil.fmtT(s) s = math.floor(s); return string.format("%d:%02d",
    s // 60,
    s % 60) end

local sound = __AuraFixUtil.new("Sound",
    {Name = "AuraSound",
    Volume = 1},
    SoundService)
local pitch = __AuraFixUtil.new("PitchShiftSoundEffect",
    {Octave = 1,
    Enabled = false},
    sound)
local eq = __AuraFixUtil.new("EqualizerSoundEffect",
    {LowGain = 0,
    MidGain = 0,
    HighGain = 0},
    sound)
local reverb = __AuraFixUtil.new("ReverbSoundEffect",
    {Enabled = false,
    DecayTime = 2.8,
    DryLevel = -2,
    WetLevel = -4},
    sound)
local echo = __AuraFixUtil.new("EchoSoundEffect",
    {Enabled = false,
    Delay = .35,
    Feedback = .45,
    DryLevel = 0,
    WetLevel = -6},
    sound)

local S = {speed = 1,
    semi = 0,
    tape = true,
    db = 0}
function __AuraFixUtil.applyAudio()
	sound.PlaybackSpeed = S.speed
	local target = 2 ^ (S.semi / 12) * (S.tape and S.speed or 1)
	local oct = math.clamp(target / S.speed,
	    .5,
	    2)
	pitch.Octave = oct
	pitch.Enabled = math.abs(oct - 1) > .001
	sound.Volume = math.min(10 ^ (S.db / 20),
	    10)
end

local nameL, statusL, histBox, box, play
local history, playTok = {}, 0
local knownTitles = {}
local queueItems = {}
local queueList, queueStatus
local queueAutoPlay = true
local visualizerStyle = 1
local musicAccentPulse = true
local touched, trackOK, endedF = false, false, false
function __AuraFixUtil.setStatus(t,
    col)
	statusL.Text = t
	tw(statusL,
	    {TextColor3 = col or C.sub},
	    .25)
end
function __AuraFixUtil.idle()
	if touched then return end
	nameL.Text = T("Ничего не играет")
	__AuraFixUtil.setStatus(T("Введите ID и нажмите «Играть»"))
end

function __AuraFixUtil.addHistory(id)
	local i = table.find(history,
	    id); if i then table.remove(history,
	    i) end
	table.insert(history,
	    1,
	    id); if #history > 3 then table.remove(history) end
	for _, c in ipairs(histBox:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	for _, v in ipairs(history) do
		local b = __AuraFixUtil.new("TextButton",
		    {Text = v,
		    Font = Enum.Font.GothamMedium,
		    TextSize = 11,
		    TextColor3 = C.text,
		    AutoButtonColor = false,
		    BackgroundColor3 = C.card,
		    AutomaticSize = Enum.AutomaticSize.X,
		    Size = UDim2.new(0,
		    0,
		    1,
		    0)},
		    histBox)
		__AuraFixUtil.round(b,
		    6); __AuraFixUtil.press(b)
		__AuraFixUtil.stroke(b,
		    1,
		    WHITE,
		    .9)
		__AuraFixUtil.new("UIPadding",
		    {PaddingLeft = UDim.new(0,
		    8),
		    PaddingRight = UDim.new(0,
		    8)},
		    b)
		local sc = b:FindFirstChild("Pop")
		sc.Scale = .6
		tw(sc,
		    {Scale = 1},
		    .45,
		    EASE.Back)
		cn(b.Activated,
		    function() box.Text = v; play(v) end)
	end
	histBox.Visible = true
end

function play(raw)
	local id = tostring(raw or ""):match("%d+")
	if not id then __AuraFixUtil.setStatus(T("Введите числовой ID"),
	    C.bad) return end
	touched, trackOK, endedF = true, false, false
	playTok += 1
	local my = playTok
	sound:Stop()
	sound.SoundId = "rbxassetid://" .. id
	__AuraFixUtil.applyAudio()
	sound:Play()
	nameL.Text = id
	__AuraFixUtil.setStatus(T("Загрузка..."))
	local t0 = os.clock()
	while my == playTok and not sound.IsLoaded and os.clock() - t0 < 8 do task.wait(.1) end
	if my ~= playTok then return end
	if sound.IsLoaded and sound.TimeLength > 0 then
		local ok, info = pcall(function() return MPS:GetProductInfo(tonumber(id)) end)
		if my ~= playTok then return end
		nameL.Text = (ok and info and info.Name) or knownTitles[id] or id
		knownTitles[id] = nameL.Text
		trackOK = true
		__AuraFixUtil.toast("Трек загружен",
		    C.good)
		__AuraFixUtil.addHistory(id)
	else
		sound:Stop()
		nameL.Text = T("Ошибка")
		__AuraFixUtil.setStatus(T("Не загрузилось: ID закрыт или неверный"),
		    C.bad)
		__AuraFixUtil.toast("Не удалось загрузить ID",
		    C.bad)
	end
end

local V = {
	hl = true,
	    skel = false,
	    names = true,
	    dist = false,
	    range = 250,
	    style = 1,
	    fps = false,
	    box = true,
	    health = true,
	    tracers = false,
	    teamCheck = false,
	    healthText = false,
	    lineWidth = 1.5,
	    skelWidth = 1.5,
	    labelSize = 13,
	    brightness = 1,
}
local esp = {}
local espAny, espWas = true, false
function __AuraFixUtil.refresh()
	-- Team filtering only changes which players are eligible; it is not a draw mode by itself.
	espAny = V.hl or V.skel or V.names or V.dist or V.box or V.health or V.tracers or V.healthText
end

function __AuraFixUtil.mkLine()
	return __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(.5,
	    .5),
	    BackgroundColor3 = accent,
	    Visible = false},
	    skelLayer)
end
function __AuraFixUtil.mkTag()
	local tag = __AuraFixUtil.new("TextLabel",
	    {AnchorPoint = Vector2.new(.5,
	    1),
	    Size = UDim2.fromOffset(180,
	    34),
	    BackgroundTransparency = 1,
	    Text = "",
	    Font = Enum.Font.GothamBold,
	    TextSize = V.labelSize,
	    TextColor3 = WHITE,
	    TextStrokeTransparency = .25,
	    TextStrokeColor3 = Color3.new(0,
	    0,
	    0),
	    TextYAlignment = Enum.TextYAlignment.Bottom,
	    TextXAlignment = Enum.TextXAlignment.Center,
	    Visible = false,
	    RichText = false},
	    skelLayer)
	return tag
end

function __AuraFixUtil.mkBoxLine()
	local line = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(.5,
	    .5),
	    BackgroundColor3 = accent,
	    BackgroundTransparency = 0,
	    Visible = false,
	    ZIndex = 2},
	    skelLayer)
	return line
end

function __AuraFixUtil.mkHealthBack()
	local back = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = Color3.fromRGB(15,
	    15,
	    20),
	    BackgroundTransparency = .1,
	    Visible = false,
	    ZIndex = 2},
	    skelLayer)
	__AuraFixUtil.stroke(back,
	    1,
	    Color3.new(0,
	    0,
	    0),
	    .2)
	return back
end

function __AuraFixUtil.mkTracer()
	return __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(.5,
	    .5),
	    BackgroundColor3 = accent,
	    BackgroundTransparency = .1,
	    Visible = false,
	    ZIndex = 1},
	    skelLayer)
end

function __AuraFixUtil.hideESPExtras(e)
	for _, line in ipairs(e.boxLines or {}) do line.Visible = false end
	if e.healthBack then e.healthBack.Visible = false end
	if e.healthFill then e.healthFill.Visible = false end
	if e.tracer then e.tracer.Visible = false end
	if e.tag then e.tag.Visible = false end
	for _, line in ipairs(e.lines or {}) do line.Visible = false end
	if e.hl then e.hl.Enabled = false end
end

function __AuraFixUtil.setLine(line,
    x1,
    y1,
    x2,
    y2,
    thickness,
    color)
	local dx = x2 - x1
	local dy = y2 - y1
	local length = math.sqrt(dx * dx + dy * dy)
	line.Position = UDim2.fromOffset((x1 + x2) / 2,
	    (y1 + y2) / 2)
	line.Size = UDim2.fromOffset(length,
	    thickness)
	line.Rotation = math.deg(math.atan2(dy,
	    dx))
	line.BackgroundColor3 = color or accent
end

function __AuraFixUtil.colorForHealth(value)
	local h = math.clamp(value,
	    0,
	    1)
	return Color3.fromRGB(255,
	    70,
	    85):Lerp(Color3.fromRGB(70,
	    235,
	    145),
	    h)
end

function __AuraFixUtil.getScreenBounds(char,
    cam)
	local ok, cf, size = pcall(function()
		local cf0, size0 = char:GetBoundingBox()
		return cf0,
		    size0
	end)
	if not ok or not cf or not size then return nil end
	local hx, hy, hz = size.X / 2, size.Y / 2, size.Z / 2
	local points = {
		Vector3.new(-hx,
		    -hy,
		    -hz),
		    Vector3.new(-hx,
		    -hy,
		    hz),
		    Vector3.new(-hx,
		    hy,
		    -hz),
		    Vector3.new(-hx,
		    hy,
		    hz),
		    Vector3.new(hx,
		    -hy,
		    -hz),
		    Vector3.new(hx,
		    -hy,
		    hz),
		    Vector3.new(hx,
		    hy,
		    -hz),
		    Vector3.new(hx,
		    hy,
		    hz),
		    }
	local minX, minY = math.huge, math.huge
	local maxX, maxY = -math.huge, -math.huge
	local visibleCount = 0
	for _, localPoint in ipairs(points) do
		local worldPoint = cf:PointToWorldSpace(localPoint)
		local p2, onScreen = cam:WorldToViewportPoint(worldPoint)
		if p2.Z > 0 then
			visibleCount += 1
			minX = math.min(minX,
			    p2.X)
			minY = math.min(minY,
			    p2.Y)
			maxX = math.max(maxX,
			    p2.X)
			maxY = math.max(maxY,
			    p2.Y)
		end
	end
	if visibleCount < 2 or maxX < 0 or maxY < 0 or minX > cam.ViewportSize.X or minY > cam.ViewportSize.Y then return nil end
	minX = math.clamp(minX,
	    0,
	    cam.ViewportSize.X)
	maxX = math.clamp(maxX,
	    0,
	    cam.ViewportSize.X)
	minY = math.clamp(minY,
	    0,
	    cam.ViewportSize.Y)
	maxY = math.clamp(maxY,
	    0,
	    cam.ViewportSize.Y)
	if maxX - minX < 2 or maxY - minY < 3 then return nil end
	return minX, minY, maxX, maxY
end

function __AuraFixUtil.updateBoxESP(e,
    char,
    hum,
    hrp,
    cam,
    vs,
    distance)
	local x1, y1, x2, y2 = __AuraFixUtil.getScreenBounds(char,
	    cam)
	local canDraw = x1 ~= nil
	if not canDraw then
		for _, line in ipairs(e.boxLines) do line.Visible = false end
		e.healthBack.Visible = false
		e.healthFill.Visible = false
		e.tracer.Visible = false
		return false
	end
	local w = x2 - x1
	local h = y2 - y1
	local col = accent:Lerp(WHITE,
	    (1 - math.clamp(V.brightness,
	    .25,
	    1)) * .15)
	local thick = math.clamp(V.lineWidth,
	    1,
	    4)
	local edgeSpecs = {
		{x1,
		    y1,
		    x2,
		    y1},
		    {x2,
		    y1,
		    x2,
		    y2},
		    {x2,
		    y2,
		    x1,
		    y2},
		    {x1,
		    y2,
		    x1,
		    y1},
		    }
	for i, spec in ipairs(edgeSpecs) do
		local line = e.boxLines[i]
		line.Visible = V.box
		line.BackgroundTransparency = 0
		__AuraFixUtil.setLine(line,
		    spec[1],
		    spec[2],
		    spec[3],
		    spec[4],
		    thick,
		    col)
	end
	local hp = hum and hum.MaxHealth > 0 and math.clamp(hum.Health / hum.MaxHealth,
	    0,
	    1) or 0
	e.healthBack.Visible = V.health
	e.healthFill.Visible = V.health
	if V.health then
		e.healthBack.Position = UDim2.fromOffset(math.max(1,
		    x1 - 6),
		    y1)
		e.healthBack.Size = UDim2.fromOffset(3,
		    h)
		e.healthFill.AnchorPoint = Vector2.new(0,
		    1)
		e.healthFill.Position = UDim2.fromOffset(math.max(1,
		    x1 - 5),
		    y2)
		e.healthFill.Size = UDim2.fromOffset(3,
		    math.max(1,
		    h * hp))
		e.healthFill.BackgroundColor3 = __AuraFixUtil.colorForHealth(hp)
		e.healthFill.Visible = V.health
	end
	e.tracer.Visible = V.tracers
	if V.tracers then
		local sx, sy = vs.X / 2, vs.Y - 2
		local tx, ty = (x1 + x2) / 2, y2
		__AuraFixUtil.setLine(e.tracer,
		    sx,
		    sy,
		    tx,
		    ty,
		    math.clamp(thick,
		    1,
		    2.5),
		    col)
	end
	return true, x1, y1, x2, y2, hp
end

function __AuraFixUtil.buildBones(e,
    char)
    -- Joint-derived links support standard R6/R15 plus most custom rigs.
    local links, seen = {}, {}
    for _, joint in ipairs(char:GetDescendants()) do
        if joint:IsA("Motor6D") then
            local a, b = joint.Part0, joint.Part1
            if a and b and a ~= b and a:IsA("BasePart") and b:IsA("BasePart")
                and a:IsDescendantOf(char) and b:IsDescendantOf(char) then
                local key = a:GetFullName() .. "->" .. b:GetFullName()
                if not seen[key] then
                    seen[key] = true
                    links[#links + 1] = {a = a,
                        b = b}
                end
            end
        end
    end
    -- A name-based fallback covers unusual characters whose joints are not Motor6Ds.
    if #links < 4 then
        links = {}
        local candidates = {
            {"Head",
                "UpperTorso"},
                {"UpperTorso",
                "LowerTorso"},
                {"UpperTorso",
                "LeftUpperArm"},
                {"LeftUpperArm",
                "LeftLowerArm"},
                {"LeftLowerArm",
                "LeftHand"},
                {"UpperTorso",
                "RightUpperArm"},
                {"RightUpperArm",
                "RightLowerArm"},
                {"RightLowerArm",
                "RightHand"},
                {"LowerTorso",
                "LeftUpperLeg"},
                {"LeftUpperLeg",
                "LeftLowerLeg"},
                {"LeftLowerLeg",
                "LeftFoot"},
                {"LowerTorso",
                "RightUpperLeg"},
                {"RightUpperLeg",
                "RightLowerLeg"},
                {"RightLowerLeg",
                "RightFoot"},
                {"Head",
                "Torso"},
                {"Torso",
                "Left Arm"},
                {"Torso",
                "Right Arm"},
                {"Torso",
                "Left Leg"},
                {"Torso",
                "Right Leg"},
                }
        for _, pair in ipairs(candidates) do
            local a, b = char:FindFirstChild(pair[1]), char:FindFirstChild(pair[2])
            if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
                links[#links + 1] = {a = a,
                    b = b}
            end
        end
    end
    e.bones = links
    while #e.lines < #e.bones do
        local line = __AuraFixUtil.mkLine()
        line.ZIndex = 3
        e.lines[#e.lines + 1] = line
    end
end

function __AuraFixUtil.drawSkel(e,
    cam,
    vs,
    char)
    e.lv = true
    for k, line in ipairs(e.lines) do
        local link = e.bones[k]
        local visible = false
        if link and char and char.Parent then
            local aPart, bPart = link.a, link.b
            if aPart and bPart and aPart.Parent and bPart.Parent
                and aPart:IsDescendantOf(char) and bPart:IsDescendantOf(char) then
                local pa = cam:WorldToViewportPoint(aPart.Position)
                local pb = cam:WorldToViewportPoint(bPart.Position)
                if pa.Z > .05 and pb.Z > .05 then
                    local dx, dy = pb.X - pa.X, pb.Y - pa.Y
                    local len = math.sqrt(dx * dx + dy * dy)
                    if len > .5 and len < math.max(vs.X,
                        vs.Y) * 1.5 then
                        line.Position = UDim2.fromOffset((pa.X + pb.X) / 2,
                            (pa.Y + pb.Y) / 2)
                        line.Size = UDim2.fromOffset(len,
                            math.clamp(V.skelWidth or 1.5,
                            1,
                            4))
                        line.Rotation = math.deg(math.atan2(dy,
                            dx))
                        line.BackgroundColor3 = accent:Lerp(WHITE,
                            (1 - math.clamp(V.brightness,
                            .25,
                            1)) * .15)
                        line.BackgroundTransparency = 0
                        visible = true
                    end
                end
            end
        end
        line.Visible = visible
    end
end

function __AuraFixUtil.getCharacterRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("Torso")
        or char.PrimaryPart
end

function __AuraFixUtil.updateESP(t)
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vs = cam.ViewportSize
    local myc = lp.Character
    local mh = __AuraFixUtil.getCharacterRoot(myc)
    local origin = mh and mh.Position or cam.CFrame.Position
    for plr, e in pairs(esp) do
        local char = plr.Character
        local hrp = __AuraFixUtil.getCharacterRoot(char)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local d = hrp and (hrp.Position - origin).Magnitude or math.huge
		local sameTeam = V.teamCheck and lp.Team ~= nil and plr.Team ~= nil and lp.Team == plr.Team
		local alive = hrp ~= nil and hum ~= nil and hum.Health > 0 and d <= V.range and not sameTeam
		local hl = e.hl
		if e.char ~= char then
			e.char = char
			hl.Adornee = char
			hl.Parent = workspace
			e.bchar = nil
		end
		local showHl = V.hl and alive
		hl.Enabled = showHl
		if showHl then
			if V.style == 1 then
				hl.FillColor = accent
				hl.OutlineColor = accent
				hl.FillTransparency = 1
				hl.OutlineTransparency = 0
			elseif V.style == 2 then
				hl.FillColor = accent
				hl.OutlineColor = WHITE
				hl.FillTransparency = .45
				hl.OutlineTransparency = .2
			else
				local k = (math.sin(t * 2.4 + e.ph) + 1) / 2
				hl.FillColor = accent:Lerp(__AuraFixUtil.shift(accent),
				    k)
				hl.OutlineColor = __AuraFixUtil.shift(accent):Lerp(accent,
				    k)
				hl.FillTransparency = .5
				hl.OutlineTransparency = .1
			end
		end
		local boxOK, x1, y1, x2, y2, hp
		if alive and (V.box or V.health or V.tracers) then
			boxOK, x1, y1, x2, y2, hp = __AuraFixUtil.updateBoxESP(e,
			    char,
			    hum,
			    hrp,
			    cam,
			    vs,
			    d)
		else
			for _, line in ipairs(e.boxLines) do line.Visible = false end
			e.healthBack.Visible = false
			e.healthFill.Visible = false
			e.tracer.Visible = false
		end
		local sk = V.skel and alive
		if sk and e.bchar ~= char then
			e.bchar, e.bt = char, t
			__AuraFixUtil.buildBones(e,
			    char)
		end
		if sk then
			__AuraFixUtil.drawSkel(e,
			    cam,
			    vs,
			    char)
		else
			for _, l in ipairs(e.lines) do l.Visible = false end
			e.lv = false
		end
		local tag = e.tag
		if alive and (V.names or V.dist or V.healthText) then
			local head = char:FindFirstChild("Head") or hrp
			local pt = cam:WorldToViewportPoint(head.Position + Vector3.new(0,
			    head.Size.Y / 2 + .6,
			    0))
			if pt.Z > 0 and pt.X >= -80 and pt.X <= vs.X + 80 and pt.Y >= -50 and pt.Y <= vs.Y + 30 then
				local label = V.names and plr.DisplayName or ""
				if V.dist then label = (label ~= "" and label .. "\n" or "") .. string.format("%d %s",
				    math.floor(d),
				    T("ст.")) end
				if V.healthText and hum then label = (label ~= "" and label .. "\n" or "") .. string.format("%d%% HP",
				    math.floor(math.clamp(hum.Health / math.max(hum.MaxHealth,
				    1),
				    0,
				    1) * 100)) end
					tag.Text = label
				tag.TextSize = V.labelSize
				tag.Position = UDim2.fromOffset(pt.X,
				    pt.Y)
				tag.Visible = label ~= ""
			else
				tag.Visible = false
			end
		else
			tag.Visible = false
		end
		if not alive then __AuraFixUtil.hideESPExtras(e) end
	end
end

function __AuraFixUtil.attach(plr)
	if plr == lp or esp[plr] then return end
	local hl = __AuraFixUtil.new("Highlight",
	    {Name = "AuraHL",
	    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	    Enabled = false,
	    FillTransparency = 1,
	    OutlineTransparency = 1},
	    workspace)
	local e = {
		hl = hl,
		    tag = __AuraFixUtil.mkTag(),
		    lines = {},
		    bones = {},
		    bt = 0,
		    ph = math.random() * 6,
		    lv = false,
		    boxLines = {},
		    healthBack = __AuraFixUtil.mkHealthBack(),
		    healthFill = __AuraFixUtil.new("Frame",
		    {BackgroundColor3 = C.good,
		    Visible = false,
		    ZIndex = 3},
		    skelLayer),
		    tracer = __AuraFixUtil.mkTracer(),
		    }
	for _ = 1, 4 do e.boxLines[#e.boxLines + 1] = __AuraFixUtil.mkBoxLine() end
	esp[plr] = e
end

function __AuraFixUtil.detach(plr)
	local e = esp[plr]
	if not e then return end
	e.hl:Destroy()
	e.tag:Destroy()
	for _, l in ipairs(e.lines) do l:Destroy() end
	for _, l in ipairs(e.boxLines) do l:Destroy() end
	e.healthBack:Destroy()
	e.healthFill:Destroy()
	e.tracer:Destroy()
	esp[plr] = nil
end
for _, p in ipairs(Players:GetPlayers()) do __AuraFixUtil.attach(p) end
cn(Players.PlayerAdded,
    __AuraFixUtil.attach)
cn(Players.PlayerRemoving,
    __AuraFixUtil.detach)

local afkOn, rejoinOn, rejoining = true, false, false
local fovT, fovOn = 70, false
cn(lp.Idled,
    function()
	if afkOn and okVU and VU then
		pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end)
	end
end)
function __AuraFixUtil.rejoin()
	if not rejoinOn or rejoining then return end
	rejoining = true
	__AuraFixUtil.toast("Переподключение...")
	task.wait(1)
	local ok = pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,
	    game.JobId,
	    lp) end)
	if not ok then pcall(function() TeleportService:Teleport(game.PlaceId,
	    lp) end) end
	task.delay(8,
	    function() rejoining = false end)
end
cn(GuiService.ErrorMessageChanged,
    function()
	local ok, m = pcall(function() return GuiService:GetErrorMessage() end)
	if rejoinOn and (not ok or m ~= "") then task.spawn(__AuraFixUtil.rejoin) end
end)
cn(TeleportService.TeleportInitFailed,
    function()
	if rejoinOn then task.delay(2,
	    function() pcall(function() TeleportService:Teleport(game.PlaceId,
	    lp) end) end) end
end)

local fpsAura = __AuraFixUtil.new("Frame",
    {Size = UDim2.fromOffset(120,
    34),
    Position = UDim2.new(1,
    -126,
    0,
    6),
    BackgroundColor3 = accent,
    BackgroundTransparency = 1,
    Visible = false,
    ZIndex = 14},
    gui)
__AuraFixUtil.round(fpsAura,
    17)
local fpsAuraScale = __AuraFixUtil.new("UIScale",
    {Scale = .88},
    fpsAura)
local fpsF = __AuraFixUtil.new("Frame",
    {Size = UDim2.fromOffset(112,
    26),
    Position = UDim2.new(1,
    -122,
    0,
    10),
    BackgroundColor3 = C.bar,
    Visible = false,
    ZIndex = 15},
    gui)
__AuraFixUtil.round(fpsF,
    13)
local fpsStroke = __AuraFixUtil.stroke(fpsF,
    1.2,
    accent,
    .38)
local fpsGradient = __AuraFixUtil.new("UIGradient",
    {Rotation = 0,
    Color = ColorSequence.new({ColorSequenceKeypoint.new(0,
    C.bar),
    ColorSequenceKeypoint.new(.5,
    C.card2),
    ColorSequenceKeypoint.new(1,
    C.bar)}),
    Offset = Vector2.new(-1,
    0)},
    fpsF)
__AuraFixUtil.loop(fpsGradient,
    {Offset = Vector2.new(1,
    0)},
    2.7)
local fpsS = __AuraFixUtil.new("UIScale",
    {Scale = .01},
    fpsF)
local fpsD = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(0,
    .5),
    Position = UDim2.new(0,
    10,
    .5,
    0),
    Size = UDim2.fromOffset(8,
    8),
    BackgroundColor3 = C.good,
    ZIndex = 16},
    fpsF)
__AuraFixUtil.round(fpsD,
    4)
local fpsL = __AuraFixUtil.new("TextLabel",
    {BackgroundTransparency = 1,
    Position = UDim2.fromOffset(24,
    0),
    Size = UDim2.new(1,
    -28,
    1,
    0),
    Font = Enum.Font.GothamBold,
    TextSize = 12,
    TextColor3 = C.text,
    TextXAlignment = Enum.TextXAlignment.Left,
    Text = "",
    ZIndex = 16},
    fpsF)
__AuraFixUtil.drag(fpsF,
    fpsF,
    function(W,
    H) return 0,
    W - 112,
    0,
    H - 26 end)
cn(fpsF:GetPropertyChangedSignal("Position"),
    function()
	fpsAura.Position = UDim2.new(fpsF.Position.X.Scale,
	    fpsF.Position.X.Offset - 4,
	    fpsF.Position.Y.Scale,
	    fpsF.Position.Y.Offset - 4)
end)
function __AuraFixUtil.showFps(v)
	if v then
		fpsAura.Visible = true
		fpsF.Visible = true
		fpsAura.BackgroundTransparency = 1
		fpsAuraScale.Scale = .88
		fpsS.Scale = .78
		tw(fpsAura,
		    {BackgroundTransparency = .72},
		    .42,
		    EASE.Sine)
		tw(fpsAuraScale,
		    {Scale = 1},
		    .48,
		    EASE.Back)
		tw(fpsS,
		    {Scale = 1},
		    .48,
		    EASE.Back)
	else
		tw(fpsAura,
		    {BackgroundTransparency = 1},
		    .28,
		    EASE.Sine)
		tw(fpsAuraScale,
		    {Scale = .88},
		    .28,
		    EASE.Quint,
		    DIR.In)
		tw(fpsS,
		    {Scale = .01},
		    .28,
		    EASE.Quint,
		    DIR.In)
		task.delay(.31,
		    function() if not V.fps then fpsF.Visible = false; fpsAura.Visible = false end end)
	end
end
local fpsA, fpsN = 0, 0

local envCleanup
function __AuraFixUtil.unload()
	pcall(function() RS:UnbindFromRenderStep("AuraMenuLoop") end)
	if __AuraFix_activeTweens then for _, records in pairs(__AuraFix_activeTweens) do for _, record in ipairs(records) do pcall(function() record.tween:Cancel() end) end end; table.clear(__AuraFix_activeTweens) end
	for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
	for plr in pairs(esp) do __AuraFixUtil.detach(plr) end
    for _, object in ipairs({blur,
        sound,
        gui,
        __AuraFix_envBloom,
        __AuraFix_envColor,
        __AuraFix_envRays,
        __AuraFix_envDOF}) do
        if object and object.Parent then pcall(function() object:Destroy() end) end
    end
    if envCleanup then pcall(envCleanup) end
    if __AuraFix_ambientFolder and __AuraFix_ambientFolder.Parent then pcall(function() __AuraFix_ambientFolder:Destroy() end) end
    genv.AuraUnload = nil
end
genv.AuraUnload = __AuraFixUtil.unload

local spd, tapeT, semi, vol, bassS, midS, trebS, reverbT, echoT, prog, pauseB, reverbDecayS, reverbWetS, echoDelayS, echoFeedbackS
function __AuraFixUtil.resetAll()
	spd.Set(1); tapeT.Set(true); semi.Set(0); vol.Set(0)
	bassS.Set(0); midS.Set(0); trebS.Set(0); reverbT.Set(false); echoT.Set(false)
    reverb.DecayTime = 2.8; reverb.WetLevel = -4; echo.Delay = .35; echo.Feedback = .45; echo.WetLevel = -6
    if reverbDecayS then reverbDecayS.Set(2.8) end; if reverbWetS then reverbWetS.Set(-4) end
    if echoDelayS then echoDelayS.Set(.35) end; if echoFeedbackS then echoFeedbackS.Set(.45) end
end
function __AuraFixUtil.dbfmt(v) return string.format("%+.0f dB",
    v) end

__AuraFix_pg = __AuraFixUtil.page("Музыка")
__AuraFixUtil.section(__AuraFix_pg,
    "ПЛЕЕР")
__AuraFix_idc = __AuraFixUtil.card(__AuraFix_pg,
    42)
box = __AuraFixUtil.new("TextBox",
    {Text = "",
    ClearTextOnFocus = false,
    Font = Enum.Font.GothamMedium,
    TextSize = 13,
    TextColor3 = C.text,
    PlaceholderColor3 = C.sub,
    BackgroundColor3 = C.card2,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClipsDescendants = true,
    Position = UDim2.fromOffset(6,
    6),
    Size = UDim2.new(1,
    -94,
    1,
    -12)},
    __AuraFix_idc)
bind(box,
    "Вставьте ID песни",
    "PlaceholderText")
__AuraFixUtil.round(box,
    6); __AuraFixUtil.new("UIPadding",
    {PaddingLeft = UDim.new(0,
    8)},
    box)
__AuraFix_bs = __AuraFixUtil.stroke(box,
    1.5,
    accent,
    1); __AuraFixUtil.acc(__AuraFix_bs,
    "Color")
cn(box.Focused,
    function() tw(__AuraFix_bs,
    {Transparency = 0},
    .2) end)
cn(box.FocusLost,
    function(enter)
	tw(__AuraFix_bs,
	    {Transparency = 1},
	    .25)
	box.Text = box.Text:match("%d+") or ""
	if enter then play(box.Text) end
end)
cn(box:GetPropertyChangedSignal("Text"),
    function()
	local s = box.Text:match("%d+") or ""
	if s ~= box.Text then box.Text = s end
end)
__AuraFix_go = __AuraFixUtil.button(__AuraFix_idc,
    "Играть",
    function() play(box.Text) end,
    true,
    UDim2.new(0,
    76,
    1,
    -12))
__AuraFix_go.Position = UDim2.new(1,
    -82,
    0,
    6)

__AuraFix_np = __AuraFixUtil.card(__AuraFix_pg,
    60)
__AuraFix_vinyl = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(0,
    .5),
    Position = UDim2.new(0,
    10,
    .5,
    0),
    Size = UDim2.fromOffset(44,
    44),
    BackgroundColor3 = WHITE},
    __AuraFix_np)
__AuraFixUtil.round(__AuraFix_vinyl,
    22)
__AuraFix_vs = __AuraFixUtil.stroke(__AuraFix_vinyl,
    2,
    accent,
    .4); __AuraFixUtil.acc(__AuraFix_vs,
    "Color")
__AuraFix_hi, __AuraFix_lo2 = Color3.fromRGB(95,
    95,
    118), Color3.fromRGB(22,
    22,
    30)
__AuraFixUtil.new("UIGradient",
    {Rotation = 35,
    Color = ColorSequence.new({ColorSequenceKeypoint.new(0,
    __AuraFix_hi),
    ColorSequenceKeypoint.new(.25,
    __AuraFix_lo2),
    ColorSequenceKeypoint.new(.5,
    __AuraFix_hi),
    ColorSequenceKeypoint.new(.75,
    __AuraFix_lo2),
    ColorSequenceKeypoint.new(1,
    __AuraFix_hi)})},
    __AuraFix_vinyl)
for _, d in ipairs({36,
    28}) do
	local g = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(.5,
	    .5),
	    Position = UDim2.fromScale(.5,
	    .5),
	    Size = UDim2.fromOffset(d,
	    d),
	    BackgroundTransparency = 1},
	    __AuraFix_vinyl)
	__AuraFixUtil.round(g,
	    d / 2); __AuraFixUtil.stroke(g,
	    1,
	    WHITE,
	    .88)
end
__AuraFix_vlab = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(.5,
    .5),
    Position = UDim2.fromScale(.5,
    .5),
    Size = UDim2.fromOffset(16,
    16)},
    __AuraFix_vinyl)
__AuraFixUtil.round(__AuraFix_vlab,
    8); __AuraFixUtil.acc(__AuraFix_vlab,
    "BackgroundColor3")
__AuraFix_vhole = __AuraFixUtil.new("Frame",
    {AnchorPoint = Vector2.new(.5,
    .5),
    Position = UDim2.fromScale(.5,
    .5),
    Size = UDim2.fromOffset(4,
    4),
    BackgroundColor3 = C.card},
    __AuraFix_vlab)
__AuraFixUtil.round(__AuraFix_vhole,
    2)
nameL = __AuraFixUtil.lbl(__AuraFix_np,
    "",
    13,
    nil,
    {Position = UDim2.fromOffset(64,
    10),
    Size = UDim2.new(1,
    -74,
    0,
    18),
    Font = Enum.Font.GothamBold})
statusL = __AuraFixUtil.lbl(__AuraFix_np,
    "",
    11,
    C.sub,
    {Position = UDim2.fromOffset(64,
    30),
    Size = UDim2.new(1,
    -74,
    0,
    16)})
trReg[#trReg + 1] = __AuraFixUtil.idle
__AuraFixUtil.idle()

histBox = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1,
    0,
    0,
    26),
    BackgroundTransparency = 1,
    Visible = false},
    __AuraFix_pg)
__AuraFixUtil.new("UIListLayout",
    {FillDirection = Enum.FillDirection.Horizontal,
    Padding = UDim.new(0,
    5)},
    histBox)

__AuraFix_queueHeading = __AuraFixUtil.section(__AuraFix_pg,
    "ОЧЕРЕДЬ")
__AuraFix_queueInfo = __AuraFixUtil.card(__AuraFix_pg,
    30)
queueStatus = __AuraFixUtil.lbl(__AuraFix_queueInfo,
    "Очередь пуста",
    11,
    C.sub,
    {Position = UDim2.fromOffset(10,
    0),
    Size = UDim2.new(1,
    -96,
    1,
    0)})
__AuraFix_clearQueueButton = __AuraFixUtil.button(__AuraFix_queueInfo,
    "Очистить очередь",
    function()
	table.clear(queueItems)
	if queueList then
		for _, child in ipairs(queueList:GetChildren()) do
			if not child:IsA("UIListLayout") then child:Destroy() end
		end
	end
	queueStatus.Text = T("Очередь пуста")
	__AuraFixUtil.toast("Список очищен")
end,
    false,
    UDim2.new(0,
    90,
    1,
    -8))
__AuraFix_clearQueueButton.Position = UDim2.new(1,
    -94,
    0,
    4)
queueList = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1,
    0,
    0,
    0),
    AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1},
    __AuraFix_pg)
__AuraFixUtil.new("UIListLayout",
    {Padding = UDim.new(0,
    4),
    SortOrder = Enum.SortOrder.LayoutOrder},
    queueList)

function __AuraFix_clearGenerated(parent)
	for _, child in ipairs(parent:GetChildren()) do
		if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then child:Destroy() end
	end
end

function __AuraFix_renderQueue()
	if not queueList then return end
	__AuraFix_clearGenerated(queueList)
	local count = #queueItems
	queueStatus.Text = count > 0 and (T("В очереди") .. ": " .. tostring(count)) or T("Очередь пуста")
	if count == 0 then
		local empty = __AuraFixUtil.new("Frame",
		    {Size = UDim2.new(1,
		    0,
		    0,
		    28),
		    BackgroundColor3 = C.card3,
		    BackgroundTransparency = .2},
		    queueList)
		__AuraFixUtil.round(empty,
		    7)
		__AuraFixUtil.lbl(empty,
		    T("Очередь пуста"),
		    11,
		    C.sub,
		    {Position = UDim2.fromOffset(10,
		    0),
		    Size = UDim2.new(1,
		    -20,
		    1,
		    0)})
		return
	end
	for index, item in ipairs(queueItems) do
		local rowFrame = __AuraFixUtil.new("Frame",
		    {Size = UDim2.new(1,
		    0,
		    0,
		    36),
		    BackgroundColor3 = C.card,
		    BackgroundTransparency = .05},
		    queueList)
		__AuraFixUtil.round(rowFrame,
		    7)
		local countLabel = __AuraFixUtil.new("TextLabel",
		    {BackgroundColor3 = C.card2,
		    Position = UDim2.fromOffset(5,
		    5),
		    Size = UDim2.fromOffset(26,
		    26),
		    Font = Enum.Font.GothamBold,
		    TextSize = 11,
		    TextColor3 = accent,
		    Text = string.format("%02d",
		    index)},
		    rowFrame)
		__AuraFixUtil.round(countLabel,
		    6)
		local titleLabel = __AuraFixUtil.lbl(rowFrame,
		    item.title or item.id,
		    11,
		    C.text,
		    {Position = UDim2.fromOffset(38,
		    1),
		    Size = UDim2.new(1,
		    -116,
		    1,
		    -2),
		    Font = Enum.Font.GothamMedium})
		local playNow = __AuraFixUtil.new("TextButton",
		    {Text = "▶",
		    Font = Enum.Font.GothamBold,
		    TextSize = 12,
		    TextColor3 = WHITE,
		    AutoButtonColor = false,
		    BackgroundColor3 = accent,
		    AnchorPoint = Vector2.new(1,
		    .5),
		    Position = UDim2.new(1,
		    -40,
		    .5,
		    0),
		    Size = UDim2.fromOffset(30,
		    26)},
		    rowFrame)
		__AuraFixUtil.round(playNow,
		    6)
		__AuraFixUtil.press(playNow,
		    true)
		cn(playNow.Activated,
		    function()
			table.remove(queueItems,
			    index)
			__AuraFix_renderQueue()
			box.Text = item.id
			play(item.id)
		end)
		local remove = __AuraFixUtil.new("TextButton",
		    {Text = "×",
		    Font = Enum.Font.GothamBold,
		    TextSize = 16,
		    TextColor3 = C.sub,
		    AutoButtonColor = false,
		    BackgroundColor3 = C.card2,
		    AnchorPoint = Vector2.new(1,
		    .5),
		    Position = UDim2.new(1,
		    -6,
		    .5,
		    0),
		    Size = UDim2.fromOffset(28,
		    26)},
		    rowFrame)
		__AuraFixUtil.round(remove,
		    6)
		__AuraFixUtil.press(remove,
		    true)
		cn(remove.Activated,
		    function()
			table.remove(queueItems,
			    index)
			__AuraFix_renderQueue()
		end)
		cn(rowFrame.MouseEnter,
		    function() tw(rowFrame,
		    {BackgroundColor3 = C.card2},
		    .15) end)
		cn(rowFrame.MouseLeave,
		    function() tw(rowFrame,
		    {BackgroundColor3 = C.card},
		    .2) end)
	end
end

function __AuraFix_addToQueue(id,
    title,
    artist)
	id = tostring(id or "")
	if not id:match("^%d+$") then return end
	for _, item in ipairs(queueItems) do
		if item.id == id then
			__AuraFixUtil.toast("Уже в очереди",
			    C.warn)
			return
		end
	end
	table.insert(queueItems,
	    {id = id,
	    title = title or knownTitles[id] or id,
	    artist = artist})
	__AuraFix_renderQueue()
	__AuraFixUtil.toast("Добавлено в очередь",
	    C.good)
end

__AuraFix_renderQueue()

-- The redundant floating mini-player has been removed; playback stays inside the Music tab.
__AuraFix_vc = __AuraFixUtil.card(__AuraFix_pg,
    56)
__AuraFix_bars = {}
for n = 1, 28 do
	local b = __AuraFixUtil.new("Frame",
	    {BackgroundColor3 = WHITE,
	    AnchorPoint = Vector2.new(0,
	    1),
	    Position = UDim2.new((n - 1) / 28,
	    2,
	    1,
	    -6),
	    Size = UDim2.new(1 / 28,
	    -3,
	    0,
	    3)},
	    __AuraFix_vc)
	__AuraFixUtil.round(b,
	    2)
	__AuraFixUtil.grad(b,
	    function() return ColorSequence.new(__AuraFixUtil.light(accent):Lerp(accent,
	    .4),
	    accent) end,
	    {Rotation = 90})
	local cap = __AuraFixUtil.new("Frame",
	    {AnchorPoint = Vector2.new(0,
	    1),
	    Position = UDim2.new((n - 1) / 28,
	    2,
	    1,
	    -11),
	    Size = UDim2.new(1 / 28,
	    -3,
	    0,
	    2)},
	    __AuraFix_vc)
	__AuraFixUtil.round(cap,
	    1); __AuraFixUtil.acc(cap,
	    "BackgroundColor3")
	__AuraFix_bars[n] = {f = b,
	    c = cap,
	    h = 0,
	    p = 0}
end
prog = __AuraFixUtil.slider(__AuraFix_pg,
    "Трек",
    0,
    1,
    0,
    function(v)
	local l = sound.TimeLength
	return __AuraFixUtil.fmtT(v * l) .. " / " .. __AuraFixUtil.fmtT(l)
end,
    function(v)
	if sound.TimeLength > 0 then sound.TimePosition = v * sound.TimeLength end
end,
    nil,
    nil,
    true)
__AuraFix_r = __AuraFixUtil.row(__AuraFix_pg,
    32)
__AuraFix_q = UDim2.new(.25,
    -5,
    1,
    0)
__AuraFixUtil.button(__AuraFix_r,
    "-10с",
    function() sound.TimePosition = math.max(0,
    sound.TimePosition - 10) end,
    false,
    __AuraFix_q)
pauseB = __AuraFixUtil.button(__AuraFix_r,
    "Пауза",
    function()
	if sound.IsPlaying then sound:Pause()
	elseif sound.IsPaused then sound:Resume()
	elseif sound.SoundId ~= "" then endedF = false; sound:Play() end
end,
    true,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_r,
    "Стоп",
    function()
	playTok += 1
	sound:Stop()
	if not trackOK and touched then __AuraFixUtil.setStatus(T("Остановлено")) end
end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_r,
    "+10с",
    function() sound.TimePosition = math.min(sound.TimeLength,
    sound.TimePosition + 10) end,
    false,
    __AuraFix_q)
__AuraFixUtil.toggle(__AuraFix_pg,
    "Повтор трека",
    false,
    function(v) sound.Looped = v end,
    "loop")

__AuraFixUtil.section(__AuraFix_pg,
    "СКОРОСТЬ И ТОНАЛЬНОСТЬ")
spd = __AuraFixUtil.slider(__AuraFix_pg,
    "Скорость",
    .25,
    3,
    1,
    function(v) return string.format("%.2fx",
    v) end,
    function(v) S.speed = v; __AuraFixUtil.applyAudio() end,
    .05,
    "speed")
tapeT = __AuraFixUtil.toggle(__AuraFix_pg,
    "Менять тон со скоростью",
    true,
    function(v) S.tape = v; __AuraFixUtil.applyAudio() end,
    "tape")
semi = __AuraFixUtil.slider(__AuraFix_pg,
    "Тональность",
    -12,
    12,
    0,
    function(v) return string.format("%+.0f %s",
    v,
    T("пт")) end,
    function(v) S.semi = v; __AuraFixUtil.applyAudio() end,
    1,
    "semi")
__AuraFixUtil.section(__AuraFix_pg,
    "ГРОМКОСТЬ")
vol = __AuraFixUtil.slider(__AuraFix_pg,
    "Усиление",
    -40,
    20,
    0,
    __AuraFixUtil.dbfmt,
    function(v) S.db = v; __AuraFixUtil.applyAudio() end,
    1,
    "db")
__AuraFix_volumeQuick = __AuraFixUtil.row(__AuraFix_pg,
    30)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Тихо",
    function() vol.Set(-12); __AuraFixUtil.toast("Тихо") end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Обычный",
    function() vol.Set(0); __AuraFixUtil.toast("Обычный") end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Громко",
    function() vol.Set(8); __AuraFixUtil.toast("Громко") end,
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_volumeQuick,
    "Максимум",
    function() vol.Set(16); __AuraFixUtil.toast("Максимум",
    C.warn) end,
    false,
    __AuraFix_q)
__AuraFixUtil.section(__AuraFix_pg,
    "БЫСТРЫЕ НАСТРОЙКИ")
__AuraFix_musicOptions = __AuraFixUtil.row(__AuraFix_pg,
    30)
__AuraFixUtil.button(__AuraFix_musicOptions,
    "Пуск / пауза",
    function()
	if sound.IsPlaying then sound:Pause() elseif sound.IsPaused then sound:Resume() elseif sound.SoundId ~= "" then sound:Play() end
end,
    true,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.button(__AuraFix_musicOptions,
    "Очистить очередь",
    function()
	table.clear(queueItems)
	__AuraFix_renderQueue()
	__AuraFixUtil.toast("Список очищен")
end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.section(__AuraFix_pg,
    "ВИЗУАЛИЗАТОР")
__AuraFixUtil.segment(__AuraFix_pg,
    "Стиль",
    {"Мягкий",
    "Пики",
    "Спектр"},
    function(i) visualizerStyle = i end,
    1,
    "visualizerStyle")
__AuraFixUtil.toggle(__AuraFix_pg,
    "Пульсация акцента",
    true,
    function(v) musicAccentPulse = v end,
    "musicAccentPulse")
__AuraFixUtil.toggle(__AuraFix_pg,
    "Авто-очередь",
    true,
    function(v) queueAutoPlay = v end,
    "queueAutoPlay")
__AuraFixUtil.button(__AuraFix_pg,
    "Сбросить всё",
    __AuraFixUtil.resetAll)

__AuraFix_pe = __AuraFixUtil.page("Эффекты")
function __AuraFix_preset(name,
    fn)
	return function() __AuraFixUtil.resetAll(); fn(); __AuraFixUtil.toast(T("Пресет: ") .. name) end
end
__AuraFixUtil.section(__AuraFix_pe,
    "ПРЕСЕТЫ")
__AuraFix_pr = __AuraFixUtil.row(__AuraFix_pe,
    30)
__AuraFixUtil.button(__AuraFix_pr,
    "Ночной",
    __AuraFix_preset("Ночной",
    function() spd.Set(1.08); tapeT.Set(true); bassS.Set(4); midS.Set(-2); trebS.Set(2); reverbT.Set(true); reverb.DecayTime = 2.2; reverb.WetLevel = -8 end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr,
    "Замедленный",
    __AuraFix_preset("Замедленный",
    function() spd.Set(.78); tapeT.Set(true); bassS.Set(3); midS.Set(0); trebS.Set(-2); reverbT.Set(true); reverb.DecayTime = 3.5; reverb.WetLevel = -5 end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr,
    "Бас",
    __AuraFix_preset("Бас",
    function() bassS.Set(10); midS.Set(-4); trebS.Set(2); reverbT.Set(false); echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFix_pr2 = __AuraFixUtil.row(__AuraFix_pe,
    30)
__AuraFixUtil.button(__AuraFix_pr2,
    "Клуб",
    __AuraFix_preset("Клуб",
    function() spd.Set(1.02); tapeT.Set(false); bassS.Set(8); midS.Set(1); trebS.Set(5); reverbT.Set(true); reverb.WetLevel = -10; echoT.Set(true); echo.Delay = .22; echo.Feedback = .28; echo.WetLevel = -9 end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr2,
    "Радио",
    __AuraFix_preset("Радио",
    function() spd.Set(1); tapeT.Set(false); bassS.Set(-8); midS.Set(5); trebS.Set(-5); reverbT.Set(false); echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFix_pr3 = __AuraFixUtil.row(__AuraFix_pe,
    30)
__AuraFixUtil.button(__AuraFix_pr3,
    "Тёплый",
    __AuraFix_preset("Тёплый",
    function() spd.Set(1); tapeT.Set(false); bassS.Set(4); midS.Set(2); trebS.Set(-3); reverbT.Set(true); reverb.DecayTime = 2.6; reverb.WetLevel = -9; echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr3,
    "Яркий звук",
    __AuraFix_preset("Яркий звук",
    function() spd.Set(1); tapeT.Set(false); bassS.Set(1); midS.Set(1); trebS.Set(7); reverbT.Set(false); echoT.Set(false) end),
    false,
    __AuraFix_q)
__AuraFixUtil.button(__AuraFix_pr3,
    "Сброс",
    function() __AuraFixUtil.resetAll(); __AuraFixUtil.toast("Всё сброшено") end,
    false,
    __AuraFix_q)
__AuraFixUtil.section(__AuraFix_pe,
    "ЭКВАЛАЙЗЕР")
bassS = __AuraFixUtil.slider(__AuraFix_pe,
    "Низкие",
    -20,
    10,
    0,
    __AuraFixUtil.dbfmt,
    function(v) eq.LowGain = v end,
    1,
    "bass")
midS = __AuraFixUtil.slider(__AuraFix_pe,
    "Средние",
    -20,
    10,
    0,
    __AuraFixUtil.dbfmt,
    function(v) eq.MidGain = v end,
    1,
    "mid")
trebS = __AuraFixUtil.slider(__AuraFix_pe,
    "Высокие",
    -20,
    10,
    0,
    __AuraFixUtil.dbfmt,
    function(v) eq.HighGain = v end,
    1,
    "treb")
__AuraFixUtil.section(__AuraFix_pe,
    "ПРОСТРАНСТВО")
reverbT = __AuraFixUtil.toggle(__AuraFix_pe,
    "Реверберация",
    false,
    function(v) reverb.Enabled = v end,
    "reverb")
echoT = __AuraFixUtil.toggle(__AuraFix_pe,
    "Эхо",
    false,
    function(v) echo.Enabled = v end,
    "echo")
__AuraFixUtil.section(__AuraFix_pe,
    "НАСТРОЙКИ ПРОСТРАНСТВА")
reverbDecayS = __AuraFixUtil.slider(__AuraFix_pe,
    "Длина реверберации",
    1,
    8,
    2.8,
    function(v) return string.format("%.1fs",
    v) end,
    function(v) reverb.DecayTime = v end,
    .1,
    "reverbDecay")
reverbWetS = __AuraFixUtil.slider(__AuraFix_pe,
    "Сила реверберации",
    -20,
    0,
    -4,
    __AuraFixUtil.dbfmt,
    function(v) reverb.WetLevel = v end,
    1,
    "reverbWet")
echoDelayS = __AuraFixUtil.slider(__AuraFix_pe,
    "Эхо-задержка",
    .1,
    1,
    .35,
    function(v) return string.format("%.2fs",
    v) end,
    function(v) echo.Delay = v end,
    .05,
    "echoDelay")
echoFeedbackS = __AuraFixUtil.slider(__AuraFix_pe,
    "Обратная связь эха",
    0,
    .8,
    .45,
    function(v) return string.format("%.2f",
    v) end,
    function(v) echo.Feedback = v end,
    .05,
    "echoFeedback")

-- Environment presets use native Roblox post-processing controls.
-- Reference patterns: https://github.com/Eldergenix/Roblox-Game/blob/main/.agents/skills/roblox-lighting/SKILL.md
-- and https://github.com/sebasbimbi/roblox-studio-agent/blob/main/apps/desktop/agent/skills/roblox-lighting/references/full.md
-- Preset values below are authored for AURA; no remote code is executed.
__AuraFix_envBloom = Instance.new("BloomEffect")
__AuraFix_envBloom.Name = "AuraEnvBloom"
__AuraFix_envBloom.Enabled = false
__AuraFix_envBloom.Intensity = 0
__AuraFix_envBloom.Size = 24
__AuraFix_envBloom.Threshold = 1
__AuraFix_envBloom.Parent = Lighting

__AuraFix_envColor = Instance.new("ColorCorrectionEffect")
__AuraFix_envColor.Name = "AuraEnvColor"
__AuraFix_envColor.Enabled = false
__AuraFix_envColor.Brightness = 0
__AuraFix_envColor.Contrast = 0
__AuraFix_envColor.Saturation = 0
__AuraFix_envColor.TintColor = WHITE
__AuraFix_envColor.Parent = Lighting

__AuraFix_envRays = Instance.new("SunRaysEffect")
__AuraFix_envRays.Name = "AuraEnvRays"
__AuraFix_envRays.Enabled = false
__AuraFix_envRays.Intensity = 0
__AuraFix_envRays.Spread = .75
__AuraFix_envRays.Parent = Lighting

__AuraFix_envDOF = Instance.new("DepthOfFieldEffect")
__AuraFix_envDOF.Name = "AuraEnvDOF"
__AuraFix_envDOF.Enabled = false
__AuraFix_envDOF.FarIntensity = 0
__AuraFix_envDOF.NearIntensity = 0
__AuraFix_envDOF.FocusDistance = 50
__AuraFix_envDOF.InFocusRadius = 50
__AuraFix_envDOF.Parent = Lighting

local envLightingBase = {
    Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ExposureCompensation = Lighting.ExposureCompensation,
        GlobalShadows = Lighting.GlobalShadows,
        FogColor = Lighting.FogColor,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
}
local envAtmo = Lighting:FindFirstChildOfClass("Atmosphere")
local envCreatedAtmo = envAtmo == nil
if not envAtmo then
    envAtmo = Instance.new("Atmosphere")
    envAtmo.Name = "AuraEnvAtmosphere"
    envAtmo.Density = 0
    envAtmo.Offset = .25
    envAtmo.Haze = 0
    envAtmo.Glare = 0
    envAtmo.Color = WHITE
    envAtmo.Decay = WHITE
    envAtmo.Parent = Lighting
end
local envAtmoBase = {
    Density = envAtmo.Density,
        Offset = envAtmo.Offset,
        Haze = envAtmo.Haze,
        Glare = envAtmo.Glare,
        Color = envAtmo.Color,
        Decay = envAtmo.Decay,
}
local envTerrain = workspace:FindFirstChildOfClass("Terrain") or workspace.Terrain
local envOriginalSkies = {}
for _, object in ipairs(Lighting:GetChildren()) do
    if object:IsA("Sky") and object.Name ~= "AuraEnvSky" then envOriginalSkies[#envOriginalSkies + 1] = object end
end
local envSky = Instance.new("Sky")
envSky.Name = "AuraEnvSky"
envSky.CelestialBodiesShown = true
envSky.StarCount = 3000
envSky.SunAngularSize = 12
envSky.MoonAngularSize = 11
local envSkyIsActive = false
local envClouds = envTerrain:FindFirstChildOfClass("Clouds")
local envCreatedClouds = envClouds == nil
if not envClouds then
    envClouds = Instance.new("Clouds")
    envClouds.Name = "AuraEnvClouds"
    envClouds.Cover = 0
    envClouds.Density = 0
    envClouds.Color = WHITE
end
local envCloudBase = {Cover = envClouds.Cover,
    Density = envClouds.Density,
    Color = envClouds.Color}
envCleanup = function()
    pcall(function()
        Lighting.Brightness = envLightingBase.Brightness
        Lighting.ClockTime = envLightingBase.ClockTime
        Lighting.Ambient = envLightingBase.Ambient
        Lighting.OutdoorAmbient = envLightingBase.OutdoorAmbient
        Lighting.ExposureCompensation = envLightingBase.ExposureCompensation
        Lighting.FogColor = envLightingBase.FogColor
        Lighting.FogStart = envLightingBase.FogStart
        Lighting.FogEnd = envLightingBase.FogEnd
        Lighting.GlobalShadows = envLightingBase.GlobalShadows
    end)
    if envSky and envSky.Parent then pcall(function() envSky:Destroy() end) end
    for _, sky in ipairs(envOriginalSkies) do
        if sky and sky.Parent ~= Lighting then pcall(function() sky.Parent = Lighting end) end
    end
    if envClouds then
        if envCreatedClouds then
            pcall(function() envClouds:Destroy() end)
        elseif envClouds.Parent then
            pcall(function() for property,
                value in pairs(envCloudBase) do envClouds[property] = value end end)
        end
    end
    if envCreatedAtmo then
        if envAtmo and envAtmo.Parent then pcall(function() envAtmo:Destroy() end) end
    elseif envAtmo and envAtmo.Parent then
        pcall(function() for property,
            value in pairs(envAtmoBase) do envAtmo[property] = value end end)
    end
end

local envPreset = math.clamp(math.floor(tonumber(cfg.envPreset) or 0),
    0,
    6)
local envOn = cfg.envBloom == true
local envStrength = math.clamp(tonumber(cfg.envBloomStrength) or 60,
    0,
    100)
local envBaseBloom, envPhase, envTick, envApplyToken = .32, 0, 0, 0
local envButtons = {}
-- Skybox texture references adapted from a public GitHub example; no remote code is executed.
-- https://gist.github.com/dexexisted-alt/655b8fc9323571ef7d46ef55eb66dc38
local envSkySets = {
    [1] = {Bk = "rbxassetid://271042516",
        Dn = "rbxassetid://271077243",
        Ft = "rbxassetid://271042556",
        Lf = "rbxassetid://271042310",
        Rt = "rbxassetid://271042467",
        Up = "rbxassetid://271077958"},
        [2] = {Bk = "rbxassetid://166509999",
        Dn = "rbxassetid://166509999",
        Ft = "rbxassetid://166509999",
        Lf = "rbxassetid://166509999",
        Rt = "rbxassetid://166509999",
        Up = "rbxassetid://166509999"},
        [3] = {Bk = "rbxassetid://159454299",
        Dn = "rbxassetid://159454299",
        Ft = "rbxassetid://159454299",
        Lf = "rbxassetid://159454299",
        Rt = "rbxassetid://159454299",
        Up = "rbxassetid://159454299"},
}
local envPresets = {
    [0] = {name = "Исходный вид",
        clockTime = envLightingBase.ClockTime,
        lightBrightness = envLightingBase.Brightness,
        ambient = envLightingBase.Ambient,
        outdoorAmbient = envLightingBase.OutdoorAmbient,
        exposure = envLightingBase.ExposureCompensation,
        fogColor = envLightingBase.FogColor,
        fogStart = envLightingBase.FogStart,
        fogEnd = envLightingBase.FogEnd,
        bloom = 0,
        size = 24,
        threshold = 1,
        brightness = 0,
        contrast = 0,
        saturation = 0,
        tint = WHITE,
        rays = 0,
        spread = .75,
        atmo = {Density = envAtmoBase.Density,
        Offset = envAtmoBase.Offset,
        Haze = envAtmoBase.Haze,
        Glare = envAtmoBase.Glare,
        Color = envAtmoBase.Color,
        Decay = envAtmoBase.Decay},
        dofFar = 0,
        dofNear = 0,
        focus = 50,
        radius = 50},
        [1] = {name = "Кинематограф",
        clockTime = 17.4,
        lightBrightness = 2.4,
        ambient = Color3.fromRGB(105,
        91,
        115),
        outdoorAmbient = Color3.fromRGB(151,
        124,
        135),
        exposure = .12,
        fogColor = Color3.fromRGB(198,
        145,
        128),
        fogStart = 0,
        fogEnd = 900,
        sky = 2,
        skyRotation = 0,
        cloudCover = .18,
        cloudDensity = .32,
        cloudColor = Color3.fromRGB(231,
        216,
        255),
        bloom = .48,
        size = 36,
        threshold = .82,
        brightness = .025,
        contrast = .16,
        saturation = .18,
        tint = Color3.fromRGB(255,
        225,
        197),
        rays = .055,
        spread = .82,
        atmo = {Density = .18,
        Offset = .22,
        Haze = .72,
        Glare = .12,
        Color = Color3.fromRGB(255,
        226,
        199),
        Decay = Color3.fromRGB(115,
        104,
        125)},
        dofFar = .025,
        dofNear = 0,
        focus = 65,
        radius = 90},
        [2] = {name = "Неоновые сумерки",
        clockTime = 19.6,
        lightBrightness = 1.8,
        ambient = Color3.fromRGB(76,
        65,
        132),
        outdoorAmbient = Color3.fromRGB(91,
        81,
        155),
        exposure = .05,
        fogColor = Color3.fromRGB(80,
        72,
        155),
        fogStart = 0,
        fogEnd = 700,
        sky = 3,
        skyRotation = 35,
        cloudCover = .28,
        cloudDensity = .48,
        cloudColor = Color3.fromRGB(170,
        157,
        255),
        bloom = .62,
        size = 42,
        threshold = .72,
        brightness = .015,
        contrast = .24,
        saturation = .32,
        tint = Color3.fromRGB(222,
        194,
        255),
        rays = .02,
        spread = .9,
        atmo = {Density = .14,
        Offset = .15,
        Haze = .9,
        Glare = .1,
        Color = Color3.fromRGB(185,
        169,
        255),
        Decay = Color3.fromRGB(65,
        86,
        157)},
        dofFar = .015,
        dofNear = 0,
        focus = 70,
        radius = 100},
        [3] = {name = "Лавандовый сон",
        clockTime = 16.8,
        lightBrightness = 2.3,
        ambient = Color3.fromRGB(130,
        100,
        160),
        outdoorAmbient = Color3.fromRGB(170,
        140,
        195),
        exposure = .1,
        fogColor = Color3.fromRGB(192,
        160,
        220),
        fogStart = 0,
        fogEnd = 1000,
        sky = 3,
        skyRotation = 105,
        cloudCover = .22,
        cloudDensity = .40,
        cloudColor = Color3.fromRGB(205,
        190,
        255),
        bloom = .52,
        size = 38,
        threshold = .78,
        brightness = .035,
        contrast = .13,
        saturation = .28,
        tint = Color3.fromRGB(231,
        214,
        255),
        rays = .025,
        spread = .78,
        atmo = {Density = .12,
        Offset = .27,
        Haze = .55,
        Glare = .08,
        Color = Color3.fromRGB(227,
        207,
        255),
        Decay = Color3.fromRGB(139,
        128,
        184)},
        dofFar = .04,
        dofNear = .01,
        focus = 60,
        radius = 120},
        [4] = {name = "Изумрудный туман",
        clockTime = 7.1,
        lightBrightness = 1.7,
        ambient = Color3.fromRGB(55,
        112,
        95),
        outdoorAmbient = Color3.fromRGB(77,
        150,
        120),
        exposure = -.08,
        fogColor = Color3.fromRGB(78,
        160,
        124),
        fogStart = 0,
        fogEnd = 500,
        sky = 3,
        skyRotation = 185,
        cloudCover = .34,
        cloudDensity = .54,
        cloudColor = Color3.fromRGB(145,
        255,
        210),
        bloom = .43,
        size = 34,
        threshold = .86,
        brightness = -.015,
        contrast = .2,
        saturation = .24,
        tint = Color3.fromRGB(190,
        255,
        225),
        rays = .018,
        spread = .76,
        atmo = {Density = .24,
        Offset = .18,
        Haze = 1.55,
        Glare = .03,
        Color = Color3.fromRGB(167,
        244,
        208),
        Decay = Color3.fromRGB(61,
        112,
        99)},
        dofFar = .015,
        dofNear = 0,
        focus = 55,
        radius = 100},
        [5] = {name = "Кристальный лёд",
        clockTime = 10.5,
        lightBrightness = 2.8,
        ambient = Color3.fromRGB(115,
        160,
        195),
        outdoorAmbient = Color3.fromRGB(160,
        205,
        235),
        exposure = .18,
        fogColor = Color3.fromRGB(170,
        215,
        255),
        fogStart = 0,
        fogEnd = 1200,
        sky = 1,
        skyRotation = 235,
        cloudCover = .16,
        cloudDensity = .30,
        cloudColor = Color3.fromRGB(185,
        231,
        255),
        bloom = .46,
        size = 36,
        threshold = .8,
        brightness = .025,
        contrast = .17,
        saturation = .18,
        tint = Color3.fromRGB(196,
        235,
        255),
        rays = .065,
        spread = .88,
        atmo = {Density = .10,
        Offset = .30,
        Haze = .42,
        Glare = .14,
        Color = Color3.fromRGB(197,
        232,
        255),
        Decay = Color3.fromRGB(111,
        153,
        202)},
        dofFar = .02,
        dofNear = 0,
        focus = 75,
        radius = 110},
        -- Custom AURA preset: animated prismatic tint with restrained glow waves.
    [6] = {name = "Призматическая аврора",
        clockTime = 20.2,
        lightBrightness = 2.1,
        ambient = Color3.fromRGB(65,
        125,
        130),
        outdoorAmbient = Color3.fromRGB(95,
        175,
        155),
        exposure = .08,
        fogColor = Color3.fromRGB(95,
        190,
        175),
        fogStart = 0,
        fogEnd = 850,
        sky = 3,
        skyRotation = 0,
        cloudCover = .26,
        cloudDensity = .47,
        cloudColor = Color3.fromRGB(145,
        255,
        226),
        bloom = .58,
        size = 40,
        threshold = .76,
        brightness = .02,
        contrast = .19,
        saturation = .32,
        tint = Color3.fromRGB(175,
        255,
        228),
        rays = .028,
        spread = .86,
        atmo = {Density = .13,
        Offset = .25,
        Haze = .82,
        Glare = .09,
        Color = Color3.fromRGB(169,
        255,
        229),
        Decay = Color3.fromRGB(93,
        106,
        190)},
        dofFar = .015,
        dofNear = 0,
        focus = 70,
        radius = 100},
}

function __AuraFixUtil.applyEnvironmentPreset(index)
    index = math.clamp(math.floor(tonumber(index) or 0),
        0,
        6)
    envPreset = index
    cfg.envPreset = index
    envApplyToken += 1
    local token = envApplyToken
    local p = envPresets[index] or envPresets[0]
    local active = envOn and index ~= 0 and envStrength > 0
    envBaseBloom = p.bloom

    __AuraFix_envBloom.Enabled = active or __AuraFix_envBloom.Enabled
    __AuraFix_envColor.Enabled = active or __AuraFix_envColor.Enabled
    __AuraFix_envRays.Enabled = active or __AuraFix_envRays.Enabled
    __AuraFix_envDOF.Enabled = active or __AuraFix_envDOF.Enabled

    if active then
        pcall(function()
            Lighting.Brightness = p.lightBrightness or envLightingBase.Brightness
            Lighting.ClockTime = p.clockTime or envLightingBase.ClockTime
            Lighting.Ambient = p.ambient or envLightingBase.Ambient
            Lighting.OutdoorAmbient = p.outdoorAmbient or envLightingBase.OutdoorAmbient
            Lighting.ExposureCompensation = p.exposure or envLightingBase.ExposureCompensation
            Lighting.FogColor = p.fogColor or envLightingBase.FogColor
            Lighting.FogStart = p.fogStart or envLightingBase.FogStart
            Lighting.FogEnd = p.fogEnd or envLightingBase.FogEnd
            Lighting.GlobalShadows = true
        end)
        for _, originalSky in ipairs(envOriginalSkies) do
            if originalSky and originalSky.Parent == Lighting then originalSky.Parent = nil end
        end
        local skySet = envSkySets[p.sky or 1] or envSkySets[1]
        for property, value in pairs(skySet) do envSky[property] = value end
        envSky.SkyboxOrientation = Vector3.new(0,
            p.skyRotation or 0,
            0)
        envSky.Parent = Lighting
        envSkyIsActive = true
        if envClouds.Parent ~= envTerrain then envClouds.Parent = envTerrain end
        envClouds.Cover = math.clamp(p.cloudCover or .2,
            0,
            1)
        envClouds.Density = math.clamp(p.cloudDensity or .35,
            0,
            1)
        envClouds.Color = p.cloudColor or WHITE
    else
        pcall(function()
            Lighting.Brightness = envLightingBase.Brightness
            Lighting.ClockTime = envLightingBase.ClockTime
            Lighting.Ambient = envLightingBase.Ambient
            Lighting.OutdoorAmbient = envLightingBase.OutdoorAmbient
            Lighting.ExposureCompensation = envLightingBase.ExposureCompensation
            Lighting.FogColor = envLightingBase.FogColor
            Lighting.FogStart = envLightingBase.FogStart
            Lighting.FogEnd = envLightingBase.FogEnd
            Lighting.GlobalShadows = envLightingBase.GlobalShadows
        end)
        if envSky.Parent then envSky.Parent = nil end
        envSkyIsActive = false
        for _, originalSky in ipairs(envOriginalSkies) do
            if originalSky and originalSky.Parent ~= Lighting then pcall(function() originalSky.Parent = Lighting end) end
        end
        if envCreatedClouds then
            if envClouds.Parent then envClouds.Parent = nil end
        elseif envClouds.Parent == envTerrain then
            envClouds.Cover, envClouds.Density, envClouds.Color = envCloudBase.Cover, envCloudBase.Density, envCloudBase.Color
        end
    end

    local strength = math.clamp(envStrength / 60,
        0,
        1.65)
    local bloomGoal = active and math.clamp(p.bloom * strength,
        0,
        1) or 0
    local colorGoal = active and p or envPresets[0]
    local atmoGoal = active and p.atmo or envPresets[0].atmo
    tw(__AuraFix_envBloom,
        {Intensity = bloomGoal,
        Size = active and p.size or 24,
        Threshold = active and p.threshold or 1},
        .72,
        EASE.Sine)
    local colorTween = tw(__AuraFix_envColor,
        {Brightness = colorGoal.brightness,
        Contrast = colorGoal.contrast,
        Saturation = colorGoal.saturation,
        TintColor = colorGoal.tint},
        .78,
        EASE.Sine)
    tw(__AuraFix_envRays,
        {Intensity = active and p.rays * strength or 0,
        Spread = active and p.spread or .75},
        .72,
        EASE.Sine)
    tw(__AuraFix_envDOF,
        {FarIntensity = active and p.dofFar or 0,
        NearIntensity = active and p.dofNear or 0,
        FocusDistance = active and p.focus or 50,
        InFocusRadius = active and p.radius or 50},
        .78,
        EASE.Sine)
    tw(envAtmo,
        {Density = atmoGoal.Density,
        Offset = atmoGoal.Offset,
        Haze = atmoGoal.Haze,
        Glare = atmoGoal.Glare,
        Color = atmoGoal.Color,
        Decay = atmoGoal.Decay},
        .85,
        EASE.Sine)
    colorTween.Completed:Connect(function()
        if envApplyToken ~= token then return end
        if not active then
            __AuraFix_envBloom.Enabled = false
            __AuraFix_envColor.Enabled = false
            __AuraFix_envRays.Enabled = false
            __AuraFix_envDOF.Enabled = false
        end
    end)
    for i, b in ipairs(envButtons) do
        if b and b.Parent then tw(b,
            {BackgroundColor3 = i == index and accent or C.card2},
            .32,
            EASE.Quint) end
    end
end

function __AuraFixUtil.selectEnvironmentPreset(index)
    envOn = true
    cfg.envBloom = true
    if ctl.envBloom then ctl.envBloom.Set(true,
        true) end
    __AuraFixUtil.applyEnvironmentPreset(index)
    __AuraFixUtil.toast(T("Активен эффект: ") .. T((envPresets[index] or envPresets[0]).name),
        C.good)
end


-- Ambient effects are authored with native Roblox parts, Trails and Tweens.
-- This keeps them self-contained: no remote code or external model requires.
-- Atmospheric particle effects (meteors, aurora dust, snow, etc.) have been removed.

__AuraFix_pv = __AuraFixUtil.page("Визуал")
__AuraFixUtil.section(__AuraFix_pv,
    "ОТОБРАЖЕНИЕ")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Подсветка игроков",
    true,
    function(v) V.hl = v; __AuraFixUtil.refresh() end,
    "hl")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Рамка игрока",
    true,
    function(v) V.box = v; __AuraFixUtil.refresh() end,
    "box")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Полоса здоровья",
    true,
    function(v) V.health = v; __AuraFixUtil.refresh() end,
    "health")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Трассеры",
    false,
    function(v) V.tracers = v; __AuraFixUtil.refresh() end,
    "tracers")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Скелет",
    false,
    function(v) V.skel = v; __AuraFixUtil.refresh() end,
    "skel")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Имена",
    true,
    function(v) V.names = v; __AuraFixUtil.refresh() end,
    "names")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Дистанция",
    false,
    function(v) V.dist = v; __AuraFixUtil.refresh() end,
    "dist")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Здоровье в имени",
    false,
    function(v) V.healthText = v; __AuraFixUtil.refresh() end,
    "healthText")
__AuraFixUtil.toggle(__AuraFix_pv,
    "Проверка команды",
    false,
    function(v) V.teamCheck = v; __AuraFixUtil.refresh() end,
    "teamCheck")
__AuraFixUtil.slider(__AuraFix_pv,
    "Дальность",
    50,
    1000,
    250,
    function(v) return string.format("%d %s",
    v,
    T("ст.")) end,
    function(v) V.range = v end,
    10,
    "range")
__AuraFixUtil.segment(__AuraFix_pv,
    "Стиль",
    {"Контур",
    "Заливка",
    "Градиент"},
    function(i) V.style = i end,
    1,
    "style")
__AuraFixUtil.section(__AuraFix_pv,
    "ЦВЕТ И ПЛАВНОСТЬ")
__AuraFixUtil.slider(__AuraFix_pv,
    "Яркость ESP",
    25,
    100,
    100,
    function(v) return string.format("%d%%",
    v) end,
    function(v) V.brightness = v / 100 end,
    5,
    "espBrightness")
__AuraFixUtil.slider(__AuraFix_pv,
    "Размер подписей",
    10,
    18,
    13,
    function(v) return string.format("%d px",
    v) end,
    function(v) V.labelSize = v end,
    1,
    "labelSize")
__AuraFixUtil.slider(__AuraFix_pv,
    "Толщина рамки",
    1,
    4,
    1.5,
    function(v) return string.format("%.1f px",
    v) end,
    function(v) V.lineWidth = v end,
    .5,
    "lineWidth")
__AuraFixUtil.slider(__AuraFix_pv,
    "Толщина скелета",
    1,
    4,
    1.5,
    function(v) return string.format("%.1f px",
    v) end,
    function(v) V.skelWidth = v end,
    .5,
    "skelWidth")
__AuraFix_espActions = __AuraFixUtil.row(__AuraFix_pv,
    32)
__AuraFixUtil.button(__AuraFix_espActions,
    "Всё включить",
    function()
	for _, key in ipairs({"hl",
	    "box",
	    "health",
	    "tracers",
	    "skel",
	    "names",
	    "dist",
	    "healthText"}) do
		if ctl[key] then ctl[key].Set(true) end
	end
	__AuraFixUtil.refresh()
	__AuraFixUtil.toast("Включено",
	    C.good)
end,
    true,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.button(__AuraFix_espActions,
    "Всё скрыть",
    function()
	for _, key in ipairs({"hl",
	    "box",
	    "health",
	    "tracers",
	    "skel",
	    "names",
	    "dist",
	    "healthText"}) do
		if ctl[key] then ctl[key].Set(false) end
	end
	__AuraFixUtil.refresh()
	__AuraFixUtil.toast("Выключено",
	    C.warn)
end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))

__AuraFix_pm = __AuraFixUtil.page("Разное")
__AuraFixUtil.section(__AuraFix_pm,
    "ОБЩЕЕ")
__AuraFixUtil.toggle(__AuraFix_pm,
    "Анти-АФК",
    true,
    function(v) afkOn = v end,
    "afk")
__AuraFixUtil.toggle(__AuraFix_pm,
    "Показывать FPS",
    false,
    function(v) V.fps = v; __AuraFixUtil.showFps(v) end,
    "fps")
__AuraFixUtil.toggle(__AuraFix_pm,
    "Авто-перезаход",
    false,
    function(v) rejoinOn = v end,
    "rejoin")
__AuraFixUtil.slider(__AuraFix_pm,
    "Поле зрения",
    50,
    120,
    70,
    function(v) return string.format("%.0f°",
    v) end,
    function(v) fovT = v; fovOn = true end,
    1,
    "fov")
__AuraFixUtil.segment(__AuraFix_pm,
    "Язык",
    {"Русский",
    "English",
    "Español"},
    setLang,
    1,
    "lang")
__AuraFix_cr = __AuraFixUtil.row(__AuraFix_pm,
    32)
__AuraFix_half = UDim2.new(.5,
    -3,
    1,
    0)
__AuraFixUtil.button(__AuraFix_cr,
    "Сохранить конфиг",
    function()
	local ok = __AuraFixUtil.saveCfg()
	__AuraFixUtil.toast(ok and "Конфиг сохранён" or "Сохранение недоступно",
	    ok and C.good or C.bad)
end,
    true,
    __AuraFix_half)
__AuraFixUtil.button(__AuraFix_cr,
    "Загрузить конфиг",
    function()
	if __AuraFixUtil.loadCfg() then
		for k, o in pairs(ctl) do if cfg[k] ~= nil then o.Set(cfg[k]) end end
		rainbow = cfg.rainbow == true
		if rainbow then __AuraFixUtil.mark(7)
		elseif type(cfg.accent) == "table" and cfg.accent[3] then __AuraFixUtil.setAccent(Color3.new(cfg.accent[1],
		    cfg.accent[2],
		    cfg.accent[3]),
		    0) end
		__AuraFixUtil.toast("Конфиг загружен",
		    C.good)
	else
		__AuraFixUtil.toast("Конфиг не найден",
		    C.bad)
	end
end,
    false,
    __AuraFix_half)

__AuraFix_ps = __AuraFixUtil.page("Настройки")
__AuraFixUtil.section(__AuraFix_ps,
    "ЦВЕТ АКЦЕНТА")
__AuraFix_swc = __AuraFixUtil.card(__AuraFix_ps,
    46)
__AuraFixUtil.new("UIListLayout",
    {FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0,
    10)},
    __AuraFix_swc)
for k, col in ipairs(cols) do
	local b = __AuraFixUtil.new("TextButton",
	    {Text = "",
	    AutoButtonColor = false,
	    BackgroundColor3 = col,
	    Size = UDim2.fromOffset(26,
	    26)},
	    __AuraFix_swc)
	__AuraFixUtil.round(b,
	    13); __AuraFixUtil.press(b,
	    true)
	swb[k] = {S = __AuraFixUtil.stroke(b,
	    2,
	    WHITE,
	    1)}
	cn(b.Activated,
	    function() rainbow = false; cfg.rainbow = false; __AuraFixUtil.setAccent(col,
	    k); __AuraFixUtil.toast("Акцент изменён") end)
end
__AuraFix_rb = __AuraFixUtil.new("TextButton",
    {Text = "",
    AutoButtonColor = false,
    BackgroundColor3 = WHITE,
    Size = UDim2.fromOffset(26,
    26)},
    __AuraFix_swc)
__AuraFixUtil.round(__AuraFix_rb,
    13); __AuraFixUtil.press(__AuraFix_rb,
    true)
__AuraFixUtil.new("UIGradient",
    {Rotation = 45,
    Color = ColorSequence.new({ColorSequenceKeypoint.new(0,
    Color3.fromRGB(255,
    80,
    80)),
    ColorSequenceKeypoint.new(.33,
    Color3.fromRGB(80,
    255,
    120)),
    ColorSequenceKeypoint.new(.66,
    Color3.fromRGB(80,
    140,
    255)),
    ColorSequenceKeypoint.new(1,
    Color3.fromRGB(255,
    80,
    200))})},
    __AuraFix_rb)
swb[7] = {S = __AuraFixUtil.stroke(__AuraFix_rb,
    2,
    WHITE,
    1)}
cn(__AuraFix_rb.Activated,
    function()
	rainbow = not rainbow
	cfg.rainbow = rainbow
	if rainbow then __AuraFixUtil.mark(7) else __AuraFixUtil.mark(0) end
	__AuraFixUtil.toast(rainbow and "Радужный режим" or "Радуга выключена")
end)
do
	local sel = 0
	for k, c in ipairs(cols) do
		if (c.R - accent.R) ^ 2 + (c.G - accent.G) ^ 2 + (c.B - accent.B) ^ 2 < 1e-4 then sel = k end
	end
	__AuraFixUtil.mark(rainbow and 7 or sel)
end
__AuraFixUtil.slider(__AuraFix_ps,
    "Оттенок",
    0,
    360,
    (accent:ToHSV()) * 360,
    function(v) return string.format("%.0f°",
    v) end,
    function(v)
	rainbow = false; cfg.rainbow = false
	__AuraFixUtil.setAccent(Color3.fromHSV(v / 360,
	    .65,
	    1),
	    0,
	    true)
end,
    1)
__AuraFixUtil.section(__AuraFix_ps,
    "ОКНО")
__AuraFixUtil.slider(__AuraFix_ps,
    "Прозрачность",
    0,
    50,
    0,
    function(v) return string.format("%.0f%%",
    v) end,
    function(v)
	baseGT = v / 100
	if opened then tw(main,
	    {GroupTransparency = baseGT},
	    .2) end
end,
    1,
    "gt")
__AuraFixUtil.slider(__AuraFix_ps,
    "Размер меню",
    60,
    130,
    baseScale * 100,
    function(v) return string.format("%.0f%%",
    v) end,
    function(v)
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(800,
	    400)
	-- Let the user both shrink and enlarge the menu. Larger values may
	-- extend beyond the viewport on very small screens, but remain user-controlled.
	baseScale = math.clamp(v / 100, .52, 1.30)
	tw(mscale,
	    {Scale = baseScale},
	    .32,
	    EASE.Quint)
	startPos = UDim2.new(.5,
	    0,
	    0,
	    math.max(6,
	    (size.Y - WIN_H * baseScale) / 2))
end,
    5,
    "size")
__AuraFixUtil.toggle(__AuraFix_ps,
    "Размытие фона",
    true,
    function(v)
	blurOn = v
	if opened then tw(blur,
	    {Size = v and 14 or 0},
	    .3) end
end,
    "blur")
__AuraFix_settingsQuick = __AuraFixUtil.row(__AuraFix_ps,
    32)
__AuraFixUtil.button(__AuraFix_settingsQuick,
    "Сбросить позицию",
    function() tw(holder,
    {Position = startPos},
    .6,
    EASE.Back) end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.button(__AuraFix_settingsQuick,
    "Сбросить конфиг",
    function()
	cfg = {}
	rainbow = false
	for _, control in pairs(ctl) do
		if control.Default ~= nil and control.Set then pcall(function() control.Set(control.Default) end) end
	end
	cfg.rainbow = false
	-- Reset the visual preset as well as standard toggles so effects do not linger.
	envPreset,
	    envOn,
	    envStrength = 0,
	    false,
	    60
	cfg.envPreset,
	    cfg.envBloom,
	    cfg.envBloomStrength = 0,
	    false,
	    60
	if ctl.envBloom then ctl.envBloom.Set(false,
	    true) end
	if ctl.envBloomStrength then ctl.envBloomStrength.Set(60,
	    true) end
	__AuraFixUtil.applyEnvironmentPreset(0)
	__AuraFixUtil.setAccent(Color3.fromRGB(130,
	    100,
	    255),
	    1)
	pcall(__AuraFixUtil.saveCfg)
	__AuraFixUtil.toast("Всё сброшено",
	    C.warn)
end,
    false,
    UDim2.new(.5,
    -3,
    1,
    0))
__AuraFixUtil.section(__AuraFix_ps,
    "ИНФОРМАЦИЯ О ПЛЕЕРЕ")
__AuraFix_aboutCard = __AuraFixUtil.card(__AuraFix_ps,
    56)
__AuraFix_aboutOrb = __AuraFixUtil.new("Frame",
    {Position = UDim2.fromOffset(10,
    10),
    Size = UDim2.fromOffset(36,
    36),
    BackgroundColor3 = accent},
    __AuraFix_aboutCard)
__AuraFixUtil.round(__AuraFix_aboutOrb,
    18)
__AuraFixUtil.new("UIGradient",
    {Rotation = 45,
    Color = ColorSequence.new(__AuraFixUtil.light(accent),
    __AuraFixUtil.dark(accent))},
    __AuraFix_aboutOrb)
__AuraFixUtil.lbl(__AuraFix_aboutOrb,
    "A",
    18,
    WHITE,
    {TextXAlignment = Enum.TextXAlignment.Center,
    Font = Enum.Font.GothamBlack})
__AuraFixUtil.lbl(__AuraFix_aboutCard,
    lp.DisplayName,
    12,
    C.text,
    {Position = UDim2.fromOffset(56,
    8),
    Size = UDim2.new(1,
    -66,
    0,
    18),
    Font = Enum.Font.GothamBold})
__AuraFixUtil.lbl(__AuraFix_aboutCard,
    "@" .. lp.Name .. " · " .. tostring(lp.UserId),
    10,
    C.sub,
    {Position = UDim2.fromOffset(56,
    27),
    Size = UDim2.new(1,
    -66,
    0,
    16)})
__AuraFixUtil.button(__AuraFix_ps,
    "Выгрузить меню",
    function() __AuraFixUtil.setOpen(false); task.delay(.4,
    __AuraFixUtil.unload) end)

__AuraFix_tabBtns, __AuraFix_cur, __AuraFix_tok = {}, nil, nil
__AuraFix_ind = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(1,
    0,
    0,
    32),
    BackgroundTransparency = .8},
    side)
__AuraFixUtil.round(__AuraFix_ind,
    8); __AuraFixUtil.acc(__AuraFix_ind,
    "BackgroundColor3")
__AuraFix_ibar = __AuraFixUtil.new("Frame",
    {Size = UDim2.new(0,
    3,
    .6,
    0),
    AnchorPoint = Vector2.new(0,
    .5),
    Position = UDim2.new(0,
    4,
    .5,
    0)},
    __AuraFix_ind)
__AuraFixUtil.round(__AuraFix_ibar,
    2); __AuraFixUtil.acc(__AuraFix_ibar,
    "BackgroundColor3")

function __AuraFix_popIn(name)
	local n = 0
	for _, c in ipairs(pages[name]:GetChildren()) do
		if c:IsA("GuiObject") and c.Visible then
			n += 1
			if n > 9 then break end
			local sc = c:FindFirstChild("Pop") or __AuraFixUtil.new("UIScale",
			    {Name = "Pop"},
			    c)
			sc.Scale = .94
			task.delay(n * .022,
			    function() if c.Parent and pages[name].Visible then tw(sc,
			    {Scale = 1},
			    .46,
			    EASE.Quint) end end)
		end
	end
end

function __AuraFix_selectTab(name,
    instant)
	if __AuraFix_cur == name then return end
	__AuraFix_cur = name
	local my = {}
	__AuraFix_tok = my
	for n, b in pairs(__AuraFix_tabBtns) do tw(b,
	    {TextColor3 = n == name and C.text or C.sub},
	    .25) end
	tw(__AuraFix_ind,
	    {Position = UDim2.fromOffset(0,
	    (table.find(order,
	    name) - 1) * 36)},
	    .4,
	    EASE.Back)
	local function swap() for n, p in pairs(pages) do p.Visible = n == name end end
	if instant then swap(); __AuraFix_popIn(name) return end
	task.spawn(function()
		tw(content,
		    {GroupTransparency = 1,
		    Position = CPOS + UDim2.fromOffset(0,
		    8)},
		    .14).Completed:Wait()
		if __AuraFix_tok ~= my then return end
		swap()
		content.Position = CPOS - UDim2.fromOffset(0,
		    8); __AuraFix_popIn(name)
		tw(content,
		    {GroupTransparency = 0,
		    Position = CPOS},
		    .34,
		    EASE.Quint)
	end)
end

__AuraFix_tabGlyphs = { ["Музыка"] = "♫",
    ["Эффекты"] = "✦",
    ["Визуал"] = "◈",
    ["Разное"] = "◌",
    ["Настройки"] = "⚙" }
for i, name in ipairs(order) do
	local b = __AuraFixUtil.new("TextButton",
	    {Font = Enum.Font.GothamBold,
	    TextSize = 12,
	    TextColor3 = C.sub,
	    TextXAlignment = Enum.TextXAlignment.Left,
	    BackgroundTransparency = 1,
	    AutoButtonColor = false,
	    Position = UDim2.fromOffset(0,
	    (i - 1) * 36),
	    Size = UDim2.new(1,
	    0,
	    0,
	    32)},
	    side)
	bind(b,
	    name)
	__AuraFixUtil.new("UIPadding",
	    {PaddingLeft = UDim.new(0,
	    31)},
	    b)
	local glyph = __AuraFixUtil.new("TextLabel",
	    {BackgroundTransparency = 1,
	    Font = Enum.Font.GothamBold,
	    TextSize = 16,
	    TextColor3 = C.sub,
	    Text = __AuraFix_tabGlyphs[name] or "•",
	    Position = UDim2.fromOffset(8,
	    0),
	    Size = UDim2.fromOffset(18,
	    32),
	    TextXAlignment = Enum.TextXAlignment.Center},
	    side)
	__AuraFixUtil.acc(glyph,
	    "TextColor3",
	    function() return __AuraFix_cur == name and accent or C.sub end)
	__AuraFix_tabBtns[name] = b
	cn(b.Activated,
	    function() __AuraFix_selectTab(name) end)
	cn(b.MouseEnter,
	    function()
		if __AuraFix_cur ~= name then
			tw(b,
			    {TextColor3 = C.text:Lerp(C.sub,
			    .45)},
			    .2)
			tw(glyph,
			    {TextColor3 = accent},
			    .2)
		end
	end)
	cn(b.MouseLeave,
	    function()
		tw(b,
		    {TextColor3 = __AuraFix_cur == name and C.text or C.sub},
		    .25)
		tw(glyph,
		    {TextColor3 = __AuraFix_cur == name and accent or C.sub},
		    .25)
	end)
end

cn(sound.Ended,
    function()
	if sound.Looped then return end
	endedF = true
	if queueAutoPlay and #queueItems > 0 then
		task.delay(.15,
		    function()
			if not sound.IsPlaying and #queueItems > 0 and gui.Parent then
				local nextItem = table.remove(queueItems,
				    1)
				__AuraFix_renderQueue()
				box.Text = nextItem.id
				play(nextItem.id)
			end
		end)
	end
end)
cn(UIS.InputBegan,
    function(i,
    gp)
	if not gp and i.KeyCode == Enum.KeyCode.RightShift then __AuraFixUtil.setOpen(not opened) end
end)

__AuraFix_spinV = 0
RS:BindToRenderStep("AuraMenuLoop",
    Enum.RenderPriority.Camera.Value + 1,
    function(dt)
	local t = os.clock()
	if rainbow then
		hue = (hue + dt * .2) % 1
		accent = Color3.fromHSV(hue,
		    .65,
		    1)
		for _, f in ipairs(reg) do f(true) end
	end
	if fovOn then
		local c = workspace.CurrentCamera
		if c then c.FieldOfView += (fovT - c.FieldOfView) * math.min(1,
		    dt * 8) end
	end
	if espAny or espWas then __AuraFixUtil.updateESP(t) end
	espWas = espAny
	if V.fps then
		fpsA += dt; fpsN += 1
		if fpsA >= .4 then
			local f = math.floor(fpsN / fpsA + .5)
			fpsA,
			    fpsN = 0,
			    0
			local ok, ping = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
			local statusColor = f >= 50 and C.good or (f >= 30 and Color3.fromRGB(255,
			    190,
			    70) or C.bad)
			fpsL.Text = f .. " FPS · " .. (ok and math.floor(ping + .5) .. " ms" or "-- ms")
			tw(fpsD,
			    {BackgroundColor3 = statusColor,
			    Size = UDim2.fromOffset(9,
			    9)},
			    .12,
			    EASE.Sine)
		task.delay(.13,
		    function() if fpsD.Parent then tw(fpsD,
		    {Size = UDim2.fromOffset(8,
		    8)},
		    .22,
		    EASE.Back) end end)
			tw(fpsStroke,
			    {Color = statusColor,
			    Transparency = .23},
			    .18,
			    EASE.Sine)
			fpsS.Scale = 1.035
			tw(fpsS,
			    {Scale = 1},
			    .25,
			    EASE.Back,
			    DIR.Out)
			tw(fpsAura,
			    {BackgroundColor3 = statusColor},
			    .24,
			    EASE.Sine)
		end
	end

	local playing = sound.IsPlaying
    -- PlaybackLoudness is Roblox's available client-side amplitude meter (not a true FFT).
    local rawLoud = playing and math.clamp(sound.PlaybackLoudness / 420,
        0,
        1) or 0
    __AuraFix_audioMeter = __AuraFix_audioMeter or {prev = 0,
        low = 0,
        mid = 0,
        high = 0,
        beat = 0,
        flux = 0}
    local meter = __AuraFix_audioMeter
    local attack = math.max(0,
        rawLoud - meter.prev)
    meter.low += (rawLoud - meter.low) * math.min(1,
        dt * 3.2)
    meter.mid += (rawLoud - meter.mid) * math.min(1,
        dt * 8.5)
    meter.high += (rawLoud - meter.high) * math.min(1,
        dt * 17)
    meter.flux += ((attack * 2.2) - meter.flux) * math.min(1,
        dt * 12)
    meter.beat = math.max(0,
        meter.beat - dt * 2.8)
    if attack > .075 and rawLoud > .12 then meter.beat = math.clamp(attack * 5.5,
        .18,
        1) end
    meter.prev = rawLoud
    local loud = math.clamp(meter.low * .35 + meter.mid * .4 + meter.high * .25 + meter.beat * .18,
        0,
        1)
	-- Original Aurora mode: slow hue drift and a restrained glow pulse, only while enabled.
    if envOn and envPreset == 6 and envStrength > 0 then
        if envSkyIsActive and envSky.Parent == Lighting then
            local skyRotation = envSky.SkyboxOrientation.Y + math.max(0,
                dt) * 1.8
            envSky.SkyboxOrientation = Vector3.new(0,
                skyRotation % 360,
                0)
        end
        envPhase += math.max(0,
            dt) * .22
        envTick += dt
        if envTick >= (1 / 30) then
            envTick = 0
            local wave = (math.sin(envPhase * 1.9) + 1) * .5
            local wave2 = (math.sin(envPhase * 1.27 + 1.4) + 1) * .5
            local hueNow = (.44 + wave * .34 + wave2 * .08) % 1
            __AuraFix_envColor.TintColor = Color3.fromHSV(hueNow,
                .14 + wave * .17,
                1)
            __AuraFix_envColor.Saturation = .10 + wave * .14
            __AuraFix_envBloom.Intensity = math.clamp(envBaseBloom * envStrength / 60 * (.88 + wave * .22),
                0,
                .8)
            __AuraFix_envRays.Intensity = .018 + wave2 * .018
            envAtmo.Color = Color3.fromHSV((hueNow + .02) % 1,
                .35,
                1)
            envAtmo.Decay = Color3.fromHSV((hueNow + .14) % 1,
                .42,
                .58)
        end
    end
	if not main.Visible then return end
	for k, m in ipairs(mini) do
		local target = playing and 3 + (.5 + .5 * math.sin(t * (6 + k * 1.7) + k)) * 9 * (.4 + loud * .6) or 3
		m.h += (target - m.h) * .25
		m.f.Size = UDim2.fromOffset(4,
		    math.floor(m.h + .5))
	end
	if not pages["Музыка"].Visible then return end
	for n, b in ipairs(__AuraFix_bars) do
        local x = (n - 1) / math.max(1,
            #__AuraFix_bars - 1)
        -- Approximate bands from the loudness envelope; Roblox exposes no per-frequency FFT bins.
        local bass = meter.low * (1 - x * .68)
        local midBand = meter.mid * (1 - math.abs(x - .5) * 1.25)
        local treble = meter.high * (.22 + x * .78)
        local ripple = math.abs(math.sin(t * (2.2 + x * 5.5) + n * .63))
        local texture = math.abs(math.sin(t * 1.7 + n * .29) * math.cos(t * 3.1 + n * .17))
        local response = bass * .82 + midBand * .55 + treble * .48 + meter.flux * (.2 + x * .55)
        if visualizerStyle == 2 then
            response = bass * .38 + midBand * .52 + treble * .9 + meter.flux * .75
        elseif visualizerStyle == 3 then
            response = bass * .55 + midBand * .85 + treble * .42 + ripple * meter.beat * .8
        end
        local target = playing and math.clamp(response * (.55 + ripple * .45) + texture * meter.beat * .22,
            0,
            1) or 0
        local easeRate = target > b.h and (18 + meter.flux * 20) or 7.5
        b.h += (target - b.h) * (1 - math.exp(-dt * easeRate))
        b.p = math.max(b.h,
            b.p - dt * (1.8 + meter.high * 3))
        b.f.Size = UDim2.new(1 / 28,
            -3,
            0,
            3 + b.h * 42)
        b.c.Position = UDim2.new((n - 1) / 28,
            2,
            1,
            -11 - b.p * 42)
    end
	__AuraFix_spinV += ((playing and 150 or 0) - __AuraFix_spinV) * math.min(1,
	    dt * 3)
	__AuraFix_vinyl.Rotation = (__AuraFix_vinyl.Rotation + __AuraFix_spinV * dt) % 360
	__AuraFix_vs.Thickness = musicAccentPulse and (2 + loud * 3) or 2
	local len = sound.TimeLength
	if not prog.Dragging then prog.Set(len > 0 and sound.TimePosition / len or 0,
	    true,
	    true) end
	local want = T(playing and "Пауза" or "Играть")
	if pauseB.Text ~= want then pauseB.Text = want end
	if trackOK then
		local s = playing and "Играет" or (sound.IsPaused and "На паузе" or (endedF and "Трек закончился" or "Остановлено"))
		s = T(s)
		if statusL.Text ~= s then __AuraFixUtil.setStatus(s,
		    playing and C.good or C.sub) end
	end
end)

-- Finalize the menu after all original widgets have been constructed.

__AuraFixUtil.applyEnvironmentPreset(envPreset)
__AuraFix_selectTab(order[1], true)
__AuraFixUtil.setOpen(true)
task.delay(.9, function() __AuraFixUtil.toast("AURA загружено") end)
