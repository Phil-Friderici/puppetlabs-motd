# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Message of the day' do
  context 'when static message from content' do
    pp = <<-PUPPETCODE
        class { motd:
          content => "Hello world!\n",
        }
    PUPPETCODE

    it 'manages the static content message', :aggregate_failures do
      idempotent_apply(pp)

      unless os[:family] == 'windows'
        expect(file('/etc/motd')).to be_file
        expect(file('/etc/motd')).to contain("Hello world!\n")
      end
    end
  end

  context 'when static message from template' do
    pp = <<-PUPPETCODE
        class { motd:
          template => "motd/spec.epp",
        }
    PUPPETCODE

    it 'manages the static template message', :aggregate_failures do
      idempotent_apply(pp)

      unless os[:family] == 'windows'
        expect(file('/etc/motd')).to be_file
        expect(file('/etc/motd')).to contain('Test Template for Rspec')
      end
    end
  end

  context 'when static message from content in /etc/issue' do
    pp = <<-PUPPETCODE
        class { motd:
          issue_content => "Hello world!\n",
          content       => "Hello world!\n",
        }
    PUPPETCODE

    it 'manages the static issue content message', :aggregate_failures do
      idempotent_apply(pp)

      unless os[:family] == 'windows'
        expect(file('/etc/issue')).to be_file
        expect(file('/etc/issue')).to contain("Hello world!\n")
      end
    end
  end

  context 'when static message from template in /etc/issue' do
    pp = <<-PUPPETCODE
        class { motd:
          issue_template => "motd/spec.epp",
          content        => "Hello world!\n",
        }
    PUPPETCODE

    it 'manages the static issue template message', :aggregate_failures do
      idempotent_apply(pp)

      unless os[:family] == 'windows'
        expect(file('/etc/issue')).to be_file
        expect(file('/etc/issue')).to contain('Test Template for Rspec')
      end
    end
  end

  context 'when static message from content in /etc/issue.net' do
    pp = <<-PUPPETCODE
        class { motd:
          issue_net_content => "Hello world!\n",
          content           => "Hello world!\n",
        }
    PUPPETCODE

    it 'manages the static issue.net content message', :aggregate_failures do
      idempotent_apply(pp)

      unless os[:family] == 'windows'
        expect(file('/etc/issue.net')).to be_file
        expect(file('/etc/issue.net')).to contain("Hello world!\n")
      end
    end
  end

  context 'when static message from template in /etc/issue.net' do
    pp = <<-PUPPETCODE
        class { motd:
          issue_net_template => "motd/spec.epp",
          content            => "Hello world!\n",
        }
    PUPPETCODE

    it 'manages the static issue.net template message', :aggregate_failures do
      idempotent_apply(pp)

      unless os[:family] == 'windows'
        expect(file('/etc/issue.net')).to be_file
        expect(file('/etc/issue.net')).to contain('Test Template for Rspec')
      end
    end
  end

  context 'when disable dynamic motd settings on Debian', if: os[:family] == 'debian' do
    pp = <<-PUPPETCODE
        class { motd:
          dynamic_motd => false,
          content      => "Hello world!\n",
        }
    PUPPETCODE

    it 'disables dynamic MOTD settings on Debian', :aggregate_failures do
      idempotent_apply(pp)

      unless os[:family] == 'windows'
        expect(file('/etc/motd')).to be_file
        expect(file('/etc/motd')).to contain("Hello world!\n")
      end
    end

    describe file('/etc/pam.d/sshd') do
      its(:content) { is_expected.not_to match %r{session    optional     pam_motd.so  motd=/run/motd.dynamic} }
    end
  end
end
