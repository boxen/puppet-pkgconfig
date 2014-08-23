# Public: Install homebrew version of pkg-config that uses the correct pc_path for .pc file lookup
#
# Examples
#
#   include pkgconfig
class pkgconfig {
  if $::osfamily == 'Darwin' {
    package {
      'gettext': ;
      'pkg-config':
        require => Package['gettext'];
    }
  }
  elsif $::osfamily == 'Debian' {
    homebrew::formula { 'pkg-config':
      before => Package[ 'boxen/brews/pkg-config' ]
    }

    package { 'boxen/brews/pkg-config': }
  }
}