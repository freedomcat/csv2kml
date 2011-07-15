#!/usr/bin/env ruby
# -*- coding: utf-8; -*-
require 'cgi'
require 'kconv'
require 'csv'
require 'pp'
require "./getlatlng.rb"
require "./rexml.rb"

home_dir = "/home/shino/dev/csv2kml"
data_dir = home_dir+"/data"

# フォームデータ受け渡し（ファイル名）
cgi = CGI.new
value = cgi.params['file'][0]
# 入力ファイル名
inputfilename = Kconv.toutf8( value.original_filename )

# ログファイル名
logfilename = data_dir+"/input.log"

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
rowcnt = 0
kml=nil
description_header = Array.new #詳細ヘッダ

#データ
# CSV仕様
# 1列名 目印住所
# 2列目 目印タイトル
# 3列目からN列目 詳細
col_address = 0
col_title = 1
col_description = 2
CSV.foreach( csvfilename ){ |row|
	row = row.collect {|value| Kconv.toutf8(value) }

	if(rowcnt==0)then
		#ヘッダ
		# 詳細情報文言取得
		colcnt=0	
		row.each do |col|
			if( col_description <= colcnt ) then
				description_header << col
			end
			colcnt+=1
		end	
		
		# KML生成
		kml = KML.new
	else
		#データ
		# タイトル
		title = row[col_title]	

		# 詳細情報編集
		description="<dl>"
		colcnt=0
		row.each do |col|
			if( col_description <= colcnt )then
				description +="<dt>"+description_header[colcnt-col_description]+"</dt>"
				description +="<dd>"+col+"</dd>"
			end
			colcnt+=1
		end	
		description+="</dl>"

		# 緯度経度取得
		point = GoogleMapGeocode.new(row[col_address])	

		if( point.result ) then
			# 緯度経度取得　成功時
			# KML 目印情報
			kml.set(rowcnt, title, description, point.lat, point.lng)
		else 
			# 緯度経度取得　失敗時
			# なんかエラーを出す。あとで書く。
		end
	end
	rowcnt+=1
}
kml.write(kmlfilename)

# ログ出力
out_f = open( logfilename, "a")
out_f.write( t.strftime("[%Y/%m/%d %H:%M:%S]\n"))
out_f.write("in : "+inputfilename +"\n" )
out_f.write("csv: "+csvfilename +"\n" )
out_f.write("kml: "+kmlfilename +"\n" )
out_f.close

# Web画面出力
print "Content-Type: application/vnd.google-earth.kml+xml\n\n"
print kml.write

