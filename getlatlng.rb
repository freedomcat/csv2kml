# -*- coding: utf-8; -*-
require 'open-uri'
require 'kconv'
require 'cgi'
require 'rexml/document'
include REXML

class GoogleMapGeocode
	RequestUrl = "http://maps.google.com/maps/api/geocode/xml?output=xml&sensor=false&address="

	attr_reader :lat
	attr_reader :lng
	attr_reader :result

	def initialize( address )
		@url = RequestUrl + CGI.escape(Kconv.toutf8(address))
		doc = Document.new(open(@url))
		if doc.elements["/GeocodeResponse/status"].text != "OK"
			@result = false
			return
		end
		@lat = doc.elements["/GeocodeResponse/result/geometry/location/lat"].text
		@lng = doc.elements["/GeocodeResponse/result/geometry/location/lng"].text
		@result = true
	end
end

#point = GoogleMapGeocode.new("フランス")
#print point.lat + "\n"
#print point.lng + "\n"

