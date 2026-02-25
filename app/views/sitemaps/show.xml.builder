xml.instruct! :xml, version: "1.0", encoding: "UTF-8"
xml.urlset xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @paths.each do |path|
    xml.url do
      xml.loc "#{request.base_url}#{path}"
      xml.lastmod Date.current.iso8601
      xml.changefreq "weekly"
      xml.priority(path == root_path ? "1.0" : "0.7")
    end
  end
end
