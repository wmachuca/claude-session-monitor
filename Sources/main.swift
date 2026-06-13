import AppKit
import Foundation
import ApplicationServices
import ServiceManagement

// MARK: - Internacionalización (en / es / pt, alineada con el OS)

enum Lang { case en, es, pt }

let systemLang: Lang = {
    let pref = (Locale.preferredLanguages.first ?? "en").prefix(2).lowercased()
    switch pref {
    case "es": return .es
    case "pt": return .pt
    default:   return .en
    }
}()

var languageOverride: Lang? = nil               // nil = seguir el idioma del sistema
var currentLang: Lang { languageOverride ?? systemLang }

func L(_ key: String) -> String { STRINGS[key]?[currentLang] ?? STRINGS[key]?[.en] ?? key }
func Lf(_ key: String, _ args: CVarArg...) -> String { String(format: L(key), arguments: args) }

let STRINGS: [String: [Lang: String]] = [
    // menú
    "header": [.en: "%d active session(s) · %d recent", .es: "%d sesión(es) activa(s) · %d reciente(s)", .pt: "%d sessão(ões) ativa(s) · %d recente(s)"],
    "no_sessions": [.en: "No recent sessions", .es: "Sin sesiones recientes", .pt: "Sem sessões recentes"],
    "group_active": [.en: "Active", .es: "Activas", .pt: "Ativas"],
    "group_dormant": [.en: "Dormant", .es: "Dormidas", .pt: "Adormecidas"],
    "group_closed": [.en: "Closed", .es: "Cerradas", .pt: "Fechadas"],
    "hidden_sessions": [.en: "Hidden sessions (%d)", .es: "Sesiones ocultas (%d)", .pt: "Sessões ocultas (%d)"],
    "refresh_now": [.en: "Refresh now", .es: "Refrescar ahora", .pt: "Atualizar agora"],
    "preferences": [.en: "Preferences…", .es: "Preferencias…", .pt: "Preferências…"],
    "open_folder": [.en: "Open sessions folder", .es: "Abrir carpeta de sesiones", .pt: "Abrir pasta de sessões"],
    "quit": [.en: "Quit", .es: "Salir", .pt: "Sair"],
    // detalle de sesión
    "context": [.en: "Context: %.1fk / %dk  (%.0f%%)", .es: "Contexto: %.1fk / %dk  (%.0f%%)", .pt: "Contexto: %.1fk / %dk  (%.0f%%)"],
    "state_prefix": [.en: "State: %@", .es: "Estado: %@", .pt: "Estado: %@"],
    "state_processing": [.en: "⚙ Processing…", .es: "⚙ Procesando…", .pt: "⚙ Processando…"],
    "state_waiting": [.en: "Waiting for input", .es: "Esperando entrada", .pt: "Aguardando entrada"],
    "state_dormant": [.en: "Dormant (window open) 💤", .es: "Dormida (ventana abierta) 💤", .pt: "Adormecida (janela aberta) 💤"],
    "state_closed": [.en: "Closed", .es: "Cerrada", .pt: "Fechada"],
    "remote_on": [.en: "Remote control: connected 📡", .es: "Control remoto: conectado 📡", .pt: "Controle remoto: conectado 📡"],
    "remote_off": [.en: "Remote control: disconnected", .es: "Control remoto: desconectado", .pt: "Controle remoto: desconectado"],
    "model": [.en: "Model: %@", .es: "Modelo: %@", .pt: "Modelo: %@"],
    "branch": [.en: "Branch: %@", .es: "Rama: %@", .pt: "Ramo: %@"],
    "goto_window": [.en: "↗ Go to this session's window", .es: "↗ Ir a la ventana de esta sesión", .pt: "↗ Ir para a janela desta sessão"],
    "resume_session": [.en: "▶ Resume this session", .es: "▶ Retomar esta sesión", .pt: "▶ Retomar esta sessão"],
    "no_agents": [.en: "No active agents", .es: "Sin agentes activos", .pt: "Sem agentes ativos"],
    "active_agents": [.en: "Active agents (%d)", .es: "Agentes activos (%d)", .pt: "Agentes ativos (%d)"],
    "in_monitor": [.en: "In the monitor", .es: "En el monitor", .pt: "No monitor"],
    "color": [.en: "Color", .es: "Color", .pt: "Cor"],
    "rename_alias": [.en: "Rename (alias)…", .es: "Renombrar (alias)…", .pt: "Renomear (apelido)…"],
    "pin_top": [.en: "Pin to top", .es: "Fijar arriba", .pt: "Fixar no topo"],
    "unpin": [.en: "Unpin", .es: "Desfijar", .pt: "Desafixar"],
    "hide_monitor": [.en: "Hide from monitor", .es: "Ocultar del monitor", .pt: "Ocultar do monitor"],
    "trend": [.en: "Trend", .es: "Tendencia", .pt: "Tendência"],
    // colores
    "c_none": [.en: "None (automatic)", .es: "Ninguno (automático)", .pt: "Nenhum (automático)"],
    "c_purple": [.en: "Purple", .es: "Morado", .pt: "Roxo"],
    "c_blue": [.en: "Blue", .es: "Azul", .pt: "Azul"],
    "c_cyan": [.en: "Cyan", .es: "Cyan", .pt: "Ciano"],
    "c_green": [.en: "Green", .es: "Verde", .pt: "Verde"],
    "c_yellow": [.en: "Yellow", .es: "Amarillo", .pt: "Amarelo"],
    "c_orange": [.en: "Orange", .es: "Naranja", .pt: "Laranja"],
    "c_red": [.en: "Red", .es: "Rojo", .pt: "Vermelho"],
    "c_pink": [.en: "Pink", .es: "Rosa", .pt: "Rosa"],
    // notificaciones
    "alert_title": [.en: "⚠️ High context: %@", .es: "⚠️ Contexto alto: %@", .pt: "⚠️ Contexto alto: %@"],
    "alert_body": [.en: "%.0f%% used (%.0fk tokens)", .es: "%.0f%% usado (%.0fk tokens)", .pt: "%.0f%% usado (%.0fk tokens)"],
    "busy_title": [.en: "Session busy", .es: "Sesión ocupada", .pt: "Sessão ocupada"],
    "busy_body": [.en: "Change saved in the monitor; not sent because the session is processing.", .es: "Cambio guardado en el monitor; no se envió porque la sesión está procesando.", .pt: "Alteração salva no monitor; não enviada porque a sessão está processando."],
    "ax_title": [.en: "Accessibility permission needed", .es: "Falta permiso de Accesibilidad", .pt: "Permissão de Acessibilidade necessária"],
    "ax_body": [.en: "Enable it for ClaudeSessionMonitor and try again. The change was saved in the monitor.", .es: "Actívalo para ClaudeSessionMonitor y reintenta. El cambio quedó guardado en el monitor.", .pt: "Ative-a para ClaudeSessionMonitor e tente novamente. A alteração foi salva no monitor."],
    // diálogo renombrar
    "rename_title": [.en: "Session alias", .es: "Alias de la sesión", .pt: "Apelido da sessão"],
    "rename_info": [.en: "Name to show in the monitor. Leave empty to use the automatic one.", .es: "Nombre a mostrar en el monitor. Déjalo vacío para usar el automático.", .pt: "Nome a mostrar no monitor. Deixe vazio para usar o automático."],
    "save": [.en: "Save", .es: "Guardar", .pt: "Salvar"],
    "cancel": [.en: "Cancel", .es: "Cancelar", .pt: "Cancelar"],
    // preferencias
    "tab_settings": [.en: "Settings", .es: "Ajustes", .pt: "Ajustes"],
    "tab_about": [.en: "About", .es: "Acerca de", .pt: "Sobre"],
    "pref_refresh": [.en: "Refresh", .es: "Refresco", .pt: "Atualização"],
    "pref_agent_live": [.en: "Agent «live»", .es: "Agente «en vivo»", .pt: "Agente «ao vivo»"],
    "pref_active": [.en: "Active session", .es: "Sesión activa", .pt: "Sessão ativa"],
    "pref_history": [.en: "History", .es: "Histórico", .pt: "Histórico"],
    "pref_green": [.en: "Green threshold", .es: "Umbral verde", .pt: "Limite verde"],
    "pref_yellow": [.en: "Yellow threshold", .es: "Umbral amarillo", .pt: "Limite amarelo"],
    "pref_window": [.en: "Context window", .es: "Ventana de contexto", .pt: "Janela de contexto"],
    "pref_language": [.en: "Language", .es: "Idioma", .pt: "Idioma"],
    "lang_system": [.en: "System", .es: "Sistema", .pt: "Sistema"],
    "pref_win_auto": [.en: "Automatic (200k / 1M)", .es: "Automático (200k / 1M)", .pt: "Automático (200k / 1M)"],
    "pref_win_200": [.en: "Force 200k", .es: "Forzar 200k", .pt: "Forçar 200k"],
    "pref_win_1m": [.en: "Force 1M", .es: "Forzar 1M", .pt: "Forçar 1M"],
    "pref_alert": [.en: "Notify when a session goes red", .es: "Notificar cuando una sesión entra en rojo", .pt: "Notificar quando uma sessão fica vermelha"],
    "pref_branch": [.en: "Show git branch", .es: "Mostrar la rama de git", .pt: "Mostrar o ramo do git"],
    "pref_task": [.en: "Show current task (in-progress TODO)", .es: "Mostrar la tarea actual (TODO en progreso)", .pt: "Mostrar a tarefa atual (TODO em andamento)"],
    "pref_push": [.en: "Send changes to Claude Code (types /color · /rename · experimental)", .es: "Enviar cambios a Claude Code (teclea /color · /rename · experimental)", .pt: "Enviar alterações ao Claude Code (digita /color · /rename · experimental)"],
    "pref_reset": [.en: "Reset to defaults", .es: "Restablecer valores por defecto", .pt: "Restaurar padrões"],
    "pref_login": [.en: "Launch at login", .es: "Iniciar al arrancar el equipo", .pt: "Iniciar ao ligar o computador"],
    "pref_usage": [.en: "Show account usage (5h / weekly)", .es: "Mostrar uso de la cuenta (5h / semanal)", .pt: "Mostrar uso da conta (5h / semanal)"],
    "usage_header": [.en: "ACCOUNT USAGE", .es: "USO DE LA CUENTA", .pt: "USO DA CONTA"],
    "usage_5h": [.en: "5 h", .es: "5 h", .pt: "5 h"],
    "usage_week": [.en: "Week", .es: "Semana", .pt: "Semana"],
    "usage_plan": [.en: "Plan", .es: "Plan", .pt: "Plano"],
    "about_version": [.en: "Version 1.0", .es: "Versión 1.0", .pt: "Versão 1.0"],
    "about_desc": [.en: "Menu-bar monitor for your Claude Code sessions: context used, live agents with time and tokens, trend and state. Reads local data from ~/.claude; no network.", .es: "Monitor de barra de menús para las sesiones de Claude Code: contexto usado, agentes en vivo con su tiempo y tokens, tendencia y estado. Lee datos locales de ~/.claude; no usa la red.", .pt: "Monitor de barra de menus para as sessões do Claude Code: contexto usado, agentes ao vivo com tempo e tokens, tendência e estado. Lê dados locais de ~/.claude; sem rede."],
    "about_author": [.en: "by Wilmer Machuca", .es: "por Wilmer Machuca", .pt: "por Wilmer Machuca"],
    "about_open": [.en: "Open project folder", .es: "Abrir carpeta del proyecto", .pt: "Abrir pasta do projeto"],
    "about_made": [.en: "Made with Claude Code 🤖", .es: "Hecho con Claude Code 🤖", .pt: "Feito com Claude Code 🤖"],
]

