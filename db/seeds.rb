# db/seeds.rb — idempotente: se puede correr varias veces sin duplicar

# ── Usuarios ─────────────────────────────────────────────────────
# Cambia emails y contraseñas antes de producción (o usa ENV)
ella = User.find_or_create_by!(email_address: ENV.fetch("ELLA_EMAIL", "ella@vivivar.app")) do |u|
  u.name     = "Fer"
  u.theme    = "ella"
  u.password = ENV.fetch("ELLA_PASSWORD", "cambiame123")
end

el = User.find_or_create_by!(email_address: ENV.fetch("EL_EMAIL", "steven@vivivar.app")) do |u|
  u.name     = "Steven"
  u.theme    = "el"
  u.password = ENV.fetch("EL_PASSWORD", "cambiame123")
end

ella.update!(partner: el)
el.update!(partner: ella)

# ── Pares de prompts ─────────────────────────────────────────────
# [prompt para ella, prompt para él, pregunta para conversar]
PAIRS = [
  ["Algo que te recordó a mí hoy", "Algo que quisieras mostrarme en persona", "¿Qué es lo primero que haremos cuando nos veamos?"],
  ["Tu cielo ahora mismo", "Tu cielo ahora mismo", "¿Qué estás pensando justo en este momento?"],
  ["Lo que estás comiendo", "Lo que estás comiendo", "¿Qué comida tenemos que probar juntos?"],
  ["Tu rincón favorito del día", "El lugar donde más me extrañaste hoy", "¿Qué te hizo sonreír hoy?"],
  ["Algo que te hace sentir en casa", "Algo que te gustaría que tengamos juntos", "¿Cómo imaginas nuestro hogar?"],
  ["Tus zapatos ahora mismo", "Tus zapatos ahora mismo", "¿A dónde quisieras caminar conmigo?"],
  ["Algo pequeño que te dio paz", "Algo pequeño que te dio paz", "¿Qué te preocupa y todavía no me has contado?"],
  ["Una canción en tu cabeza (foto de lo que escuchas)", "Una canción que te recuerda a nosotros", "¿Cuál sería la canción de nuestra relación?"],
  ["Lo más bonito que viste hoy", "Lo más bonito que viste hoy", "¿Qué momento de hoy repetirías?"],
  ["Tu vista desde donde estás sentada", "Tu vista desde donde estás sentado", "Si pudieras teletransportarte ya, ¿qué harías primero?"],
  ["Algo que te dé risa", "Algo que me daría risa a mí", "¿Cuál es el recuerdo más gracioso que tenemos?"],
  ["Algo de color rosa", "Algo de color azul", "¿Qué color le pondrías a este día?"],
  ["Tu cara de 'te extraño'", "Tu cara de 'te extraño'", "¿Qué es lo que más extrañas de mí hoy?"],
  ["Algo que aprendiste hoy", "Algo que aprendiste hoy", "¿Qué te gustaría que aprendamos juntos?"],
  ["Un lugar al que me llevarías", "Un lugar al que me llevarías", "¿Cuál sería nuestro viaje soñado?"],
  ["Tu bebida del día", "Tu bebida del día", "¿Café, té o qué nos tomamos en nuestra próxima cita?"],
  ["Algo que te hizo pensar en nuestro futuro", "Algo que te hizo pensar en nuestro futuro", "¿Dónde nos ves en cinco años?"],
  ["Tus manos haciendo algo", "Tus manos haciendo algo", "¿Qué te gustaría que hagamos juntos con las manos (cocinar, pintar…)?"],
  ["La última cosa que compraste", "La última cosa que compraste", "¿Cuál sería un regalo perfecto para el otro ahora?"],
  ["Tu reflejo en algún lugar", "Tu reflejo en algún lugar", "¿Qué te gusta de ti hoy?"],
  ["Algo que te recuerde a nuestra primera cita", "Algo que te recuerde a nuestra primera cita", "¿Qué pensaste de mí la primera vez?"],
  ["Algo con textura bonita", "Algo con textura bonita", "¿Qué detalle mío notas que nadie más nota?"],
  ["Tu momento más tranquilo del día", "Tu momento más ocupado del día", "¿Cómo te puedo apoyar esta semana?"],
  ["Una sombra interesante", "Una luz interesante", "¿Qué te da energía últimamente?"],
  ["Algo que quisieras que yo vea", "Algo que quisieras que yo vea", "¿Qué me quieres contar que no cabe en un mensaje?"],
  ["Un animal que veas hoy", "Un animal que veas hoy", "Si fuéramos animales, ¿cuáles seríamos?"],
  ["Tu outfit de hoy", "Tu outfit de hoy", "¿Qué nos ponemos para nuestra próxima salida?"],
  ["Algo que te dé nostalgia", "Algo que te dé nostalgia", "¿Qué recuerdo nuestro vuelves a ver en tu cabeza?"],
  ["Algo que te gustaría cambiar de tu día", "Algo que salió mejor de lo esperado", "¿Qué fue lo mejor y lo peor de tu semana?"],
  ["Tu lugar favorito para pensar en mí", "Tu lugar favorito para pensar en mí", "¿Qué es lo que más te gusta de nosotros?"]
]

PAIRS.each do |a, b, q|
  PromptPair.find_or_create_by!(prompt_a: a, prompt_b: b, conversation_question: q)
end

puts "✓ #{User.count} usuarios · #{PromptPair.count} pares de prompts"
