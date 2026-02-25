module ApplicationHelper
  def icon_asset_version
    @icon_asset_version ||= begin
      icon_path = Rails.root.join("public", "icon.svg")
      icon_path.exist? ? icon_path.mtime.to_i.to_s : "1"
    end
  end

  def nav_link_class(path)
    base = "text-sm font-medium transition hover:text-cyan-700"
    active = "text-cyan-800"
    inactive = "text-slate-700"

    "#{base} #{current_page?(path) ? active : inactive}"
  end

  def admin_nav_link_class(path)
    base = "admin-link"
    active = "admin-link-active"
    inactive = "admin-link-inactive"
    active_path = current_page?(path) || request.path.start_with?("#{path}/")

    "#{base} #{active_path ? active : inactive}"
  end

  def admin_inline_icon(name)
    icons = {
      leads: <<~SVG,
        <svg viewBox="0 0 24 24" class="h-4 w-4" fill="none" aria-hidden="true">
          <path d="M12 13.5a4.5 4.5 0 1 0 0-9 4.5 4.5 0 0 0 0 9Z" stroke="currentColor" stroke-width="1.8"/>
          <path d="M4 20a8 8 0 0 1 16 0" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
        </svg>
      SVG
      traffic: <<~SVG,
        <svg viewBox="0 0 24 24" class="h-4 w-4" fill="none" aria-hidden="true">
          <path d="M4 19h16M6 16v-3m4 3V9m4 7V6m4 10v-5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
        </svg>
      SVG
      seo: <<~SVG,
        <svg viewBox="0 0 24 24" class="h-4 w-4" fill="none" aria-hidden="true">
          <circle cx="11" cy="11" r="7" stroke="currentColor" stroke-width="1.8"/>
          <path d="m20 20-3.5-3.5" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"/>
        </svg>
      SVG
      settings: <<~SVG,
        <svg viewBox="0 0 24 24" class="h-4 w-4" fill="none" aria-hidden="true">
          <path d="M12 15.2a3.2 3.2 0 1 0 0-6.4 3.2 3.2 0 0 0 0 6.4Z" stroke="currentColor" stroke-width="1.8"/>
          <path d="M19.4 15.1a1 1 0 0 0 .2 1.1l.1.1a2 2 0 0 1-2.8 2.8l-.1-.1a1 1 0 0 0-1.1-.2 1 1 0 0 0-.6.9V20a2 2 0 0 1-4 0v-.1a1 1 0 0 0-.6-.9 1 1 0 0 0-1.1.2l-.1.1a2 2 0 1 1-2.8-2.8l.1-.1a1 1 0 0 0 .2-1.1 1 1 0 0 0-.9-.6H4a2 2 0 0 1 0-4h.1a1 1 0 0 0 .9-.6 1 1 0 0 0-.2-1.1l-.1-.1A2 2 0 1 1 7.5 4.8l.1.1a1 1 0 0 0 1.1.2 1 1 0 0 0 .6-.9V4a2 2 0 0 1 4 0v.1a1 1 0 0 0 .6.9 1 1 0 0 0 1.1-.2l.1-.1a2 2 0 1 1 2.8 2.8l-.1.1a1 1 0 0 0-.2 1.1 1 1 0 0 0 .9.6H20a2 2 0 0 1 0 4h-.1a1 1 0 0 0-.9.6Z" stroke="currentColor" stroke-width="1.5"/>
        </svg>
      SVG
      website: <<~SVG
        <svg viewBox="0 0 24 24" class="h-4 w-4" fill="none" aria-hidden="true">
          <rect x="3" y="4" width="18" height="16" rx="2.5" stroke="currentColor" stroke-width="1.8"/>
          <path d="M3 9h18" stroke="currentColor" stroke-width="1.8"/>
          <circle cx="7" cy="6.5" r="0.9" fill="currentColor"/>
          <circle cx="10" cy="6.5" r="0.9" fill="currentColor"/>
        </svg>
      SVG
    }

    icons.fetch(name).html_safe
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
