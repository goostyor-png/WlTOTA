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
	    ["Мини-помощник"] = "Mini assistant",
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
        ["Мини-помощник"]="Mini asistente",
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

local function __AuraBuildAI()
--[[
    AURA AI / Lightweight Hybrid Helper
    -----------------------------------
    Starts with local multilingual knowledge, then optionally looks up unfamiliar
    unfamiliar terms in Roblox Developer Forum when a supported HTTP transport is available.
    No neural-model API key is required. Recent conversation memory is intentionally small.
]]
local aiHistory = {}
local aiLastTopic = nil
local aiOpen = false
local aiBusy = false
local aiMessageCount = 0
local aiMaxMemory = 8
local aiTopics = {
    music = {
        keys={"музык",
            "плеер",
            "трек",
            "music",
            "player",
            "song",
            "reproductor",
            "música",
            "canción",
            "pista"},
            ru={"Вкладка «Музыка» — это встроенный аудиоплеер. Вставь числовой ID аудио, нажми «Играть», а затем управляй паузой, перемоткой, громкостью и повтором.",
            "Плеер работает с аудио по ID. В этой вкладке также есть управление скоростью и тональностью, пресеты звука и очередь треков."},
            en={"The Music tab is the built-in audio player. Enter a numeric audio ID, press Play, then control pause, seeking, volume, and repeat.",
            "The player uses audio IDs. The same tab also contains speed and pitch controls, sound presets, and a track queue."},
            es={"La pestaña Música es el reproductor integrado. Introduce un ID de audio numérico, pulsa Reproducir y controla la pausa, la búsqueda, el volumen y la repetición.",
            "El reproductor utiliza IDs de audio. También incluye velocidad, tono, preajustes de sonido y una cola de pistas."},
            tip={ru="Если ID не загружается, он может быть неверным, закрытым или недоступным в текущем клиенте.",
            en="If an ID fails to load, it may be invalid, private, or unavailable in the current client.",
            es="Si no se carga un ID, puede ser incorrecto, privado o no estar disponible en el cliente actual."}
    },
        queue = {
        keys={"очеред",
            "queue",
            "cola",
            "следующ",
            "next track"},
            ru={"Очередь хранит треки, которые ты добавил для последующего воспроизведения. Можно запускать элемент сразу, удалять отдельные записи и очищать список.",
            "Очередь нужна, чтобы собрать несколько аудио заранее: добавляй ID, меняй текущий трек и убирай ненужные элементы."},
            en={"The queue keeps tracks you want to play later. You can start an item immediately, remove individual entries, or clear the list.",
            "Use the queue to line up several audio IDs in advance, switch the current track, and remove items you no longer need."},
            es={"La cola guarda las pistas para reproducirlas después. Puedes iniciar un elemento, eliminar entradas individuales o vaciar la lista.",
            "Usa la cola para preparar varios IDs de audio, cambiar de pista y quitar elementos que ya no necesites."},
            tip={ru="Добавление в очередь не означает, что аудио обязательно доступно для воспроизведения.",
            en="Adding a track does not guarantee the audio is available for playback.",
            es="Añadir una pista no garantiza que el audio esté disponible para reproducirse."}
    },
        eq = {
        keys={"эквалайзер",
            "equaliz",
            "ecualizador",
            "бас",
            "graves",
            "bass",
            "низк",
            "mid",
            "средн",
            "agudos",
            "treble",
            "высок"},
            ru={"Эквалайзер меняет баланс низких, средних и высоких частот. Бас добавляет вес низам, средние помогают голосам и мелодиям, а высокие влияют на детализацию.",
            "В блоке эквалайзера регулируются три диапазона частот. Начни с небольших изменений и сбрось значения, если звук стал резким или мутным."},
            en={"The equalizer changes the balance of low, mid, and high frequencies. Bass adds weight, mids shape voices and melodies, and highs affect detail.",
            "The EQ has three frequency bands. Make small adjustments first and reset them if the sound becomes harsh or muddy."},
            es={"El ecualizador cambia el equilibrio de graves, medios y agudos. Los graves aportan cuerpo, los medios afectan voces y melodías y los agudos añaden detalle.",
            "El ecualizador tiene tres bandas. Haz cambios pequeños y restablece los valores si el sonido se vuelve áspero o apagado."},
            tip={ru="Изменяй по одному диапазону за раз — так проще понять результат.",
            en="Change one band at a time so you can hear what it does.",
            es="Cambia una banda cada vez para notar mejor el efecto."}
    },
        speed = {
        keys={"скорост",
            "speed",
            "velocidad",
            "тональ",
            "pitch",
            "tono",
            "замедл",
            "slowed",
            "ralentiz"},
            ru={"Скорость меняет темп воспроизведения. Ползунок тональности корректирует высоту звука, а переключатель связи позволяет изменять тон вместе со скоростью.",
            "Скорость отвечает за темп, а тональность — за высоту звука. Если включена связь тона со скоростью, изменение темпа будет влиять и на звучание."},
            en={"Speed changes playback tempo. Pitch adjusts how high or low the audio sounds; the linked-pitch option lets pitch follow speed changes.",
            "Speed controls tempo, while pitch controls perceived note height. When linked, changing speed also changes the pitch."},
            es={"La velocidad cambia el tempo. El tono ajusta qué tan grave o agudo suena el audio; la opción vinculada hace que siga los cambios de velocidad.",
            "La velocidad controla el tempo y el tono controla la altura sonora. Si están vinculados, cambiar la velocidad también cambia el tono."},
            tip={ru="Для естественного звучания лучше менять скорость небольшими шагами.",
            en="For a more natural result, adjust speed in small steps.",
            es="Para obtener un sonido más natural, cambia la velocidad poco a poco."}
    },
        volume = {
        keys={"громк",
            "volume",
            "gain",
            "усиление",
            "loudness",
            "volumen",
            "ganancia",
            "тихо",
            "громко"},
            ru={"Громкость меняет общий уровень воспроизведения, а усиление добавляет уровень аудиосигнала. Если звук начинает хрипеть или становится слишком резким, уменьши усиление.",
            "Громкость — это насколько громко звучит трек, а gain (усиление) дополнительно поднимает уровень сигнала. Большое усиление не улучшает качество автоматически и иногда даёт искажения."},
            en={"Volume sets the overall playback level, while gain boosts the audio signal. If the sound becomes harsh or distorted, lower the gain.",
            "Volume controls how loud the track plays; gain adds extra signal level. More gain does not automatically mean better quality and can introduce distortion."},
            es={"El volumen ajusta el nivel general de reproducción y la ganancia amplifica la señal de audio. Si el sonido se vuelve áspero o distorsionado, reduce la ganancia.",
            "El volumen controla lo fuerte que suena la pista; la ganancia añade nivel de señal. Más ganancia no significa automáticamente más calidad y puede causar distorsión."},
            tip={ru="Сначала настрой комфортную громкость, а усиление меняй небольшими шагами.",
            en="Set a comfortable volume first, then adjust gain in small steps.",
            es="Primero ajusta un volumen cómodo y después cambia la ganancia poco a poco."}
    },
        reverb = {
        keys={"реверб",
            "reverb",
            "reverber",
            "эхо",
            "echo",
            "eco",
            "простран",
            "space",
            "espacio"},
            ru={"Реверберация добавляет отражения, словно звук звучит в помещении. Эхо повторяет звук с задержкой. Слишком большие значения могут сделать аудио неразборчивым.",
            "Реверберация создаёт ощущение пространства, а эхо добавляет отдельные повторы. Их параметры позволяют менять длительность и выраженность эффекта."},
            en={"Reverb adds reflections, making audio feel as if it is in a room. Echo repeats the sound after a delay. Too much of either can reduce clarity.",
            "Reverb creates a sense of space, while echo adds distinct repeats. Their controls adjust how long and how strongly the effects are heard."},
            es={"La reverberación añade reflejos y hace que el audio parezca sonar en una sala. El eco repite el sonido con retraso. Un exceso puede reducir la claridad.",
            "La reverberación crea sensación de espacio y el eco añade repeticiones claras. Sus controles ajustan la duración y la intensidad."},
            tip={ru="Начни с небольшого уровня эффекта и увеличивай его по слуху.",
            en="Start with a subtle effect and increase it by ear.",
            es="Empieza con un efecto sutil y aumenta la intensidad de oído."}
    },
        esp = {
        keys={"esp",
            "подсвет",
            "рамк",
            "box",
            "health bar",
            "полос.*здоров",
            "трассер",
            "tracer",
            "скелет",
            "skeleton",
            "esqueleto",
            "имен",
            "nombres",
            "team check",
            "команд",
            "здоровье в имени",
            "visual"},
            ru={"Вкладка «Визуал» содержит отдельные оверлеи: подсветку, рамку, полосу здоровья, трассеры, скелет, имена и дистанцию. Их можно включать независимо и настраивать дальность, стиль и размеры.",
            "Здесь настраиваются визуальные обозначения игроков. Отключай ненужные элементы отдельно, меняй дальность и толщину, а проверка команды позволяет учитывать принадлежность к команде, если игра её предоставляет."},
            en={"The Visuals tab contains separate overlays: highlight, player box, health bar, tracers, skeleton, names, and distance. You can toggle them independently and tune range, style, and sizing.",
            "This page configures player visual indicators. Disable any elements you do not need, adjust range and thickness, and use team check where the game exposes team information."},
            es={"La pestaña Visuales contiene indicadores separados: resaltado, caja del jugador, barra de salud, trazadores, esqueleto, nombres y distancia. Puedes activarlos por separado y ajustar alcance y estilo.",
            "Esta página configura indicadores visuales de jugadores. Desactiva lo que no necesites, ajusta el alcance y el grosor y usa la comprobación de equipo cuando el juego proporcione esa información."},
            tip={ru="Чем больше оверлеев и чем выше дальность, тем больше может быть нагрузка. Отключай то, чем не пользуешься.",
            en="More overlays and longer ranges can increase workload. Disable anything you do not use.",
            es="Más indicadores y mayor alcance pueden aumentar la carga. Desactiva los que no utilices."}
    },
        fps = {
        keys={"fps",
            "кадр",
            "frame rate",
            "rendimiento",
            "производительност"},
            ru={"Счётчик FPS показывает приблизительную частоту кадров. Он полезен, чтобы заметить, когда меню или визуальные эффекты сопровождаются падением плавности.",
            "FPS — это количество кадров в секунду. Более высокое значение обычно означает более плавное изображение, но стабильность важна не меньше пикового числа."},
            en={"The FPS counter shows an approximate frame rate. It helps you notice when the menu or visual effects coincide with a drop in smoothness.",
            "FPS means frames per second. A higher number usually looks smoother, but consistency matters as much as the peak value."},
            es={"El contador FPS muestra una frecuencia de fotogramas aproximada. Ayuda a notar cuándo el menú o los efectos coinciden con una pérdida de fluidez.",
            "FPS significa fotogramas por segundo. Un valor mayor suele verse más fluido, pero la estabilidad también importa."},
            tip={ru="Если плавность падает, попробуй выключить лишние визуальные элементы и уменьшить дальность.",
            en="If performance drops, try disabling extra overlays and reducing their range.",
            es="Si baja el rendimiento, desactiva indicadores adicionales y reduce su alcance."}
    },
        afk = {
        keys={"анти-афк",
            "анти афк",
            "anti-afk",
            "anti afk",
            "afk",
            "автоматически бездейств"},
            ru={"Анти-АФК предназначен для уменьшения риска автоматического отключения за бездействие. Поведение зависит от ограничений игры и текущего клиента.",
            "Этот переключатель относится к защите от простоя. Он не гарантирует, что конкретная игра не отключит игрока по собственным правилам."},
            en={"Anti-AFK is intended to reduce the chance of being disconnected for inactivity. Its behavior depends on the game and client restrictions.",
            "This switch relates to inactivity prevention. It cannot guarantee that a particular game will not disconnect you under its own rules."},
            es={"Anti-AFK intenta reducir el riesgo de desconexión por inactividad. Su comportamiento depende del juego y de las limitaciones del cliente.",
            "Esta opción está relacionada con la prevención de inactividad. No garantiza que un juego no te desconecte por sus propias reglas."},
            tip={ru="Не считай переключатель гарантией от любых отключений.",
            en="Do not treat the toggle as a guarantee against every disconnect.",
            es="No consideres esta opción una garantía contra cualquier desconexión."}
    },
        fov = {
        keys={"fov",
            "поле зрения",
            "field of view",
            "campo de visión",
            "угол обзора"},
            ru={"Поле зрения меняет угол обзора камеры. Более широкое значение показывает больше пространства по краям, но может сильнее искажать перспективу.",
            "Этот ползунок меняет FOV камеры. Выбери комфортное значение: большое FOV расширяет обзор, а меньшее делает картинку более приближённой."},
            en={"Field of view changes the camera angle. A wider value shows more at the edges but can distort perspective more strongly.",
            "This slider changes camera FOV. Choose a comfortable value: larger FOV widens the view, while smaller FOV feels more zoomed-in."},
            es={"El campo de visión cambia el ángulo de la cámara. Un valor amplio muestra más por los bordes, pero puede distorsionar más la perspectiva.",
            "Este control cambia el FOV de la cámara. Elige un valor cómodo: uno mayor amplía la vista y uno menor parece más acercado."},
            tip={ru="Если изображение выглядит слишком растянуто, вернись к более умеренному значению.",
            en="If the image looks too stretched, return to a more moderate value.",
            es="Si la imagen parece demasiado estirada, vuelve a un valor más moderado."}
    },
        environment = {
        keys={"эффект окруж",
            "environment",
            "entorno",
            "окружение",
            "свечение",
            "bloom",
            "brillo",
            "пресет",
            "preset",
            "preajuste",
            "cinematic",
            "кино"},
            ru={"Вкладка «Эффекты» меняет атмосферу изображения через цветокоррекцию, мягкое свечение и пресеты окружения. Эти параметры не являются физическими объектами в мире и могут отображаться по-разному в разных играх.",
            "Эффекты окружения — это визуальные настройки освещения и цвета. Пресеты дают быстрый старт, а сила эффекта помогает сделать оформление мягче или выразительнее."},
            en={"The Effects tab changes the scene's look with color grading, soft bloom, and environment presets. These settings may appear differently across games.",
            "Environment effects adjust lighting and color. Presets provide a starting point, and effect strength controls how subtle or pronounced the result looks."},
            es={"La pestaña Efectos cambia el aspecto de la escena mediante corrección de color, brillo suave y preajustes del entorno. El resultado puede variar entre juegos.",
            "Los efectos del entorno ajustan la iluminación y el color. Los preajustes sirven como punto de partida y la intensidad controla lo sutil o marcado del resultado."},
            tip={ru="Если цвет стал слишком сильным, выбери более мягкий пресет или сбрось эффект.",
            en="If the color becomes too strong, choose a softer preset or reset the effect.",
            es="Si el color queda demasiado intenso, elige un preajuste suave o restablece el efecto."}
    },
        language = {
        keys={"язык",
            "language",
            "idioma",
            "español",
            "испанск",
            "english",
            "русск"},
            ru={"Язык меняется во вкладке «Разное». Поддерживаются русский, English и Español; выбор сохраняется в конфигурации, если файловое сохранение доступно.",
            "Открой «Разное» → «Язык» и выбери один из трёх вариантов. Надписи обновятся сразу, а языковые настройки сохраняются вместе с конфигом при поддержке файловой системы."},
            en={"Change the language in Misc → Language. Russian, English, and Spanish are supported; the choice is saved when file saving is available.",
            "Open Misc → Language and select one of the three options. Labels update immediately, and the choice is stored with the config when filesystem access is supported."},
            es={"Cambia el idioma en Varios → Idioma. Se admiten ruso, inglés y español; la elección se guarda si está disponible el almacenamiento de archivos.",
            "Abre Varios → Idioma y selecciona una de las tres opciones. Las etiquetas se actualizan al instante y la elección se guarda con la configuración si el cliente lo permite."},
            tip={ru="Если часть надписей не перевелась, это может быть текст, добавленный сторонней игрой, а не меню.",
            en="If some text remains untranslated, it may belong to the game rather than this menu.",
            es="Si queda algún texto sin traducir, puede pertenecer al juego y no a este menú."}
    },
        config = {
        keys={"конфиг",
            "config",
            "configuración",
            "guardar",
            "save settings",
            "загрузить конфиг"},
            ru={"Кнопки сохранения и загрузки находятся во вкладке «Разное». Сохранение зависит от того, разрешены ли в текущем исполнителе функции чтения и записи файлов.",
            "Конфиг хранит поддерживаемые параметры меню. Если сохранение недоступно, это ограничение среды выполнения, а не ошибка самого переключателя."},
            en={"Save and Load Config are in the Misc tab. Saving depends on whether the current executor allows file read/write functions.",
            "The config stores supported menu settings. If saving is unavailable, that is a limitation of the runtime environment rather than the switch itself."},
            es={"Guardar y Cargar configuración están en la pestaña Varios. El guardado depende de que el ejecutor permita leer y escribir archivos.",
            "La configuración guarda los ajustes compatibles del menú. Si no se puede guardar, es una limitación del entorno de ejecución."},
            tip={ru="После изменения языка или акцента сохрани конфиг, если хочешь перенести настройки между запусками.",
            en="After changing language or accent, save the config if you want to keep it between runs.",
            es="Después de cambiar el idioma o el color de acento, guarda la configuración para conservar los ajustes entre sesiones."}
    },
        menu = {
        keys={"свернут",
            "свернуть",
            "минус",
            "minimize",
            "collapse",
            "minus button",
            "перетащ",
            "drag",
            "двигать меню",
            "close button",
            "закрыть меню"},
            ru={"Кнопка «−» сворачивает окно до верхней панели, «+» разворачивает обратно, «×» закрывает меню, а плавающая кнопка A возвращает его. Верхнюю панель можно перетаскивать.",
            "Меню можно двигать за верхнюю панель. Минус оставляет компактную шапку, плюс раскрывает всё окно, крестик скрывает меню, а круглая кнопка A открывает его снова."},
            en={"The minus button collapses the window to its title bar, plus expands it, × closes the menu, and the floating A button opens it again. Drag the top bar to move the menu.",
            "Move the menu by dragging its header. Minus keeps a compact title bar, plus expands the window, × hides it, and the floating A button reopens it."},
            es={"El botón menos minimiza la ventana a la barra superior, más la expande, × cierra el menú y el botón flotante A lo vuelve a abrir. Arrastra la barra superior para moverlo.",
            "Puedes mover el menú arrastrando su cabecera. Menos deja una barra compacta, más expande la ventana, × la oculta y el botón A la vuelve a abrir."},
            tip={ru="Если окно съехало, вкладка «Настройки» содержит сброс позиции.",
            en="If the window moves off-screen, Settings has a reset-position control.",
            es="Si la ventana queda fuera de lugar, Ajustes incluye un control para restablecer la posición."}
    },
}

local function aiLocale(text)
    local lower = string.lower(tostring(text or ""))
    for _, ch in ipairs({"а",
        "б",
        "в",
        "г",
        "д",
        "е",
        "ё",
        "ж",
        "з",
        "и",
        "й",
        "к",
        "л",
        "м",
        "н",
        "о",
        "п",
        "р",
        "с",
        "т",
        "у",
        "ф",
        "х",
        "ц",
        "ч",
        "ш",
        "щ",
        "ъ",
        "ы",
        "ь",
        "э",
        "ю",
        "я"}) do
        if lower:find(ch,
            1,
            true) then return "ru" end
    end
    for _, ch in ipairs({"á",
        "é",
        "í",
        "ó",
        "ú",
        "ñ",
        "¿",
        "¡"}) do
        if lower:find(ch,
            1,
            true) then return "es" end
    end
    for _, word in ipairs({"que ",
        "qué ",
        "hola",
        "como ",
        "cómo ",
        "para ",
        "ayuda",
        "gracias",
        "puedes",
        "quiero",
        "tengo",
        "hacer",
        "funciona",
        "reproductor",
        "canción"}) do
        if lower:find(word,
            1,
            true) then return "es" end
    end
    for _, word in ipairs({"what ",
        "how ",
        "does ",
        "why ",
        "where ",
        "which ",
        "can you",
        "could you",
        "please",
        "help me",
        "menu",
        "setting",
        "feature",
        "theme",
        "hello",
        "thanks",
        "explain",
        "works",
        "work?",
        "what's"}) do
        if lower:find(word,
            1,
            true) then return "en" end
    end
    if lang == "Русский" then return "ru" end
    if lang == "Español" then return "es" end
    return "en"
end