// ============================================================================
// Claude Session Monitor v2 — utilidad de barra de menús para macOS
//
// Lee los datos locales de Claude Code y muestra, por cada sesión:
//   • contexto usado + color (verde/amarillo/rojo) + forma del ícono
//   • tendencia (↑/↓/→) y mini-gráfico del crecimiento del contexto
//   • sub-agentes corriendo EN VIVO (con su propio contexto)
//   • en qué tarea está trabajando la sesión (TODO in_progress)
//   • modelo y rama de git
// Alerta cuando una sesión entra en rojo. Configurable sin recompilar.
//
// Fuentes (todo local, sin red):
//   ~/.claude/projects/<proj>/<session>.jsonl              -> sesión principal
//   ~/.claude/projects/<proj>/<session>/subagents/*.jsonl  -> sub-agentes
//   ~/.claude/tasks/<session>/*.json                       -> TODOs con estado
//   ~/.config/claude-session-monitor/config.json           -> configuración
// ============================================================================

// MARK: - Configuración (editable en caliente, sin recompilar)

/// Ajustes por sesión guardados en el monitor (no tocan Claude Code).
struct SessionOverride: Codable {
    var color: String?    // color de identidad en el monitor
    var alias: String?    // nombre a mostrar
    var pinned: Bool?     // fijar arriba
    var hidden: Bool?     // ocultar del monitor
    var isEmpty: Bool { color == nil && (alias?.isEmpty ?? true) && !(pinned ?? false) && !(hidden ?? false) }
}

struct Config: Codable {
    var refreshInterval: Double = 3            // segundos entre refrescos
    var activeWindowSeconds: Double = 8 * 60   // "activa" = modificada hace menos
    var listWindowSeconds: Double = 90 * 60    // sesiones que se listan
    var subagentLiveSeconds: Double = 45       // sub-agente "corriendo" si su archivo cambió hace menos
    var greenMax: Double = 40                  // < 40%  -> verde
    var yellowMax: Double = 70                 // 40-70% -> amarillo ; >70% -> rojo
    var forceContextWindow: Int? = nil         // null = auto (200k/1M). Pon 1000000 para forzar.
    var alertOnRed: Bool = true                // notificación al entrar en rojo
    var showBranch: Bool = true                // muestra (rama) en la línea
    var showCurrentTask: Bool = true           // muestra la tarea in_progress
    var pushToClaude: Bool = true              // refleja cambios de color en Claude (teclea /color)
    var showUsage: Bool = true                 // muestra uso de la cuenta (5h/semanal) vía /api/oauth/usage
    var language: String = "system"            // "system" | "en" | "es" | "pt"
    var overrides: [String: SessionOverride] = [:]   // ajustes por sesión (clave = sessionId)

    static let path: URL = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".config/claude-session-monitor/config.json")

    init() {}

    // Decodificación tolerante: si falta una clave (config vieja), usa el valor por defecto.
    init(from d: Decoder) throws {
        let def = Config()
        let c = try? d.container(keyedBy: CodingKeys.self)
        refreshInterval     = (try? c?.decode(Double.self, forKey: .refreshInterval))     ?? def.refreshInterval
        activeWindowSeconds = (try? c?.decode(Double.self, forKey: .activeWindowSeconds)) ?? def.activeWindowSeconds
        listWindowSeconds   = (try? c?.decode(Double.self, forKey: .listWindowSeconds))   ?? def.listWindowSeconds
        subagentLiveSeconds = (try? c?.decode(Double.self, forKey: .subagentLiveSeconds)) ?? def.subagentLiveSeconds
        greenMax            = (try? c?.decode(Double.self, forKey: .greenMax))            ?? def.greenMax
        yellowMax           = (try? c?.decode(Double.self, forKey: .yellowMax))           ?? def.yellowMax
        forceContextWindow  = (try? c?.decode(Int.self,    forKey: .forceContextWindow))  ?? def.forceContextWindow
        alertOnRed          = (try? c?.decode(Bool.self,   forKey: .alertOnRed))          ?? def.alertOnRed
        showBranch          = (try? c?.decode(Bool.self,   forKey: .showBranch))          ?? def.showBranch
        showCurrentTask     = (try? c?.decode(Bool.self,   forKey: .showCurrentTask))     ?? def.showCurrentTask
        pushToClaude        = (try? c?.decode(Bool.self,   forKey: .pushToClaude))        ?? def.pushToClaude
        showUsage           = (try? c?.decode(Bool.self,   forKey: .showUsage))           ?? def.showUsage
        language            = (try? c?.decode(String.self, forKey: .language))            ?? def.language
        overrides           = (try? c?.decode([String: SessionOverride].self, forKey: .overrides)) ?? def.overrides
    }
}

/// Mapea el nombre de color (8 opciones de Claude Code) a un NSColor.
func monitorColor(_ name: String?) -> NSColor? {
    switch name {
    case "purple": return .systemPurple
    case "yellow": return .systemYellow
    case "orange": return .systemOrange
    case "red":    return .systemRed
    case "green":  return .systemGreen
    case "blue":   return .systemBlue
    case "pink":   return .systemPink
    case "cyan":   return .systemCyan
    default:       return nil
    }
}

final class ConfigStore {
    private(set) var config = Config() { didSet { applyLanguage() } }
    private var lastMtime: Date = .distantPast

    init() { writeDefaultIfMissing(); reloadIfChanged(); applyLanguage() }

    private func applyLanguage() {
        switch config.language {
        case "en": languageOverride = .en
        case "es": languageOverride = .es
        case "pt": languageOverride = .pt
        default:   languageOverride = nil   // sistema
        }
    }

    private func writeDefaultIfMissing() {
        let fm = FileManager.default
        guard !fm.fileExists(atPath: Config.path.path) else { return }
        try? fm.createDirectory(at: Config.path.deletingLastPathComponent(), withIntermediateDirectories: true)
        save(Config())
    }

    func save(_ c: Config) {
        let enc = JSONEncoder(); enc.outputFormatting = [.prettyPrinted, .sortedKeys]
        if let data = try? enc.encode(c) { try? data.write(to: Config.path) }
    }

