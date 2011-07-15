# -*- coding: utf-8; -*-
require 'rexml/document'
include REXML

class KML
	$doc = nil
	$document_element =nil

	#
	# name = KMLの名前
	# description = KMLの詳細
	#
	def initialize(name=nil,description=nil)
	
		$doc = Document.new
		
		# XML宣言
		$doc.add( XMLDecl.new(version="1.0", encoding="UTF-8") )
		
		# xml_root
		root_element = Element.new("kml")
		root_element.add_attribute("xmlns","http://earth.google.com/kml/2.2")
		$doc.add_element(root_element)
		
		#Document
		$document_element = Element.new("Document")
		root_element.add_element($document_element)
		
		#name
		if(name)then 
			name_element = Element.new("name").add_text(CData.new(name))
			$document_element.add_element(name_element)
		end
		
		#description
		if(description)then
			description_element = Element.new("description").add_text(CData.new( description ))
			$document_element.add_element(description_element)
		end
	end

	#
	#	id 目印のID(styleidに使用)
	#	name = "Placemarkの場所"
	#	description = "placemarkの詳細ほげほげ"
	#	lat = 緯度
	#	lng = 軽度
	#	icon = 目印のiconのurl
	#
	def set(id,name,description,lat,lng,icon=nil)
		coordinates = lng+","+lat+"0.000000"
		styleid = "style"+id.to_s
		if(!icon)then
			icon = "http://maps.gstatic.com/intl/ja_jp/mapfiles/ms/micons/blue-dot.png"
		end
		
		### Style
		
		#document//Style
		style_element = Element.new("Style")
		style_element.add_attribute("id", styleid)
		$document_element.add_element(style_element)
		
		##Style//IconStyle
		iconstyle_element = Element.new("IconStyle")
		style_element.add_element(iconstyle_element)
		
		##Style//IconStyle//Icon
		icon_element = Element.new("Icon")
		iconstyle_element.add_element(icon_element)
		
		##Style//IconStyle//Icon/href
		href_element = Element.new("href").add_text(icon)
		icon_element.add_element(href_element)
		
		### Placemark
		
		#Document//Placemark
		placemark_element = Element.new("Placemark")
		$document_element.add_element(placemark_element)
		
		#Placemark//name
		placemark_name_element = Element.new("name").add_text( name )
		placemark_element.add_element(placemark_name_element)
		
		#Placemark//description CData
		placemark_description_element = Element.new("description").add_text(CData.new(description))
		placemark_element.add_element(placemark_description_element)
		
		#Placemark//styleUrl
		placemark_styleurl_element = Element.new("styleUrl").add_text("#"+styleid)
		placemark_element.add_element(placemark_styleurl_element)

		#Placemark//Point
		placemark_point_element = Element.new("Point")
		placemark_element.add_element(placemark_point_element)
		
		#Placemark//Point//coordinates
		placemark_point_coordinates_element = Element.new("coordinates").add_text(coordinates)
		placemark_point_element.add_element(placemark_point_coordinates_element)
	end

	def write(filename=nil)
		if(filename)then
			$doc.write( File.new(filename , "w") )
		else
			$doc.write STDOUT
		end
	end

end

#kml = KML.new("","最終更新：2011/07/15")
#kml.set(1,"フランス","ほげほげげ","46.2276380","2.2137490")
#kml.set(1,"東京大学","ほげほげげ","35.7134285","139.7623078")
#kml.write("./kml/rexml.kml")
#kml.write
