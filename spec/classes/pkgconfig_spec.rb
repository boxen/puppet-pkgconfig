require 'spec_helper'

describe 'pkgconfig' do
  
  context 'when running on Debian' do
    let(:facts) do
      default_test_facts.merge({
        :osfamily => 'Debian'
      })
    end
    
    it do
      with_constants :RUBY_PLATFORM => 'linux' do
        should contain_homebrew__formula('pkg-config').with({
          :before => 'Package[boxen/brews/pkg-config]',
        })
        should contain_package('boxen/brews/pkg-config')
      end
    end
  end
  
  context 'when running on Darwin' do
    let(:facts) do
      default_test_facts.merge({
        :osfamily => 'Darwin'
      })
    end

    it do
      with_constants :RUBY_PLATFORM => 'darwin' do
        should contain_package('gettext')
        should contain_package('pkg-config').with({
          :require => 'Package[gettext]',
        })
      end
    end
  end
  
end

def with_constants(constants, &block)
  constants.each do |constant, val|
    Object.const_set(constant, val)
  end

  block.call

  constants.each do |constant, val|
    Object.send(:remove_const, constant)
  end
end