    /// Aplica una config en caliente (la guarda y la deja activa de inmediato).
    func apply(_ c: Config) {
        config = c
        save(c)
        lastMtime = (try? Config.path.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? lastMtime
    }

    /// Recarga el archivo si cambió desde la última lectura. Devuelve true si cambió.
    @discardableResult
    func reloadIfChanged() -> Bool {
        let mtime = (try? Config.path.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? .distantPast
        guard mtime != lastMtime else { return false }
        lastMtime = mtime
        if let data = try? Data(contentsOf: Config.path),
           let c = try? JSONDecoder().decode(Config.self, from: data) {
            config = c
        }
        return true
    }
}

// MARK: - Modelo de datos

struct Subagent {
    let id: String
    let name: String?         // nombre del agente (subagent_type, ej. "dev-backend")
    let desc: String?         // tarea del agente (description de la llamada)
    let contextTokens: Int   // tokens de contexto del agente (≈ "tokens" que muestra Claude Code)
    let elapsed: Double       // tiempo de ejecución en segundos
    let ageSeconds: Double    // hace cuánto fue su última actividad
    let isLive: Bool          // corriendo ahora mismo
    let startDate: Date?      // inicio del agente (para el reloj en vivo)

    var displayName: String { (name?.isEmpty == false ? name : nil) ?? id }
}

// MARK: - Helpers de tiempo

let isoFormatter: ISO8601DateFormatter = {
    let f = ISO8601DateFormatter()
    f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return f
}()

func parseTS(_ s: String?) -> Date? {
    guard let s = s else { return nil }
    return isoFormatter.date(from: s) ?? ISO8601DateFormatter().date(from: s)
}

/// "10m 2s", "1h 04m", "45s"
func formatDuration(_ seconds: Double) -> String {
    let s = max(0, Int(seconds))
    if s >= 86400 { return "\(s / 86400)d \((s % 86400) / 3600)h" }
    if s >= 3600 { return String(format: "%dh %02dm", s / 3600, (s % 3600) / 60) }
    if s >= 60   { return String(format: "%dm %02ds", s / 60, s % 60) }
    return "\(s)s"
}

struct Session {
    let id: String
    let project: String
    let cwd: String             // carpeta de la sesión (para retomarla)
    let branch: String
    let model: String
    let contextTokens: Int
    let window: Int
    let mtime: Date
    let liveSubagents: [Subagent]
    let totalSubagents: Int
    let currentTask: String?
    let title: String?          // nombre de la sesión (sessions/*.json > customTitle > aiTitle)
    let colorName: String?      // color de identidad (override del monitor o agentColor)
    let busy: Bool?             // estado real desde sessions/*.json (busy = procesando ahora)
    let pid: Int?               // pid del proceso claude (para enfocar su ventana de terminal)
    let bridged: Bool           // control remoto conectado (bridgeSessionId presente)
    let alive: Bool             // el proceso claude sigue vivo (ventana abierta)
    let pinned: Bool            // fijada arriba (override del monitor)
    let hidden: Bool            // oculta del monitor (override)

    var pct: Double { window > 0 ? Double(contextTokens) / Double(window) * 100 : 0 }

    /// Color de identidad (override del monitor o el de Claude Code), si lo hay.
    var accentColor: NSColor? { monitorColor(colorName) }

    /// Nombre legible: el que le pusiste a la sesión, o el título auto, o el proyecto.
    var displayName: String {
        if let t = title, !t.isEmpty { return t }
        return project
    }
    /// Rama solo si es informativa (las worktrees suelen reportar "HEAD").
    var meaningfulBranch: String? {
        let b = branch.trimmingCharacters(in: .whitespaces)
        return (b.isEmpty || b == "HEAD") ? nil : b
    }

    enum Level { case green, yellow, red }
    func level(_ c: Config) -> Level {
        if pct < c.greenMax { return .green }
        if pct <= c.yellowMax { return .yellow }
        return .red
    }
    func color(_ c: Config) -> NSColor {
        switch level(c) { case .green: return .systemGreen; case .yellow: return .systemYellow; case .red: return .systemRed }
    }
    func dot(_ c: Config) -> String {
        switch level(c) { case .green: return "🟢"; case .yellow: return "🟡"; case .red: return "🔴" }
    }
    /// Símbolo SF que cambia de FORMA según el nivel (accesible para daltonismo).
    func symbol(_ c: Config) -> String {
        switch level(c) {
        case .green: return "circle.fill"
        case .yellow: return "triangle.fill"
        case .red: return "exclamationmark.octagon.fill"
        }
    }
    func isActive(_ c: Config) -> Bool {
        if !alive { return false }                                        // proceso muerto => no puede estar activa
        if busy == true { return true }                                   // procesando ahora
        return Date().timeIntervalSince(mtime) <= c.activeWindowSeconds   // o usada hace poco
    }
}

// MARK: - Historial / tendencia

final class History {
    private var samples: [String: [Double]] = [:]
    private let cap = 30

    func record(_ id: String, _ pct: Double) {
        var arr = samples[id] ?? []
        arr.append(pct)
        if arr.count > cap { arr.removeFirst(arr.count - cap) }
        samples[id] = arr
    }

    enum Trend { case up, down, flat }
    func trend(_ id: String) -> Trend {
        guard let a = samples[id], a.count >= 3 else { return .flat }
        let recent = a.last!
        let past = a[max(0, a.count - 7)]
        if recent - past > 1.0 { return .up }
        if recent - past < -1.0 { return .down }
        return .flat
    }
    func arrow(_ id: String) -> String {
        switch trend(id) { case .up: return "↑"; case .down: return "↓"; case .flat: return "→" }
    }

    func values(_ id: String) -> [Double] { samples[id] ?? [] }

    func sparkline(_ id: String) -> String {
        guard let a = samples[id], a.count >= 2 else { return "" }
        let blocks = Array("▁▂▃▄▅▆▇█")
        let lo = a.min()!, hi = a.max()!
        let span = max(hi - lo, 0.0001)
        return String(a.suffix(20).map { v in
            let i = min(blocks.count - 1, max(0, Int(((v - lo) / span) * Double(blocks.count - 1))))
            return blocks[i]
        })
    }
}

// MARK: - Uso de la cuenta (/api/oauth/usage)

struct UsageInfo {
    let fiveHourPct: Double
    let fiveHourReset: Date?
    let weekPct: Double
    let weekReset: Date?
    let plan: String?
}

/// Color por nivel de uso: verde bajo, amarillo medio, rojo cerca del límite.
func usageColor(_ pct: Double) -> NSColor {
    if pct < 60 { return .systemGreen }
    if pct < 85 { return .systemYellow }
    return .systemRed
}

enum Usage {
    /// Lee el token OAuth del Keychain (el mismo de Claude Code) y consulta /api/oauth/usage.
    static func fetch(completion: @escaping (UsageInfo?) -> Void) {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/security")
        p.arguments = ["find-generic-password", "-s", "Claude Code-credentials", "-w"]
        let out = Pipe(); p.standardOutput = out; p.standardError = Pipe()
        try? p.run(); p.waitUntilExit()
        let raw = out.fileHandleForReading.readDataToEndOfFile()
        guard let obj = try? JSONSerialization.jsonObject(with: raw) as? [String: Any],
              let oauth = obj["claudeAiOauth"] as? [String: Any],
              let token = oauth["accessToken"] as? String else { completion(nil); return }
        let plan = oauth["subscriptionType"] as? String

        var req = URLRequest(url: URL(string: "https://api.anthropic.com/api/oauth/usage")!)
        req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        req.setValue("oauth-2025-04-20", forHTTPHeaderField: "anthropic-beta")
        req.setValue("claude-session-monitor", forHTTPHeaderField: "User-Agent")
        req.timeoutInterval = 12
        URLSession.shared.dataTask(with: req) { data, _, _ in
            // si hay error (p.ej. rate limit) o no llegan ventanas válidas, NO actualices (conserva lo último bueno)
            guard let data = data,
                  let j = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  j["error"] == nil,
                  (j["five_hour"] is [String: Any] || j["seven_day"] is [String: Any]) else { completion(nil); return }
            func win(_ key: String) -> (Double, Date?) {
                guard let o = j[key] as? [String: Any] else { return (0, nil) }
                let pct = o["utilization"] as? Double ?? 0
                let reset = (o["resets_at"] as? String).flatMap { parseTS($0) }
                return (pct, reset)
            }
            let (f, fr) = win("five_hour"); let (w, wr) = win("seven_day")
            completion(UsageInfo(fiveHourPct: f, fiveHourReset: fr, weekPct: w, weekReset: wr, plan: plan))
        }.resume()
    }
}

// MARK: - Parser

/// Resultado del parseo de un transcript (todo lo que depende SOLO del archivo de sesión).
struct TranscriptParse {
    let ctx: Int
    let cwd: String
    let firstCwd: String   // primer cwd del transcript = directorio de lanzamiento (para retomar)
    let branch: String
    let model: String
    let custom: String?
    let ai: String?
    let colorName: String?
    let agentNames: [String: (name: String, desc: String?)]
}

enum Parser {
    // Cachés por mtime: si el archivo no cambió, no se re-lee ni re-parsea.
    // Acceso serializado (un solo escaneo a la vez vía el flag `scanning`).
    private static var transcriptCache: [String: (mtime: Date, parse: TranscriptParse?)] = [:]
    private static var agentCache: [String: (mtime: Date, firstTs: Date?, tokens: Int, lastTs: Date?)] = [:]

    /// Parsea un transcript completo (lectura + extracción). nil si no tiene uso aún.
    static func parseTranscript(_ file: URL) -> TranscriptParse? {
        guard let content = try? String(contentsOf: file, encoding: .utf8) else { return nil }
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        var ctx = 0, cwd = "", branch = "", model = "?"
        var found = false
        for line in lines.reversed() where line.contains("\"role\":\"assistant\"") && line.contains("\"usage\"") {
            if let r = usageTokens(in: line) { (ctx, cwd, branch, model) = r; found = true; break }
        }
        guard found else { return nil }
        // primer cwd (directorio de lanzamiento), antes de que derive durante la sesión
        var firstCwd = ""
        for line in lines where line.contains("\"cwd\"") {
            if let d = line.data(using: .utf8),
               let o = try? JSONSerialization.jsonObject(with: d) as? [String: Any],
               let cw = o["cwd"] as? String, !cw.isEmpty { firstCwd = cw; break }
        }
        let custom = reverseFind(lines, "\"type\":\"custom-title\"")?["customTitle"] as? String
        let ai = reverseFind(lines, "\"type\":\"ai-title\"")?["aiTitle"] as? String
        let colorName = reverseFind(lines, "\"type\":\"agent-color\"")?["agentColor"] as? String
        return TranscriptParse(ctx: ctx, cwd: cwd, firstCwd: firstCwd, branch: branch, model: model,
                               custom: custom, ai: ai, colorName: colorName, agentNames: agentNames(lines))
    }

    /// Parsea un archivo de agente: inicio, tokens de contexto y última actividad.
    static func parseAgentFile(_ f: URL) -> (firstTs: Date?, tokens: Int, lastTs: Date?)? {
        guard let content = try? String(contentsOf: f, encoding: .utf8) else { return nil }
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        guard !lines.isEmpty else { return nil }
        var firstTs: Date? = nil
        if let d = lines.first?.data(using: .utf8), let o = try? JSONSerialization.jsonObject(with: d) as? [String: Any] {
            firstTs = parseTS(o["timestamp"] as? String)
        }
        var ctx = 0; var lastTs: Date? = nil
        for line in lines.reversed() {
            guard let d = line.data(using: .utf8), let o = try? JSONSerialization.jsonObject(with: d) as? [String: Any] else { continue }
            if lastTs == nil { lastTs = parseTS(o["timestamp"] as? String) }
            if let msg = o["message"] as? [String: Any], let u = msg["usage"] as? [String: Any] {
                ctx = (u["input_tokens"] as? Int ?? 0) + (u["cache_read_input_tokens"] as? Int ?? 0) + (u["cache_creation_input_tokens"] as? Int ?? 0)
                break
            }
        }
        return (firstTs, ctx, lastTs)
    }

    static func usageTokens(in line: Substring) -> (Int, String, String, String)? {
        guard let data = line.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let msg = obj["message"] as? [String: Any],
              let usage = msg["usage"] as? [String: Any] else { return nil }
        let t = (usage["input_tokens"] as? Int ?? 0)
              + (usage["cache_read_input_tokens"] as? Int ?? 0)
              + (usage["cache_creation_input_tokens"] as? Int ?? 0)
        let cwd = obj["cwd"] as? String ?? ""
        let branch = obj["gitBranch"] as? String ?? ""
        let model = msg["model"] as? String ?? "?"
        return (t, cwd, branch, model)
    }

    /// Último contexto (tokens) de un jsonl, leyendo de atrás hacia adelante.
    static func lastContext(of file: URL) -> (Int, String, String, String)? {
        guard let content = try? String(contentsOf: file, encoding: .utf8) else { return nil }
        for line in content.split(separator: "\n", omittingEmptySubsequences: true).reversed()
        where line.contains("\"role\":\"assistant\"") && line.contains("\"usage\"") {
            if let r = usageTokens(in: line) { return r }
        }
        return nil
    }

    /// Metadatos en vivo de ~/.claude/sessions/*.json: sessionId -> (nombre, busy).
    /// Es la fuente fiable del nombre y del estado (busy/idle) de cada sesión abierta.
    /// ¿El proceso sigue vivo? (la ventana/sesión sigue abierta)
    static func processAlive(_ pid: Int) -> Bool {
        let r = kill(pid_t(pid), 0)
        return r == 0 || errno == EPERM
    }

    static func liveMeta(home: URL) -> [String: (name: String?, busy: Bool?, pid: Int?, bridged: Bool, alive: Bool, cwd: String?)] {
        let dir = home.appendingPathComponent(".claude/sessions")
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else { return [:] }
        var best: [String: (name: String?, busy: Bool?, pid: Int?, bridged: Bool, cwd: String?, updated: Double)] = [:]
        for f in files where f.pathExtension == "json" {
            guard let data = try? Data(contentsOf: f),
                  let o = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let sid = o["sessionId"] as? String else { continue }
            let updated = o["updatedAt"] as? Double ?? 0
            if let prev = best[sid], prev.updated >= updated { continue }   // conserva el más reciente
            let busy = (o["status"] as? String).map { $0 == "busy" }
            let bridged = (o["bridgeSessionId"] as? String) != nil          // control remoto conectado
            best[sid] = (o["name"] as? String, busy, o["pid"] as? Int, bridged, o["cwd"] as? String, updated)
        }
        return best.mapValues { v in
            (v.name, v.busy, v.pid, v.bridged, v.pid.map { processAlive($0) } ?? false, v.cwd)
        }
    }

    /// Mapea agentId -> (nombre = subagent_type, tarea = description) leyendo la sesión padre:
    /// enlaza la llamada Agent/Task (tool_use) con el tool_result que revela el agentId.
    static func agentNames(_ lines: [Substring]) -> [String: (name: String, desc: String?)] {
        var calls: [String: (String, String?)] = [:]   // tool_use_id -> (name, desc)
        for line in lines where line.contains("\"tool_use\"") && (line.contains("\"name\":\"Agent\"") || line.contains("\"name\":\"Task\"")) {
            guard let d = line.data(using: .utf8),
                  let o = try? JSONSerialization.jsonObject(with: d) as? [String: Any],
                  let msg = o["message"] as? [String: Any],
                  let content = msg["content"] as? [[String: Any]] else { continue }
            for b in content where (b["type"] as? String) == "tool_use" {
                let nm = b["name"] as? String
                guard nm == "Agent" || nm == "Task",
                      let id = b["id"] as? String, let input = b["input"] as? [String: Any] else { continue }
                let name = (input["subagent_type"] as? String) ?? (input["agentType"] as? String) ?? "agent"
                calls[id] = (name, input["description"] as? String)
            }
        }
        var map: [String: (name: String, desc: String?)] = [:]
        for line in lines where line.contains("\"agentId\"") || line.contains("(internal ID") {
            guard let d = line.data(using: .utf8),
                  let o = try? JSONSerialization.jsonObject(with: d) as? [String: Any],
                  let msg = o["message"] as? [String: Any],
                  let content = msg["content"] as? [[String: Any]] else { continue }
            let useId = content.first { ($0["type"] as? String) == "tool_result" }?["tool_use_id"] as? String

            // Subagentes síncronos (Task): el resultado trae agentId + agentType directamente.
            if let tur = o["toolUseResult"] as? [String: Any], let aid = tur["agentId"] as? String, !aid.isEmpty {
                let name = (tur["agentType"] as? String) ?? useId.flatMap { calls[$0]?.0 } ?? "agent"
                map[aid] = (name, useId.flatMap { calls[$0]?.1 })
                continue
            }
            // Agentes en segundo plano (Agent): el agentId viene en el texto "(internal ID".
            for b in content where (b["type"] as? String) == "tool_result" {
                guard let uid = b["tool_use_id"] as? String else { continue }
                var text = ""
                if let s = b["content"] as? String { text = s }
                else if let arr = b["content"] as? [[String: Any]] { text = arr.compactMap { $0["text"] as? String }.joined(separator: " ") }
                guard let r = text.range(of: "[0-9a-f]{16,17} \\(internal ID", options: .regularExpression) else { continue }
                let aid = text[r].components(separatedBy: " ").first ?? ""
                if let info = calls[uid], !aid.isEmpty { map[aid] = info }
            }
        }
        return map
    }

    /// Devuelve el último objeto JSON cuya línea contiene `marker`.
    static func reverseFind(_ lines: [Substring], _ marker: String) -> [String: Any]? {
        for line in lines.reversed() where line.contains(marker) {
            if let d = line.data(using: .utf8),
               let o = try? JSONSerialization.jsonObject(with: d) as? [String: Any] { return o }
        }
        return nil
    }

    static func scanAll(_ c: Config) -> [Session] {
        let fm = FileManager.default
        let home = fm.homeDirectoryForCurrentUser
        let projects = home.appendingPathComponent(".claude/projects")
        guard let dirs = try? fm.contentsOfDirectory(at: projects, includingPropertiesForKeys: [.isDirectoryKey]) else { return [] }
        let now = Date()
        let meta = liveMeta(home: home)
        var out: [Session] = []

        // poda simple para que los cachés no crezcan sin límite con el tiempo
        if transcriptCache.count > 200 { transcriptCache.removeAll(keepingCapacity: true) }
        if agentCache.count > 800 { agentCache.removeAll(keepingCapacity: true) }

        for dir in dirs {
            guard (try? dir.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true,
                  let files = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: [.contentModificationDateKey]) else { continue }
            for file in files where file.pathExtension == "jsonl" {
                let mtime = (try? file.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? .distantPast
                let id = file.deletingPathExtension().lastPathComponent
                let lm = meta[id]
                let recent = now.timeIntervalSince(mtime) <= c.listWindowSeconds
                // muestra si es reciente O si la ventana sigue abierta (proceso vivo); descarta solo viejas y cerradas
                if !recent && !(lm?.alive ?? false) { continue }

                // caché por mtime: solo re-parsea si el archivo cambió
                let path = file.path
                let parsed: TranscriptParse?
                if let cached = transcriptCache[path], cached.mtime == mtime {
                    parsed = cached.parse
                } else {
                    parsed = parseTranscript(file)
                    transcriptCache[path] = (mtime, parsed)
                }
                guard let p = parsed else { continue }

                let ov = c.overrides[id]

                // nombre: alias del monitor > sessions/*.json > customTitle > aiTitle
                let liveName = (lm?.name?.isEmpty == false) ? lm?.name : nil
                let alias = (ov?.alias?.isEmpty == false) ? ov?.alias : nil
                let title = alias ?? liveName ?? (p.custom?.isEmpty == false ? p.custom : nil) ?? p.ai
                let colorName = ov?.color ?? p.colorName   // override del monitor tiene prioridad

                let window = c.forceContextWindow ?? (p.ctx <= 200_000 ? 200_000 : 1_000_000)
                // cwd fiable = directorio de lanzamiento: sessions/*.json > primer cwd del transcript > último
                let launchCwd = (lm?.cwd?.isEmpty == false ? lm?.cwd : nil) ?? (p.firstCwd.isEmpty ? p.cwd : p.firstCwd)
                let project = launchCwd.isEmpty ? id : (launchCwd as NSString).lastPathComponent

                let (live, total) = subagents(projectDir: dir, sessionId: id, now: now, c: c, names: p.agentNames)
                let task = c.showCurrentTask ? currentTask(home: home, sessionId: id) : nil

                out.append(Session(id: id, project: project, cwd: launchCwd, branch: p.branch,
                                   model: shortModel(p.model), contextTokens: p.ctx, window: window,
                                   mtime: mtime, liveSubagents: live, totalSubagents: total,
                                   currentTask: task, title: title, colorName: colorName, busy: lm?.busy, pid: lm?.pid,
                                   bridged: lm?.bridged ?? false, alive: lm?.alive ?? false,
                                   pinned: ov?.pinned ?? false, hidden: ov?.hidden ?? false))
            }
        }
        // orden por estado: activa (0) -> dormida/abierta (1) -> cerrada (2)
        func rank(_ s: Session) -> Int { s.isActive(c) ? 0 : (s.alive ? 1 : 2) }
        return out.sorted {
            if $0.pinned != $1.pinned { return $0.pinned }                // fijadas arriba
            let r0 = rank($0), r1 = rank($1)
            if r0 != r1 { return r0 < r1 }
            return $0.pct > $1.pct                                         // dentro del grupo, por % de contexto
        }
    }

    /// Sub-agentes recientes con tiempo de ejecución + tokens + estado en vivo, y total.
    static func subagents(projectDir: URL, sessionId: String, now: Date, c: Config,
                          names: [String: (name: String, desc: String?)]) -> ([Subagent], Int) {
        let dir = projectDir.appendingPathComponent(sessionId).appendingPathComponent("subagents")
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: [.contentModificationDateKey]) else { return ([], 0) }
        let agentFiles = files.filter { $0.pathExtension == "jsonl" && $0.lastPathComponent.hasPrefix("agent-") }

        // ordena por mtime desc y parsea solo los más recientes (rendimiento)
        let ranked = agentFiles.map { f -> (URL, Date) in
            ((f), (try? f.resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate ?? .distantPast)
        }.sorted { $0.1 > $1.1 }

        var agents: [Subagent] = []
        for (f, mtime) in ranked.prefix(10) {
            let age = now.timeIntervalSince(mtime)
            if age > c.listWindowSeconds { continue }

            // caché por mtime: los agentes terminados (mtime estable) no se re-parsean
            let path = f.path
            let firstTs: Date?, ctx: Int, lastTs: Date?
            if let cached = agentCache[path], cached.mtime == mtime {
                firstTs = cached.firstTs; ctx = cached.tokens; lastTs = cached.lastTs
            } else {
                guard let stats = parseAgentFile(f) else { continue }
                firstTs = stats.firstTs; ctx = stats.tokens; lastTs = stats.lastTs
                agentCache[path] = (mtime, firstTs, ctx, lastTs)
            }

            let isLive = age <= c.subagentLiveSeconds
            let endRef = isLive ? now : (lastTs ?? mtime)               // agente vivo => reloj corriendo
            let elapsed = endRef.timeIntervalSince(firstTs ?? endRef)
            let full = f.deletingPathExtension().lastPathComponent.replacingOccurrences(of: "agent-", with: "")
            let short = String(full.prefix(6))
            let info = names[full]
            agents.append(Subagent(id: short, name: info?.name, desc: info?.desc,
                                   contextTokens: ctx, elapsed: elapsed, ageSeconds: age, isLive: isLive, startDate: firstTs))
        }
        agents.sort { ($0.isLive ? 0 : 1, $0.ageSeconds) < ($1.isLive ? 0 : 1, $1.ageSeconds) }
        return (agents, agentFiles.count)
    }

    /// Tarea in_progress de la sesión (de ~/.claude/tasks/<id>/*.json).
    static func currentTask(home: URL, sessionId: String) -> String? {
        let dir = home.appendingPathComponent(".claude/tasks").appendingPathComponent(sessionId)
        let fm = FileManager.default
        guard let files = try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) else { return nil }
        for f in files where f.pathExtension == "json" {
            guard let data = try? Data(contentsOf: f),
                  let o = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  (o["status"] as? String) == "in_progress" else { continue }
            return (o["activeForm"] as? String) ?? (o["subject"] as? String)
        }
        return nil
    }

    static func shortModel(_ m: String) -> String {
        m.replacingOccurrences(of: "claude-", with: "")
    }
}

// MARK: - Componentes visuales (dibujados, no texto)

private func drawSymbol(_ name: String, color: NSColor, rect: NSRect, weight: NSFont.Weight = .semibold) {
    let conf = NSImage.SymbolConfiguration(pointSize: rect.height, weight: weight)
        .applying(NSImage.SymbolConfiguration(paletteColors: [color]))
    NSImage(systemSymbolName: name, accessibilityDescription: nil)?
        .withSymbolConfiguration(conf)?.draw(in: rect)
}

private func drawText(_ str: String, _ rect: NSRect, color: NSColor, font: NSFont,
                      align: NSTextAlignment = .left, truncate: Bool = false) {
    let p = NSMutableParagraphStyle(); p.alignment = align
    if truncate { p.lineBreakMode = .byTruncatingTail }
    NSAttributedString(string: str, attributes: [.foregroundColor: color, .font: font, .paragraphStyle: p]).draw(in: rect)
}

private func drawHighlight(_ bounds: NSRect, _ highlighted: Bool) {
    guard highlighted else { return }
    NSColor.selectedContentBackgroundColor.setFill()
    NSBezierPath(roundedRect: bounds.insetBy(dx: 4, dy: 1), xRadius: 5, yRadius: 5).fill()
}

/// Fila de una sesión: forma de estado + nombre + barra de progreso real + % + tendencia + agentes.
/// Base de filas de menú: se ajustan al ancho REAL del menú (no a un ancho fijo).
class MenuRow: NSView {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        autoresizingMask = [.width]
    }
    required init?(coder: NSCoder) { fatalError() }
    override func setFrameSize(_ newSize: NSSize) { super.setFrameSize(newSize); needsDisplay = true }
}

final class SessionRowView: MenuRow {
    private let s: Session
    private let cfg: Config
    private let trend: String
    private let liveCount: Int

