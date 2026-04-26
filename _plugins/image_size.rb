# frozen_string_literal: true
# Liquid filter that returns ` width="W" height="H"` for a local image,
# or an empty string when the image is missing / unreadable.
# Use:  <img src="{{ p }}" alt="..." {{ p | image_dims }}>
#
# Implementation:
#   - Resolves both `/birusupi/foo.jpg` (with baseurl) and `/foo.jpg` to
#     a path under the repository root.
#   - Parses JPEG SOF, PNG IHDR, GIF logical screen, WebP VP8/VP8L/VP8X
#     to extract width/height without external dependencies.
#   - Cached by absolute path for the lifetime of the build.

require "jekyll"

module Birusupi
  module ImageSize
    CACHE = {}

    def image_dims(input)
      d = lookup(input)
      return "" unless d
      %Q[ width="#{d[0]}" height="#{d[1]}"]
    end

    def image_width(input)
      d = lookup(input)
      d ? d[0].to_s : ""
    end

    def image_height(input)
      d = lookup(input)
      d ? d[1].to_s : ""
    end

    private

    def lookup(input)
      return nil if input.nil? || input.to_s.empty?
      path = resolve_path(input.to_s)
      return nil unless path && File.file?(path)
      CACHE[path] ||= read_dims(path)
    end

    def resolve_path(src)
      site = @context.registers[:site]
      baseurl = (site.config["baseurl"] || "").to_s
      src = src.sub(/\?.*$/, "").sub(/#.*$/, "")
      # absolute URL → skip
      return nil if src =~ /^https?:\/\//
      # strip baseurl prefix if present
      src = src.sub(/^#{Regexp.escape(baseurl)}/, "") if !baseurl.empty?
      src = "/" + src unless src.start_with?("/")
      candidate = File.expand_path(File.join(site.source, src))
      root = File.expand_path(site.source)
      # containment check — must stay under site.source
      return nil unless candidate == root || candidate.start_with?(root + File::SEPARATOR)
      candidate
    end

    def read_dims(path)
      File.open(path, "rb") do |io|
        head = io.read(32) || ""
        return parse_png(io, head)  if head.start_with?("\x89PNG\r\n\x1A\n".b)
        return parse_gif(head)      if head.start_with?("GIF87a", "GIF89a")
        return parse_webp(io, head) if head[0, 4] == "RIFF" && head[8, 4] == "WEBP"
        return parse_jpeg(io, head) if head[0, 2] == "\xFF\xD8".b
      end
      nil
    rescue StandardError
      nil
    end

    def parse_png(_io, head)
      # IHDR starts at byte 16 (after 8 sig + 4 length + 4 type "IHDR")
      w = head[16, 4].unpack1("N")
      h = head[20, 4].unpack1("N")
      [w, h]
    end

    def parse_gif(head)
      w = head[6, 2].unpack1("v")
      h = head[8, 2].unpack1("v")
      [w, h]
    end

    def parse_webp(io, head)
      # need at least 30 bytes (we have 32 from head)
      buf = head
      buf += io.read(8).to_s if buf.length < 30
      return nil if buf.length < 30
      vp = buf[12, 4]
      case vp
      when "VP8 "
        # lossy: width/height at offsets 26..29, low 14 bits each
        w = buf[26, 2].unpack1("v") & 0x3FFF
        h = buf[28, 2].unpack1("v") & 0x3FFF
        [w, h]
      when "VP8L"
        # lossless: signature 0x2F at 20, then 28 bits packed dims-1
        b = buf.bytes
        return nil if b[20] != 0x2F
        w = ((b[21] | (b[22] << 8)) & 0x3FFF) + 1
        h = (((b[22] >> 6) | (b[23] << 2) | (b[24] << 10)) & 0x3FFF) + 1
        [w, h]
      when "VP8X"
        # extended: canvas w-1 at 24..26, h-1 at 27..29 (24-bit LE)
        b = buf.bytes
        w = (b[24] | (b[25] << 8) | (b[26] << 16)) + 1
        h = (b[27] | (b[28] << 8) | (b[29] << 16)) + 1
        [w, h]
      end
    end

    def parse_jpeg(io, head)
      # head already has 32 bytes; skip them - need to seek SOFn marker.
      io.seek(2) # past SOI
      loop do
        byte = io.read(1)
        return nil unless byte
        next if byte != "\xFF".b
        # consume any 0xFF padding
        marker = io.read(1)
        marker = io.read(1) while marker == "\xFF".b
        return nil unless marker
        m = marker.ord
        # SOFn (frame): 0xC0..0xCF except 0xC4, 0xC8, 0xCC
        if [0xC0, 0xC1, 0xC2, 0xC3, 0xC5, 0xC6, 0xC7, 0xC9, 0xCA, 0xCB, 0xCD, 0xCE, 0xCF].include?(m)
          io.read(3) # length(2) + precision(1)
          h = io.read(2).unpack1("n")
          w = io.read(2).unpack1("n")
          return [w, h]
        end
        # SOI/EOI etc – 0-length
        next if [0xD0, 0xD1, 0xD2, 0xD3, 0xD4, 0xD5, 0xD6, 0xD7, 0xD8, 0xD9, 0x01].include?(m)
        # otherwise read length and skip
        len = io.read(2)
        return nil unless len
        skip = len.unpack1("n") - 2
        return nil if skip < 0  # malformed segment
        io.seek(skip, IO::SEEK_CUR)
      end
    end
  end
end

Liquid::Template.register_filter(Birusupi::ImageSize)
