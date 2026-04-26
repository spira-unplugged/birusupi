# frozen_string_literal: true
# Post-render hook: inject width/height into <img> tags whose src points
# to a local asset, so the browser can reserve layout space (CLS = 0).
#
# - Skips <img> that already declare width or height.
# - Skips off-site sources (http(s)://).
# - Resolves URLs relative to baseurl when present.
# - Re-uses the parser from image_size.rb (loaded earlier).

require "jekyll"

require_relative "image_size"

module Birusupi
  class InjectImageDims
    class << self
      attr_accessor :site

      # Reuse the same cache as the image_dims Liquid filter — avoids
      # parsing the same image twice when it is referenced both in a
      # template (via `image_dims`) and in body HTML.
      def cache
        Birusupi::ImageSize::CACHE
      end

      def resolve_path(src)
        return nil if src.nil? || src.empty?
        return nil if src =~ /^(https?:|data:|mailto:|javascript:)/
        src = src.split("?", 2).first.split("#", 2).first
        baseurl = (site.config["baseurl"] || "").to_s
        src = src.sub(/^#{Regexp.escape(baseurl)}/, "") if !baseurl.empty?
        src = "/" + src unless src.start_with?("/")
        candidate = File.expand_path(File.join(site.source, src))
        root = File.expand_path(site.source)
        return nil unless candidate == root || candidate.start_with?(root + File::SEPARATOR)
        candidate
      end

      def read_dims(path)
        cache[path] ||= begin
          dims = nil
          File.open(path, "rb") do |io|
            head = io.read(32) || ""
            dims = if head.start_with?("\x89PNG\r\n\x1A\n".b)
                     [head[16, 4].unpack1("N"), head[20, 4].unpack1("N")]
                   elsif head.start_with?("GIF87a", "GIF89a")
                     [head[6, 2].unpack1("v"), head[8, 2].unpack1("v")]
                   elsif head[0, 4] == "RIFF" && head[8, 4] == "WEBP"
                     parse_webp(io, head)
                   elsif head[0, 2] == "\xFF\xD8".b
                     parse_jpeg(io)
                   end
          end
          dims
        rescue StandardError
          nil
        end
      end

      def parse_webp(io, head)
        buf = head
        buf += io.read(8).to_s if buf.length < 30
        return nil if buf.length < 30
        vp = buf[12, 4]
        case vp
        when "VP8 "
          [(buf[26, 2].unpack1("v") & 0x3FFF), (buf[28, 2].unpack1("v") & 0x3FFF)]
        when "VP8L"
          b = buf.bytes
          return nil if b[20] != 0x2F
          [(((b[21] | (b[22] << 8)) & 0x3FFF) + 1),
           ((((b[22] >> 6) | (b[23] << 2) | (b[24] << 10)) & 0x3FFF) + 1)]
        when "VP8X"
          b = buf.bytes
          [((b[24] | (b[25] << 8) | (b[26] << 16)) + 1),
           ((b[27] | (b[28] << 8) | (b[29] << 16)) + 1)]
        end
      end

      def parse_jpeg(io)
        io.seek(2)
        loop do
          byte = io.read(1)
          return nil unless byte
          next if byte != "\xFF".b
          marker = io.read(1)
          marker = io.read(1) while marker == "\xFF".b
          return nil unless marker
          m = marker.ord
          if [0xC0, 0xC1, 0xC2, 0xC3, 0xC5, 0xC6, 0xC7, 0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF].include?(m)
            io.read(3)
            h = io.read(2).unpack1("n")
            w = io.read(2).unpack1("n")
            return [w, h]
          end
          next if [0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0x01].include?(m)
          len = io.read(2)
          return nil unless len
          skip = len.unpack1("n") - 2
          return nil if skip < 0
          io.seek(skip, IO::SEEK_CUR)
        end
      end

      # Regex-based injection: avoids Nokogiri reformatting that strips
      # <!doctype>/<html>/<head> wrappers when parsing a full document.
      # quote-aware: allows `>` inside "..." or '...' attribute values
      IMG_TAG_RE = /<img\b(?:[^>"']|"[^"]*"|'[^']*')*?>/i.freeze
      ATTR_WIDTH_RE = /\s(?:width|height)\s*=/i.freeze
      SRC_RE = /\bsrc\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s>]+))/i.freeze

      def process(html)
        return html if html.nil? || !html.include?("<img")
        html.gsub(IMG_TAG_RE) do |tag|
          # already has width or height — leave alone
          next tag if tag =~ ATTR_WIDTH_RE
          # find src
          m = tag.match(SRC_RE)
          next tag unless m
          src = m[1] || m[2] || m[3]
          path = resolve_path(src)
          next tag unless path && File.file?(path)
          dims = read_dims(path)
          next tag unless dims
          # insert before closing > (handles both `>` and ` />`)
          tag.sub(/(\s*\/?>)\z/, %( width="#{dims[0]}" height="#{dims[1]}"\\1))
        end
      end
    end
  end
end

Jekyll::Hooks.register :site, :pre_render do |site|
  Birusupi::InjectImageDims.site = site
end

# Apply only to documents we care about (HTML).
Jekyll::Hooks.register [:posts, :pages, :documents], :post_render do |doc|
  next unless doc.output_ext == ".html"
  doc.output = Birusupi::InjectImageDims.process(doc.output)
end