local function aiRemember(role, text)
    aiHistory[#aiHistory + 1] = {role=role,
        text=tostring(text),
        time=os.clock()}
    while #aiHistory > aiMaxMemory do table.remove(aiHistory,
        1) end
end

local function aiScoreTopic(text, entry)
    local q = string.lower(tostring(text or ""))
    local score = 0
    for _, key in ipairs(entry.keys or {}) do
        local k = string.lower(key)
        local at = q:find(k,
            1,
            true)
        if at then score = score + math.max(1,
            #k / 8) end
    end
    return score
end

local function aiFindTopic(question)
    local bestName, bestScore = nil, 0
    for name, topic in pairs(aiTopics) do
        local score = aiScoreTopic(question,
            topic)
        if score > bestScore then bestName, bestScore = name, score end
    end
    return bestName, bestScore
end

local aiPhrases = {
    ru={open={"Давай разберёмся.",
        "Вот что важно знать.",
        "Объясню простыми словами:",
        "Хороший вопрос — смотри."},
        outro={"",
        "",
        "Если нужно, спроси про конкретный переключатель.",
        "Можешь назвать вкладку или кнопку — уточню."},
        hello={"Привет! Чем я могу помочь?"},
        who={"Я AURA AI — лёгкий локальный помощник. Я подбираю ответы по встроенной базе функций и запоминаю несколько последних реплик только на время текущего запуска.",
        "Я не большая нейросеть: использую встроенный справочник и короткую память чата. Для незнакомых терминов о Roblox могу попробовать поискать обсуждение на форуме разработчиков Roblox, если HTTP доступен."},
        unknown={"Пока не уверен, что именно ты имеешь в виду. Сначала проверяю локальную справку, а при неизвестном термине попробую найти обсуждение на форуме разработчиков Roblox, если HTTP доступен.",
        "Я не нашёл точного совпадения в локальной справке. Если HTTP доступен, попробую найти обсуждение на форуме разработчиков Roblox; можно также уточнить термин."},
        code={"Я не генерирую большие программы: я объясняю функции меню и распространённые технические понятия. При неизвестном термине о Roblox могу попробовать поиск на форуме разработчиков Roblox, если HTTP доступен.",
        "Я лёгкий справочный помощник, а не генератор программ. Зато могу объяснить, что делает переключатель, какой параметр он меняет и где искать настройку."},
        help={"Можешь спрашивать: «что делает ESP?», «как работает очередь?», «что меняет реверберация?», «что такое Luau?» или «почему низкий FPS?». Ответы используют локальную справку Roblox, а неизвестные термины могут проверяться на форуме разработчиков Roblox.",
        "Лучше всего я отвечаю о вкладках Музыка, Эффекты, Визуал, Разное и Настройки, а также о распространённых технических терминах. Например, спроси про FPS, FOV, Luau или аудиоплеер."}},
        en={open={"Let's break it down.",
        "Here's the useful part.",
        "In simple terms:",
        "Good question — here's how it works."},
        outro={"",
        "",
        "Ask about a specific switch if you want more detail.",
        "Name a tab or button and I can narrow it down."},
        hello={"Hi! How can I help?"},
        who={"I'm AURA AI, a small local helper. I match questions to a built-in feature guide and keep a few recent messages only during this run.",
        "I'm not a large neural model: I use a built-in guide and brief chat memory. For unfamiliar terms I can try Roblox Developer Forum search when HTTP is available."},
        unknown={"I'm not sure what you mean yet. I check the local guide first and may try a Roblox Developer Forum search for unfamiliar terms when HTTP is available.",
        "I couldn't find a confident match in my guide. Try asking 'what does the equalizer do?' or 'what is Luau?'"},
        code={"I don't generate full programs. I explain menu features and common technical concepts; if a term is unfamiliar, I can try Roblox Developer Forum search when HTTP is available.",
        "I'm a lightweight help assistant, not a programming model. I can still explain what a switch changes and where its setting lives."},
        help={"Try asking: 'what does ESP do?', 'how does the queue work?', 'what is reverb?', 'what is Luau?', or 'why is FPS low?'. Answers use a local Roblox guide and may try Roblox Developer Forum search if HTTP is available.",
        "I'm strongest on Music, Effects, Visuals, Misc, Settings, and common technical terms. Ask about FPS, FOV, Luau, or the audio player."}},
        es={open={"Vamos a verlo.",
        "Esto es lo importante.",
        "En pocas palabras:",
        "Buena pregunta; funciona así."},
        outro={"",
        "",
        "Pregunta por un control concreto si quieres más detalle.",
        "Dime una pestaña o botón y precisaré la respuesta."},
        hello={"¡Hola! ¿En qué te ayudo?"},
        who={"Soy AURA AI, un pequeño asistente local. Relaciono preguntas con una guía integrada y conservo algunos mensajes recientes solo durante esta sesión.",
        "No soy un gran modelo neuronal: uso una guía integrada y una memoria breve del chat. Para términos desconocidos puedo buscar en el foro de desarrolladores de Roblox si HTTP está disponible."},
        unknown={"Todavía no estoy seguro de qué quieres decir. Primero reviso la guía local y puedo intentar una búsqueda en Roblox Developer Forum si HTTP está disponible.",
        "No encontré una coincidencia en la guía local. Si funciona HTTP, intentaré buscar una referencia en Roblox Developer Forum; también puedes concretar el término."},
        code={"No genero programas completos. Explico las opciones de AuraMenu y conceptos técnicos comunes; si el término es desconocido, puedo intentar buscarlo en Roblox Developer Forum si HTTP está disponible.",
        "Soy un asistente ligero, no un modelo de programación. Aun así, puedo explicar qué cambia un control y dónde está."},
        help={"Puedes preguntar: «¿qué hace ESP?», «¿cómo funciona la cola?», «¿qué es la reverberación?», «¿qué es Luau?» o «¿por qué bajan los FPS?». Las respuestas usan una guía local de Roblox y pueden buscar en Roblox Developer Forum si HTTP está disponible.",
        "Respondo mejor sobre Música, Efectos, Visuales, Varios, Ajustes y términos técnicos comunes. Pregunta por FPS, FOV, Luau o el reproductor."}}
}

local function aiContains(q, phrases)
    q = string.lower(q)
    for _, phrase in ipairs(phrases) do if q:find(phrase,
        1,
        true) then return true end end
    return false
end

    local extendedGeneral = {
      {
        keys={
          "nil",
          "nil в lua",
          "nil значение",
        },
        ru="nil в Lua означает отсутствие значения. Это не то же самое, что false или 0; обращение к полю nil-значения может вызвать ошибку.",
        en="In Lua, nil represents the absence of a value. It differs from false and 0; trying to access a field on nil can cause an error.",
        es="En Lua, nil representa la ausencia de un valor. No es lo mismo que false o 0; acceder a un campo de nil puede causar un error.",
      },
      {
        keys={
          "return",
          "return в lua",
          "оператор return",
        },
        ru="return завершает выполнение функции и при необходимости возвращает значение вызывающему коду. Инструкции после return в той же ветке уже не выполняются.",
        en="return ends a function and can pass a value back to its caller. Statements after return in the same branch won't run.",
        es="return termina una función y puede devolver un valor al código que la llamó. Las instrucciones posteriores en esa misma rama no se ejecutan.",
      },
      {
        keys={
          "boolean",
          "булев",
          "true false",
          "verdadero falso",
        },
        ru="Boolean — логический тип с двумя значениями: true и false. Его используют в условиях, флагах состояния и переключателях.",
        en="A boolean has two values: true and false. It is used in conditions, state flags, and toggles.",
        es="Un booleano tiene dos valores: true y false. Se usa en condiciones, indicadores de estado e interruptores.",
      },
      {
        keys={
          "string",
          "строка в lua",
          "строковый тип",
          "cadena de texto",
        },
        ru="Строка хранит текст. В Lua её можно записать в одинарных или двойных кавычках; конкатенация выполняется оператором .., а не знаком +.",
        en="A string stores text. Lua accepts single or double quotes; strings are concatenated with .. rather than +.",
        es="Una cadena almacena texto. Lua acepta comillas simples o dobles; las cadenas se concatenan con .. y no con +.",
      },
      {
        keys={
          "number",
          "число в lua",
          "числовой тип",
        },
        ru="Числовой тип хранит числа. Следи за делением на ноль, округлением и тем, что данные из TextBox изначально являются строкой и их может понадобиться преобразовать через tonumber().",
        en="The number type stores numeric values. Watch for division by zero and rounding; TextBox input starts as a string and may need tonumber().",
        es="El tipo number guarda valores numéricos. Ten cuidado con la división por cero y el redondeo; el texto de un TextBox puede necesitar tonumber().",
      },
      {
        keys={
          "event",
          "событие roblox",
          "события roblox",
          "evento roblox",
        },
        ru="Событие сообщает, что что-то произошло: игрок нажал кнопку, объект изменился или кадр обновился. Обработчик подключают через Connect() и отключают, когда он больше не нужен.",
        en="An event signals that something happened: a button was pressed, an object changed, or a frame updated. Connect a handler with Connect() and disconnect it when no longer needed.",
        es="Un evento indica que ocurrió algo: se pulsó un botón, cambió un objeto o se actualizó un fotograma. Conecta un manejador con Connect() y desconéctalo cuando ya no haga falta.",
      },
      {
        keys={
          "connect(",
          "connection",
          "disconnect(",
          "подключение события",
          "отключить обработчик",
        },
        ru="Connect() подписывает функцию на событие и возвращает соединение. Вызов Disconnect() прекращает обработку; это помогает не оставлять лишние обработчики после закрытия интерфейса.",
        en="Connect() subscribes a function to an event and returns a connection. Disconnect() stops it, helping prevent leftover handlers after a UI closes.",
        es="Connect() suscribe una función a un evento y devuelve una conexión. Disconnect() la detiene y ayuda a evitar manejadores sobrantes al cerrar una interfaz.",
      },
      {
        keys={
          "task.spawn",
          "spawn в luau",
        },
        ru="task.spawn() запускает функцию в отдельной планируемой задаче, чтобы текущий код не ждал её завершения. Это не создаёт отдельное ядро CPU и не делает тяжёлую работу бесплатной.",
        en="task.spawn() schedules a function as a separate task so the current code doesn't wait for completion. It doesn't create a CPU core or make expensive work free.",
        es="task.spawn() programa una función como tarea separada para que el código actual no espere. No crea otro núcleo de CPU ni vuelve gratis el trabajo costoso.",
      },
      {
        keys={
          "task.defer",
          "defer в luau",
        },
        ru="task.defer() ставит функцию в очередь на выполнение после завершения текущего участка планирования. Это удобно для безопасного отложенного обновления интерфейса.",
        en="task.defer() schedules a function to run after the current resumption point. It can be useful for deferred UI updates.",
        es="task.defer() programa una función para ejecutarla después del punto actual de reanudación. Puede servir para actualizar la interfaz de forma diferida.",
      },
      {
        keys={
          "task.delay",
          "delay в luau",
        },
        ru="task.delay() планирует вызов функции после указанной задержки. Для задач, которые можно отменить, сохраняй ссылку или токен и проверяй, что действие ещё актуально.",
        en="task.delay() schedules a function after a given delay. Keep a token or reference for delayed work and check that it is still relevant before applying it.",
        es="task.delay() programa una función tras una demora. Guarda una referencia o token y comprueba que la acción siga siendo válida antes de aplicarla.",
      },
      {
        keys={
          "runservice",
          "run service",
          "сервис runservice",
        },
        ru="RunService предоставляет события игрового цикла, например Heartbeat и RenderStepped. Выбирай событие по задаче и не делай тяжёлые вычисления каждый кадр без необходимости.",
        en="RunService exposes game-loop events such as Heartbeat and RenderStepped. Choose the event for your task and avoid heavy work every frame unless needed.",
        es="RunService ofrece eventos del ciclo del juego, como Heartbeat y RenderStepped. Elige el evento adecuado y evita trabajo pesado en cada fotograma sin necesidad.",
      },
      {
        keys={
          "heartbeat",
          "renderstepped",
          "stepped event",
        },
        ru="Heartbeat срабатывает после физического шага симуляции, а RenderStepped связан с подготовкой кадра на клиенте. Для визуальных обновлений используй подходящее событие и учитывай delta time.",
        en="Heartbeat fires after a simulation step, while RenderStepped is tied to preparing a client frame. Use the appropriate event for visual updates and account for delta time.",
        es="Heartbeat se activa después de un paso de simulación y RenderStepped se relaciona con preparar un fotograma del cliente. Usa el evento apropiado y considera delta time.",
      },
      {
        keys={
          "userinputservice",
          "user input service",
          "ввод пользователя roblox",
        },
        ru="UserInputService сообщает о клавиатуре, касаниях и других способах ввода на клиенте. На телефоне проверяй TouchEnabled и не полагайся только на мышь или клавиши.",
        en="UserInputService reports keyboard, touch, and other client input. On phones, check TouchEnabled and don't rely only on mouse or keyboard controls.",
        es="UserInputService informa sobre teclado, toques y otras entradas del cliente. En móviles, comprueba TouchEnabled y no dependas solo del ratón o teclado.",
      },
      {
        keys={
          "contextactionservice",
          "context action service",
        },
        ru="ContextActionService позволяет привязывать действия к вводу и создавать сенсорные кнопки для мобильных устройств. Не забывай снимать привязки, если интерфейс выгружается.",
        en="ContextActionService binds actions to input and can create touch buttons on mobile devices. Remember to unbind actions when the UI is unloaded.",
        es="ContextActionService vincula acciones a entradas y puede crear botones táctiles en móviles. Recuerda quitar las vinculaciones al descargar la interfaz.",
      },
      {
        keys={
          "humanoid",
          "humanoid roblox",
        },
        ru="Humanoid управляет характеристиками персонажа, такими как здоровье, скорость движения и состояние прыжка. Он обычно находится внутри модели персонажа и может отсутствовать при загрузке или смене персонажа.",
        en="Humanoid controls character properties such as health, movement speed, and jump state. It is usually inside the character model and may be absent while a character loads or respawns.",
        es="Humanoid controla propiedades del personaje como salud, velocidad y salto. Normalmente está dentro del modelo del personaje y puede faltar durante la carga o reaparición.",
      },
      {
        keys={
          "cframe",
          "cframe roblox",
        },
        ru="CFrame хранит положение и поворот в 3D-пространстве. Он часто используется для камеры, деталей и перемещения объектов; это не просто координаты, потому что включает ориентацию.",
        en="CFrame stores a 3D position and rotation. It is used for cameras, parts, and object movement; it contains orientation as well as coordinates.",
        es="CFrame guarda una posición y rotación 3D. Se usa para cámaras, piezas y movimiento de objetos; incluye orientación además de coordenadas.",
      },
      {
        keys={
          "vector3",
          "vector 3",
          "вектор3",
        },
        ru="Vector3 — набор из трёх чисел X, Y и Z. В Roblox его используют для направлений, размеров и позиций; сам Vector3 не хранит поворот объекта.",
        en="Vector3 is a set of three numbers: X, Y, and Z. Roblox uses it for directions, sizes, and positions; it does not store an object's rotation.",
        es="Vector3 es un conjunto de tres números: X, Y y Z. Roblox lo usa para direcciones, tamaños y posiciones; no almacena la rotación del objeto.",
      },
      {
        keys={
          "color3",
          "color3 roblox",
          "цвет3",
        },
        ru="Color3 представляет цвет RGB в диапазоне от 0 до 1 на каждый канал. Для привычных значений 0–255 используй Color3.fromRGB(r, g, b).",
        en="Color3 represents an RGB color with each channel from 0 to 1. Use Color3.fromRGB(r, g, b) for familiar 0–255 values.",
        es="Color3 representa un color RGB con cada canal entre 0 y 1. Usa Color3.fromRGB(r, g, b) para valores habituales de 0–255.",
      },
      {
        keys={
          "udim2",
          "udim 2",
          "размер ui в roblox",
        },
        ru="UDim2 задаёт позицию или размер GUI через масштаб и смещение по двум осям. Масштаб зависит от родителя, а смещение задаётся в пикселях; сочетание помогает адаптировать интерфейс под экраны.",
        en="UDim2 defines a GUI position or size with scale and offset on two axes. Scale depends on the parent, while offset uses pixels; combining them helps layouts adapt to screens.",
        es="UDim2 define la posición o el tamaño de una interfaz con escala y desplazamiento en dos ejes. La escala depende del padre y el desplazamiento usa píxeles.",
      },
      {
        keys={
          "screengui",
          "screen gui",
          "экранный gui",
        },
        ru="ScreenGui — контейнер для интерфейса на экране игрока. Его обычно помещают в PlayerGui; ResetOnSpawn и DisplayOrder влияют на повторное создание и порядок отображения.",
        en="ScreenGui is a container for on-screen UI. It is usually placed in PlayerGui; ResetOnSpawn and DisplayOrder affect respawning and display order.",
        es="ScreenGui es un contenedor para la interfaz en pantalla. Suele colocarse en PlayerGui; ResetOnSpawn y DisplayOrder afectan la reaparición y el orden visual.",
      },
      {
        keys={
          "textbutton",
          "text button",
          "кнопка gui",
        },
        ru="TextButton — элемент интерфейса с текстом, на который можно нажимать. Для мыши и касаний удобно использовать Activated, а визуальное состояние кнопки лучше показывать анимацией или изменением цвета.",
        en="TextButton is a text-bearing UI control. Activated works well for mouse and touch; visual state can be communicated with a small animation or color change.",
        es="TextButton es un control de interfaz con texto. Activated funciona con ratón y toque; el estado puede indicarse con una pequeña animación o cambio de color.",
      },
      {
        keys={
          "canvasgroup",
          "canvas group",
        },
        ru="CanvasGroup позволяет управлять прозрачностью всей группы GUI через GroupTransparency. Это удобно для плавного появления окна; убедись, что сами дочерние элементы не остаются скрытыми отдельными свойствами.",
        en="CanvasGroup controls the transparency of a GUI group through GroupTransparency. It's useful for fading a window in or out; make sure child elements aren't separately hidden.",
        es="CanvasGroup controla la transparencia de un grupo GUI mediante GroupTransparency. Es útil para mostrar u ocultar una ventana suavemente; comprueba también las propiedades de los hijos.",
      },
      {
        keys={
          "uistroke",
          "ui stroke",
          "обводка gui",
        },
        ru="UIStroke добавляет контур вокруг GUI-элемента. Толщина и прозрачность помогают выделить границы, но слишком яркая обводка вокруг каждого элемента перегружает интерфейс.",
        en="UIStroke adds an outline to a GUI element. Thickness and transparency can define boundaries, but strong outlines on every element can make a UI feel noisy.",
        es="UIStroke añade un contorno a un elemento GUI. El grosor y la transparencia definen los bordes, pero demasiados contornos fuertes recargan la interfaz.",
      },
      {
        keys={
          "uigradient",
          "ui gradient",
          "градиент gui",
        },
        ru="UIGradient применяет градиент цвета и прозрачности к своему родительскому GUI-объекту. Высокая прозрачность в NumberSequence может сделать фон почти невидимым — проверяй значения около 0 для более плотного фона.",
        en="UIGradient applies color and transparency gradients to its parent GUI object. High transparency values can make a background nearly invisible; values near 0 keep it opaque.",
        es="UIGradient aplica gradientes de color y transparencia al objeto GUI padre. Valores altos de transparencia pueden volver casi invisible el fondo; valores cercanos a 0 lo mantienen opaco.",
      },
      {
        keys={
          "uiscale",
          "ui scale",
          "масштаб gui",
        },
        ru="UIScale умножает визуальный размер GUI-элемента и его потомков. Его удобно анимировать для мягкого появления, но для мобильного экрана также нужно учитывать доступную ширину и высоту.",
        en="UIScale multiplies the visual size of a GUI element and its descendants. It can animate a soft pop-in, but mobile layouts must still account for available width and height.",
        es="UIScale multiplica el tamaño visual de un elemento GUI y sus descendientes. Sirve para una aparición suave, pero el diseño móvil también debe considerar el ancho y alto disponibles.",
      },
      {
        keys={
          "tweeninfo",
          "tween info",
        },
        ru="TweenInfo задаёт длительность, стиль easing, направление и повторение анимации для TweenService. Короткие переходы обычно воспринимаются отзывчивее, а длинные лучше оставить для фоновых эффектов.",
        en="TweenInfo configures duration, easing style, direction, and repeats for TweenService. Short transitions often feel responsive; longer ones suit subtle ambient effects.",
        es="TweenInfo define duración, estilo de easing, dirección y repeticiones para TweenService. Las transiciones cortas suelen sentirse ágiles; las largas sirven para efectos ambientales sutiles.",
      },
      {
        keys={
          "remotefunction",
          "remote function",
        },
        ru="RemoteFunction обеспечивает запрос с ответом между клиентом и сервером Roblox. Вызов может ожидать результат, поэтому не используй его в частых циклах и всегда проверяй данные на сервере.",
        en="RemoteFunction supports request-and-response between Roblox client and server. Calls can wait for a result, so avoid frequent loops and validate data on the server.",
        es="RemoteFunction permite solicitudes con respuesta entre el cliente y el servidor de Roblox. La llamada puede esperar el resultado; evita usarla en ciclos frecuentes y valida los datos en el servidor.",
      },
      {
        keys={
          "httpservice",
          "http service",
          "http-запрос",
          "http запрос",
        },
        ru="HttpService в Roblox умеет кодировать JSON и выполнять HTTP-запросы, если серверная игра разрешила этот доступ. В LocalScript возможности ограничены; сторонние исполнители могут предоставлять собственные функции, которые не гарантированы везде.",
        en="Roblox HttpService encodes JSON and can make HTTP requests when the experience enables them. LocalScript access is limited; third-party runtimes may expose extra functions that are not universally available.",
        es="HttpService en Roblox codifica JSON y puede hacer solicitudes HTTP si la experiencia lo permite. El acceso desde LocalScript es limitado; otros entornos pueden ofrecer funciones adicionales no disponibles en todas partes.",
      },
      {
        keys={
          "cache",
          "кэш",
          "кеш",
          "caché",
          "cache memory",
        },
        ru="Кэш временно хранит уже полученные результаты, чтобы не выполнять одинаковую работу повторно. Нужно ограничивать размер кэша и учитывать, что данные могут устареть.",
        en="A cache temporarily stores results so repeated work can be avoided. Limit its size and remember that cached data can become stale.",
        es="Una caché guarda temporalmente resultados para evitar repetir trabajo. Limita su tamaño y recuerda que los datos guardados pueden quedar desactualizados.",
      },
      {
        keys={
          "debounce",
          "debouncing",
          "защита от повторного нажатия",
        },
        ru="Debounce ограничивает слишком частые вызовы, например быстрые повторные нажатия кнопки. Он полезен для сетевых запросов, поиска и действий, которые не должны запускаться параллельно.",
        en="Debounce prevents overly frequent calls, such as rapid repeated button presses. It helps with web requests, search, and actions that shouldn't run concurrently.",
        es="Debounce evita llamadas demasiado frecuentes, como pulsaciones repetidas. Ayuda con solicitudes web, búsquedas y acciones que no deben ejecutarse en paralelo.",
      },
      {
        keys={
          "memory leak",
          "утечка памяти",
          "fuga de memoria",
        },
        ru="Утечка памяти возникает, когда ненужные объекты или ссылки продолжают удерживаться. В GUI удаляй созданные элементы и отключай соединения событий, если больше не используешь их.",
        en="A memory leak happens when unused objects or references remain retained. In GUI code, destroy temporary elements and disconnect event connections when they are no longer needed.",
        es="Una fuga de memoria ocurre cuando objetos o referencias que ya no se necesitan siguen retenidos. En interfaces, destruye elementos temporales y desconecta eventos cuando ya no hagan falta.",
      },
      {
        keys={
          "module script",
          "modulescript",
          "модульный скрипт",
          "módulo script",
        },
        ru="ModuleScript хранит код, который можно подключать через require(). Он помогает разделить проект на небольшие переиспользуемые части; модуль обычно возвращает таблицу или функцию.",
        en="A ModuleScript stores reusable code that can be loaded with require(). It helps split a project into smaller parts and usually returns a table or function.",
        es="ModuleScript guarda código reutilizable que se carga con require(). Ayuda a dividir el proyecto y normalmente devuelve una tabla o función.",
      },
      {
        keys={
          "require(",
          "require function",
          "подключить модуль",
        },
        ru="require() загружает ModuleScript и возвращает то, что этот модуль передал через return. При первом вызове результат обычно кэшируется для соответствующего окружения.",
        en="require() loads a ModuleScript and returns the value it returns. The result is generally cached for that environment after the first load.",
        es="require() carga un ModuleScript y devuelve el valor que retorna. El resultado suele almacenarse en caché para ese entorno después de la primera carga.",
      },
      {
        keys={
          "enum",
          "enum roblox",
        },
        ru="Enum в Roblox содержит наборы заранее определённых значений, например стили шрифтов, состояния и виды ввода. Это помогает выбирать допустимые значения вместо произвольных строк.",
        en="Roblox Enum provides predefined sets of values, such as font styles, states, and input types. It helps select valid values instead of arbitrary strings.",
        es="Enum en Roblox contiene conjuntos de valores predefinidos, como estilos de fuente, estados y tipos de entrada. Ayuda a elegir valores válidos en vez de cadenas arbitrarias.",
      },
      {
        keys={
          "workspace",
          "workspace roblox",
        },
        ru="workspace — контейнер объектов игрового мира. В нём находятся многие детали и модели; объект может ещё не существовать при загрузке, поэтому используй WaitForChild() или проверки FindFirstChild() там, где это уместно.",
        en="workspace contains objects in the 3D world. Some objects may not exist yet during loading, so use WaitForChild() or FindFirstChild() checks where appropriate.",
        es="workspace contiene objetos del mundo 3D. Algunos pueden no existir aún durante la carga; usa WaitForChild() o comprobaciones con FindFirstChild() cuando corresponda.",
      },
      {
        keys={
          "players service",
          "players service roblox",
          "сервис players",
        },
        ru="Players содержит сведения об игроках и позволяет получать LocalPlayer в клиентском коде. Персонаж может перерождаться, поэтому подключайся к CharacterAdded и не сохраняй старые ссылки навсегда.",
        en="Players exposes player information and LocalPlayer on the client. Characters can respawn, so handle CharacterAdded and avoid keeping stale character references forever.",
        es="Players ofrece información de jugadores y LocalPlayer en el cliente. Los personajes pueden reaparecer; gestiona CharacterAdded y no conserves referencias antiguas indefinidamente.",
      },
      {
        keys={
          "parent property",
          "parent в roblox",
          "свойство parent",
        },
        ru="Свойство Parent определяет, где объект находится в иерархии Roblox. Если Parent равен nil, объект не находится внутри дерева игры; для отображения GUI его нужно поместить в правильный контейнер.",
        en="Parent defines an object's place in the Roblox hierarchy. If Parent is nil, the object isn't in the game's instance tree; UI must be parented to the correct container to appear.",
        es="Parent define el lugar de un objeto en la jerarquía de Roblox. Si es nil, el objeto no está en el árbol; para mostrar la interfaz hay que ponerlo en el contenedor correcto.",
      },
      {
        keys={
          "studio",
          "roblox studio",
          "студия roblox",
        },
        ru="Roblox Studio — редактор для создания и тестирования собственных игр Roblox. В нём можно редактировать мир, писать Luau-скрипты, проверять клиентскую и серверную логику и смотреть вывод ошибок.",
        en="Roblox Studio is the editor for building and testing Roblox experiences. It lets you edit worlds, write Luau, test client/server logic, and inspect errors in the output.",
        es="Roblox Studio es el editor para crear y probar experiencias de Roblox. Permite editar mundos, escribir Luau, probar lógica cliente/servidor y revisar errores en la salida.",
      },
      {
        keys={
          "delta time",
          "deltatime",
          "дельта времени",
        },
        ru="Delta time — время между обновлениями. Умножение скорости движения на delta time помогает сделать анимацию более одинаковой при разном FPS.",
        en="Delta time is the elapsed time between updates. Multiplying movement speed by delta time helps animations behave consistently across different FPS rates.",
        es="Delta time es el tiempo entre actualizaciones. Multiplicar la velocidad por delta time ayuda a que las animaciones sean consistentes con distintos FPS.",
      },
      {
        keys={
          "stack trace",
          "traceback",
          "стек вызовов",
          "трассировка ошибки",
        },
        ru="Stack trace показывает цепочку вызовов, приведших к ошибке. Начни с первой строки, указывающей на твой скрипт, проверь номер строки и значения рядом с местом сбоя.",
        en="A stack trace shows the call chain leading to an error. Start at the first line pointing to your script, inspect the line number, and check nearby values.",
        es="Una traza muestra la cadena de llamadas que llevó al error. Empieza por la primera línea de tu script, revisa el número de línea y los valores cercanos.",
      },
      {
        keys={
          "syntax error",
          "syntax",
          "синтаксическая ошибка",
          "error de sintaxis",
        },
        ru="Синтаксическая ошибка означает, что код записан не по правилам языка. Проверь кавычки, скобки, запятые и закрывающие end; сообщение об ошибке часто указывает место, где парсер перестал понимать код.",
        en="A syntax error means the code doesn't follow the language grammar. Check quotes, brackets, commas, and closing end statements; the reported line helps locate the issue.",
        es="Un error de sintaxis significa que el código no sigue la gramática del lenguaje. Revisa comillas, paréntesis, comas y end; la línea indicada ayuda a localizarlo.",
      },
      {
        keys={
          "runtime error",
          "ошибка выполнения",
          "error en tiempo de ejecución",
        },
        ru="Ошибка выполнения возникает уже при работе скрипта, например если обратиться к nil или передать неподходящий тип. Смотри текст ошибки и стек вызовов, затем проверь условия и типы данных.",
        en="A runtime error occurs while code is running, for example when indexing nil or passing the wrong type. Read the error and stack trace, then check conditions and data types.",
        es="Un error de ejecución ocurre mientras corre el código, por ejemplo al acceder a nil o usar un tipo incorrecto. Lee el error y la traza, y revisa condiciones y tipos.",
      },
      {
        keys={
          "performance",
          "оптимизация",
          "optimization",
          "rendimiento",
          "оптимизировать скрипт",
        },
        ru="Оптимизация начинается с поиска узкого места. Уменьшай лишнюю работу каждый кадр, переиспользуй объекты, ограничивай число GUI-элементов и проверяй результат на целевом устройстве.",
        en="Optimization starts by finding the bottleneck. Reduce unnecessary per-frame work, reuse objects, limit GUI elements, and test on the target device.",
        es="La optimización empieza por encontrar el cuello de botella. Reduce trabajo innecesario por fotograma, reutiliza objetos, limita elementos GUI y prueba en el dispositivo objetivo.",
      },
      {
        keys={
          "fps drop",
          "падает fps",
          "низкий fps",
          "bajan los fps",
        },
        ru="Падение FPS может быть связано с большим числом объектов, тяжёлой графикой, долгими циклами или нагрузкой устройства. Отключай эффекты по одному и сравнивай результат, чтобы найти источник.",
        en="FPS drops can come from too many objects, heavy graphics, long loops, or device load. Disable effects one at a time and compare results to find the cause.",
        es="La caída de FPS puede deberse a muchos objetos, gráficos pesados, bucles largos o carga del dispositivo. Desactiva efectos uno por uno y compara resultados.",
      },
      {
        keys={
          "jsondecode",
          "jsonencode",
          "json encode",
          "json decode",
        },
        ru="HttpService:JSONEncode() превращает поддерживаемую таблицу в JSON-строку, а JSONDecode() разбирает строку обратно в данные. Декодирование может завершиться ошибкой, поэтому используй pcall() для недоверенного ответа.",
        en="HttpService:JSONEncode() converts a supported table to a JSON string; JSONDecode() parses it back. Decoding can fail, so use pcall() for untrusted responses.",
        es="HttpService:JSONEncode() convierte una tabla compatible en texto JSON y JSONDecode() lo analiza de nuevo. El análisis puede fallar; usa pcall() con respuestas no confiables.",
      },
      {
        keys={
          "https",
          "http vs https",
          "https protocol",
          "что такое https",
        },
        ru="HTTPS — HTTP, защищённый TLS-шифрованием. Он помогает защитить данные в пути, но не гарантирует, что сайт правдивый или безопасный сам по себе.",
        en="HTTPS is HTTP protected by TLS encryption. It helps protect data in transit, but doesn't guarantee that a site is truthful or safe by itself.",
        es="HTTPS es HTTP protegido por cifrado TLS. Ayuda a proteger los datos en tránsito, pero no garantiza que un sitio sea veraz o seguro.",
      },
      {
        keys={
          "browser cache",
          "кэш браузера",
          "cache del navegador",
        },
        ru="Кэш браузера хранит копии некоторых ресурсов, чтобы страницы загружались быстрее. Очистка может помочь при устаревших данных, но не увеличивает оперативную память автоматически.",
        en="A browser cache stores copies of some resources so pages load faster. Clearing it can help with stale data, but does not automatically increase RAM.",
        es="La caché del navegador guarda copias de recursos para acelerar páginas. Limpiarla puede ayudar con datos antiguos, pero no aumenta la RAM automáticamente.",
      },
      {
        keys={
          "wifi",
          "wi-fi",
          "вайфай",
          "wi fi",
        },
        ru="Wi‑Fi — беспроводное подключение к локальной сети. Слабый сигнал, перегруженный канал или проблемы провайдера могут влиять на задержки и стабильность; проверь и уровень сигнала, и пинг.",
        en="Wi‑Fi is a wireless connection to a local network. Weak signal, congestion, or ISP issues can affect latency and stability; check both signal strength and ping.",
        es="Wi‑Fi es una conexión inalámbrica a una red local. Una señal débil, congestión o problemas del proveedor afectan la latencia; revisa la señal y el ping.",
      },
      {
        keys={
          "cpu",
          "процессор",
          "processor",
          "procesador",
        },
        ru="CPU выполняет инструкции программ. При высокой нагрузке устройство может снижать частоту или нагреваться; закрытие тяжёлых приложений иногда помогает, но зависит от причины.",
        en="The CPU executes program instructions. Heavy load can cause heat or throttling; closing demanding apps may help depending on the cause.",
        es="La CPU ejecuta instrucciones de programas. La carga alta puede generar calor o reducir la frecuencia; cerrar aplicaciones pesadas puede ayudar según la causa.",
      },
      {
        keys={
          "gpu",
          "видеокарта",
          "graphics processing unit",
          "unidad gráfica",
        },
        ru="GPU обрабатывает графику и часть параллельных вычислений. В играх нагрузка может быть связана как с графикой, так и с CPU, поэтому снижение эффектов помогает не во всех случаях.",
        en="The GPU processes graphics and some parallel workloads. Games can be limited by graphics or CPU, so lowering visual effects won't help every bottleneck.",
        es="La GPU procesa gráficos y algunas tareas paralelas. Un juego puede estar limitado por gráficos o CPU, así que reducir efectos no siempre resuelve el problema.",
      },
      {
        keys={
          "refresh rate",
          "частота обновления",
          "hz экран",
          "frecuencia de refresco",
        },
        ru="Частота обновления экрана измеряется в герцах и показывает, сколько раз экран может обновляться за секунду. Она отличается от FPS: игра может выдавать меньше кадров, чем поддерживает дисплей.",
        en="Display refresh rate is measured in hertz and describes how often the screen can refresh each second. It differs from FPS; a game may render fewer frames than the display can show.",
        es="La frecuencia de actualización se mide en hercios e indica cuántas veces puede actualizarse la pantalla por segundo. No es lo mismo que FPS.",
      },
      {
        keys={
          "latency",
          "задержка сети",
          "network delay",
          "latencia de red",
        },
        ru="Сетевая задержка — время, нужное данным для прохождения по сети. На неё влияют расстояние до сервера, маршрутизация, перегрузка и качество Wi‑Fi; это не то же самое, что FPS.",
        en="Network latency is the time data takes to travel across a network. Distance, routing, congestion, and Wi‑Fi quality matter; it's different from FPS.",
        es="La latencia de red es el tiempo que tardan los datos en viajar. Influyen la distancia, la ruta, la congestión y la calidad del Wi‑Fi; no es lo mismo que FPS.",
      },
      {
        keys={
          "open source",
          "открытый исходный код",
          "código abierto",
        },
        ru="Открытый исходный код означает, что код доступен для чтения по условиям конкретной лицензии. Это не всегда значит, что можно делать с ним что угодно: проверь требования лицензии и авторства.",
        en="Open source means source code is available under a specific license. It doesn't mean you can do absolutely anything with it; check the license and attribution requirements.",
        es="Código abierto significa que el código está disponible bajo una licencia concreta. No implica que puedas hacer cualquier cosa; revisa la licencia y la atribución.",
      },
      {
        keys={
          "license",
          "лицензия кода",
          "licencia de software",
        },
        ru="Лицензия определяет, как можно использовать, изменять и распространять программный код. Перед повторным использованием чужого проекта проверь условия лицензии и сохрани обязательные уведомления.",
        en="A software license defines how code may be used, modified, and redistributed. Check the terms and preserve required notices before reusing a project.",
        es="Una licencia define cómo se puede usar, modificar y redistribuir el código. Revisa sus condiciones y conserva los avisos obligatorios antes de reutilizar un proyecto.",
      },
      {
        keys={
          "algorithm",
          "алгоритм",
          "algoritmo",
        },
        ru="Алгоритм — последовательность шагов для решения задачи. Хороший алгоритм даёт правильный результат и не тратит лишние ресурсы; для больших данных важно оценивать, как растёт его время работы.",
        en="An algorithm is a sequence of steps for solving a problem. A good algorithm produces the right result without unnecessary work; for large data, consider how runtime grows.",
        es="Un algoritmo es una secuencia de pasos para resolver un problema. Uno bueno da el resultado correcto sin trabajo innecesario; con muchos datos, importa cómo crece el tiempo de ejecución.",
      },
      {
        keys={
          "recursion",
          "рекурсия",
          "recursión",
        },
        ru="Рекурсия — когда функция вызывает сама себя. Ей обязательно нужен базовый случай остановки; иначе вызовы могут продолжаться до ошибки переполнения стека.",
        en="Recursion is when a function calls itself. It needs a base case to stop, or calls may continue until a stack overflow occurs.",
        es="La recursión ocurre cuando una función se llama a sí misma. Necesita un caso base para detenerse o puede causar un desbordamiento de pila.",
      },
      {
        keys={
          "global variable",
          "глобальная переменная",
          "variable global",
        },
        ru="Глобальная переменная видна из разных частей окружения и легче случайно перезаписывается. В Lua чаще безопаснее использовать local и явно передавать нужные значения между функциями.",
        en="A global variable is visible across a wider environment and can be overwritten accidentally. In Lua, local variables and explicit parameters are often safer.",
        es="Una variable global es visible en un entorno más amplio y puede sobrescribirse por accidente. En Lua, suele ser más seguro usar local y pasar parámetros explícitos.",
      },
      {
        keys={
          "local variable",
          "локальная переменная",
          "variable local",
        },
        ru="local ограничивает видимость переменной текущим блоком или функцией. Это уменьшает случайные конфликты имён и помогает сохранять состояние в нужной области.",
        en="local limits a variable's visibility to its block or function. This reduces accidental name conflicts and keeps state in the intended scope.",
        es="local limita la visibilidad de una variable a su bloque o función. Reduce conflictos de nombres y mantiene el estado en el ámbito adecuado.",
      },
      {
        keys={
          "soundservice",
          "sound service",
          "звуковой сервис roblox",
        },
        ru="SoundService содержит общие настройки звука и помогает управлять воспроизведением. Отдельный Sound обычно отвечает за конкретный источник или трек; проверь, где объект расположен и как он подключён.",
        en="SoundService contains global audio settings. A Sound instance usually represents a specific source or track; check where it is parented and how it is wired.",
        es="SoundService contiene ajustes generales de audio. Un objeto Sound suele representar una fuente o pista concreta; revisa dónde está colocado y cómo se conecta.",
      },
      {
        keys={
          "sound id",
          "audio id",
          "id аудио",
          "id de audio",
        },
        ru="ID аудио — числовой идентификатор загруженного ресурса. Доступность зависит от разрешений владельца, модерации и правил конкретного опыта; сам правильный номер не гарантирует воспроизведение.",
        en="An audio ID identifies an uploaded asset. Availability depends on owner permissions, moderation, and the experience's rules; a valid number alone doesn't guarantee playback.",
        es="El ID de audio identifica un recurso subido. La disponibilidad depende de permisos, moderación y reglas de la experiencia; un número válido no garantiza que suene.",
      },
      {
        keys={
          "equalizer",
          "ecualizador",
        },
        ru="Эквалайзер усиливает или ослабляет выбранные диапазоны частот. Небольшие изменения обычно легче контролировать, чем сильное усиление всех полос сразу.",
        en="An equalizer boosts or cuts selected frequency bands. Small adjustments are usually easier to control than boosting every band heavily.",
        es="Un ecualizador aumenta o reduce bandas de frecuencia. Los cambios pequeños suelen ser más fáciles de controlar que subir todas las bandas mucho.",
      },
      {
        keys={
          "echo effect",
          "эффект эхо",
          "efecto eco",
        },
        ru="Эхо добавляет повтор звука с задержкой. Если повторов слишком много или они громкие, речь и музыка могут смешиваться; уменьши обратную связь или задержку.",
        en="Echo repeats sound after a delay. Too many or loud repeats can muddy speech and music; lower feedback or delay to make it clearer.",
        es="El eco repite el sonido con retraso. Demasiadas repeticiones pueden emborronar voz y música; reduce la realimentación o el retardo.",
      },
      {
        keys={
          "reverb effect",
          "reverberation effect",
          "эффект реверберации",
          "efecto de reverberación",
        },
        ru="Реверберация имитирует множество отражений в помещении и добавляет ощущение пространства. Эхо обычно слышно отдельными повторами, а реверберация звучит более слитно.",
        en="Reverb simulates many room reflections and adds a sense of space. Echo is usually heard as distinct repeats, while reverb blends more continuously.",
        es="La reverberación simula múltiples reflejos de una sala y añade espacio. El eco suele oírse como repeticiones separadas; la reverberación se mezcla más.",
      },
      {
        keys={
          "mobile ui",
          "мобильный интерфейс",
          "interfaz móvil",
        },
        ru="Мобильный интерфейс должен учитывать касания, экранную клавиатуру, безопасные отступы и небольшую ширину. Делай кнопки достаточно крупными и не размещай важные элементы слишком близко друг к другу.",
        en="Mobile UI should account for touch, the on-screen keyboard, safe areas, and narrow widths. Make controls easy to tap and avoid crowding important actions.",
        es="La interfaz móvil debe considerar el tacto, el teclado en pantalla, las zonas seguras y el ancho reducido. Haz los controles fáciles de tocar y evita amontonarlos.",
      },
      {
        keys={
          "accessibility",
          "доступность интерфейса",
          "accesibilidad",
        },
        ru="Доступность интерфейса — это удобство для людей с разными возможностями и устройствами. Контрастный текст, понятные подписи и отсутствие зависимости только от цвета помогают большему числу пользователей.",
        en="UI accessibility means making controls usable by people with different abilities and devices. Strong text contrast, clear labels, and not relying on color alone help more users.",
        es="La accesibilidad de la interfaz busca que los controles sean utilizables por personas y dispositivos distintos. Un buen contraste, etiquetas claras y no depender solo del color ayudan a más usuarios.",
      },
      {
        keys={
          "clipboard",
          "буфер обмена",
          "portapapeles",
        },
        ru="Буфер обмена временно хранит скопированный текст или другие данные между приложениями. Доступ к нему зависит от платформы и разрешений, поэтому не каждая среда выполнения позволяет управлять им напрямую.",
        en="The clipboard temporarily stores copied text or other data between apps. Access depends on the platform and permissions, so not every runtime can control it directly.",
        es="El portapapeles guarda temporalmente texto u otros datos copiados entre aplicaciones. El acceso depende de la plataforma y permisos; no todos los entornos pueden controlarlo.",
      },
      {
        keys={
          "url",
          "ссылка url",
          "uniform resource locator",
        },
        ru="URL — адрес ресурса в сети. Проверяй схему https:// и домен перед открытием; не отправляй пароли или личные данные в неизвестные формы.",
        en="A URL is the address of a resource on the web. Check the https:// scheme and domain before opening it, and don't send passwords or personal data to unknown forms.",
        es="Una URL es la dirección de un recurso web. Revisa el esquema https:// y el dominio antes de abrirla; no envíes contraseñas ni datos personales a formularios desconocidos.",
      },
      {
        keys={
          "search engine",
          "поисковая система",
          "motor de búsqueda",
        },
        ru="Поисковая система находит страницы по словам запроса и ранжирует результаты. Она может ошибаться или показывать неактуальные сведения, поэтому важные факты лучше сверять с первоисточником.",
        en="A search engine finds pages using query terms and ranks results. It can be wrong or show outdated information, so verify important facts with primary sources.",
        es="Un motor de búsqueda encuentra páginas por términos y ordena resultados. Puede equivocarse o mostrar datos antiguos; verifica los hechos importantes en fuentes primarias.",
      },
      {
        keys={
          "offline",
          "офлайн",
          "sin conexión",
        },
        ru="Офлайн-режим означает работу без сетевого подключения. Локальная база продолжит отвечать, но свежие сведения и неизвестные термины будут недоступны, если они заранее не добавлены.",
        en="Offline mode works without a network connection. A local guide still responds, but fresh information and unknown terms may be unavailable unless stored beforehand.",
        es="El modo sin conexión funciona sin red. La guía local sigue respondiendo, pero la información nueva y los términos desconocidos pueden no estar disponibles.",
      },
      {
        keys={
          "api limit",
          "лимит api",
          "límite de api",
        },
        ru="Лимит API ограничивает число запросов или объём данных за период. Кэш, короткие запросы и обращение только при необходимости снижают число обращений, но не отменяют правила сервиса.",
        en="An API limit restricts requests or data volume over a period. Caching and requesting only when needed can reduce usage, but do not bypass the provider's rules.",
        es="Un límite de API restringe las solicitudes o el volumen de datos durante un periodo. La caché y consultar solo cuando hace falta reducen el uso, pero no eliminan las reglas del servicio.",
      },
      {
        keys={
          "require(",
          "require module",
          "зачем require",
          "qué hace require",
        },
        ru="require() загружает ModuleScript или возвращает его закэшированный результат. Путь и доступность модуля должны быть корректными; повторный require обычно не выполняет модуль заново.",
        en="require() loads a ModuleScript or returns its cached result. The module path and availability must be correct; requiring it again usually does not execute it from scratch.",
        es="require() carga un ModuleScript o devuelve el resultado guardado en caché. La ruta y disponibilidad deben ser correctas; repetir require normalmente no vuelve a ejecutar el módulo desde cero.",
      },
      {
        keys={
          "modulescript",
          "module script",
          "модульный скрипт",
          "script de módulo",
        },
        ru="ModuleScript хранит код, который подключают через require(). Он помогает разделять проект на переиспользуемые части, например аудио-утилиты, интерфейс и проверки.",
        en="A ModuleScript stores code loaded with require(). It helps split a project into reusable pieces such as audio utilities, UI, and validation.",
        es="ModuleScript guarda código que se carga con require(). Ayuda a dividir el proyecto en partes reutilizables, como utilidades de audio, interfaz y validaciones.",
      },
      {
        keys={
          "userinputservice",
          "user input service",
          "сервис ввода",
          "servicio de entrada",
        },
        ru="UserInputService сообщает о нажатиях клавиш, касаниях и других способах ввода. Для мобильной игры нужно отдельно учитывать касания и экранные кнопки.",
        en="UserInputService reports keyboard, touch, and other input. Mobile experiences should account for touch and on-screen controls separately.",
        es="UserInputService informa sobre teclado, toques y otras entradas. En móviles hay que tener en cuenta los toques y los controles en pantalla.",
      },
      {
        keys={
          "contextactionservice",
          "context action service",
          "контекстное действие",
        },
        ru="ContextActionService связывает действия игры с вводом и умеет создавать кнопки для сенсорного экрана. Это удобно для действий, которые должны работать и на телефоне, и на компьютере.",
        en="ContextActionService binds game actions to input and can create touch buttons. It is useful for actions that should work on both phones and computers.",
        es="ContextActionService vincula acciones del juego a entradas y puede crear botones táctiles. Sirve para acciones compatibles con móviles y ordenadores.",
      },
      {
        keys={
          "runservice",
          "run service",
          "сервис кадров",
        },
        ru="RunService предоставляет события игрового цикла, например Heartbeat и RenderStepped. Для обновлений каждый кадр используй их осторожно: тяжёлый код может снижать FPS.",
        en="RunService provides game-loop events such as Heartbeat and RenderStepped. Use per-frame updates carefully because expensive code can lower FPS.",
        es="RunService ofrece eventos del ciclo del juego, como Heartbeat y RenderStepped. Usa las actualizaciones por fotograma con cuidado: el código pesado reduce los FPS.",
      },
      {
        keys={
          "heartbeat",
          "renderstepped",
          "render stepped",
        },
        ru="Heartbeat срабатывает после шага физики, а RenderStepped связан с подготовкой кадра на клиенте. Выбирай событие под задачу и не выполняй внутри него тяжёлые циклы.",
        en="Heartbeat fires after a physics step, while RenderStepped is tied to client frame rendering. Choose the event for the task and avoid heavy loops inside it.",
        es="Heartbeat se activa después de un paso de física; RenderStepped está ligado al renderizado del cliente. Elige el evento adecuado y evita ciclos pesados dentro.",
      },
      {
        keys={
          "screengui",
          "screen gui",
          "экранный интерфейс",
          "interfaz de pantalla",
        },
        ru="ScreenGui — контейнер пользовательского интерфейса на экране игрока. Его обычно помещают в PlayerGui; порядок отображения зависит в том числе от DisplayOrder и ZIndex.",
        en="ScreenGui is a container for on-screen UI. It is typically placed in PlayerGui; drawing order depends partly on DisplayOrder and ZIndex.",
        es="ScreenGui es un contenedor para la interfaz en pantalla. Normalmente va en PlayerGui; el orden visual depende, entre otras cosas, de DisplayOrder y ZIndex.",
      },
      {
        keys={
          "textbutton",
          "text button",
          "текстовая кнопка",
          "botón de texto",
        },
        ru="TextButton — кнопка интерфейса с текстовой подписью. Для мобильных устройств увеличивай область нажатия, делай состояние нажатия заметным и подключай Activated для разных типов ввода.",
        en="TextButton is a UI button with a text label. For mobile, give it a generous hit area, show press feedback, and use Activated for different input types.",
        es="TextButton es un botón de interfaz con texto. En móviles conviene ampliar la zona táctil, mostrar la pulsación y usar Activated para distintos tipos de entrada.",
      },
      {
        keys={
          "textlabel",
          "text label",
          "текстовая метка",
          "etiqueta de texto",
        },
        ru="TextLabel отображает текст без собственного действия при нажатии. Важно правильно настроить TextWrapped, TextSize и размеры, чтобы длинные подписи не обрезались.",
        en="TextLabel displays text without providing a button action. Configure TextWrapped, TextSize, and its size so long labels are not clipped.",
        es="TextLabel muestra texto sin acción de botón. Ajusta TextWrapped, TextSize y el tamaño para que las etiquetas largas no se corten.",
      },
      {
        keys={
          "scrollingframe",
          "scrolling frame",
          "прокручиваемая область",
          "marco desplazable",
        },
        ru="ScrollingFrame показывает содержимое, которое не помещается в видимую область, и позволяет прокручивать его. CanvasSize или AutomaticCanvasSize задаёт размер прокручиваемого содержимого.",
        en="ScrollingFrame displays content that does not fit in the visible area and allows scrolling. CanvasSize or AutomaticCanvasSize defines the scrollable content size.",
        es="ScrollingFrame muestra contenido que no cabe en el área visible y permite desplazarlo. CanvasSize o AutomaticCanvasSize define el tamaño del contenido desplazable.",
      },
      {
        keys={
          "uilistlayout",
          "ui list layout",
          "список элементов gui",
        },
        ru="UIListLayout автоматически располагает дочерние элементы вертикально или горизонтально. Padding управляет промежутками, а LayoutOrder — порядком элементов.",
        en="UIListLayout automatically arranges children vertically or horizontally. Padding controls spacing, while LayoutOrder controls order.",
        es="UIListLayout organiza automáticamente los hijos en vertical u horizontal. Padding controla la separación y LayoutOrder el orden.",
      },
      {
        keys={
          "uipadding",
          "ui padding",
          "внутренние отступы gui",
        },
        ru="UIPadding задаёт внутренние отступы контейнера GUI. Он помогает выровнять текст и карточки, не изменяя размеры каждого дочернего элемента вручную.",
        en="UIPadding adds inner spacing to a GUI container. It helps align text and cards without manually resizing every child.",
        es="UIPadding añade márgenes internos a un contenedor GUI. Ayuda a alinear texto y tarjetas sin cambiar manualmente cada elemento hijo.",
      },
      {
        keys={
          "uicorner",
          "ui corner",
          "скругление gui",
        },
        ru="UICorner задаёт радиус скругления углов GUI. Слишком большое скругление может уменьшить полезную площадь кнопки, поэтому подбирай его вместе с размером элемента.",
        en="UICorner rounds a GUI element's corners. Excessive rounding can reduce the useful area of a button, so balance it with the element size.",
        es="UICorner redondea las esquinas de un elemento GUI. Un radio excesivo puede reducir el área útil de un botón, así que ajústalo al tamaño.",
      },
      {
        keys={
          "uistroke",
          "ui stroke",
          "обводка gui",
        },
        ru="UIStroke рисует обводку вокруг GUI. Цвет и прозрачность должны давать достаточный контраст, но не отвлекать сильнее основного содержимого.",
        en="UIStroke draws an outline around a GUI element. Its color and transparency should provide sufficient contrast without overpowering the content.",
        es="UIStroke dibuja un contorno alrededor de un elemento GUI. Su color y transparencia deben dar contraste sin dominar el contenido.",
      },
      {
        keys={
          "uigradient",
          "ui gradient",
          "градиент интерфейса",
        },
        ru="UIGradient накладывает цветовой или прозрачностный градиент на родительский GUI-элемент. Если градиент прозрачности близок к 1, элемент может казаться почти невидимым.",
        en="UIGradient applies color or transparency gradients to its parent GUI object. If transparency values are near 1, the element can look almost invisible.",
        es="UIGradient aplica degradados de color o transparencia al elemento GUI padre. Si la transparencia se acerca a 1, el elemento puede parecer casi invisible.",
      },
      {
        keys={
          "canvasgroup",
          "canvas group",
          "группа gui",
        },
        ru="CanvasGroup позволяет плавно менять прозрачность всей группы через GroupTransparency. Проверь это свойство при проблемах с видимостью: даже непрозрачные дочерние элементы могут исчезнуть вместе с группой.",
        en="CanvasGroup can fade an entire group through GroupTransparency. Check this property when visibility fails: opaque children can still disappear with the group.",
        es="CanvasGroup permite cambiar la transparencia de todo el grupo mediante GroupTransparency. Si algo no se ve, revisa esta propiedad: los hijos opacos también pueden desaparecer.",
      },
      {
        keys={
          "zindex",
          "z-index",
          "порядок слоёв gui",
          "orden de capas gui",
        },
        ru="ZIndex определяет порядок наложения GUI-элементов в пределах интерфейса. Если кнопка перекрывается другим элементом, проверь ZIndex и поведение ZIndexBehavior.",
        en="ZIndex controls the stacking order of GUI elements. If a button is covered, check ZIndex and ZIndexBehavior.",
        es="ZIndex determina el orden de superposición de elementos GUI. Si un botón queda tapado, revisa ZIndex y ZIndexBehavior.",
      },
      {
        keys={
          "udim2",
          "udim2.new",
          "позиция gui",
          "размер gui",
        },
        ru="UDim2 задаёт позицию или размер GUI в виде сочетания относительной доли и пиксельного смещения по двум осям. Scale помогает адаптироваться к экранам разных размеров, Offset удобен для фиксированных отступов.",
        en="UDim2 defines a GUI position or size using scale and pixel offset on both axes. Scale adapts to different screens, while Offset is useful for fixed spacing.",
        es="UDim2 define la posición o tamaño GUI combinando escala relativa y desplazamiento en píxeles. Scale se adapta a distintas pantallas; Offset sirve para márgenes fijos.",
      },
      {
        keys={
          "color3.fromrgb",
          "color3",
          "цвет3",
          "rgb roblox",
        },
        ru="Color3 представляет цвет в Roblox. Color3.fromRGB() принимает три канала от 0 до 255; Color3.new() использует значения от 0 до 1.",
        en="Color3 represents a Roblox color. Color3.fromRGB() takes channels from 0 to 255, while Color3.new() uses values from 0 to 1.",
        es="Color3 representa un color de Roblox. Color3.fromRGB() recibe canales de 0 a 255; Color3.new() usa valores de 0 a 1.",
      },
      {
        keys={
          "enum",
          "enum.item",
          "перечисление roblox",
        },
        ru="Enum — набор заранее определённых значений, например Enum.Font.Gotham или Enum.KeyCode.Space. Использование корректного элемента Enum помогает избежать опечаток в строках.",
        en="Enum is a set of predefined values such as Enum.Font.Gotham or Enum.KeyCode.Space. Using the correct Enum item avoids string typos.",
        es="Enum es un conjunto de valores predefinidos, como Enum.Font.Gotham o Enum.KeyCode.Space. Usar el elemento correcto evita errores de texto.",
      },
      {
        keys={
          "waitforchild",
          "wait for child",
          "ожидание дочернего объекта",
        },
        ru="WaitForChild() ждёт появления дочернего объекта и возвращает его. Укажи разумный timeout там, где объект может не появиться, чтобы не зависнуть навсегда.",
        en="WaitForChild() waits for a child instance and returns it. Use a reasonable timeout when the instance may never appear.",
        es="WaitForChild() espera a que aparezca una instancia hija y la devuelve. Usa un tiempo límite razonable si podría no aparecer.",
      },
      {
        keys={
          "findfirstchild",
          "find first child",
          "поиск дочернего объекта",
        },
        ru="FindFirstChild() проверяет наличие дочернего объекта и сразу возвращает его или nil. В отличие от WaitForChild(), он не ждёт появления элемента.",
        en="FindFirstChild() immediately returns a child if present, or nil. Unlike WaitForChild(), it does not wait for an instance to appear.",
        es="FindFirstChild() devuelve inmediatamente un hijo si existe, o nil. A diferencia de WaitForChild(), no espera a que aparezca.",
      },
      {
        keys={
          "getdescendants",
          "get descendants",
          "все потомки",
        },
        ru="GetDescendants() возвращает все вложенные объекты под данным экземпляром. На больших деревьях это может быть дорого, поэтому не пересоздавай список каждый кадр без необходимости.",
        en="GetDescendants() returns every nested instance under an object. It can be costly for large trees, so avoid rebuilding the list every frame unnecessarily.",
        es="GetDescendants() devuelve todas las instancias anidadas dentro de un objeto. Puede ser costoso en árboles grandes; evita reconstruir la lista en cada fotograma sin necesidad.",
      },
      {
        keys={
          "destroy()",
          "instance destroy",
          "удалить объект roblox",
        },
        ru="Destroy() удаляет экземпляр и его потомков из игры. После уничтожения не используй ссылку как будто объект всё ещё существует; при очистке отключай связанные события.",
        en="Destroy() removes an instance and its descendants. Do not keep using it as if it still exists; disconnect related events when cleaning up.",
        es="Destroy() elimina una instancia y sus descendientes. No sigas usándola como si existiera; desconecta los eventos asociados al limpiar.",
      },
      {
        keys={
          "clone()",
          "instance clone",
          "клонировать объект",
        },
        ru="Clone() создаёт копию экземпляра и его клонируемых потомков. Чтобы копия появилась в игре, обычно нужно установить её Parent.",
        en="Clone() creates a copy of an instance and its archivable descendants. To make the copy appear in the game, you usually need to set its Parent.",
        es="Clone() crea una copia de una instancia y sus descendientes clonables. Para que aparezca en el juego normalmente debes asignar Parent.",
      },
      {
        keys={
          "parent property",
          "свойство parent",
          "propiedad parent",
        },
        ru="Parent указывает родительский объект в иерархии Roblox. Если Parent равен nil, объект не находится в обычном дереве игры и может быть не виден игроку.",
        en="Parent identifies an instance's parent in the Roblox hierarchy. If Parent is nil, the object is outside the normal game tree and may not be visible.",
        es="Parent indica el objeto padre en la jerarquía de Roblox. Si vale nil, el objeto está fuera del árbol normal del juego y quizá no sea visible.",
      },
      {
        keys={
          "debounce",
          "дебаунс",
          "bloqueo de doble clic",
        },
        ru="Debounce — приём, который временно блокирует повторный запуск действия, пока предыдущий не завершён или не истёк короткий интервал. Он помогает предотвращать двойные нажатия и повторные награды.",
        en="Debounce temporarily blocks repeated action calls until the previous action completes or a short interval passes. It helps prevent double clicks and duplicate rewards.",
        es="Debounce bloquea temporalmente llamadas repetidas hasta que termina la acción anterior o pasa un intervalo breve. Evita dobles clics y recompensas duplicadas.",
      },
      {
        keys={
          "cooldown",
          "перезарядка способности",
          "tiempo de recarga",
        },
        ru="Cooldown — период, в течение которого действие нельзя повторить. Его следует проверять на авторитетной стороне игры, если он влияет на честность или награды.",
        en="Cooldown is a period during which an action cannot be repeated. If it affects fairness or rewards, enforce it on the authoritative game side.",
        es="Cooldown es el periodo durante el cual no se puede repetir una acción. Si afecta a la equidad o recompensas, debe validarse en el servidor.",
      },
      {
        keys={
          "memory leak",
          "утечка памяти",
          "fuga de memoria",
        },
        ru="Утечка памяти возникает, когда ненужные объекты или ссылки продолжают удерживаться и не освобождаются. В GUI регулярно уничтожай временные элементы и отключай события при закрытии окна.",
        en="A memory leak occurs when unneeded objects or references remain retained. In UI code, destroy temporary elements and disconnect events when a window closes.",
        es="Una fuga de memoria ocurre cuando se conservan objetos o referencias innecesarias. En interfaces, destruye elementos temporales y desconecta eventos al cerrar una ventana.",
      },
      {
        keys={
          "connection disconnect",
          "disconnect event",
          "отключить событие",
        },
        ru="Disconnect() отключает подписку на событие, возвращённую Connect(). Это важно для временных окон и повторных запусков скрипта, чтобы старые обработчики не продолжали работать.",
        en="Disconnect() disables an event connection returned by Connect(). It matters for temporary windows and reruns so old handlers do not keep running.",
        es="Disconnect() desactiva una conexión de evento creada por Connect(). Es importante en ventanas temporales y al reiniciar para que no sigan activos los controladores antiguos.",
      },
      {
        keys={
          "characteradded",
          "character added",
          "появление персонажа",
        },
        ru="CharacterAdded срабатывает, когда у игрока появляется новый персонаж. Используй его для повторного поиска Humanoid и частей персонажа после возрождения.",
        en="CharacterAdded fires when a player's character spawns. Use it to reacquire the Humanoid and character parts after respawn.",
        es="CharacterAdded se activa cuando aparece el personaje del jugador. Úsalo para volver a localizar Humanoid y las partes del personaje tras reaparecer.",
      },
      {
        keys={
          "humanoid",
          "humanoid здоровье",
          "объект humanoid",
        },
        ru="Humanoid управляет частью поведения персонажа Roblox: здоровьем, движением, состояниями и смертью. Персонаж может перезагружаться, поэтому ссылку на Humanoid нужно обновлять после возрождения.",
        en="Humanoid controls aspects of a Roblox character such as health, movement, states, and death. Characters respawn, so reacquire the Humanoid after each respawn.",
        es="Humanoid controla aspectos del personaje, como salud, movimiento, estados y muerte. Como el personaje reaparece, vuelve a localizar Humanoid tras cada reaparición.",
      },
      {
        keys={
          "humanoidrootpart",
          "humanoid root part",
          "корневая часть персонажа",
        },
        ru="HumanoidRootPart — центральная часть стандартного персонажа, часто используемая для позиции и направления. Не предполагай, что она уже создана: персонаж может ещё загружаться.",
        en="HumanoidRootPart is the central part of a standard character, often used for position and orientation. Do not assume it exists before the character finishes loading.",
        es="HumanoidRootPart es la parte central del personaje estándar, usada para posición y orientación. No supongas que existe antes de terminar la carga.",
      },
      {
        keys={
          "players service",
          "players service",
          "сервис игроков",
        },
        ru="Players содержит игроков текущего сервера и события их входа и выхода. На клиенте LocalPlayer обозначает текущего игрока; серверный код должен учитывать всех подключённых игроков.",
        en="Players contains players on the current server and join/leave events. On the client, LocalPlayer identifies the current player; server code must handle all players.",
        es="Players contiene los jugadores del servidor y eventos de entrada y salida. En el cliente, LocalPlayer identifica al jugador actual; el servidor debe gestionar a todos.",
      },
      {
        keys={
          "replicatedstorage",
          "replicated storage",
          "общие реплицируемые данные",
        },
        ru="ReplicatedStorage хранит объекты, доступные и клиенту, и серверу. Не помещай туда секреты или критичные проверки: клиент может видеть содержимое реплицируемых объектов.",
        en="ReplicatedStorage stores objects accessible to both client and server. Do not put secrets or critical validation there because clients can see replicated contents.",
        es="ReplicatedStorage guarda objetos accesibles para cliente y servidor. No pongas secretos ni validaciones críticas allí: el cliente puede ver su contenido.",
      },
      {
        keys={
          "serverstorage",
          "server storage",
          "серверное хранилище",
        },
        ru="ServerStorage хранит объекты только на сервере и не реплицирует их клиентам напрямую. Он подходит для шаблонов и ресурсов, которые не должны быть видны клиенту до использования.",
        en="ServerStorage stores objects only on the server and does not replicate them directly to clients. It suits templates and assets that should stay server-side until needed.",
        es="ServerStorage guarda objetos solo en el servidor y no los replica directamente al cliente. Sirve para plantillas y recursos que deben permanecer del lado del servidor.",
      },
      {
        keys={
          "startergui",
          "starter gui",
          "стартовый интерфейс",
        },
        ru="StarterGui содержит шаблоны интерфейса, которые копируются в PlayerGui при появлении игрока. Для изменений во время игры обычно обращаются к копии в PlayerGui.",
        en="StarterGui contains UI templates copied into PlayerGui when a player spawns. For runtime changes, scripts usually work with the copy in PlayerGui.",
        es="StarterGui contiene plantillas de interfaz que se copian a PlayerGui cuando aparece el jugador. Para cambios durante el juego normalmente se usa la copia en PlayerGui.",
      },
      {
        keys={
          "datastoreservice",
          "data store service",
          "сохранение данных roblox",
        },
        ru="DataStoreService сохраняет данные между игровыми сессиями на стороне сервера. Запросы могут завершаться ошибкой или ограничиваться по частоте, поэтому применяют pcall, обработку ошибок и разумное кэширование.",
        en="DataStoreService persists data between sessions on the server. Calls can fail or be throttled, so use pcall, error handling, and sensible caching.",
        es="DataStoreService guarda datos entre sesiones en el servidor. Las llamadas pueden fallar o tener límites; usa pcall, manejo de errores y caché razonable.",
      },
      {
        keys={
          "leaderstats",
          "лидерстатс",
          "tabla de clasificación",
        },
        ru="leaderstats — соглашение в Roblox для отображения статистики игрока в списке игроков. Значения обычно создают на сервере и обновляют только после проверки игрового действия.",
        en="leaderstats is a Roblox convention for showing player stats in the player list. Values are usually created on the server and updated only after validating game actions.",
        es="leaderstats es una convención de Roblox para mostrar estadísticas en la lista de jugadores. Normalmente se crean en el servidor y se actualizan tras validar la acción.",
      },
      {
        keys={
          "cframe",
          "cframe.new",
          "позиция и поворот",
        },
        ru="CFrame задаёт положение и ориентацию в 3D-пространстве. Его используют для перемещения объектов и вычисления относительных смещений; для одного лишь направления можно также использовать вектор.",
        en="CFrame represents a 3D position and orientation. It is used to move objects and calculate relative offsets; a vector may suffice when only direction is needed.",
        es="CFrame representa posición y orientación 3D. Se usa para mover objetos y calcular desplazamientos relativos; un vector puede bastar si solo importa la dirección.",
      },
      {
        keys={
          "vector3",
          "vector3.new",
          "трёхмерный вектор",
        },
        ru="Vector3 хранит три числа: X, Y и Z. Он используется для позиций, направлений, скорости и размеров в трёхмерном пространстве.",
        en="Vector3 stores three numbers: X, Y, and Z. It is used for positions, directions, velocity, and dimensions in 3D space.",
        es="Vector3 guarda tres números: X, Y y Z. Se utiliza para posiciones, direcciones, velocidad y dimensiones en el espacio 3D.",
      },
      {
        keys={
          "raycastparams",
          "raycast params",
          "параметры raycast",
        },
        ru="RaycastParams задаёт фильтр и параметры лучевого запроса, например какие объекты исключить. Он помогает избежать попадания луча в собственный персонаж, когда этого не требуется.",
        en="RaycastParams configures a raycast filter, such as which objects to exclude. It can prevent a ray from hitting the local character when that is unwanted.",
        es="RaycastParams configura el filtro del raycast, por ejemplo qué objetos excluir. Puede evitar que el rayo golpee al propio personaje cuando no conviene.",
      },
      {
        keys={
          "raycast",
          "workspace:raycast",
          "лучевой запрос",
        },
        ru="Raycast проверяет, какой объект пересекает луч в 3D-пространстве. Он часто используется для определения препятствий, прицеливания и проверки видимости, но результат зависит от фильтров и геометрии.",
        en="Raycast tests which object a line intersects in 3D space. It is used for obstacles, aiming, and visibility checks, but results depend on filters and geometry.",
        es="Raycast comprueba qué objeto cruza un rayo en el espacio 3D. Se usa para obstáculos, apuntado y visibilidad, pero depende de filtros y geometría.",
      },
      {
        keys={
          "cancollide",
          "can collide",
          "столкновения объектов",
        },
        ru="CanCollide определяет, сталкивается ли физическая часть с другими частями. Отключение столкновений может сделать объект проходным, но не отключает все проверки касаний или лучей.",
        en="CanCollide controls whether a physical part collides with other parts. Turning it off makes the part pass-through, but does not disable every touch or raycast check.",
        es="CanCollide determina si una pieza colisiona con otras. Desactivarlo permite atravesarla, pero no desactiva todas las detecciones de toque o raycast.",
      },
      {
        keys={
          "anchored",
          "anchor part",
          "закреплённая деталь",
        },
        ru="Anchored фиксирует деталь в мире и не позволяет обычной физике свободно перемещать её. Для анимирования закреплённых деталей часто меняют CFrame или используют TweenService.",
        en="Anchored fixes a part in the world so normal physics does not move it freely. Anchored parts can be animated by changing CFrame or using TweenService.",
        es="Anchored fija una pieza en el mundo para que la física normal no la mueva libremente. Puede animarse cambiando CFrame o usando TweenService.",
      },
      {
        keys={
          "soundid",
          "sound id",
          "идентификатор звука",
        },
        ru="SoundId указывает на аудио-ресурс Roblox. Даже корректный ID может не проигрываться, если у игры нет разрешения на использование аудио, оно недоступно или не прошло соответствующие проверки платформы.",
        en="SoundId points to a Roblox audio asset. A valid ID may still fail if the experience lacks permission to use it, the asset is unavailable, or platform checks restrict it.",
        es="SoundId apunta a un recurso de audio de Roblox. Un ID válido puede no reproducirse si la experiencia no tiene permiso, el recurso no está disponible o la plataforma lo restringe.",
      },
      {
        keys={
          "playback speed",
          "playbackspeed",
          "скорость проигрывания",
        },
        ru="PlaybackSpeed меняет скорость воспроизведения Sound. Значение выше 1 обычно ускоряет звук и может повысить тональность; ниже 1 замедляет и может снизить тон, в зависимости от источника.",
        en="PlaybackSpeed changes Sound playback rate. Values above 1 usually speed up audio and may raise pitch; values below 1 slow it and may lower pitch depending on the asset.",
        es="PlaybackSpeed cambia la velocidad de reproducción. Un valor mayor que 1 suele acelerar el audio y puede subir el tono; uno menor lo ralentiza y puede bajarlo.",
      },
      {
        keys={
          "sound volume",
          "sound.volume",
          "громкость sound",
        },
        ru="Sound.Volume задаёт громкость конкретного Sound в допустимом диапазоне. Итоговая громкость может также зависеть от SoundGroup, расстояния и других настроек аудио.",
        en="Sound.Volume sets the volume of a particular Sound within its allowed range. Final loudness may also depend on SoundGroup, distance, and other audio settings.",
        es="Sound.Volume establece el volumen de un Sound concreto dentro de su rango. El volumen final también puede depender de SoundGroup, distancia y otros ajustes de audio.",
      },
      {
        keys={
          "getservice",
          "game:getservice",
          "получение сервиса",
        },
        ru="game:GetService() получает сервис Roblox по имени, например Players или TweenService. Такой способ предпочтителен для доступа к сервисам, которые нужны скрипту.",
        en="game:GetService() retrieves a Roblox service by name, such as Players or TweenService. It is the standard way to access services a script needs.",
        es="game:GetService() obtiene un servicio de Roblox por nombre, como Players o TweenService. Es la forma habitual de acceder a los servicios necesarios.",
      },
      {
        keys={
          "os.clock",
          "os.time",
          "tick()",
          "таймер lua",
        },
        ru="os.clock() подходит для измерения прошедшего времени в текущем процессе, а os.time() возвращает время Unix в секундах. Выбирай функцию в зависимости от того, измеряешь длительность или календарное время.",
        en="os.clock() is useful for measuring elapsed time in the current process, while os.time() returns Unix time in seconds. Choose based on whether you need duration or calendar time.",
        es="os.clock() sirve para medir tiempo transcurrido en el proceso; os.time() devuelve tiempo Unix en segundos. Elige según necesites duración o tiempo de calendario.",
      },
      {
        keys={
          "math.random",
          "random number lua",
          "случайное число lua",
        },
        ru="math.random() возвращает псевдослучайное число. Для воспроизводимости или независимых генераторов в современных сценариях можно использовать Random.new() и объект Random.",
        en="math.random() returns a pseudorandom value. For independent generators or explicit seeding, modern scripts can use Random.new() and a Random object.",
        es="math.random() devuelve un valor seudoaleatorio. Para generadores independientes o una semilla explícita, se puede usar Random.new() y un objeto Random.",
      },
      {
        keys={
          "math.clamp",
          "ограничить значение",
          "limitar valor",
        },
        ru="math.clamp(x, mínimo, máximo) ограничивает число заданным диапазоном. Это удобно для ползунков громкости, FOV и размеров интерфейса.",
        en="math.clamp(x, min, max) constrains a number to a range. It is useful for volume sliders, FOV, and UI sizes.",
        es="math.clamp(x, mínimo, máximo) limita un número a un rango. Sirve para controles de volumen, FOV y tamaños de interfaz.",
      },
      {
        keys={
          "string.gsub",
          "gsub lua",
          "замена текста lua",
        },
        ru="string.gsub() заменяет совпадения в строке по шаблону и возвращает новую строку вместе с числом замен. Он часто используется для очистки пробелов и форматирования текста.",
        en="string.gsub() replaces pattern matches in a string and returns the new string plus the number of replacements. It is often used to trim or format text.",
        es="string.gsub() reemplaza coincidencias de patrón y devuelve la cadena nueva junto con el número de reemplazos. Se usa para limpiar o formatear texto.",
      },
      {
        keys={
          "string.sub",
          "sub lua string",
          "часть строки lua",
        },
        ru="string.sub() извлекает часть строки по индексам. В Lua индексация строк начинается с 1; отрицательные индексы отсчитывают символы с конца.",
        en="string.sub() extracts part of a string by index. Lua string indices start at 1; negative indices count from the end.",
        es="string.sub() extrae una parte de la cadena por índices. En Lua se empieza desde 1; los índices negativos cuentan desde el final.",
      },
      {
        keys={
          "string.find",
          "find lua string",
          "найти текст lua",
        },
        ru="string.find() ищет совпадение и возвращает начальную и конечную позиции. Безопасно проверяй результат: если совпадения нет, функция вернёт nil.",
        en="string.find() searches for a match and returns start and end positions. Check the result because it returns nil when no match is found.",
        es="string.find() busca una coincidencia y devuelve las posiciones inicial y final. Comprueba el resultado porque devuelve nil si no hay coincidencia.",
      },
      {
        keys={
          "string.lower",
          "нижний регистр lua",
          "minúsculas lua",
        },
        ru="string.lower() переводит строку в нижний регистр для сравнений без учёта регистра. Обработка Unicode может быть ограничена, поэтому не все языковые символы преобразуются одинаково.",
        en="string.lower() converts a string to lowercase for case-insensitive comparisons. Unicode handling may be limited, so not every language character is converted equally.",
        es="string.lower() convierte una cadena a minúsculas para comparar sin distinguir mayúsculas. El soporte Unicode puede ser limitado.",
      },
      {
        keys={
          "string.format",
          "format lua string",
          "форматирование строки",
        },
        ru="string.format() создаёт строку по шаблону с подстановками, например числами с заданным количеством знаков. Следи, чтобы типы аргументов соответствовали спецификаторам формата.",
        en="string.format() builds a string from a format template, such as numbers with a chosen precision. Ensure argument types match the format specifiers.",
        es="string.format() crea una cadena a partir de una plantilla, por ejemplo números con precisión elegida. Asegúrate de que los tipos coincidan con los especificadores.",
      },
      {
        keys={
          "coroutine",
          "корутина",
          "corutina lua",
        },
        ru="Корутина — механизм приостановки и продолжения выполнения кода. Это не то же самое, что параллельный поток; нужно понимать, где и когда корутина возобновляется.",
        en="A coroutine lets code pause and resume. It is not the same as a parallel thread; understand where and when the coroutine is resumed.",
        es="Una corrutina permite pausar y reanudar código. No es lo mismo que un hilo paralelo; hay que entender dónde y cuándo se reanuda.",
      },
      {
        keys={
          "task.delay",
          "задержанный запуск",
          "ejecución retrasada",
        },
        ru="task.delay() планирует вызов функции после заданной задержки и сразу возвращает управление текущему коду. Точный момент запуска не гарантируется до миллисекунды.",
        en="task.delay() schedules a function after a delay and returns control immediately. The exact start time is not guaranteed to the millisecond.",
        es="task.delay() programa una función tras una demora y devuelve el control inmediatamente. El instante exacto no está garantizado al milisegundo.",
      },
      {
        keys={
          "task.cancel",
          "отменить задачу",
          "cancelar tarea",
        },
        ru="task.cancel() пытается отменить запланированную задачу, если у тебя есть её thread-объект и среда поддерживает отмену. Не полагайся на него для очистки уже выполненных действий.",
        en="task.cancel() attempts to cancel a scheduled task when you have its thread object and the runtime supports cancellation. It cannot undo work already completed.",
        es="task.cancel() intenta cancelar una tarea programada si tienes su objeto thread y el entorno lo permite. No deshace trabajo ya completado.",
      },
      {
        keys={
          "bindableevent",
          "bindable event",
          "внутреннее событие",
        },
        ru="BindableEvent передаёт событие между скриптами на одной стороне клиента/сервера. В отличие от RemoteEvent, он сам по себе не связывает клиент с сервером.",
        en="BindableEvent communicates between scripts on the same side of the client/server boundary. Unlike RemoteEvent, it does not bridge client and server by itself.",
        es="BindableEvent comunica scripts del mismo lado cliente/servidor. A diferencia de RemoteEvent, por sí mismo no conecta cliente con servidor.",
      },
      {
        keys={
          "collectionservice",
          "collection service",
          "теги объектов",
        },
        ru="CollectionService позволяет назначать теги экземплярам и находить все объекты с определённым тегом. Это удобнее ручного поиска по названиям, когда группа объектов имеет одинаковую роль.",
        en="CollectionService tags instances and retrieves all objects with a given tag. This can be cleaner than searching names when many objects share a role.",
        es="CollectionService asigna etiquetas a instancias y encuentra objetos con una etiqueta. Puede ser más limpio que buscarlos por nombre cuando comparten función.",
      },
      {
        keys={
          "proximityprompt",
          "proximity prompt",
          "подсказка взаимодействия",
        },
        ru="ProximityPrompt показывает игроку действие при приближении к объекту. Сервер всё равно должен проверять дистанцию и состояние, если действие влияет на важную игровую логику.",
        en="ProximityPrompt presents an interaction when a player approaches an object. The server should still validate distance and state for important game actions.",
        es="ProximityPrompt muestra una interacción cuando el jugador se acerca. El servidor debe validar distancia y estado si la acción afecta a la lógica importante.",
      },
      {
        keys={
          "clickdetector",
          "click detector",
          "детектор клика",
        },
        ru="ClickDetector позволяет реагировать на клики по объекту в мире. Для мобильного интерфейса лучше учитывать сенсорные сценарии и не рассчитывать только на мышь.",
        en="ClickDetector lets a world object react to clicks. For mobile UI, account for touch interactions instead of relying only on mouse input.",
        es="ClickDetector permite responder a clics sobre un objeto del mundo. En móviles, contempla el tacto y no dependas solo del ratón.",
      },
      {
        keys={
          "tool",
          "инструмент roblox",
          "herramienta roblox",
        },
        ru="Tool — объект предмета, который игрок может экипировать. События Equipped и Unequipped подходят для включения и выключения связанных эффектов или интерфейса.",
        en="Tool is an item a player can equip. Equipped and Unequipped events can enable or disable related effects or UI.",
        es="Tool es un objeto que el jugador puede equipar. Los eventos Equipped y Unequipped pueden activar o desactivar efectos o interfaz relacionados.",
      },
      {
        keys={
          "pathfindingservice",
          "pathfinding service",
          "поиск пути npc",
        },
        ru="PathfindingService вычисляет маршрут персонажа с учётом проходимости пространства. Маршрут может стать недействительным при изменении карты, поэтому NPC иногда нужно пересчитывать путь.",
        en="PathfindingService computes a route based on traversable space. A route may become invalid as the map changes, so NPCs sometimes need to recompute it.",
        es="PathfindingService calcula rutas según el espacio transitable. La ruta puede quedar obsoleta si cambia el mapa, por lo que a veces hay que recalcularla.",
      },
      {
        keys={
          "humanoid moveto",
          "humanoid:moveto",
          "движение npc",
        },
        ru="Humanoid:MoveTo() просит персонажа двигаться к указанной точке. Для NPC проверяй, дошёл ли он до цели, и обрабатывай случаи, когда путь перекрыт.",
        en="Humanoid:MoveTo() asks a character to walk toward a target point. For NPCs, check whether the target was reached and handle blocked paths.",
        es="Humanoid:MoveTo() pide al personaje que camine hacia un punto. En NPC, comprueba si llegó al destino y maneja rutas bloqueadas.",
      },
      {
        keys={
          "tweeninfo",
          "tween info",
          "параметры tween",
        },
        ru="TweenInfo задаёт длительность, стиль плавности, направление, число повторов и автоповорот tween-анимации. Выбирай стиль в зависимости от задачи: мягкий интерфейс обычно выигрывает от коротких переходов.",
        en="TweenInfo defines duration, easing style and direction, repeat count, and reverse behavior for a tween. Choose the style to fit the task; UI often benefits from short transitions.",
        es="TweenInfo define duración, estilo y dirección de easing, repeticiones y reversa de una animación tween. Elige el estilo según la tarea; la interfaz suele beneficiarse de transiciones breves.",
      },
      {
        keys={
          "uisizelimit",
          "uitextsizelimit",
          "ограничение размера текста",
        },
        ru="UITextSizeConstraint ограничивает минимальный и максимальный размер текста, когда его размер масштабируется. Это помогает сохранить читаемость на маленьких и больших экранах.",
        en="UITextSizeConstraint limits the minimum and maximum text size when scaling is used. It helps preserve readability on small and large screens.",
        es="UITextSizeConstraint limita el tamaño mínimo y máximo del texto cuando se escala. Ayuda a mantener la legibilidad en pantallas pequeñas y grandes.",
      },
      {
        keys={
          "automaticcanvasSize",
          "automatic size gui",
          "автоматический размер canvas",
        },
        ru="AutomaticCanvasSize позволяет прокручиваемой области подстраивать CanvasSize под содержимое. Убедись, что дочерние элементы действительно задают корректный размер, иначе область прокрутки может быть слишком маленькой.",
        en="AutomaticCanvasSize lets a scrolling region size its canvas to content. Ensure children provide correct sizes or the scroll area may be too small.",
        es="AutomaticCanvasSize adapta el lienzo de desplazamiento al contenido. Asegúrate de que los hijos tengan tamaños correctos o el área puede quedar demasiado pequeña.",
      },
      {
        keys={
          "textwrapped",
          "text wrapped",
          "перенос текста gui",
        },
        ru="TextWrapped переносит длинный текст на новые строки внутри TextLabel или TextButton. В сочетании с фиксированной высотой текст всё ещё может обрезаться, поэтому рассчитывай высоту или применяй прокрутку.",
        en="TextWrapped wraps long text onto multiple lines in a TextLabel or TextButton. Fixed height can still clip content, so calculate height or use scrolling.",
        es="TextWrapped divide el texto largo en varias líneas. Una altura fija aún puede cortarlo; calcula la altura o utiliza desplazamiento.",
      },
      {
        keys={
          "textscaled",
          "text scaled",
          "масштабировать текст",
        },
        ru="TextScaled подгоняет размер текста под область элемента. На мобильных это может помочь, но строки разной длины могут выглядеть непоследовательно; для более предсказуемого вида используй TextSize и ограничения.",
        en="TextScaled fits text to its container. It can help on mobile, but different labels may end up with inconsistent sizes; fixed TextSize and constraints are more predictable.",
        es="TextScaled adapta el texto al contenedor. Puede ayudar en móviles, pero las etiquetas pueden acabar con tamaños distintos; TextSize fijo y restricciones son más previsibles.",
      },
      {
        keys={
          "layoutorder",
          "layout order",
          "порядок элементов",
        },
        ru="LayoutOrder определяет порядок элемента при использовании UIListLayout или UIGridLayout. Измени это число, если элементы отображаются не в том порядке, в котором были созданы.",
        en="LayoutOrder controls an item’s order in UIListLayout or UIGridLayout. Change it when items display in a different order from their creation order.",
        es="LayoutOrder controla el orden de un elemento en UIListLayout o UIGridLayout. Cámbialo si los elementos aparecen en un orden distinto al esperado.",
      },
      {
        keys={
          "anchorpoint",
          "anchor point gui",
          "якорная точка",
        },
        ru="AnchorPoint выбирает точку элемента, которая привязана к его Position. Значение 0.5, 0.5 означает центр; это упрощает центрирование и анимации масштабирования.",
        en="AnchorPoint chooses which point of an element is positioned at Position. A value of 0.5, 0.5 means the center and simplifies centering and scale animations.",
        es="AnchorPoint elige qué punto del elemento se coloca en Position. El valor 0.5, 0.5 representa el centro y facilita centrado y animaciones de escala.",
      },
      {
        keys={
          "uiscale",
          "ui scale",
          "масштаб интерфейса",
        },
        ru="UIScale равномерно масштабирует GUI-элемент и его содержимое. На телефонах можно вычислять масштаб по ViewportSize, но нижняя граница должна оставлять текст читаемым.",
        en="UIScale uniformly scales a GUI object and its contents. On phones, scale can depend on ViewportSize, but a lower bound should keep text readable.",
        es="UIScale escala uniformemente un elemento GUI y su contenido. En móviles puede depender de ViewportSize, pero el mínimo debe mantener el texto legible.",
      },
      {
        keys={
          "uiaspectratioconstraint",
          "aspect ratio constraint",
          "соотношение сторон gui",
        },
        ru="UIAspectRatioConstraint удерживает заданное соотношение ширины и высоты. Это полезно для круглых кнопок и квадратных значков, особенно при разных пропорциях экрана.",
        en="UIAspectRatioConstraint preserves a width-to-height ratio. It is useful for circular buttons and square icons across different screen shapes.",
        es="UIAspectRatioConstraint conserva la proporción entre ancho y alto. Es útil para botones circulares e iconos cuadrados en distintas pantallas.",
      },
      {
        keys={
          "numbersequence",
          "числовая последовательность roblox",
          "secuencia numérica",
        },
        ru="NumberSequence описывает значение, меняющееся вдоль диапазона 0–1, например прозрачность по длине эффекта. Если прозрачность везде близка к 1, эффект почти исчезает.",
        en="NumberSequence describes a value changing across a 0–1 range, such as transparency along an effect. If transparency stays near 1, the effect nearly disappears.",
        es="NumberSequence describe un valor que cambia a lo largo del rango 0–1, como transparencia en un efecto. Si se acerca a 1 en todo el rango, el efecto casi desaparece.",
      },
      {
        keys={
          "colorsequence",
          "цветовая последовательность",
          "secuencia de color",
        },
        ru="ColorSequence задаёт изменение цвета по диапазону, например градиент партиклов или интерфейса. Контрастные цвета помогают выделить направление перехода.",
        en="ColorSequence defines how color changes across a range, such as a particle or UI gradient. Contrasting colors make the transition clearer.",
        es="ColorSequence define cómo cambia el color a lo largo de un rango, por ejemplo en partículas o gradientes de interfaz. Colores contrastantes hacen más visible la transición.",
      },
      {
        keys={
          "delta time",
          "deltatime",
          "дельта времени",
        },
        ru="Delta time — время между обновлениями. Умножение скорости на delta time помогает сохранять похожую скорость движения при разном FPS, вместо того чтобы перемещаться на фиксированное расстояние каждый кадр.",
        en="Delta time is the time between updates. Multiplying velocity by delta time keeps movement more consistent across different FPS instead of moving a fixed distance per frame.",
        es="Delta time es el tiempo entre actualizaciones. Multiplicar la velocidad por delta time hace el movimiento más consistente con distintos FPS, en vez de avanzar una distancia fija por fotograma.",
      },
      {
        keys={
          "client server model",
          "клиент и сервер",
          "cliente y servidor",
        },
        ru="Клиент отвечает за локальное отображение и ввод, сервер — за авторитетное состояние общего мира. Клиентские данные не следует считать доверенными, особенно для валюты, урона и наград.",
        en="The client handles local presentation and input, while the server owns authoritative shared state. Client-provided data should not be trusted for currency, damage, or rewards.",
        es="El cliente gestiona presentación e entrada local; el servidor mantiene el estado compartido autoritativo. No confíes en datos del cliente para moneda, daño o recompensas.",
      },
      {
        keys={
          "exploit executor",
          "исполнитель lua",
          "entorno de ejecución",
        },
        ru="Lua-исполнитель — отдельная среда, которая запускает скрипты и может добавлять собственные HTTP-функции. Такие функции не являются частью стандартного Roblox API и могут отличаться по названию и доступности.",
        en="A Lua executor is a separate runtime that runs scripts and may expose its own HTTP functions. These are not part of the standard Roblox API and may vary by name and availability.",
        es="Un ejecutor Lua es un entorno separado que ejecuta scripts y puede ofrecer funciones HTTP propias. No forman parte de la API estándar de Roblox y su disponibilidad varía.",
      },
      {
        keys={
          "http request",
          "http request error",
          "ошибка http запроса",
        },
        ru="HTTP-запрос может не выполниться из-за отсутствия разрешения, сети, TLS, ограничений сервиса или несовместимого формата ответа. Используй тайм-аут, обрабатывай ошибку и сохраняй локальный запасной ответ.",
        en="An HTTP request can fail because of permissions, network, TLS, provider limits, or an unexpected response format. Use a timeout, handle failure, and keep a local fallback.",
        es="Una solicitud HTTP puede fallar por permisos, red, TLS, límites del servicio o formato inesperado. Usa un tiempo límite, maneja el error y conserva una respuesta local de respaldo.",
      },
      {
        keys={
          "cache",
          "кэширование",
          "caché web",
        },
        ru="Кэш временно хранит уже полученные результаты, чтобы ускорить повторные запросы. Для изменяющихся данных нужны срок годности и понятное правило очистки; кэш не должен бесконечно расти.",
        en="A cache temporarily stores fetched results to speed up repeat requests. Changing data needs expiration and cleanup; the cache should not grow without bound.",
        es="La caché guarda temporalmente resultados para acelerar consultas repetidas. Los datos cambiantes necesitan caducidad y limpieza; la caché no debe crecer sin límite.",
      },
      {
        keys={
          "timeout",
          "тайм-аут",
          "tiempo de espera",
        },
        ru="Timeout ограничивает, как долго программа ждёт ответ от операции. Он помогает не зависать при проблемах сети, но сам по себе не гарантирует отмену операции на сервере.",
        en="A timeout limits how long a program waits for an operation. It prevents long hangs during network problems but does not necessarily cancel work on the server.",
        es="Un timeout limita cuánto espera el programa una operación. Evita bloqueos largos por problemas de red, pero no siempre cancela el trabajo del servidor.",
      },
      {
        keys={
          "accessibility ui",
          "доступность интерфейса",
          "accesibilidad interfaz",
        },
        ru="Доступность интерфейса означает, что им могут пользоваться люди с разными устройствами и возможностями. Хороший контраст, крупные сенсорные цели и понятные подписи помогают всем.",
        en="UI accessibility means people with different abilities and devices can use the interface. Strong contrast, large touch targets, and clear labels help everyone.",
        es="La accesibilidad permite que personas con capacidades y dispositivos distintos usen la interfaz. Buen contraste, botones táctiles amplios y etiquetas claras ayudan a todos.",
      },
      {
        keys={
          "battery usage",
          "расход батареи",
          "consumo de batería",
        },
        ru="Частые обновления каждый кадр, постоянные циклы и сетевые запросы могут расходовать батарею. Используй события, интервалы обновления и выключай эффекты, когда окно закрыто.",
        en="Per-frame updates, constant loops, and network requests can drain battery. Prefer events and sensible update intervals, and stop effects when the window is closed.",
        es="Las actualizaciones por fotograma, ciclos constantes y solicitudes de red consumen batería. Usa eventos e intervalos razonables y detén efectos al cerrar la ventana.",
      },
      {
        keys={
          "ui animation",
          "анимация интерфейса",
          "animación de interfaz",
        },
        ru="Хорошая анимация быстро показывает результат действия и не мешает взаимодействию. Для интерфейса часто достаточно 0,15–0,35 секунды, плавной кривой и отмены старого tween перед новым.",
        en="Good animation confirms an action without slowing interaction. UI transitions often work well around 0.15–0.35 seconds with easing, while cancelling outdated tweens before starting new ones.",
        es="Una buena animación confirma la acción sin ralentizar la interacción. En interfaces suelen bastar 0,15–0,35 segundos con easing y cancelando tweens antiguos antes de iniciar otros.",
      },
      {
        keys={
          "contrast ui",
          "контраст текста",
          "contraste de texto",
        },
        ru="Контраст — различие между текстом и фоном. Для читаемости не делай второстепенный текст слишком тусклым и не используй прозрачность всего окна для приглушения отдельных элементов.",
        en="Contrast is the difference between text and its background. Keep secondary text readable and avoid fading the entire window to de-emphasize only some elements.",
        es="El contraste es la diferencia entre texto y fondo. Mantén legible el texto secundario y no reduzcas la opacidad de toda la ventana para atenuar solo algunos elementos.",
      },
      {
        keys={
          "responsive ui",
          "адаптивный интерфейс",
          "interfaz adaptable",
        },
        ru="Адаптивный интерфейс подстраивается под размер экрана и способ ввода. Проверяй короткие и длинные строки, экранную клавиатуру, узкую ширину и ориентацию устройства.",
        en="Responsive UI adapts to screen size and input method. Test short and long text, the on-screen keyboard, narrow widths, and device orientation.",
        es="Una interfaz adaptable se ajusta al tamaño de pantalla y método de entrada. Prueba textos cortos y largos, teclado en pantalla, anchura estrecha y orientación.",
      },
    }

local function aiAnswer(question)
    local q = string.lower(tostring(question or ""))
    local locale = aiLocale(question)
    local p = aiPhrases[locale] or aiPhrases.en
    local tiny = q:gsub("^%s+",
        ""):gsub("%s+$",
        "")
    if tiny == "" then return locale == "ru" and "Напиши вопрос о любой функции меню." or (locale == "es" and "Escribe una pregunta sobre cualquier función del menú." or "Ask me about any menu feature.") end
    if aiContains(q,
        {"привет",
        "здравствуй",
        "хай",
        "hello",
        "hi there",
        "hey",
        "hola",
        "buenas",
        "buenos días",
        "buenas tardes"}) then return p.hello[math.random(1,
        #p.hello)] end
    if aiContains(q,
        {"кто ты",
        "что ты такое",
        "who are you",
        "what are you",
        "quién eres",
        "que eres",
        "qué eres"}) then return p.who[math.random(1,
        #p.who)] end
    if aiContains(q,
        {"помощь",
        "что спросить",
        "что ты умеешь",
        "что умеешь",
        "какую помощь",
        "help",
        "what can you help with",
        "what can you do",
        "examples",
        "ayuda",
        "ayudarme",
        "en qué puedes ayudarme",
        "en que puedes ayudarme",
        "qué puedo preguntar",
        "que puedo preguntar"}) then return p.help[math.random(1,
        #p.help)] end
    if aiContains(q,
        {"напиши код",
        "сгенерируй код",
        "можешь программировать",
        "write code",
        "generate code",
        "can you code",
        "programa código",
        "escribe código",
        "puedes programar"}) then return p.code[math.random(1,
        #p.code)] end
    if aiContains(q,
        {"спасибо",
        "thanks",
        "thank you",
        "gracias",
        "muchas gracias"}) then
        if locale == "ru" then return "Пожалуйста! Задавай следующий вопрос — я постараюсь объяснить конкретную функцию." end
        if locale == "es" then return "¡De nada! Haz otra pregunta y trataré de explicar la función concreta." end
        return "You're welcome! Ask another question and I'll explain the specific feature."
    end
    if aiContains(q,
        {"подробнее",
        "а подробнее",
        "и дальше",
        "а это",
        "почему так",
        "more detail",
        "tell me more",
        "what about that",
        "más detalle",
        "cuéntame más",
        "y eso"}) and aiLastTopic and aiTopics[aiLastTopic] then
        local topic = aiTopics[aiLastTopic]
        local explanation = topic[locale] or topic.en
        return explanation[math.random(1,
            #explanation)] .. " " .. ((topic.tip and topic.tip[locale]) or "")
    end
    if aiContains(q, {"silent aim", "silent-aim", "silentaim", "сайлент эйм", "сайлент аим", "сайлент aim"}) then
        if locale == "ru" then
            return "В Roblox Silent Aim обычно называют чит, который пытается менять выбор цели для попаданий. Это может нарушать правила игры и привести к бану. Я могу объяснить, как разработчики Roblox обнаруживают такие вмешательства и защищают игру, но не помогать использовать чит."
        elseif locale == "es" then
            return "En Roblox, Silent Aim suele referirse a una trampa que altera la selección del objetivo. Puede infringir las reglas del juego y provocar una suspensión. Puedo explicar cómo proteger un juego, pero no ayudar a usar esa trampa."
        else
            return "In Roblox, Silent Aim usually refers to a cheat that alters target selection for hits. It may violate game rules and lead to a ban. I can explain how Roblox developers detect and defend against this, but I can't help use the cheat."
        end
    end
    local topicName, score = aiFindTopic(question)
    if topicName and score >= 1 then
        aiLastTopic = topicName
        local topic = aiTopics[topicName]
        local answers = topic[locale] or topic.en
        local answer = answers[math.random(1,
            #answers)]
        local tip = topic.tip and (topic.tip[locale] or topic.tip.en)
        if tip and math.random() > .36 then answer = answer .. " " .. tip end
        -- A short contextual lead varies the phrasing without pretending to be a free-form LLM.
        if math.random() > .58 then answer = p.open[math.random(1,
            #p.open)] .. " " .. answer end
        return answer
    end
    if aiContains(q,
        {"как открыть меню",
        "open menu",
        "abrir menú",
        "abrir menu",
        "кнопка a",
        "floating a"}) then
        if locale == "ru" then return "Плавающая круглая кнопка «A» открывает или закрывает главное меню. Отдельная кнопка «AI» открывает чат-помощник." end
        if locale == "es" then return "El botón flotante «A» abre o cierra el menú principal. El botón «AI» abre el chat del asistente." end
        return "The floating A button opens or closes the main menu. The separate AI button opens this assistant chat."
    end
    if aiContains(q,
        {"какие функции",
        "что умеет меню",
        "features",
        "what can this menu do",
        "qué funciones",
        "qué puede hacer el menú"}) then return p.help[math.random(1,
        #p.help)] end
    -- Small offline glossary extends the assistant beyond AuraMenu itself.
    -- It remains local and deliberately limited; it is not a generative LLM.
    local general = {
      {keys={"function", "функци", "función", "funcion"},
       ru="Функция — переиспользуемый блок кода для выполнения задачи. Она может принимать аргументы и возвращать результат через return; например, считать значение или обрабатывать нажатие кнопки.",
       en="A function is a reusable block of code that performs a task. It can accept arguments and return a value; for example, it can calculate something or handle a button press.",
       es="Una función es un bloque de código reutilizable. Puede recibir argumentos y devolver un valor; por ejemplo, calcular algo o responder a un botón."},
      {keys={"print(", "print function", "print функция", "print в lua"},
       ru="В Lua/Luau print() выводит значения в окно Output/консоль разработчика. Это удобно для отладки, но само по себе не меняет интерфейс игры.",
       en="In Lua/Luau, print() writes values to the Output/developer console. It is useful for debugging but does not itself change the game UI.",
       es="En Lua/Luau, print() escribe valores en la consola Output. Sirve para depurar, pero no cambia por sí sola la interfaz."},
      {keys={"pairs(", "pairs function", "pairs функция"},
       ru="pairs() перебирает пары ключ–значение таблицы Lua. Порядок обхода не гарантирован; для списков с числовыми индексами часто используют ipairs().",
       en="pairs() iterates through key-value pairs in a Lua table. Order is not guaranteed; ipairs() is often used for sequential lists.",
       es="pairs() recorre pares clave-valor de una tabla Lua. El orden no está garantizado; ipairs() suele usarse para listas secuenciales."},
      {keys={"ipairs(", "ipairs function", "ipairs функция"},
       ru="ipairs() проходит числовые индексы таблицы по порядку от 1 и останавливается на первом отсутствующем элементе.",
       en="ipairs() walks a table's integer indices in order from 1 and stops at the first missing element.",
       es="ipairs() recorre los índices enteros de una tabla en orden desde 1 y se detiene en el primer elemento ausente."},
      {keys={"tweenservice", "tween service", "tween в roblox"},
       ru="TweenService в Roblox плавно меняет свойства объекта за время: позицию, размер, цвет или прозрачность. Нужно задать объект, конечные свойства и TweenInfo.",
       en="Roblox TweenService smoothly changes object properties over time, such as position, size, color, or transparency. You specify the object, target properties, and TweenInfo.",
       es="TweenService en Roblox cambia suavemente propiedades con el tiempo, como posición, tamaño, color o transparencia. Se indican el objeto, las propiedades finales y TweenInfo."},
      {keys={"instance.new", "создать объект roblox", "создание объекта"},
       ru="Instance.new() создаёт экземпляр Roblox, например Frame, Part или Sound. Затем обычно задают свойства и Parent, чтобы поместить его в нужную часть иерархии.",
       en="Instance.new() creates a Roblox instance such as a Frame, Part, or Sound. You then set properties and Parent to place it in the hierarchy.",
       es="Instance.new() crea una instancia de Roblox, como Frame, Part o Sound. Después se configuran sus propiedades y Parent para colocarla en la jerarquía."},
      {keys={"remoteevent", "remote event", "удалённое событие", "удаленное событие"},
       ru="RemoteEvent передаёт сообщения между клиентом и сервером Roblox без ожидания ответа. Данные от клиента нужно проверять на сервере, а не считать автоматически доверенными.",
       en="RemoteEvent sends messages between a Roblox client and server without waiting for a response. The server should validate client data rather than automatically trusting it.",
       es="RemoteEvent envía mensajes entre el cliente y el servidor de Roblox sin esperar respuesta. El servidor debe validar los datos del cliente."},
      {keys={"localscript", "local script", "скрипт клиента", "клиентский скрипт"},
       ru="LocalScript выполняется на клиенте игрока и подходит для интерфейса, камеры и ввода. Важные игровые правила и проверки следует выполнять на сервере.",
       en="A LocalScript runs on the player's client and is suitable for UI, camera, and input. Important game rules and validation should run on the server.",
       es="LocalScript se ejecuta en el cliente y sirve para interfaz, cámara y entrada. Las reglas importantes y validaciones deben ejecutarse en el servidor."},
      {keys={"task.wait", "wait(", "задержка в lua", "ожидание в lua"},
       ru="task.wait() приостанавливает текущую задачу на некоторое время. Фактическая задержка может отличаться, поэтому для игровых циклов учитывают delta time или используют события.",
       en="task.wait() yields the current task for a while. Actual timing can vary, so game loops may need delta time or event-based logic.",
       es="task.wait() pausa la tarea actual durante un tiempo. La demora real puede variar; los ciclos pueden necesitar delta time o eventos."},
      {keys={"pcall(", "pcall function", "pcall функция"},
       ru="pcall() вызывает функцию в защищённом режиме: ошибка возвращается как результат, вместо немедленного распространения. Её всё равно следует обработать.",
       en="pcall() calls a function in protected mode: an error is returned instead of immediately propagating. Your code should still handle it.",
       es="pcall() llama a una función en modo protegido: el error se devuelve como resultado en vez de propagarse inmediatamente. Aun así, hay que gestionarlo."},
      {keys={"fps", "кадров в секунду", "frames per second", "fotogramas por segundo"},
       ru="FPS — число кадров в секунду. Больше FPS обычно даёт более плавное движение, но важны также стабильность кадров, нагрузка устройства и частота экрана.",
       en="FPS means frames per second. Higher FPS usually looks smoother, but frame-time stability, device load, and display refresh rate also matter.",
       es="FPS significa fotogramas por segundo. Más FPS suele verse más fluido, pero también importan la estabilidad, la carga del dispositivo y la pantalla."},
      {keys={"ping", "пинг", "latency", "latencia"},
       ru="Пинг — время прохождения сетевого сигнала туда и обратно. Низкий пинг обычно уменьшает сетевую задержку; потери пакетов тоже могут вызывать рывки.",
       en="Ping is the round-trip time of a network signal. Lower ping usually means less network delay; packet loss can still cause stutter.",
       es="El ping es el tiempo de ida y vuelta de una señal de red. Un ping bajo suele reducir el retraso, aunque la pérdida de paquetes también causa tirones."},
      {keys={"ram", "оперативная память", "memoria ram"},
       ru="RAM — оперативная память, где приложения держат используемые сейчас данные. Если её не хватает, устройство может замедляться. Очистка RAM не равна освобождению места в хранилище.",
       en="RAM holds data apps are actively using. If it is scarce, a device may slow down. Freeing RAM is different from freeing storage space.",
       es="La RAM guarda datos que las aplicaciones usan en ese momento. Si falta, el dispositivo puede ralentizarse. No es lo mismo que liberar almacenamiento."},
      {keys={"api", "апи", "application programming interface"},
       ru="API — определённый способ взаимодействия программ. Она может предоставлять данные или действия и иногда требует разрешений, ключа или соблюдения лимитов.",
       en="An API is a defined way for programs to interact. It can expose data or actions and may require permissions, a key, or usage limits.",
       es="Una API es una forma definida de interacción entre programas. Puede ofrecer datos o acciones y requerir permisos, una clave o límites."},
      {keys={"json", "джейсон"},
       ru="JSON — текстовый формат структурированных данных: объектов, массивов, строк, чисел, логических значений и null. Его часто используют в настройках и API.",
       en="JSON is a text format for structured data such as objects, arrays, strings, numbers, booleans, and null. It is common in settings and APIs.",
       es="JSON es un formato de texto para datos estructurados, como objetos, arrays, cadenas, números, booleanos y null. Se usa mucho en ajustes y APIs."},
      {keys={"luau", "lua язык", "язык lua", "lenguaje lua"},
       ru="Luau — язык сценариев на основе Lua, используемый в Roblox для игровой логики, интерфейсов и взаимодействий. Доступные API зависят от среды выполнения.",
       en="Luau is a Lua-based scripting language used in Roblox for game logic, UI, and interactions. Available APIs depend on the runtime.",
       es="Luau es un lenguaje de scripts basado en Lua y usado en Roblox para lógica, interfaz e interacciones. Las APIs disponibles dependen del entorno."},
      {keys={"variable", "переменн", "variab"},
       ru="Переменная связывает имя со значением. В Lua ключевое слово local ограничивает область видимости переменной и помогает избегать случайных конфликтов.",
       en="A variable associates a name with a value. In Lua, local limits its scope and helps avoid accidental conflicts.",
       es="Una variable asocia un nombre con un valor. En Lua, local limita su alcance y ayuda a evitar conflictos accidentales."},
      {keys={"loop", "цикл", "bucle", "for loop", "while loop"},
       ru="Цикл повторяет блок кода. for часто перебирает диапазон или таблицу, а while повторяет код, пока условие истинно. Не стоит надолго блокировать игровой поток.",
       en="A loop repeats code. for often iterates over a range or table; while repeats as long as a condition is true. Avoid blocking the game thread for long periods.",
       es="Un bucle repite código. for suele recorrer rangos o tablas; while repite mientras una condición sea verdadera. Evita bloquear el juego demasiado tiempo."},
      {keys={"fov", "field of view", "поле зрения", "campo de visión"},
       ru="FOV — поле зрения камеры. Большое значение показывает больше пространства по краям, но объекты могут казаться меньше; маленькое выглядит как приближение.",
       en="FOV is the camera's field of view. A larger value shows more at the edges but makes objects appear smaller; a lower value feels zoomed in.",
       es="FOV es el campo de visión. Un valor mayor muestra más espacio en los bordes, pero los objetos parecen menores; uno bajo se siente más acercado."}
    }
    -- Wider offline glossary for common Roblox, programming, UI, and networking terms.
    -- Each entry is short and multilingual to keep responses useful without a model API.
for _, entry in ipairs(extendedGeneral) do
        general[#general + 1] = entry
    end
    -- Prefer the closest, most specific topic instead of accepting the first loose keyword.
    local bestGeneral, bestGeneralScore = nil, 0
    for _, entry in ipairs(general) do
        local score = aiScoreTopic(question, entry)
        if score > bestGeneralScore then
            bestGeneral, bestGeneralScore = entry, score
        end
    end
    if bestGeneral then return bestGeneral[locale] or bestGeneral.en end
    if aiContains(q, {
        "что делает", "что такое", "как работает", "объясни",
        "what does", "what is", "how does", "explain",
        "qué hace", "que hace", "qué es", "que es", "cómo funciona", "como funciona", "explica"
    }) then
        if locale == "ru" then
            return "Могу объяснять общие понятия и функции меню. Сначала проверяю локальную справку, а неизвестные термины пытаюсь искать в интернете, если доступен HTTP. Напиши точное название функции или термина — например print(), TweenService, RemoteEvent, FPS или API."
        elseif locale == "es" then
            return "Puedo explicar conceptos generales y funciones del menú. Primero reviso la guía local y puedo buscar términos desconocidos en la web si HTTP está disponible. Escribe el nombre exacto, por ejemplo print(), TweenService, RemoteEvent, FPS o API."
        else
            return "I can explain general concepts and menu features. I check my local guide first, then may try a web lookup for unfamiliar terms when HTTP is available. Name the function or term—for example print(), TweenService, RemoteEvent, FPS, or API."
        end
    end
    return p.unknown[math.random(1,
        #p.unknown)]
end

local function aiLocalize(key)
    return T(key)
end

local aiFab = __AuraFixUtil.new("TextButton",
    {
    Name="AuraAIButton",
        Text="AI",
        Font=Enum.Font.GothamBlack,
        TextSize=15,
        TextColor3=WHITE,
        AutoButtonColor=false,
        AnchorPoint=Vector2.new(1,
        1),
        Position=UDim2.new(1,
        -15,
        1,
        -88),
        Size=UDim2.fromOffset(54,
        54),
        BackgroundColor3=accent,
        BackgroundTransparency=0,
        TextTransparency=0,
        ZIndex=300,
},
    gui)
__AuraFixUtil.round(aiFab,
    18)
local aiFabGradient = __AuraFixUtil.new("UIGradient",
    {Name="AIAccentGradient",
    Rotation=35,
    Color=ColorSequence.new({ColorSequenceKeypoint.new(0,
    __AuraFixUtil.light(accent)),
    ColorSequenceKeypoint.new(1,
    accent)})},
    aiFab)
local aiFabStroke = __AuraFixUtil.stroke(aiFab,
    2,
    accent,
    .25); aiFabStroke.Name = "AIAccentStroke"
local aiFabScale = __AuraFixUtil.new("UIScale",
    {Scale=1},
    aiFab)
__AuraFixUtil.press(aiFab)
cn(aiFab.MouseEnter,
    function() tw(aiFab,
    {Rotation=4},
    .16,
    EASE.Back); tw(aiFabScale,
    {Scale=1.06},
    .18,
    EASE.Back) end)
cn(aiFab.MouseLeave,
    function() tw(aiFab,
    {Rotation=0},
    .2,
    EASE.Sine); tw(aiFabScale,
    {Scale=1},
    .2,
    EASE.Quint) end)
TS:Create(aiFabStroke,
    TweenInfo.new(1.5,
    EASE.Sine,
    DIR.InOut,
    -1,
    true),
    {Transparency=.72,
    Thickness=3.5}):Play()
local aiFabDrag = __AuraFixUtil.drag(aiFab,
    aiFab,
    function(W,
    H) return 0,
    W-52,
    0,
    H-52 end)

local AI_THEME = {
    bg = Color3.fromRGB(248, 252, 255),
    bgEnd = Color3.fromRGB(239, 248, 252),
    header = Color3.fromRGB(230, 245, 250),
    text = Color3.fromRGB(31, 45, 57),
    sub = Color3.fromRGB(91, 111, 124),
    border = Color3.fromRGB(202, 222, 231),
    bubble = Color3.fromRGB(235, 244, 248),
    input = Color3.fromRGB(255, 255, 255),
    inputFocus = Color3.fromRGB(242, 250, 253),
    quick = Color3.fromRGB(233, 244, 249),
    quickHover = Color3.fromRGB(218, 237, 244),
}
local aiPanel = __AuraFixUtil.new("CanvasGroup",
    {
    Name="AuraAIChat",
        AnchorPoint=Vector2.new(.5,
        .5),
        Position=UDim2.fromScale(.5,
        .5),
        Size=UDim2.fromOffset(342,
        468),
        BackgroundColor3=AI_THEME.bg,
        BackgroundTransparency=0,
        BorderSizePixel=0,
        GroupTransparency=0,
        Visible=false,
        ClipsDescendants=true,
        ZIndex=290,
},
    gui)
__AuraFixUtil.round(aiPanel,
    17)
local aiPanelScale = __AuraFixUtil.new("UIScale",
    {Scale=1},
    aiPanel)
local aiPanelStroke = __AuraFixUtil.stroke(aiPanel,
    1.8,
    accent,
    .12); aiPanelStroke.Name = "AIAccentStroke"
local aiPanelStrokePulse = TS:Create(aiPanelStroke,
    TweenInfo.new(2.1, EASE.Sine, DIR.InOut, -1, true),
    {Transparency=.18, Thickness=1.45})
aiPanelStrokePulse:Play()
local aiPanelGradient = __AuraFixUtil.new("UIGradient",
    {Rotation=90,
    Color=ColorSequence.new(AI_THEME.bg, AI_THEME.bgEnd),
    Transparency=NumberSequence.new(0)},
    aiPanel)
local aiHeader = __AuraFixUtil.new("Frame",
    {Name="AIHeader",
    Size=UDim2.new(1,
    0,
    0,
    52),
    BackgroundColor3=AI_THEME.header,
    BackgroundTransparency=0,
    ZIndex=291},
    aiPanel)
local aiOrb = __AuraFixUtil.new("Frame",
    {Position=UDim2.fromOffset(10,
    9),
    Size=UDim2.fromOffset(34,
    34),
    BackgroundColor3=accent,
    ZIndex=292},
    aiHeader)
__AuraFixUtil.round(aiOrb,
    12); aiOrb.Name = "AIOrb"
local aiOrbStroke = __AuraFixUtil.stroke(aiOrb, 1, WHITE, .68)
__AuraFixUtil.new("UIGradient",
    {Name="AIAccentGradient",
    Rotation=40,
    Color=ColorSequence.new(__AuraFixUtil.light(accent),
    accent)},
    aiOrb)
__AuraFixUtil.lbl(aiOrb,
    "✦",
    19,
    WHITE,
    {TextXAlignment=Enum.TextXAlignment.Center,
    Font=Enum.Font.GothamBlack,
    ZIndex=293})
local aiTitle = __AuraFixUtil.lbl(aiHeader,
    "AURA AI",
    14,
    AI_THEME.text,
    {Position=UDim2.fromOffset(52,
    7),
    Size=UDim2.new(1,
    -94,
    0,
    20),
    Font=Enum.Font.GothamBlack,
    ZIndex=292})
local aiSubtitle = __AuraFixUtil.lbl(aiHeader,
    "Roblox-справка",
    10,
    AI_THEME.sub,
    {Position=UDim2.fromOffset(52,
    27),
    Size=UDim2.new(1,
    -116,
    0,
    16),
    ZIndex=292})
bind(aiSubtitle,
    "Roblox-справка")
local aiClose = __AuraFixUtil.new("TextButton",
    {Text="×",
    Font=Enum.Font.GothamBold,
    TextSize=21,
    TextColor3=AI_THEME.text,
    BackgroundColor3=AI_THEME.quick,
    AutoButtonColor=false,
    AnchorPoint=Vector2.new(1,
    .5),
    Position=UDim2.new(1,
    -9,
    .5,
    0),
    Size=UDim2.fromOffset(28,
    28),
    ZIndex=293},
    aiHeader)
__AuraFixUtil.round(aiClose,
    9); __AuraFixUtil.press(aiClose,
    true)
local aiStatusDot = __AuraFixUtil.new("Frame",
    {Name="AIStatusDot",
    AnchorPoint=Vector2.new(1, .5),
    Position=UDim2.new(1, -43, .5, 0),
    Size=UDim2.fromOffset(6, 6),
    BackgroundColor3=accent,
    BorderSizePixel=0,
    ZIndex=293},
    aiHeader)
__AuraFixUtil.round(aiStatusDot, 3)
__AuraFixUtil.stroke(aiStatusDot, 1, C.bg, .15)
local aiHeaderShine = __AuraFixUtil.new("Frame",
    {Name="AIHeaderShine",
    Position=UDim2.new(0,
    0,
    1,
    -1),
    Size=UDim2.new(1,
    0,
    0,
    1),
    BackgroundColor3=accent,
    BackgroundTransparency=.15,
    ZIndex=293},
    aiHeader)
__AuraFixUtil.new("UIGradient",
    {Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,
    1),
    NumberSequenceKeypoint.new(.5,
    0),
    NumberSequenceKeypoint.new(1,
    1)})},
    aiHeaderShine)
__AuraFixUtil.drag(aiHeader,
    aiPanel,
    function(W,
    H)
    local sx = math.min(342,
        W-16)
    local sy = math.min(468,
        H-24)
    return sx/2+8,
        W-sx/2-8,
        sy/2+12,
        H-sy/2-12
end)

local aiScroll = __AuraFixUtil.new("ScrollingFrame",
    {
    Name="Messages",
        Position=UDim2.fromOffset(10,
        59),
        Size=UDim2.new(1,
        -20,
        1,
        -164),
        BackgroundTransparency=1,
        BorderSizePixel=0,
        ScrollBarThickness=4,
        ScrollBarImageColor3=accent,
        ScrollBarImageTransparency=.12,
        CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        ScrollingDirection=Enum.ScrollingDirection.Y,
        ZIndex=291,
        ClipsDescendants=true,
},
    aiPanel)
local aiLayout = __AuraFixUtil.new("UIListLayout",
    {Padding=UDim.new(0,
    8),
    SortOrder=Enum.SortOrder.LayoutOrder},
    aiScroll)
__AuraFixUtil.new("UIPadding",
    {PaddingTop=UDim.new(0,
    3),
    PaddingBottom=UDim.new(0,
    5),
    PaddingLeft=UDim.new(0,
    2),
    PaddingRight=UDim.new(0,
    2)},
    aiScroll)
local aiMsgOrder = 0
local aiVisibleRows = {}
local AI_VISIBLE_ROW_LIMIT = 36

local function aiScrollBottom()
    task.defer(function()
        if not aiScroll or not aiScroll.Parent then return end
        local y = math.max(0,
            aiLayout.AbsoluteContentSize.Y - aiScroll.AbsoluteWindowSize.Y + 8)
        aiScroll.CanvasPosition = Vector2.new(0,
            y)
    end)
end

local function aiAddMessage(role, message, remember, animated)
    message = tostring(message or "")
    aiMsgOrder += 1
    local isUser = role == "user"
    local locale = aiLocale(message)
    local width = 304 -- design-space width; UIScale scales the entire chat consistently.
    local textWidth = width - 24
    local measure = TextService:GetTextSize(message,
        14,
        Enum.Font.GothamMedium,
        Vector2.new(textWidth,
        640))
    local height = math.clamp(measure.Y + 19,
        35,
        310)
    local row = __AuraFixUtil.new("Frame",
        {Name="MessageRow_"..aiMsgOrder,
        Size=UDim2.new(1,
        -4,
        0,
        height+2),
        BackgroundTransparency=1,
        LayoutOrder=aiMsgOrder,
        ZIndex=292},
        aiScroll)
    aiVisibleRows[#aiVisibleRows + 1] = row
    while #aiVisibleRows > AI_VISIBLE_ROW_LIMIT do
        local oldest = table.remove(aiVisibleRows, 1)
        if oldest and oldest.Parent then oldest:Destroy() end
    end
    local bubbleWidth = math.clamp(math.min(measure.X,
        textWidth) + 24,
        92,
        width)
    local bubble = __AuraFixUtil.new("CanvasGroup",
        {
        Name=isUser and "UserBubble" or "AssistantBubble",
            AnchorPoint=Vector2.new(isUser and 1 or 0,
            0),
            Position=UDim2.new(isUser and 1 or 0,
            isUser and -2 or 2,
            0,
            0),
            Size=UDim2.fromOffset(bubbleWidth,
            height),
            BackgroundColor3=isUser and accent or AI_THEME.bubble,
            BackgroundTransparency=0,
            GroupTransparency=0,
            ZIndex=293,
            },
            row)
    __AuraFixUtil.round(bubble,
        11)
    if isUser then
        __AuraFixUtil.new("UIGradient",
            {Name="UserBubbleGradient",
            Rotation=18,
            Color=ColorSequence.new(__AuraFixUtil.light(accent), accent),
            Transparency=NumberSequence.new(.035)},
            bubble)
        __AuraFixUtil.stroke(bubble, 1, WHITE, .78)
    else
        __AuraFixUtil.stroke(bubble,
            1,
            AI_THEME.border,
            .18)
    end
    local textLabel = __AuraFixUtil.new("TextLabel",
        {
        BackgroundTransparency=1,
            Position=UDim2.fromOffset(11,
            7),
            Size=UDim2.new(1,
            -22,
            1,
            -14),
            Font=Enum.Font.GothamMedium,
            TextSize=14,
            TextColor3=isUser and WHITE or AI_THEME.text,
            TextWrapped=true,
            TextXAlignment=Enum.TextXAlignment.Left,
            TextYAlignment=Enum.TextYAlignment.Top,
            Text=(animated and not isUser) and "" or tostring(message),
            AutomaticSize=Enum.AutomaticSize.None,
            ZIndex=294,
            },
            bubble)
    local bubbleScale = __AuraFixUtil.new("UIScale",
        {Scale=.94},
        bubble)
    tw(bubbleScale,
        {Scale=1},
        .25,
        EASE.Back,
        DIR.Out)
    if animated and not isUser then
        task.spawn(function()
            local visible = ""
            for chunk in message:gmatch("%S+%s*") do
                if not row.Parent or not textLabel.Parent then return end
                visible = visible .. chunk
                textLabel.Text = visible
                task.wait(.018)
            end
            if textLabel.Parent then textLabel.Text = message end
        end)
    end
    if remember ~= false then aiRemember(role,
        message) end
    aiScrollBottom()
    return row
end

local function aiTyping()
    aiMsgOrder += 1
    local row = __AuraFixUtil.new("Frame",
        {Name="AITyping",
        Size=UDim2.new(1,
        -4,
        0,
        35),
        BackgroundTransparency=1,
        LayoutOrder=aiMsgOrder,
        ZIndex=292},
        aiScroll)
    local bubble = __AuraFixUtil.new("Frame",
        {Position=UDim2.fromOffset(2,
        0),
        Size=UDim2.fromOffset(76,
        29),
        BackgroundColor3=AI_THEME.bubble,
        ZIndex=293},
        row)
    __AuraFixUtil.round(bubble,
        11)
    local dots={}
    for i=1, 3 do
        local dot=__AuraFixUtil.new("Frame",
            {AnchorPoint=Vector2.new(.5,
            .5),
            Position=UDim2.new(0,
            18+(i-1)*20,
            .5,
            0),
            Size=UDim2.fromOffset(6,
            6),
            BackgroundColor3=accent,
            ZIndex=294},
            bubble)
        __AuraFixUtil.round(dot,
            3); dots[i]=dot
        task.delay((i-1)*.08,
            function()
            if dot.Parent then TS:Create(dot,
                TweenInfo.new(.32,
                EASE.Sine,
                DIR.InOut,
                -1,
                true),
                {Position=UDim2.new(0,
                18+(i-1)*20,
                .5,
                -4),
                BackgroundTransparency=.2}):Play() end
        end)
    end
    aiScrollBottom()
    return row
end

local function aiClearMessages()
    for _, child in ipairs(aiScroll:GetChildren()) do if child ~= aiLayout and not child:IsA("UIPadding") then child:Destroy() end end
    table.clear(aiHistory)
    table.clear(aiVisibleRows)
    aiLastTopic=nil
    aiMsgOrder=0
    local locale=aiLocale("")
    local welcome=aiPhrases[locale].hello[1]
    aiAddMessage("assistant",
        welcome)
end

-- Optional Roblox-only lookup: public Roblox Developer Forum search, not Wikipedia.
local aiWebCache = {}
local AI_WEB_CACHE_LIMIT = 24
local function aiUrlEncode(value)
    return tostring(value or ""):gsub("([^%w%-_%.~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
end

local function aiHttpGet(url)
    local env = (getgenv and getgenv()) or _G
    local candidates = {}
    local function addCandidate(fn) if type(fn) == "function" then table.insert(candidates, fn) end end
    addCandidate(env and env.request)
    addCandidate(env and env.http_request)
    addCandidate(env and env.syn and env.syn.request)
    addCandidate(env and env.fluxus and env.fluxus.request)
    addCandidate(env and env.krnl and env.krnl.request)
    for _, fn in ipairs(candidates) do
        if type(fn) == "function" then
            local ok, result = pcall(fn, {Url = url, Method = "GET", Timeout = 6, Headers = { ["User-Agent"] = "AuraMenu-Roblox-Assistant/1.2", ["Accept"] = "application/json" }})
            if ok and type(result) == "table" then
                local body = result.Body or result.body or result.ResponseBody
                local status = tonumber(result.StatusCode or result.Status or result.status_code or 200)
                if type(body) == "string" and status >= 200 and status < 300 then return body end
            end
        end
    end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" then return body end
    local ok2, body2 = pcall(function() return HttpService:GetAsync(url) end)
    if ok2 and type(body2) == "string" then return body2 end
    return nil
end

local function aiWebSearch(question, locale)
    -- Wikipedia search + summary API: lightweight, no API key, bounded response.
    local clean = tostring(question or ""):gsub("[%c]", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    clean = clean:sub(1, 140)
    if clean == "" then return nil end
    local lang = (locale == "ru" and "ru") or (locale == "es" and "es") or "en"
    local cacheKey = lang .. ":wiki:" .. string.lower(clean)
    if aiWebCache[cacheKey] then return aiWebCache[cacheKey] end

    local searchUrl = "https://" .. lang .. ".wikipedia.org/w/api.php?action=query&list=search&format=json&utf8=1&srlimit=3&srsearch=" .. aiUrlEncode(clean)
    local searchBody = aiHttpGet(searchUrl)
    if type(searchBody) ~= "string" or #searchBody > 600000 then return nil end
    local ok, parsed = pcall(function() return HttpService:JSONDecode(searchBody) end)
    if not ok or type(parsed) ~= "table" or type(parsed.query) ~= "table" or type(parsed.query.search) ~= "table" then return nil end
    local results = parsed.query.search
    if #results == 0 or type(results[1]) ~= "table" or type(results[1].title) ~= "string" then return nil end
    local title = results[1].title:sub(1, 180)
    local summaryUrl = "https://" .. lang .. ".wikipedia.org/api/rest_v1/page/summary/" .. aiUrlEncode(title:gsub(" ", "_"))
    local summaryBody = aiHttpGet(summaryUrl)
    if type(summaryBody) ~= "string" or #summaryBody > 300000 then return nil end
    local ok2, summary = pcall(function() return HttpService:JSONDecode(summaryBody) end)
    if not ok2 or type(summary) ~= "table" then return nil end
    local extract = tostring(summary.extract or ""):gsub("[%c]+", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if extract == "" then return nil end
    if #extract > 900 then extract = extract:sub(1, 897) .. "..." end
    local pageUrl = type(summary.content_urls) == "table" and type(summary.content_urls.desktop) == "table" and summary.content_urls.desktop.page or ("https://" .. lang .. ".wikipedia.org/wiki/" .. aiUrlEncode(title:gsub(" ", "_")))
    local answer
    if lang == "ru" then
        answer = "Нашёл статью в Википедии по запросу «" .. clean .. "»:\n\n" .. title .. "\n" .. extract .. "\n\nИсточник: " .. tostring(pageUrl)
    elseif lang == "es" then
        answer = "Encontré un artículo de Wikipedia para «" .. clean .. "»:\n\n" .. title .. "\n" .. extract .. "\n\nFuente: " .. tostring(pageUrl)
    else
        answer = "Found a Wikipedia article for “" .. clean .. "”:\n\n" .. title .. "\n" .. extract .. "\n\nSource: " .. tostring(pageUrl)
    end
    aiWebCache[cacheKey] = answer
    local count = 0
    for _ in pairs(aiWebCache) do count = count + 1 end
    if count > AI_WEB_CACHE_LIMIT then
        for key in pairs(aiWebCache) do if key ~= cacheKey then aiWebCache[key] = nil; break end end
    end
    return answer
end

local aiInput
local aiRequestSerial = 0
local function aiSend(raw)
    if aiBusy then return end
    local question=tostring(raw or ""):gsub("[%c]", " "):gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if question=="" then return end
    if #question > 240 then question = question:sub(1, 237) .. "..." end
    aiBusy=true
    aiRequestSerial += 1
    local requestId=aiRequestSerial
    aiAddMessage("user", question)
    if aiInput then aiInput.Text="" end
    local typing=aiTyping()
    -- Do the lookup away from the UI event callback; always restore the chat state.
    task.spawn(function()
        local answer
        local ok, result = pcall(function()
            local locale=aiLocale(question)
            local webAnswer=aiWebSearch(question, locale)
            if webAnswer then return webAnswer end
            local localAnswer=aiAnswer(question)
            local phrases=aiPhrases[locale] or aiPhrases.en
            for _, unknownText in ipairs(phrases.unknown or {}) do
                if localAnswer == unknownText then
                    if locale == "ru" then return "Не удалось получить статью из Википедии. Проверь подключение к интернету или попробуй другое название." end
                    if locale == "es" then return "No pude obtener un artículo de Wikipedia. Comprueba la conexión o prueba otro término." end
                    return "I couldn't retrieve a Wikipedia article. Check the connection or try another term."
                end
            end
            return localAnswer
        end)
        if ok then answer=tostring(result or "") else
            local locale=aiLocale(question)
            answer=(locale=="ru" and "Поиск не удался. Проверь подключение и попробуй ещё раз." or (locale=="es" and "La búsqueda falló. Comprueba la conexión e inténtalo de nuevo." or "Search failed. Check the connection and try again."))
        end
        if requestId ~= aiRequestSerial then return end
        if typing and typing.Parent then pcall(function() typing:Destroy() end) end
        -- Bound output size to keep text layout responsive on low-end phones.
        if #answer > 1100 then answer=answer:sub(1,1097) .. "..." end
        pcall(function() aiAddMessage("assistant", answer, true, true) end)
        aiBusy=false
    end)
end

aiInput = __AuraFixUtil.new("TextBox",
    {
    Name="QuestionInput",
        Position=UDim2.new(0,
        10,
        1,
        -58),
        Size=UDim2.new(1,
        -68,
        0,
        42),
        BackgroundColor3=AI_THEME.input,
        TextColor3=AI_THEME.text,
        PlaceholderColor3=AI_THEME.sub,
        TextTransparency=0,
        BackgroundTransparency=0,
        Text="",
        PlaceholderText="Напиши вопрос...",
        Font=Enum.Font.GothamMedium,
        TextSize=14,
        TextXAlignment=Enum.TextXAlignment.Left,
        ClearTextOnFocus=false,
        MultiLine=false,
        TextTruncate=Enum.TextTruncate.AtEnd,
        AutoLocalize=false,
        ZIndex=295,
},
    aiPanel)
__AuraFixUtil.round(aiInput, 11)
local aiInputStroke = __AuraFixUtil.stroke(aiInput, 1, C.border, .42)
cn(aiInput.Focused, function()
    tw(aiInputStroke, {Color=accent, Transparency=.12, Thickness=1.6}, .18, EASE.Quint)
    tw(aiInput, {BackgroundColor3=AI_THEME.inputFocus}, .18, EASE.Sine)
end)
cn(aiInput.FocusLost, function()
    tw(aiInputStroke, {Color=C.border, Transparency=.42, Thickness=1}, .2, EASE.Sine)
    tw(aiInput, {BackgroundColor3=AI_THEME.input}, .2, EASE.Sine)
end)
__AuraFixUtil.new("UIPadding",
    {PaddingLeft=UDim.new(0,
    12),
    PaddingRight=UDim.new(0,
    8)},
    aiInput)
bind(aiInput,
    "Напиши вопрос...",
    "PlaceholderText")
local aiSendButton = __AuraFixUtil.new("TextButton",
    {
    Name="Send",
        Text="➤",
        Font=Enum.Font.GothamBlack,
        TextSize=17,
        TextColor3=WHITE,
        AutoButtonColor=false,
        BackgroundColor3=accent,
        Position=UDim2.new(1,
        -52,
        1,
        -58),
        Size=UDim2.fromOffset(42,
        42),
        ZIndex=295,
},
    aiPanel)
__AuraFixUtil.round(aiSendButton,
    12); __AuraFixUtil.press(aiSendButton)
local aiSendStroke = __AuraFixUtil.stroke(aiSendButton,
    1,
    WHITE,
    .6)
local aiQuickRow = __AuraFixUtil.new("Frame",
    {Position=UDim2.new(0,
    10,
    1,
    -106),
    Size=UDim2.new(1,
    -20,
    0,
    30),
    BackgroundTransparency=1,
    ZIndex=294},
    aiPanel)
__AuraFixUtil.new("UIListLayout",
    {FillDirection=Enum.FillDirection.Horizontal,
    Padding=UDim.new(0,
    6),
    SortOrder=Enum.SortOrder.LayoutOrder},
    aiQuickRow)
local function aiQuickButton(label, prompt, width)
    local b=__AuraFixUtil.new("TextButton",
        {Text=label,
        Font=Enum.Font.GothamBold,
        TextSize=11,
        TextColor3=AI_THEME.text,
        AutoButtonColor=false,
        BackgroundColor3=AI_THEME.quick,
        Size=UDim2.new(0,
        width,
        1,
        0),
        ZIndex=295},
        aiQuickRow)
    __AuraFixUtil.round(b,
        9); __AuraFixUtil.press(b,
        true)
    local edge = __AuraFixUtil.stroke(b, 1, accent, .72)
    cn(b.MouseEnter, function()
        tw(b, {BackgroundColor3=AI_THEME.quickHover}, .13, EASE.Sine)
        tw(edge, {Transparency=.25}, .13, EASE.Sine)
    end)
    cn(b.MouseLeave, function()
        tw(b, {BackgroundColor3=AI_THEME.quick}, .16, EASE.Sine)
        tw(edge, {Transparency=.72}, .16, EASE.Sine)
    end)
    return b
end
local aiQuickHelp=aiQuickButton("?  "..T("Помощь"),
    "Что ты умеешь?",
    86)
local aiQuickLua=aiQuickButton("</>  "..T("Код / Luau"),
    "Что такое Luau?",
    88)
local aiQuickVisual=aiQuickButton("◈  "..T("ESP"),
    "Что делает ESP?",
    72)
local function aiPrompt(which)
    if lang == "English" then
        return which=="help" and "What can you help with?" or (which=="lua" and "What is Luau?" or "What does ESP do?")
    elseif lang == "Español" then
        return which=="help" and "¿En qué puedes ayudarme?" or (which=="lua" and "¿Qué es Luau?" or "¿Qué hace ESP?")
    end
    return which=="help" and "Что ты умеешь?" or (which=="lua" and "Что такое Luau?" or "Что делает ESP?")
end
cn(aiQuickHelp.Activated,
    function() aiSend(aiPrompt("help")) end)
cn(aiQuickLua.Activated,
    function() aiSend(aiPrompt("lua")) end)
cn(aiQuickVisual.Activated,
    function() aiSend(aiPrompt("visual")) end)
trReg[#trReg+1]=function()
    aiQuickHelp.Text="?  "..T("Помощь")
    aiQuickLua.Text="</>  "..T("Код / Luau")
    aiQuickVisual.Text="◈  "..T("ESP")
end
-- Keep AI accent surfaces synchronized when the user changes the accent slider/swatches.
reg[#reg+1]=function()
    if aiFab and aiFab.Parent then
        aiFab.BackgroundColor3=accent
        if aiFabGradient then aiFabGradient.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,
            __AuraFixUtil.light(accent)),
            ColorSequenceKeypoint.new(1,
            accent)}) end
        if aiFabStroke then aiFabStroke.Color=accent end
    end
    if aiPanel and aiPanel.Parent then
        if aiPanelStroke then aiPanelStroke.Color=accent end
        if aiOrb then aiOrb.BackgroundColor3=accent end
        if aiHeaderShine then aiHeaderShine.BackgroundColor3=accent end
        if aiSendButton then aiSendButton.BackgroundColor3=accent end
        for _, child in ipairs(aiScroll:GetDescendants()) do
            if child.Name=="UserBubble" then
                child.BackgroundColor3=accent
                local gradient=child:FindFirstChild("UserBubbleGradient")
                if gradient and gradient:IsA("UIGradient") then
                    gradient.Color=ColorSequence.new(__AuraFixUtil.light(accent), accent)
                end
            end
        end
    end
end

local function aiFitToScreen()
    local camera=workspace.CurrentCamera
    local size=camera and camera.ViewportSize or Vector2.new(400,
        800)
    aiPanel.Size=UDim2.fromOffset(342,
        468)
    aiPanelScale.Scale=math.clamp(math.min((size.X-12)/342,
        (size.Y-30)/468),
        .52,
        1)
end
aiFitToScreen()
cn(workspace:GetPropertyChangedSignal("CurrentCamera"),
    aiFitToScreen)
if workspace.CurrentCamera then cn(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"),
    aiFitToScreen) end

local aiOpenToken=0
local function aiSetOpen(value)
    if aiOpen==value then return end
    aiOpen=value
    aiOpenToken+=1
    local my=aiOpenToken
    if value then
        aiFitToScreen()
        aiPanel.Visible=true
        aiPanel.GroupTransparency=0
        aiPanel.Position=UDim2.fromScale(.5,
            .53)
        local fitScale=aiPanelScale.Scale
        aiPanelScale.Scale=fitScale*.88
        tw(aiPanel,
            {Position=UDim2.fromScale(.5,
            .5)},
            .32,
            EASE.Quint,
            DIR.Out)
        tw(aiPanelScale,
            {Scale=fitScale},
            .38,
            EASE.Back,
            DIR.Out)
        tw(blur,
            {Size=blurOn and 10 or 0},
            .28,
            EASE.Sine)
        if aiMsgOrder==0 then
            local locale=aiLocale("")
            aiAddMessage("assistant",
                aiPhrases[locale].hello[1])
        end
    else
        tw(aiPanel,
            {Position=UDim2.fromScale(.5,
            .53)},
            .22,
            EASE.Quint,
            DIR.In)
        task.delay(.23,
            function() if aiOpenToken==my then aiPanel.Visible=false; aiPanel.Position=UDim2.fromScale(.5,
            .5); aiPanel.GroupTransparency=0 end end)
        if not opened then tw(blur,
            {Size=0},
            .22,
            EASE.Sine) end
    end
end
cn(aiFab.Activated,
    function() if aiFabDrag.moved then return end; aiSetOpen(not aiOpen); tw(aiFab,
    {Rotation=aiFab.Rotation+180},
    .32,
    EASE.Back) end)
cn(aiClose.Activated,
    function() aiSetOpen(false) end)
cn(aiSendButton.Activated,
    function() aiSend(aiInput.Text) end)
cn(aiInput.FocusLost,
    function(enterPressed) if enterPressed then aiSend(aiInput.Text) end end)
cn(UIS:GetPropertyChangedSignal("OnScreenKeyboardVisible"),
    function()
    if aiOpen then
        local y = UIS.OnScreenKeyboardVisible and .34 or .5
        tw(aiPanel,
            {Position=UDim2.fromScale(.5,
            y)},
            .22,
            EASE.Quint,
            DIR.Out)
    end
end)
cn(UIS.InputBegan,
    function(input,
    processed)
    if processed or not aiOpen then return end
    if input.KeyCode==Enum.KeyCode.Escape then aiSetOpen(false) end
end)

-- Finalize the UI after all original widgets have been constructed.

__AuraFixUtil.applyEnvironmentPreset(envPreset)
__AuraFix_selectTab(order[1],
    true)
__AuraFixUtil.setOpen(true)
task.delay(.9,
    function() __AuraFixUtil.toast("AURA загружено") end)
end

__AuraBuildAI()
