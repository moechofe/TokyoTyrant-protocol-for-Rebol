REBOL
[
	Title: "Tokyo Tyrant Protocol/Driver test"
	Date: 11-Dec-2009
	Version: 0.1.4
	File: %tokyo-tyrant-test.r
	Home: http://github.com/moechofe/TokyoTyrant-protocol-for-Rebol
	Author: {martin mauchauffée}
	Rights: {Copyleft}
	Tabs: 2
	Needs: [%tokyo-tyrant-protocol.r %tokyo-tyrant-driver.r]
	Usage: none
	Purpose: {This is a script to test the implementation of the ToykyoTyrant protocol via the TykyoTyrant driver.}
	Comment: {This is more a sanbox than a fully effective program.}
	History: [
		0.1.4 [11-Dec-2009 {Add test for VSIZ.}]
		0.1.3 [10-Dec-2009 {Add test for PUT and GET integer!, string!, binary!.}] ]
	Language: 'English
	Library: [
		level: 'intermediate
		platform: 'all
		type: [tool]
		domain: [protocol database]
		tested-under: [core 2.7.6.3.1 Windows XP]
		license: 'Copyleft
		see-also: [%tokyo-tyrant-driver.r %tokyo-tyrant-protocol.r] ]
]

do %tokyo-tyrant-driver.r
trace/net off
trace/net on

t: tokyo-tyrant tokyo://moechofe.info:1978

; Launching the server :
; on-memory hash database = ttserver *
; on-memory tree database = ttserver +
; hash database = ttserver <path/file>.tcf
; B+ tree database = ttserver <path/file>.tcb
; fixed-length database = ttserver <path/file>.tcf
; table database = ttserver <path/file>.tct

prin "PUT/GET (integer!) = " t/put 'a tmp: 255 print mold equal? tmp t/get/i 'a
prin "PUT/GET (string!) = " t/put 'a tmp: copy "Ceci est une phrase" print mold equal? tmp t/get 'a
prin "PUT/GET (binary!) = " t/put 'a tmp: copy to-binary reduce [ random 255 random 255 ] print mold equal? tmp t/get/b 'a
prin "PUT/VSIZ (string!) = " t/put 'a tmp: copy "123" print mold equal? t/length? 'a length? tmp
prin "PUTKEEP (integer!) = " t/put/keep 'a 61

halt
