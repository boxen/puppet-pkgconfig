require 'formula'

class PkgConfig < Formula
  homepage 'http://pkgconfig.freedesktop.org'
  url 'http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz'
  mirror 'http://fossies.org/unix/privat/pkg-config-0.28.tar.gz'
  sha256 '6b6eb31c6ec4421174578652c7e141fdaae2dabad1021f420d8713206ac1f845'

  bottle do
    revision 2
    sha1 '809937fdb5faaa3170f0abfc810ff244207d8975' => :mavericks
    sha1 'a0cbbdbe64aa3ffe665f674d68db8fb6fb84f7df' => :mountain_lion
    sha1 '44ec3ac051189dcd1e782cb7175979812f018e97' => :lion
  end

  def install
    # if there already is a pkg-config installed (as there likely will be on linux), add that installation's pc-path to the end of this one's
    # two methods are attempted
    # first, common system level executable paths are checked
    system_pc_dir = ['/bin','/usr/bin','/sbin','/usr/sbin']
    pc_found = false
    system_pc_dir.each do |dirpath|
      execpath = File.join(dirpath, 'pkg-config')
      if File.exists?(execpath)
        pc_found = true
        break
      end
    end
    # second, if the above fails, 'which' is called to find the pkg-config execuatble 
    if not pc_found
      which_pc = %x{which pkg-config}.chomp
      if not which_pc.empty?
        pc_found = true
        execpath = which_pc
      end
    end
    pc_found ? system_pc_path = %x{pkg-config --variable pc_path pkg-config}.chomp.split(File::PATH_SEPARATOR) : system_pc_path = []
    pc_path = %W[
      #{HOMEBREW_PREFIX}/lib/pkgconfig
      #{HOMEBREW_PREFIX}/share/pkgconfig
      /usr/local/lib/pkgconfig
      /usr/lib/pkgconfig
      #{HOMEBREW_LIBRARY}/ENV/pkgconfig/#{MacOS.version}
    ] + system_pc_path
    pc_path = pc_path.uniq.join(File::PATH_SEPARATOR)

    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-host-tool",
                          "--with-internal-glib",
                          "--with-pc-path=#{pc_path}"
    system "make"
    system "make", "check"
    system "make", "install"
  end
end
