
require 'find'
require 'logger'

require 'rubygems'
require 'libnotify'
require 'maildir'
require 'rb-inotify'

WAIT_TIME = 3.5         # 1.5 (s), 1000 (ms), "2", nil, false

@log = Logger.new(STDERR)
@log.level = Logger::DEBUG

def notify_new_mail(box, num)
  @log.debug("prepping to notify on #{box} email box, for #{num} emails")
  n = Libnotify.new do |notify|
    notify.summary    = "in %s: " % box
    notify.body       = "%d unread email" % num
    notify.timeout    = WAIT_TIME
    notify.urgency    = :low   # :low, :normal, :critical
    notify.append     = false       # default true - append onto existing notification
    notify.transient  = false        # default false - keep the notifications around after display
    notify.icon_path  = "/usr/share/icons/gnome/scalable/status/mail-unread-symbolic.svg"
  end
  @log.debug("libnotify show!")
  n.show!

  @log.debug("sleep for #{WAIT_TIME + 0.1}")
  Kernel.sleep WAIT_TIME + 0.1
  @log.debug("libnotify close")
  n.close
end

def find_maildirs(base_path)
  dirs = []
  @log.debug("searching for maildirs")
  Find.find(base_path) do |path|
    if FileTest.directory?(path) && File.basename(path) == 'new'
      dir = File.dirname(path)
      dirs << dir
      @log.debug("adding directory #{dir}")
    end
  end
  @log.debug("returning #{dirs.length} dirs")
  return dirs
end

def check_maildir(path, &block)
  @log.debug("setup maildir for path #{path}")

  mdir = Maildir.new(path, false) 
  @log.debug(mdir)

  new_mail = mdir.list(:new)
  @log.debug(new_mail)

  yield(new_mail)

  @log.debug("nil out the vars, for good measure")
  mdir = new_mail = nil
end

# vim:set sw=2 sts=2 et:
