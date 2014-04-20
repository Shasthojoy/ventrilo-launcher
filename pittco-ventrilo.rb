#!/usr/bin/env ruby

require 'resolv'
require 'uri'
require 'logger'

VENTRILO_TYPE = "_ventrilo._udp"
VENTRILO_URL = "ventrilo://%{hostname}:%{port}/servername=%{servername}"
PITTCO_DOMAIN = "pittco.org"
PITTCO_SERVERNAME = "Pittco, provided by CST"
RECORD = [VENTRILO_TYPE, PITTCO_DOMAIN].join(".")
SRV = Resolv::DNS::Resource::IN::SRV
LOGGER = Logger.new STDOUT


def display_error_and_exit error
  require 'java'
  message = ["<html>Unable to resolve the Pittco Ventrilo server address :-(",
             "You can always try <b>ventrilo.pittco.org</b> on the default port, but it may not work.",
             "",
             "#{error.message} (#{error.class})</html>"].join("<br/>")
  title = "Cannot find Pittco Ventrilo"
  javax.swing.JOptionPane.show_message_dialog(nil, message, title,
                                              javax.swing.JOptionPane::ERROR_MESSAGE)
  exit 1
end

resolver = Resolv::DNS.new

begin
  result = resolver.getresource(RECORD, SRV)
rescue Resolv::ResolvError => e
  display_error_and_exit e
end

LOGGER.info result

url =  VENTRILO_URL % {hostname: result.target, port: result.port, servername: URI.encode(PITTCO_SERVERNAME)}

LOGGER.info url

if RbConfig::CONFIG['host_os'] =~ /mswin|mingw|cygwin/
  system "start #{url}"
elsif RbConfig::CONFIG['host_os'] =~ /darwin/
  system "open #{url}"
elsif RbConfig::CONFIG['host_os'] =~ /linux|bsd/
  system "xdg-open #{url}"
end
