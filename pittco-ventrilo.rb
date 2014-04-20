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

resolver = Resolv::DNS.new

result = resolver.getresource(RECORD, SRV)

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
