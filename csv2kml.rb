#!/usr/bin/env ruby
# -*- coding: utf-8; -*-
require 'cgi'
require 'kconv'
require 'date'
require 'csv'
require 'pp'

$log_file = "./input.log"
$csv_dir = "./csv/"

# フォームデータ受け渡し（ファイル名）
cgi = CGI.new
value = cgi.params['file'][]

# 入力ファイル名
inputfilename = Kconv.toutf8( value.original_filename )

# 出力ファイル名
d = Date.today
outputfilename  = $csv_dir + d.strtime("%Y%m%d_%H%M%S") + ".csv"

# CSV出力(utf-8)
out_f = open(outputfilename, "w")
out_f.write( Kconv.toutf8( value.read ) )
out_f.close
print Kconv.toutf8( value.read )

# ログ出力

print "Content-Type: text/html\n\n"
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
print "<html><head>"
print "<meta http-equiv=\"Contetn-Type\" content=\"text/html\"; charset=UTF-8\" />"
print "</head><body>"
print "</body></html>"