    init(_ s: Session, cfg: Config, trend: String, liveCount: Int) {
        self.s = s; self.cfg = cfg; self.trend = trend; self.liveCount = liveCount
        super.init(frame: NSRect(x: 0, y: 0, width: 372, height: 26))
    }
    required init?(coder: NSCoder) { fatalError() }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach(removeTrackingArea)
        addTrackingArea(NSTrackingArea(rect: bounds,
            options: [.activeAlways, .mouseEnteredAndExited, .inVisibleRect], owner: self))
    }
    override func mouseEntered(with event: NSEvent) { needsDisplay = true }
    override func mouseExited(with event: NSEvent) { needsDisplay = true }

    override func draw(_ dirtyRect: NSRect) {
        let hl = enclosingMenuItem?.isHighlighted ?? false
        drawHighlight(bounds, hl)
        let active = s.isActive(cfg)
        // brillo: activa = 1, dormida (abierta) = 0.6, cerrada = 0.4
        let a: CGFloat = active ? 1.0 : (s.alive ? 0.6 : 0.4)
        let txt = (hl ? NSColor.selectedMenuItemTextColor : NSColor.labelColor).withAlphaComponent(a)
        let sec = (hl ? NSColor.selectedMenuItemTextColor : NSColor.secondaryLabelColor).withAlphaComponent(a)
        let lvl = active ? s.color(cfg) : NSColor.systemGray
        let midY = bounds.midY

        // marcador: color asignado a la sesión (como en la consola); si no, forma por nivel
        if let accent = s.accentColor {
            accent.withAlphaComponent(a).setFill()
            NSBezierPath(ovalIn: NSRect(x: 12, y: midY - 6, width: 12, height: 12)).fill()
            if hl {  // borde para que resalte sobre el azul
                NSColor.white.withAlphaComponent(0.7).setStroke()
                let ring = NSBezierPath(ovalIn: NSRect(x: 12, y: midY - 6, width: 12, height: 12)); ring.lineWidth = 1; ring.stroke()
            }
        } else {
            drawSymbol(s.symbol(cfg), color: lvl.withAlphaComponent(a), rect: NSRect(x: 12, y: midY - 7, width: 14, height: 14))
        }
        let R = bounds.width   // cluster derecho anclado al borde real del menú
        drawText("›", NSRect(x: R - 16, y: midY - 10, width: 10, height: 18), color: sec, font: .systemFont(ofSize: 14))
        if liveCount > 0 {
            drawText("🤖\(liveCount)", NSRect(x: R - 52, y: midY - 9, width: 34, height: 18), color: txt, font: .systemFont(ofSize: 12))
        } else if s.busy == true {
            NSColor.systemGreen.withAlphaComponent(a).setFill()
            NSBezierPath(ovalIn: NSRect(x: R - 46, y: midY - 4, width: 8, height: 8)).fill()
        } else if !active {
            let icon = s.alive ? "moon.zzz.fill" : "pause.circle.fill"
            drawSymbol(icon, color: sec, rect: NSRect(x: R - 50, y: midY - 7, width: 14, height: 14), weight: .regular)
        }
        drawText(trend, NSRect(x: R - 72, y: midY - 9, width: 14, height: 18), color: sec, font: .systemFont(ofSize: 12))
        drawText(String(format: "%.0f%%", s.pct), NSRect(x: R - 116, y: midY - 9, width: 38, height: 18),
                 color: txt, font: .monospacedDigitSystemFont(ofSize: 12, weight: .regular), align: .right)

        // barra de progreso real, anclada a la izquierda del %
        let barW: CGFloat = 84
        let bar = NSRect(x: R - 126 - barW, y: midY - 4, width: barW, height: 7)
        (hl ? NSColor.white.withAlphaComponent(0.25) : NSColor.quaternaryLabelColor).setFill()
        NSBezierPath(roundedRect: bar, xRadius: 3.5, yRadius: 3.5).fill()
        let w = max(4, bar.width * CGFloat(min(1, s.pct / 100)))
        lvl.withAlphaComponent(a).setFill()
        NSBezierPath(roundedRect: NSRect(x: bar.minX, y: bar.minY, width: w, height: bar.height), xRadius: 3.5, yRadius: 3.5).fill()

        // nombre: ocupa el espacio entre el marcador y la barra
        let nameW = max(40, bar.minX - 32 - 10)
        drawText(s.displayName, NSRect(x: 32, y: midY - 9, width: nameW, height: 18),
                 color: txt, font: .systemFont(ofSize: 13, weight: .medium), truncate: true)
    }
}

