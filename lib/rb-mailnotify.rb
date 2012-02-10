=begin
Copyright (c) 2012, Vincent Batts, Raleigh, NC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
=end

require 'find'
require 'logger'

require 'rubygems'
require 'libnotify'
require 'maildir'
require 'rb-inotify'

WAIT_TIME = 3.5         # 1.5 (s), 1000 (ms), "2", nil, false

@log = Logger.new(STDERR)
@log.level = Logger::INFO

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
  cur_mail = mdir.list(:cur)
  @log.debug(new_mail)
  @log.debug(cur_mail)

  yield(new_mail,cur_mail)

  @log.debug("nil out the vars, for good measure")
  mdir = new_mail = nil
end

# vim:set sw=2 sts=2 et:
