REBOL
[
	Title: "Tokyo Tyrant Driver"
	Date: 11-Dec-2009
	Version: 0.1.2
	File: %tokyo-tyrant-driver.r
	Home: http://github.com/moechofe/TokyoTyrant-protocol-for-Rebol
	Author: {martin mauchauffée}
	Rights: {Copyleft}
	Tabs: 2
	Needs: %tokyo-tyrant-protocol.r
	Usage: none
	Purpose: {This is a front-end to send command to a ToykyoTyrant server.}
	Comment: {This is more a sanbox than a fully effective program.}
	History: [
		0.1.2 [11-Dec-2009 {Support VSIZ, PUTKEEP and PUTCAT commands.}]
		0.1.1 [10-Dec-2009 {Support PUT and GET commands.}] ]
	Language: 'English
	Library: [
		level: 'intermediate
		platform: 'all
		type: [tool]
		domain: [protocol database]
		tested-under: [core 2.7.6.3.1 Windows XP]
		license: 'Copyleft
		see-also: [%tokyo-tyrant-protocol.r %tokyo-tyrant-test.r] ]
]

do %tokyo-tyrant-protocol.r

tokyo-tyrant-object: context
[
	server-url: tokyo://localhost:1978
	port: none

	set 'tokyo-tyrant func [ url [url!] /local object ]
	[ make tokyo-tyrant-object [ port: open server-url: url ] ]

	put: func [ "Put or keep a value identified by a key."
	key [word!] "The key."
	value "The value."
	/keep /k "Put a value only if the key isn't exists."
	/concat /cat /c "Concat a value with an existing key."
	/noerror /no-error /nr "Do not wait for a response from server, always return TRUE."
	/local data ] [
		data: system/words/copy reduce [ to-set-word key value ]
		either any [keep k]	[ insert data [attempt] ] ;PUTKEEP
		[ either any [concat cat c] [ insert data [append] ] ;PUTCAT
		[ if any [noerror no-error nr] [ insert data [noerror] ] ] ] ;PUTNR
		insert port data ]

	get: func [ "Get a value identified by a key."
	key [word!] "The key."
	/integer /int /i "Convert to integer."
	/raw /binary /b "Do not convert, return a binary value."
	/local value ] [
		insert port reduce [ to-get-word key ]
		if any [ integer int i ] [ return to-integer copy port ]
		if any [ raw binary b ] [ return copy port ]
		return any [
			attempt [ do mold to-string value: copy port ]
			to-integer value ] ]

	length?: func [ "Return the length of a value identified by a key."
	key [word!] "The key." ] [
		insert port reduce [ 'length? to-get-word key ]
		to-integer copy port ]
]