/// Fila de un agente activo: en vivo + nombre + tarea + tiempo de ejecución (reloj) + tokens.
final class AgentRowView: MenuRow {
    private let name: String
    private let desc: String?
    private let start: Date?
    private let fallbackElapsed: Double
    private let tokens: Int

    init(_ a: Subagent) {
        name = a.displayName; desc = a.desc
        start = a.startDate; fallbackElapsed = a.elapsed; tokens = a.contextTokens
        super.init(frame: NSRect(x: 0, y: 0, width: 392, height: 24))
    }
    required init?(coder: NSCoder) { fatalError() }

    func tick() { needsDisplay = true }   // recalcula el reloj en vivo

    override func draw(_ dirtyRect: NSRect) {
        let hl = enclosingMenuItem?.isHighlighted ?? false
        drawHighlight(bounds, hl)
        let txt = hl ? NSColor.selectedMenuItemTextColor : NSColor.labelColor
        let sec = hl ? NSColor.selectedMenuItemTextColor : NSColor.secondaryLabelColor
        let midY = bounds.midY
        let mono = NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .regular)

        drawSymbol("play.fill", color: hl ? .white : .systemGreen, rect: NSRect(x: 14, y: midY - 5, width: 10, height: 10), weight: .bold)

        // nombre (medium) + tarea (secundaria), en una sola línea truncada
        let p = NSMutableParagraphStyle(); p.lineBreakMode = .byTruncatingTail
        let line = NSMutableAttributedString(string: name, attributes: [
            .foregroundColor: txt, .font: NSFont.systemFont(ofSize: 12, weight: .medium), .paragraphStyle: p])
        if let d = desc, !d.isEmpty {
            line.append(NSAttributedString(string: "  \(d)", attributes: [
                .foregroundColor: sec, .font: NSFont.systemFont(ofSize: 11), .paragraphStyle: p]))
        }
        let R = bounds.width
        let tok = tokens >= 1000 ? String(format: "%.0fk", Double(tokens) / 1000) : "\(tokens)"
        drawText("↓ \(tok) tok", NSRect(x: R - 90, y: midY - 8, width: 78, height: 16), color: sec, font: mono, align: .right)
        let elapsed = start.map { Date().timeIntervalSince($0) } ?? fallbackElapsed
        drawText(formatDuration(elapsed), NSRect(x: R - 158, y: midY - 8, width: 62, height: 16), color: txt, font: mono, align: .right)
        line.draw(in: NSRect(x: 30, y: midY - 8, width: max(60, R - 168), height: 16))
    }
}

/// Mini-gráfico de tendencia del contexto (línea + área), como componente real.
final class TrendChartView: MenuRow {
    private let vals: [Double]
    private let color: NSColor
    private let arrow: String

    init(values: [Double], color: NSColor, arrow: String) {
        self.vals = Array(values.suffix(40)); self.color = color; self.arrow = arrow
        super.init(frame: NSRect(x: 0, y: 0, width: 392, height: 34))
    }
    required init?(coder: NSCoder) { fatalError() }

    override func draw(_ dirtyRect: NSRect) {
        let hl = enclosingMenuItem?.isHighlighted ?? false
        drawHighlight(bounds, hl)
        let lbl = hl ? NSColor.selectedMenuItemTextColor : NSColor.secondaryLabelColor
        let midY = bounds.midY
        drawText(L("trend"), NSRect(x: 14, y: midY - 9, width: 70, height: 18), color: lbl, font: .systemFont(ofSize: 12))
        drawText(arrow, NSRect(x: bounds.width - 24, y: midY - 9, width: 16, height: 18), color: lbl, font: .systemFont(ofSize: 13))

        // gráfico a ancho completo (entre la etiqueta y la flecha)
        let chart = NSRect(x: 88, y: 7, width: bounds.width - 88 - 30, height: bounds.height - 14)
        (hl ? NSColor.white.withAlphaComponent(0.15) : NSColor.quaternaryLabelColor.withAlphaComponent(0.4)).setFill()
        NSBezierPath(roundedRect: chart, xRadius: 4, yRadius: 4).fill()

        let stroke = hl ? NSColor.white : color
        let ix = chart.minX + 5, iw = chart.width - 10, iy = chart.minY + 4, ih = chart.height - 8
        if vals.count >= 2 {
            let lo = vals.min()!, hi = vals.max()!, span = max(hi - lo, 0.0001), n = vals.count
            func pt(_ i: Int, _ v: Double) -> NSPoint {
                NSPoint(x: ix + iw * CGFloat(i) / CGFloat(n - 1), y: iy + ih * CGFloat((v - lo) / span))
            }
            let area = NSBezierPath()
            area.move(to: NSPoint(x: ix, y: iy))
            for (i, v) in vals.enumerated() { area.line(to: pt(i, v)) }
            area.line(to: NSPoint(x: ix + iw, y: iy)); area.close()
            stroke.withAlphaComponent(0.22).setFill(); area.fill()
            let path = NSBezierPath(); path.move(to: pt(0, vals[0]))
            for (i, v) in vals.enumerated() where i > 0 { path.line(to: pt(i, v)) }
            path.lineWidth = 1.8; stroke.setStroke(); path.stroke()
        } else {
            let path = NSBezierPath()
            path.move(to: NSPoint(x: ix, y: chart.midY)); path.line(to: NSPoint(x: ix + iw, y: chart.midY))
            path.lineWidth = 1.8; stroke.withAlphaComponent(0.6).setStroke(); path.stroke()
        }
    }
}

/// Pequeño NSImage con un círculo de color (para el menú de colores).
func swatchImage(_ color: NSColor?) -> NSImage {
    let size = NSSize(width: 14, height: 14)
    let img = NSImage(size: size)
    img.lockFocus()
    let rect = NSRect(origin: .zero, size: size).insetBy(dx: 1.5, dy: 1.5)
    if let color = color {
        color.setFill(); NSBezierPath(ovalIn: rect).fill()
    } else {
        NSColor.tertiaryLabelColor.setStroke()
        let p = NSBezierPath(ovalIn: rect); p.lineWidth = 1.2; p.stroke()
    }
    img.unlockFocus()
    img.isTemplate = false
    return img
}

/// Identifica una opción de color para un sessionId (va en representedObject del menú).
final class ColorChoice: NSObject {
    let id: String; let color: String?
    init(id: String, color: String?) { self.id = id; self.color = color }
}

// MARK: - Ventana de Preferencias

final class PreferencesWindowController: NSWindowController, NSWindowDelegate {
    private let store: ConfigStore
    private let onChange: () -> Void
    private let onClose: () -> Void

    private let refreshSlider = NSSlider()
    private let subagentSlider = NSSlider()
    private let activeSlider = NSSlider()
    private let listSlider = NSSlider()
    private let greenSlider = NSSlider()
    private let yellowSlider = NSSlider()
    private let windowPopup = NSPopUpButton()
    private let langPopup = NSPopUpButton()
    private let alertCheck = NSButton(checkboxWithTitle: L("pref_alert"), target: nil, action: nil)
    private let branchCheck = NSButton(checkboxWithTitle: L("pref_branch"), target: nil, action: nil)
    private let taskCheck = NSButton(checkboxWithTitle: L("pref_task"), target: nil, action: nil)
    private let pushCheck = NSButton(checkboxWithTitle: L("pref_push"), target: nil, action: nil)
    private let loginCheck = NSButton(checkboxWithTitle: L("pref_login"), target: nil, action: nil)
    private let usageCheck = NSButton(checkboxWithTitle: L("pref_usage"), target: nil, action: nil)
    private var valueLabels: [NSSlider: NSTextField] = [:]
    private var suffixes: [NSSlider: String] = [:]

