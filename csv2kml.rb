#!/usr/bin/env ruby
# -*- coding: utf-8; -*-
require 'cgi'
require 'kconv'
require 'csv'
require 'pp'

home_dir = "/home/shino/dev/csv2kml"
data_dir = home_dir+"/data"

# フォームデータ受け渡し（ファイル名）
cgi = CGI.new
value = cgi.params['file'][0]

# ログファイル名
logfilename = data_dir+"/input.log"

# 入力ファイル名
inputfilename = Kconv.toutf8( value.original_filename )
#inputfilename = value.original_filename

# csvファイル名
t = Time.now 
csvfilename  = data_dir + t.strftime("/%Y%m%d_%H%M%S.csv")

# kmlファイル名
kmlfilename  = data_dir + t.strftime("/%Y%m%d_%H%M%S.kml")

# csv保存(utf-8)
out_f = open( csvfilename, "w")
out_f.write( value.read  )
out_f.close

# csvファイル読み込み kmlファイル変換
CSV.foreach( csvfilename ){ |row|
	row = row.collect {|value|
		 Kconv.toutf8(value)
	}
}

# ログ出力
out_f = open( logfilename, "a")
out_f.write( t.strftime("[%Y/%m/%d %H:%M:%S]\n"))
out_f.write("in : "+inputfilename +"\n" )
out_f.write("csv: "+csvfilename +"\n" )
out_f.write("kml: "+kmlfilename +"\n" )
out_f.close

# Web画面出力
print "Content-Type: text/html\n\n"
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
print "<html><head>"
print "<meta http-equiv=\"Contetn-Type\" content=\"text/html\"; charset=UTF-8\" />"
print "</head><body>"
print inputfilename
CSV.foreach( csvfilename ){ |row|
	row = row.collect {|value|
		print Kconv.toutf8(value)
	}
}
print "</body></html>"

