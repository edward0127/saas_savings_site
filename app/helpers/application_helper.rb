module ApplicationHelper
  def nav_link_class(path)
    base = "text-sm font-medium transition hover:text-cyan-700"
    active = "text-cyan-800"
    inactive = "text-slate-700"

    "#{base} #{current_page?(path) ? active : inactive}"
  end

  def inline_icon(name)
    icons = {
      coins: <<~SVG,
        <svg viewBox="0 0 24 24" fill="none" class="h-6 w-6" aria-hidden="true">
          <path d="M4 7.5c0 1.9 3.1 3.5 7 3.5s7-1.6 7-3.5-3.1-3.5-7-3.5-7 1.6-7 3.5Z" stroke="currentColor" stroke-width="1.6"/>
          <path d="M4 7.5v4.5c0 1.9 3.1 3.5 7 3.5s7-1.6 7-3.5V7.5" stroke="currentColor" stroke-width="1.6"/>
          <path d="M4 12v4.5c0 1.9 3.1 3.5 7 3.5s7-1.6 7-3.5V12" stroke="currentColor" stroke-width="1.6"/>
        </svg>
      SVG
      chart: <<~SVG,
        <svg viewBox="0 0 24 24" fill="none" class="h-6 w-6" aria-hidden="true">
          <path d="M4 19h16M7 16v-4m5 4V8m5 8v-6" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
        </svg>
      SVG
      workflow: <<~SVG,
        <svg viewBox="0 0 24 24" fill="none" class="h-6 w-6" aria-hidden="true">
          <rect x="3" y="4" width="7" height="6" rx="1.5" stroke="currentColor" stroke-width="1.6"/>
          <rect x="14" y="4" width="7" height="6" rx="1.5" stroke="currentColor" stroke-width="1.6"/>
          <rect x="8.5" y="14" width="7" height="6" rx="1.5" stroke="currentColor" stroke-width="1.6"/>
          <path d="M10 7h4m-2 3v4" stroke="currentColor" stroke-width="1.6" stroke-linecap="round"/>
        </svg>
      SVG
      shield: <<~SVG,
        <svg viewBox="0 0 24 24" fill="none" class="h-6 w-6" aria-hidden="true">
          <path d="M12 3l7 3v5c0 4.6-2.7 8.9-7 10-4.3-1.1-7-5.4-7-10V6l7-3Z" stroke="currentColor" stroke-width="1.6"/>
          <path d="m9.5 11.5 1.8 1.8 3.2-3.2" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
      SVG
      bolt: <<~SVG
        <svg viewBox="0 0 24 24" fill="none" class="h-6 w-6" aria-hidden="true">
          <path d="M13 2 5 13h6l-1 9 8-11h-6l1-9Z" stroke="currentColor" stroke-width="1.6" stroke-linejoin="round"/>
        </svg>
      SVG
    }

    icons.fetch(name).html_safe
  end
end