    init(store: ConfigStore, onChange: @escaping () -> Void, onClose: @escaping () -> Void) {
        self.store = store; self.onChange = onChange; self.onClose = onClose
        let win = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 480, height: 600),
                           styleMask: [.titled, .closable], backing: .buffered, defer: false)
        win.title = "Claude Session Monitor"
        super.init(window: win)
        win.delegate = self
        buildUI()
        loadValues()
        win.center()
    }
    required init?(coder: NSCoder) { fatalError() }

    func windowWillClose(_ notification: Notification) { onClose() }

    // -- construcción de UI --
    private func buildUI() {
        let stack = NSStackView(views: [
            sliderRow(L("pref_refresh"), refreshSlider, 1, 30, "s"),
            sliderRow(L("pref_agent_live"), subagentSlider, 10, 120, "s"),
            sliderRow(L("pref_active"), activeSlider, 1, 60, "min"),
            sliderRow(L("pref_history"), listSlider, 10, 240, "min"),
            sliderRow(L("pref_green"), greenSlider, 0, 100, "%"),
            sliderRow(L("pref_yellow"), yellowSlider, 0, 100, "%"),
            labeledRow(L("pref_window"), windowPopup),
            labeledRow(L("pref_language"), langPopup),
            loginCheck, usageCheck, alertCheck, branchCheck, taskCheck, pushCheck,
        ])
        stack.orientation = .vertical
        stack.alignment = .leading
        stack.spacing = 12

        windowPopup.removeAllItems()
        windowPopup.addItems(withTitles: [L("pref_win_auto"), L("pref_win_200"), L("pref_win_1m")])
        windowPopup.target = self; windowPopup.action = #selector(changed)
        langPopup.removeAllItems()
        langPopup.addItems(withTitles: [L("lang_system"), "English", "Español", "Português"])
        langPopup.target = self; langPopup.action = #selector(changed)
        for ck in [usageCheck, alertCheck, branchCheck, taskCheck, pushCheck] { ck.target = self; ck.action = #selector(changed) }
        loginCheck.target = self; loginCheck.action = #selector(toggleLogin)   // gestionado por el sistema, no por Config

        let reset = NSButton(title: L("pref_reset"), target: self, action: #selector(resetDefaults))
        reset.bezelStyle = .rounded

        // pestaña Settings: controles arriba, botón "Restablecer" abajo a la derecha (estándar Apple)
        let settingsView = NSView()
        settingsView.addSubview(stack)
        settingsView.addSubview(reset)
        stack.translatesAutoresizingMaskIntoConstraints = false
        reset.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: settingsView.topAnchor, constant: 18),
            stack.leadingAnchor.constraint(equalTo: settingsView.leadingAnchor, constant: 18),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: settingsView.trailingAnchor, constant: -18),
            reset.trailingAnchor.constraint(equalTo: settingsView.trailingAnchor, constant: -18),
            reset.bottomAnchor.constraint(equalTo: settingsView.bottomAnchor, constant: -18),
            reset.topAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: 16),
        ])

        // pestañas
        let tabs = NSTabView()
        let t1 = NSTabViewItem(identifier: "settings"); t1.label = L("tab_settings"); t1.view = settingsView
        let t2 = NSTabViewItem(identifier: "about"); t2.label = L("tab_about"); t2.view = buildAbout()
        tabs.addTabViewItem(t1)
        tabs.addTabViewItem(t2)

        let content = NSView()
        window!.contentView = content
        content.addSubview(tabs)
        tabs.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabs.topAnchor.constraint(equalTo: content.topAnchor, constant: 12),
            tabs.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 12),
            tabs.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -12),
            tabs.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -12),
        ])
    }

    private func buildAbout() -> NSView {
        let title = NSTextField(labelWithString: "Claude Session Monitor")
        title.font = .systemFont(ofSize: 18, weight: .bold)

        let version = NSTextField(labelWithString: L("about_version"))
        version.textColor = .secondaryLabelColor

        let desc = NSTextField(wrappingLabelWithString: L("about_desc"))
        desc.alignment = .center
        desc.preferredMaxLayoutWidth = 380

        let author = NSTextField(labelWithString: L("about_author"))
        author.textColor = .secondaryLabelColor

        let madeWith = NSTextField(labelWithString: L("about_made"))
        madeWith.font = .systemFont(ofSize: 11)
        madeWith.textColor = .tertiaryLabelColor

        let github = NSButton(title: "", target: self, action: #selector(openGitHub))
        github.isBordered = false
        github.attributedTitle = NSAttributedString(string: "github.com/wmachuca", attributes: [
            .foregroundColor: NSColor.linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .font: NSFont.systemFont(ofSize: 12),
        ])

        let folderBtn = NSButton(title: L("about_open"), target: self, action: #selector(openProjectFolder))
        folderBtn.bezelStyle = .rounded

        let robot = NSTextField(labelWithString: "🤖")
        robot.font = .systemFont(ofSize: 48)

        let stack = NSStackView(views: [robot, title, version, desc, author, github, folderBtn, madeWith])
        stack.orientation = .vertical
        stack.alignment = .centerX
        stack.spacing = 12

        let v = NSView()
        v.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: v.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: v.trailingAnchor, constant: -24),
        ])
        return v
    }

    @objc private func openProjectFolder() {
        NSWorkspace.shared.open(Bundle.main.bundleURL.deletingLastPathComponent())
    }

    @objc private func openGitHub() {
        if let url = URL(string: "https://github.com/wmachuca") { NSWorkspace.shared.open(url) }
    }

    private func sliderRow(_ title: String, _ slider: NSSlider, _ lo: Double, _ hi: Double, _ suffix: String) -> NSView {
        slider.minValue = lo; slider.maxValue = hi
        slider.isContinuous = true
        slider.target = self; slider.action = #selector(changed)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.widthAnchor.constraint(equalToConstant: 190).isActive = true
        let value = NSTextField(labelWithString: "")
        value.alignment = .right
        value.font = .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        value.translatesAutoresizingMaskIntoConstraints = false
        value.widthAnchor.constraint(equalToConstant: 60).isActive = true
        valueLabels[slider] = value; suffixes[slider] = suffix
        return labeledRow(title, slider, value)
    }

    private func labeledRow(_ title: String, _ a: NSView, _ b: NSView? = nil) -> NSStackView {
        let l = NSTextField(labelWithString: title)
        l.alignment = .right
        l.translatesAutoresizingMaskIntoConstraints = false
        l.widthAnchor.constraint(equalToConstant: 130).isActive = true
        let row = NSStackView(views: b == nil ? [l, a] : [l, a, b!])
        row.orientation = .horizontal; row.spacing = 8; row.alignment = .centerY
        return row
    }

    // -- valores --
    private func loadValues() {
        let c = store.config
        refreshSlider.doubleValue = c.refreshInterval
        subagentSlider.doubleValue = c.subagentLiveSeconds
        activeSlider.doubleValue = c.activeWindowSeconds / 60
        listSlider.doubleValue = c.listWindowSeconds / 60
        greenSlider.doubleValue = c.greenMax
        yellowSlider.doubleValue = c.yellowMax
        windowPopup.selectItem(at: c.forceContextWindow == nil ? 0 : (c.forceContextWindow == 200_000 ? 1 : 2))
        langPopup.selectItem(at: ["system", "en", "es", "pt"].firstIndex(of: c.language) ?? 0)
        alertCheck.state = c.alertOnRed ? .on : .off
        branchCheck.state = c.showBranch ? .on : .off
        taskCheck.state = c.showCurrentTask ? .on : .off
        pushCheck.state = c.pushToClaude ? .on : .off
        usageCheck.state = c.showUsage ? .on : .off
        loginCheck.state = (SMAppService.mainApp.status == .enabled) ? .on : .off
        updateLabels()
    }

    @objc private func toggleLogin() {
        do {
            if loginCheck.state == .on { try SMAppService.mainApp.register() }
            else { try SMAppService.mainApp.unregister() }
        } catch {
            // si falla, refleja el estado real
            loginCheck.state = (SMAppService.mainApp.status == .enabled) ? .on : .off
        }
    }

    private func updateLabels() {
        for (slider, label) in valueLabels {
            label.stringValue = "\(Int(slider.doubleValue.rounded())) \(suffixes[slider] ?? "")"
        }
    }

    @objc private func changed() {
        let oldLang = store.config.language
        var c = store.config
        c.refreshInterval = refreshSlider.doubleValue.rounded()
        c.subagentLiveSeconds = subagentSlider.doubleValue.rounded()
        c.activeWindowSeconds = activeSlider.doubleValue.rounded() * 60
        c.listWindowSeconds = listSlider.doubleValue.rounded() * 60
        c.greenMax = greenSlider.doubleValue.rounded()
        c.yellowMax = yellowSlider.doubleValue.rounded()
        if c.greenMax > c.yellowMax { c.yellowMax = c.greenMax }   // mantener el orden verde ≤ amarillo
        c.forceContextWindow = [nil, 200_000, 1_000_000][windowPopup.indexOfSelectedItem]
        c.alertOnRed = alertCheck.state == .on
        c.showBranch = branchCheck.state == .on
        c.showCurrentTask = taskCheck.state == .on
        c.pushToClaude = pushCheck.state == .on
        c.showUsage = usageCheck.state == .on
        c.language = ["system", "en", "es", "pt"][langPopup.indexOfSelectedItem]
        store.apply(c)
        updateLabels()
        onChange()
        if c.language != oldLang { buildUI(); loadValues() }   // relabela la ventana en el nuevo idioma
    }

    @objc private func resetDefaults() {
        store.apply(Config())
        loadValues()
        onChange()
    }
}

/// Cabecera de la sección de uso: "USO DE LA CUENTA" a la izquierda, "Plan: XXX" a la derecha.
final class UsageHeaderView: MenuRow {
    private let plan: String
    init(plan: String) {
        self.plan = plan
        super.init(frame: NSRect(x: 0, y: 0, width: 372, height: 22))
    }
    required init?(coder: NSCoder) { fatalError() }
    override func draw(_ dirtyRect: NSRect) {
        let sec = NSColor.secondaryLabelColor
        let f = NSFont.systemFont(ofSize: 11, weight: .semibold)
        let midY = bounds.midY
        drawText(L("usage_header"), NSRect(x: 16, y: midY - 9, width: 220, height: 18), color: sec, font: f)
        if !plan.isEmpty {
            drawText("\(L("usage_plan")): \(plan)", NSRect(x: bounds.width - 166, y: midY - 9, width: 150, height: 18),
                     color: sec, font: f, align: .right)
        }
    }
}

/// Barra de uso de la cuenta: etiqueta + barra real coloreada + % + tiempo hasta el reset.
final class UsageBarView: MenuRow {
    private let title: String
    private let pct: Double
    private let reset: Date?
    init(title: String, pct: Double, reset: Date?) {
        self.title = title; self.pct = pct; self.reset = reset
        super.init(frame: NSRect(x: 0, y: 0, width: 372, height: 22))
    }
    required init?(coder: NSCoder) { fatalError() }

    func tick() { needsDisplay = true }   // actualiza la cuenta regresiva en vivo

    override func draw(_ dirtyRect: NSRect) {
        let hl = enclosingMenuItem?.isHighlighted ?? false
        drawHighlight(bounds, hl)
        let txt = hl ? NSColor.selectedMenuItemTextColor : NSColor.labelColor
        let sec = hl ? NSColor.selectedMenuItemTextColor : NSColor.secondaryLabelColor
        let midY = bounds.midY
        let color = usageColor(pct)
        let R = bounds.width

        drawText(title, NSRect(x: 16, y: midY - 9, width: 64, height: 18), color: txt, font: .systemFont(ofSize: 12, weight: .medium))
        if let reset = reset, reset.timeIntervalSinceNow > 0 {
            drawText("↻ \(formatDuration(reset.timeIntervalSinceNow))", NSRect(x: R - 86, y: midY - 9, width: 72, height: 18),
                     color: sec, font: .systemFont(ofSize: 11), align: .right)
        }
        drawText(String(format: "%.0f%%", pct), NSRect(x: R - 134, y: midY - 9, width: 42, height: 18),
                 color: txt, font: .monospacedDigitSystemFont(ofSize: 12, weight: .regular), align: .right)

        // barra: rellena el espacio entre el título y el %
        let bar = NSRect(x: 84, y: midY - 4, width: max(40, (R - 144) - 84), height: 7)
        (hl ? NSColor.white.withAlphaComponent(0.25) : NSColor.quaternaryLabelColor).setFill()
        NSBezierPath(roundedRect: bar, xRadius: 3.5, yRadius: 3.5).fill()
        let w = max(4, bar.width * CGFloat(min(1, pct / 100)))
        color.setFill()
        NSBezierPath(roundedRect: NSRect(x: bar.minX, y: bar.minY, width: w, height: bar.height), xRadius: 3.5, yRadius: 3.5).fill()
    }
}

