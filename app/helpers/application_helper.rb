module ApplicationHelper
  DIAS  = %w[Domingo Lunes Martes Miércoles Jueves Viernes Sábado].freeze
  MESES = %w[enero febrero marzo abril mayo junio julio agosto septiembre octubre noviembre diciembre].freeze
  INICIALES = %w[L M M J V S D].freeze

  # Íconos de trazo (mismos paths que los mockups)
  ICONS = {
    camera:        '<path d="M14.5 4h-5L7 7H4a2 2 0 0 0-2 2v9a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2h-3l-2.5-3z"/><circle cx="12" cy="13" r="3"/>',
    lock:          '<rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V7a4 4 0 0 1 8 0v4"/>',
    sun:           '<circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M6.34 17.66l-1.41 1.41M19.07 4.93l-1.41 1.41"/>',
    calendar:      '<rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/>',
    heart:         '<path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>',
    arrow_right:   '<path d="M5 12h14M13 6l6 6-6 6"/>',
    chevron_left:  '<path d="m15 18-6-6 6-6"/>',
    chevron_right: '<path d="m9 18 6-6-6-6"/>',
    share:         '<path d="M12 3v12M8 7l4-4 4 4"/><path d="M5 12v7a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2v-7"/>',
    plus_square:   '<rect x="3" y="3" width="18" height="18" rx="4"/><path d="M12 8v8M8 12h8"/>',
    bell:          '<path d="M6 8a6 6 0 0 1 12 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10.3 21a1.94 1.94 0 0 0 3.4 0"/>'
  }.freeze

  # Degradados abstractos para la polaroid bloqueada (nunca se manda la foto real)
  LOCKED_GRADIENTS = [
    "radial-gradient(circle at 30% 30%,#F0C8A8,transparent 55%),radial-gradient(circle at 70% 70%,#7F97B5,transparent 60%),#C9A48E",
    "radial-gradient(circle at 25% 35%,#C9D3B9,transparent 55%),radial-gradient(circle at 75% 65%,#D8B49C,transparent 60%),#B5A48E",
    "radial-gradient(circle at 35% 25%,#A9C1DB,transparent 55%),radial-gradient(circle at 65% 75%,#E7B89A,transparent 60%),#B8A79A"
  ].freeze

  def icon(name, size: 20, stroke: 1.8)
    tag.svg(ICONS.fetch(name).html_safe,
            width: size, height: size, viewBox: "0 0 24 24", fill: "none",
            stroke: "currentColor", "stroke-width": stroke,
            "stroke-linecap": "round", "stroke-linejoin": "round", "aria-hidden": "true")
  end

  def locked_gradient(seed)
    LOCKED_GRADIENTS[seed.to_i % LOCKED_GRADIENTS.size]
  end

  # ── Fechas en español ──
  def dia_semana(date)  = DIAS[date.wday]
  def fecha_larga(date) = "#{date.day} de #{MESES[date.month - 1]}"
  def mes_titulo(date)  = MESES[date.month - 1].capitalize
  def fecha_corta(date) = "#{DIAS[date.wday][0, 3].downcase} #{date.day} #{MESES[date.month - 1][0, 3]}"
  def inicial_dia(date) = INICIALES[(date.wday + 6) % 7]

  # Nombre de la otra persona (se define en users.name, editable en Nosotros)
  def partner_label(user = Current.user)
    user&.partner&.name.presence || "Tu persona"
  end

  # Estado de una celda del calendario
  def calendar_state(day, date, today)
    return :future if date > today
    return :both if day&.revealed?
    return :locked if date == today

    day && day.moments.size == 1 ? :one : :empty
  end
end