// MARK: - App

class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var timer: Timer?
    private var currentInterval: Double = 0
    private var alerted: Set<String> = []
    private var menuOpen = false
    private var tickTimer: Timer?
    private var agentViews: [AgentRowView] = []
    private var usageViews: [UsageBarView] = []
    private var lastSessions: [Session] = []   // último snapshot (para abrir el menú al instante)
    private var scanning = false               // evita escaneos solapados
    private var usage: UsageInfo?              // uso de la cuenta (cacheado)
    private var lastUsageFetch: Date = .distantPast
    private var prefs: PreferencesWindowController?
    private let store = ConfigStore()
    private let history = History()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let menu = NSMenu(); menu.delegate = self
        statusItem.menu = menu
        rescheduleTimer()
        refresh()
    }

    private func rescheduleTimer() {
        let iv = store.config.refreshInterval
        guard iv != currentInterval else { return }
        currentInterval = iv
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: iv, repeats: true) { [weak self] _ in self?.refresh() }
    }

    /// Lanza un escaneo en segundo plano (no bloquea el hilo principal / la apertura del menú).
    private func refresh() {
        store.reloadIfChanged()
        rescheduleTimer()
        maybeFetchUsage()
        guard !scanning else { return }   // ya hay uno en curso
        scanning = true
        let c = store.config
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let sessions = Parser.scanAll(c)
            DispatchQueue.main.async {
                guard let self else { return }
                self.scanning = false
                self.lastSessions = sessions
                for s in sessions { self.history.record(s.id, s.pct) }
                let active = sessions.filter { !$0.hidden && $0.isActive(c) }
                self.updateStatusTitle(active: active, c: c)
                if !self.menuOpen {   // no reconstruir con el menú abierto (evita parpadeo)
                    self.rebuildMenu(sessions: sessions, active: active, c: c)
                }
                if c.alertOnRed { self.checkAlerts(active, c: c) }
            }
        }
    }

    /// Consulta el uso de la cuenta (máx. cada 60s, en segundo plano).
    private func maybeFetchUsage() {
        guard store.config.showUsage else { if usage != nil { usage = nil } ; return }
        guard Date().timeIntervalSince(lastUsageFetch) > 300 else { return }   // cada 5 min (el endpoint también limita)
        lastUsageFetch = Date()
        DispatchQueue.global(qos: .utility).async {
            Usage.fetch { info in
                DispatchQueue.main.async {
                    guard let info = info else { return }
                    self.usage = info
                    if !self.menuOpen {
                        let c = self.store.config
                        let active = self.lastSessions.filter { !$0.hidden && $0.isActive(c) }
                        self.rebuildMenu(sessions: self.lastSessions, active: active, c: c)
                    }
                }
            }
        }
    }

    // -- Barra: ícono CON COLOR según el estado (no template) + contador --
    private func updateStatusTitle(active: [Session], c: Config) {
        let hottest = active.max { $0.pct < $1.pct }
        let color = hottest?.color(c) ?? .systemGray
        let symbol = hottest?.symbol(c) ?? "circle.fill"
        let conf = NSImage.SymbolConfiguration(pointSize: 13, weight: .bold)
            .applying(NSImage.SymbolConfiguration(paletteColors: [color]))
        if let img = NSImage(systemSymbolName: symbol, accessibilityDescription: "estado")?.withSymbolConfiguration(conf) {
            img.isTemplate = false   // clave: permite mostrar color real en la barra
            statusItem.button?.image = img
            statusItem.button?.imagePosition = .imageLeading
            statusItem.button?.contentTintColor = nil
        }
        statusItem.button?.attributedTitle = NSAttributedString(
            string: " \(active.count)",
            attributes: [.foregroundColor: color, .font: NSFont.menuBarFont(ofSize: 0)])
    }

    private func rebuildMenu(sessions: [Session], active: [Session], c: Config) {
        let menu = statusItem.menu!
        menu.autoenablesItems = false
        menu.removeAllItems()
        agentViews.removeAll()
        usageViews.removeAll()

        let visible = sessions.filter { !$0.hidden }
        let hiddenOnes = sessions.filter { $0.hidden }

        // sección de uso de la cuenta (5h / semanal)
        if store.config.showUsage, let u = usage {
            let uh = NSMenuItem(); uh.isEnabled = false
            uh.view = UsageHeaderView(plan: (u.plan ?? "").uppercased())
            menu.addItem(uh)
            let v5 = UsageBarView(title: L("usage_5h"), pct: u.fiveHourPct, reset: u.fiveHourReset)
            let vw = UsageBarView(title: L("usage_week"), pct: u.weekPct, reset: u.weekReset)
            usageViews = [v5, vw]
            let b5 = NSMenuItem(); b5.view = v5; b5.isEnabled = true; menu.addItem(b5)
            let bw = NSMenuItem(); bw.view = vw; bw.isEnabled = true; menu.addItem(bw)
            menu.addItem(.separator())
        }

        let header = NSMenuItem(title: Lf("header", active.count, visible.count), action: nil, keyEquivalent: "")
        header.isEnabled = false
        menu.addItem(header)
        menu.addItem(.separator())

        if visible.isEmpty {
            let e = NSMenuItem(title: L("no_sessions"), action: nil, keyEquivalent: ""); e.isEnabled = false
            menu.addItem(e)
        }

        let groupTitles = [L("group_active"), L("group_dormant"), L("group_closed")]
        func groupOf(_ s: Session) -> Int { s.isActive(c) ? 0 : (s.alive ? 1 : 2) }
        let counts = (0...2).map { g in visible.filter { groupOf($0) == g }.count }

        var lastGroup = -1
        for s in visible {
            let g = groupOf(s)
            if g != lastGroup {
                if lastGroup != -1 { menu.addItem(.separator()) }
                let h = NSMenuItem(title: groupTitles[g], action: nil, keyEquivalent: "")
                h.isEnabled = false
                h.attributedTitle = NSAttributedString(string: "\(groupTitles[g].uppercased())  ·  \(counts[g])", attributes: [
                    .font: NSFont.systemFont(ofSize: 11, weight: .semibold),
                    .foregroundColor: NSColor.secondaryLabelColor,
                ])
                menu.addItem(h)
                lastGroup = g
            }
            let liveCount = s.liveSubagents.filter { $0.isLive }.count
            let item = NSMenuItem()
            item.view = SessionRowView(s, cfg: c, trend: history.arrow(s.id), liveCount: liveCount)
            item.isEnabled = true
            item.submenu = detailSubmenu(for: s, c: c)
            menu.addItem(item)
        }

        if !hiddenOnes.isEmpty {
            menu.addItem(.separator())
            let h = NSMenuItem(title: Lf("hidden_sessions", hiddenOnes.count), action: nil, keyEquivalent: "")
            h.isEnabled = true
            h.image = NSImage(systemSymbolName: "eye.slash", accessibilityDescription: nil)
            let hm = NSMenu(); hm.autoenablesItems = false
            for s in hiddenOnes {
                let it = NSMenuItem(title: s.displayName, action: #selector(unhideSession(_:)), keyEquivalent: "")
                it.target = self; it.isEnabled = true; it.representedObject = s.id
                it.image = NSImage(systemSymbolName: "eye", accessibilityDescription: nil)
                hm.addItem(it)
            }
            h.submenu = hm
            menu.addItem(h)
        }

        menu.addItem(.separator())
        func sym(_ n: String) -> NSImage? { NSImage(systemSymbolName: n, accessibilityDescription: nil) }
        let r = menu.addItem(withTitle: L("refresh_now"), action: #selector(manualRefresh), keyEquivalent: "r"); r.target = self; r.isEnabled = true; r.image = sym("arrow.clockwise")
        let cfg = menu.addItem(withTitle: L("preferences"), action: #selector(openConfig), keyEquivalent: ","); cfg.target = self; cfg.isEnabled = true; cfg.image = sym("gearshape")
        let fld = menu.addItem(withTitle: L("open_folder"), action: #selector(openFolder), keyEquivalent: ""); fld.target = self; fld.isEnabled = true; fld.image = sym("folder")
        menu.addItem(.separator())
        let q = menu.addItem(withTitle: L("quit"), action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"); q.isEnabled = true; q.image = sym("power")
    }

    private func detailSubmenu(for s: Session, c: Config) -> NSMenu {
        let sub = NSMenu()
        sub.autoenablesItems = false
        let mono = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)

        func info(_ t: String, useMono: Bool = false, secondary: Bool = false) {
            let i = NSMenuItem(title: t, action: nil, keyEquivalent: "")
            var attrs: [NSAttributedString.Key: Any] = [:]
            if useMono { attrs[.font] = mono }
            if secondary { attrs[.foregroundColor] = NSColor.secondaryLabelColor }
            if !attrs.isEmpty { i.attributedTitle = NSAttributedString(string: t, attributes: attrs) }
            i.isEnabled = true
            sub.addItem(i)
        }

        if let task = s.currentTask { info("📋 \(task)") }
        info(Lf("context", Double(s.contextTokens)/1000, s.window/1000, s.pct), useMono: true)
        let estado: String
        if s.busy == true { estado = L("state_processing") }
        else if s.isActive(c) { estado = L("state_waiting") }
        else if s.alive { estado = L("state_dormant") }
        else { estado = L("state_closed") }
        info(Lf("state_prefix", estado), useMono: true)
        info(s.bridged ? L("remote_on") : L("remote_off"), useMono: true)
        info(Lf("model", s.model), useMono: true)
        if let b = s.meaningfulBranch { info(Lf("branch", b), useMono: true) }

        if s.alive, let pid = s.pid {
            let go = NSMenuItem(title: L("goto_window"), action: #selector(goToWindow(_:)), keyEquivalent: "")
            go.target = self; go.representedObject = pid; go.isEnabled = true
            sub.addItem(go)
        } else {
            let rs = NSMenuItem(title: L("resume_session"), action: #selector(resumeSession(_:)), keyEquivalent: "")
            rs.target = self; rs.representedObject = s.id; rs.isEnabled = true
            sub.addItem(rs)
        }

        let it = NSMenuItem()
        it.view = TrendChartView(values: history.values(s.id), color: s.color(c), arrow: history.arrow(s.id))
        it.isEnabled = true
        sub.addItem(it)

        sub.addItem(.separator())
        let live = s.liveSubagents.filter { $0.isLive }
        if live.isEmpty {
            info(L("no_agents"), secondary: true)
        } else {
            info(Lf("active_agents", live.count), secondary: true)
            for a in live {
                let it = NSMenuItem()
                let v = AgentRowView(a)
                it.view = v
                it.isEnabled = true
                agentViews.append(v)
                sub.addItem(it)
            }
        }

        // --- Ajustes de esta sesión en el monitor ---
        sub.addItem(.separator())
        info(L("in_monitor"), secondary: true)

        let colorRow = NSMenuItem(title: L("color"), action: nil, keyEquivalent: "")
        colorRow.isEnabled = true
        colorRow.image = swatchImage(s.accentColor)
        colorRow.submenu = colorMenu(for: s.id)
        sub.addItem(colorRow)

        let rn = NSMenuItem(title: L("rename_alias"), action: #selector(renameSession(_:)), keyEquivalent: "")
        rn.target = self; rn.isEnabled = true; rn.representedObject = s.id
        rn.image = NSImage(systemSymbolName: "pencil", accessibilityDescription: nil)
        sub.addItem(rn)

        let pin = NSMenuItem(title: s.pinned ? L("unpin") : L("pin_top"), action: #selector(togglePin(_:)), keyEquivalent: "")
        pin.target = self; pin.isEnabled = true; pin.representedObject = s.id
        pin.image = NSImage(systemSymbolName: s.pinned ? "pin.slash" : "pin", accessibilityDescription: nil)
        sub.addItem(pin)

        let hide = NSMenuItem(title: L("hide_monitor"), action: #selector(hideSession(_:)), keyEquivalent: "")
        hide.target = self; hide.isEnabled = true; hide.representedObject = s.id
        hide.image = NSImage(systemSymbolName: "eye.slash", accessibilityDescription: nil)
        sub.addItem(hide)

        return sub
    }

    private func colorMenu(for id: String) -> NSMenu {
        let m = NSMenu(); m.autoenablesItems = false
        let options: [(String, String?)] = [
            (L("c_none"), nil), (L("c_purple"), "purple"), (L("c_blue"), "blue"), (L("c_cyan"), "cyan"),
            (L("c_green"), "green"), (L("c_yellow"), "yellow"), (L("c_orange"), "orange"), (L("c_red"), "red"), (L("c_pink"), "pink"),
        ]
        let current = store.config.overrides[id]?.color
        for (label, name) in options {
            let it = NSMenuItem(title: label, action: #selector(setSessionColor(_:)), keyEquivalent: "")
            it.target = self; it.isEnabled = true
            it.image = swatchImage(monitorColor(name))
            it.representedObject = ColorChoice(id: id, color: name)
            if name == current { it.state = .on }
            m.addItem(it)
        }
        return m
    }

    private func checkAlerts(_ active: [Session], c: Config) {
        for s in active {
            if s.level(c) == .red {
                if !alerted.contains(s.id) {
                    notify(title: Lf("alert_title", s.displayName),
                           body: Lf("alert_body", s.pct, Double(s.contextTokens)/1000))
                    alerted.insert(s.id)
                }
            } else { alerted.remove(s.id) }
        }
    }

    private func notify(title: String, body: String) {
        let script = "display notification \"\(body)\" with title \"\(title)\" sound name \"Ping\""
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        p.arguments = ["-e", script]
        try? p.run()
    }

    @objc private func goToWindow(_ sender: NSMenuItem) {
        guard let pid = sender.representedObject as? Int else { return }
        focusTerminalWindow(claudePid: pid)
    }

    /// Retoma una sesión cerrada: abre la terminal en su carpeta y ejecuta `claude --resume <id>`.
    @objc private func resumeSession(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String,
              let s = lastSessions.first(where: { $0.id == id }) else { return }
        let cwdQuoted = "'" + s.cwd.replacingOccurrences(of: "'", with: "'\\''") + "'"
        let cmd = "cd \(cwdQuoted); claude --resume \(id)"
        let esc = cmd.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
        if preferredTerminalKind() == "iTerm2" {
            runScript("""
            tell application "iTerm2"
                activate
                create window with default profile
                tell current session of current window to write text "\(esc)"
            end tell
            """)
        } else {
            runScript("""
            tell application "Terminal"
                activate
                do script "\(esc)"
            end tell
            """)
        }
    }

    /// Detecta la terminal a usar a partir de una sesión viva; si no hay, Terminal.app.
    private func preferredTerminalKind() -> String {
        guard let pid = lastSessions.first(where: { $0.alive })?.pid else { return "Terminal" }
        var cur = pid
        for _ in 0..<10 {
            let line = shell("/bin/ps", ["-o", "ppid=,comm=", "-p", "\(cur)"]).trimmingCharacters(in: .whitespaces)
            guard let sp = line.firstIndex(of: " "), let ppid = Int(line[..<sp]) else { break }
            let comm = line[line.index(after: sp)...]
            if comm.contains("iTerm") { return "iTerm2" }
            if comm.contains("Terminal") { return "Terminal" }
            cur = ppid
            if cur <= 1 { break }
        }
        return "Terminal"
    }

    /// Enfoca la ventana/pestaña de terminal que hospeda al proceso claude `pid`.
    private func focusTerminalWindow(claudePid pid: Int) {
        // tty del proceso claude (para identificar la pestaña exacta)
        let ttyShort = shell("/bin/ps", ["-o", "tty=", "-p", "\(pid)"]).trimmingCharacters(in: .whitespacesAndNewlines)
        let device = ttyShort.isEmpty || ttyShort == "??" ? "" : "/dev/\(ttyShort)"

        // sube por el árbol de procesos hasta encontrar la app de terminal
        var cur = pid, termPid = 0, termKind = ""
        for _ in 0..<10 {
            let line = shell("/bin/ps", ["-o", "ppid=,comm=", "-p", "\(cur)"]).trimmingCharacters(in: .whitespaces)
            guard let sp = line.firstIndex(of: " "), let ppid = Int(line[..<sp]) else { break }
            let comm = line[line.index(after: sp)...].trimmingCharacters(in: .whitespaces)
            if comm.contains("iTerm") { termKind = "iTerm2"; termPid = ppid; break }
            if comm.contains("Terminal") { termKind = "Terminal"; termPid = ppid; break }
            if comm.contains("ghostty") || comm.contains("Ghostty") { termKind = "Ghostty"; termPid = ppid; break }
            if comm.contains("WezTerm") || comm.contains("wezterm") { termKind = "WezTerm"; termPid = ppid; break }
            cur = ppid
            if cur <= 1 { break }
        }

        // selección de pestaña exacta (Terminal / iTerm2); para el resto, activar la app
        if termKind == "Terminal", !device.isEmpty {
            runScript("""
            tell application "Terminal"
              activate
              repeat with w in windows
                repeat with t in tabs of w
                  try
                    if tty of t is "\(device)" then
                      set selected of t to true
                      set frontmost of w to true
                    end if
                  end try
                end repeat
              end repeat
            end tell
            """)
        } else if termKind == "iTerm2", !device.isEmpty {
            runScript("""
            tell application "iTerm2"
              activate
              repeat with w in windows
                repeat with t in tabs of w
                  repeat with s in sessions of t
                    try
                      if tty of s is "\(device)" then
                        select w
                        tell t to select
                        tell s to select
                      end if
                    end try
                  end repeat
                end repeat
              end repeat
            end tell
            """)
        } else if termPid > 0 {
            NSRunningApplication(processIdentifier: pid_t(termPid))?.activate()
        }
    }

    @discardableResult
    private func shell(_ launchPath: String, _ args: [String]) -> String {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: launchPath)
        p.arguments = args
        let out = Pipe(); p.standardOutput = out; p.standardError = Pipe()
        try? p.run(); p.waitUntilExit()
        return String(data: out.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8) ?? ""
    }

    private func runScript(_ source: String) {
        let p = Process()
        p.executableURL = URL(fileURLWithPath: "/usr/bin/osascript")
        p.arguments = ["-e", source]
        try? p.run()
    }

    // -- Overrides por sesión (guardados en el monitor) --
    private func mutateOverride(_ id: String, _ change: (inout SessionOverride) -> Void) {
        var c = store.config
        var ov = c.overrides[id] ?? SessionOverride()
        change(&ov)
        c.overrides[id] = ov.isEmpty ? nil : ov   // limpia overrides vacíos
        store.apply(c)
        refresh()
    }

    @objc private func setSessionColor(_ sender: NSMenuItem) {
        guard let ch = sender.representedObject as? ColorChoice else { return }
        mutateOverride(ch.id) { $0.color = ch.color }
        if let color = ch.color { pushCommandToClaude(sessionId: ch.id, command: "/color \(color)") }
    }

    /// Refleja un cambio en Claude Code tecleando un slash command en su terminal (solo si está libre).
    private func pushCommandToClaude(sessionId id: String, command: String) {
        guard store.config.pushToClaude,
              let s = lastSessions.first(where: { $0.id == id }), let pid = s.pid else { return }
        if s.busy == true {
            notify(title: L("busy_title"), body: L("busy_body"))
            return
        }
        // si falta el permiso de Accesibilidad, pídelo (muestra el diálogo del sistema) y no teclees aún
        if !AXIsProcessTrusted() {
            _ = AXIsProcessTrustedWithOptions(["AXTrustedCheckOptionPrompt": true] as CFDictionary)
            notify(title: L("ax_title"), body: L("ax_body"))
            return
        }
        focusTerminalWindow(claudePid: pid)
        let escaped = command.replacingOccurrences(of: "\\", with: "\\\\").replacingOccurrences(of: "\"", with: "\\\"")
        runScript("""
        delay 0.4
        tell application "System Events"
            keystroke "\(escaped)"
            delay 0.2
            key code 36
        end tell
        """)
    }

    @objc private func togglePin(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String else { return }
        let pinned = store.config.overrides[id]?.pinned ?? false
        mutateOverride(id) { $0.pinned = pinned ? nil : true }
    }

    @objc private func hideSession(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String else { return }
        mutateOverride(id) { $0.hidden = true }
    }

    @objc private func unhideSession(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String else { return }
        mutateOverride(id) { $0.hidden = nil }
    }

    @objc private func renameSession(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String else { return }
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
        let alert = NSAlert()
        alert.messageText = L("rename_title")
        alert.informativeText = L("rename_info")
        let tf = NSTextField(frame: NSRect(x: 0, y: 0, width: 240, height: 24))
        tf.stringValue = store.config.overrides[id]?.alias ?? ""
        alert.accessoryView = tf
        alert.addButton(withTitle: L("save"))
        alert.addButton(withTitle: L("cancel"))
        let resp = alert.runModal()
        NSApp.setActivationPolicy(.accessory)
        if resp == .alertFirstButtonReturn {
            let v = tf.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
            mutateOverride(id) { $0.alias = v.isEmpty ? nil : v }
            if !v.isEmpty { pushCommandToClaude(sessionId: id, command: "/rename \(v)") }
        }
    }

    @objc private func manualRefresh() {
        lastUsageFetch = .distantPast   // fuerza re-consultar el uso ya (normalmente limitado a cada 60s)
        refresh()
    }
    @objc private func openConfig() {
        if prefs == nil {
            prefs = PreferencesWindowController(
                store: store,
                onChange: { [weak self] in self?.refresh() },
                onClose: { NSApp.setActivationPolicy(.accessory) })   // vuelve a ocultar del Dock al cerrar
        }
        NSApp.setActivationPolicy(.regular)      // para que la ventana reciba foco
        NSApp.activate(ignoringOtherApps: true)
        prefs?.showWindow(nil)
        prefs?.window?.makeKeyAndOrderFront(nil)
    }
    @objc private func openFolder() {
        NSWorkspace.shared.open(FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent(".claude/projects"))
    }
    func menuWillOpen(_ menu: NSMenu) {
        menuOpen = true
        // abre AL INSTANTE con el último snapshot (sin re-escanear en el hilo principal)
        let c = store.config
        let active = lastSessions.filter { !$0.hidden && $0.isActive(c) }
        rebuildMenu(sessions: lastSessions, active: active, c: c)
        refresh()   // refresca en segundo plano para la próxima apertura
        // reloj en vivo: en modo .common para que avance mientras el menú está abierto
        tickTimer?.invalidate()
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.agentViews.forEach { $0.tick() }
            self?.usageViews.forEach { $0.tick() }
        }
        RunLoop.main.add(t, forMode: .common)
        tickTimer = t
    }
    func menuDidClose(_ menu: NSMenu) {
        menuOpen = false
        tickTimer?.invalidate(); tickTimer = nil
    }
}

// MARK: - Arranque

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = AppDelegate()
app.delegate = delegate
app.run()
