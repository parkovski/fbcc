#include once "cc.bi"
namespace crt
#include once "crt.bi"
end namespace

#ifdef __FB_DEBUG__
#define dprt(x) print x
#else
#define dprt(x)
#End If

dprt(1)

'' load tiles
dim shared as any ptr floor, elvis, eater, wall, bluekey, greenkey, redkey, _
	yellowkey, blackkey, whitekey, purplekey, tealkey, orangekey, greykey, _
	bluedoor, greendoor, reddoor, yellowdoor, blackdoor, whitedoor, purpledoor, _
	tealdoor, orangedoor, greydoor, icetl, icetr, icebl, icebr, _
	ice, redfloor, redwall, dirtblock, dirt, leftwall, rightwall, topwall, _
	bottomwall, invisiblewall, appearingwall, greenbutton, bluebutton, _
	greenwall, greenfloor, bluewall, bluefloor, redbutton, yellowbutton, _
	brownbutton, teleport, finish, note, trumpet, chord, guitar, hint, _
	fire, water, fireboot, waterboot, iceboot, forceboot, thief, _
	forceleft, forceright, forceup, forcedown, forcerandom, bomb, _
	trap, flameon, gravel, eyeballboss, steak, tooth, weldingmachine, _
	capeguy, weldingmask, popupwall, cover, _
	tools, timetool, noteamt, chordamt, trapconnect, cloneup, noclone, _
	clonedown, cloneleft, cloneright, password, sethint, setname, _
	dlgsettime, dlgsetnotes, dlgsetchords, dlgsetpswd, dlgsetname, dlgsethint, _
	dlgnewlevel, dlgsave, dlgopen
dim shared as integer xoffset = 0, yoffset = 0
dim shared as integer tileset = 0
dim shared tile as any ptr, rttile as any ptr
dim shared tiles as any ptr ptr ptr
redim shared gameboard(0 to 29, 0 to 29) as any ptr
redim shared attribs(0 to 29, 0 to 29) as uinteger
Shared lvtime As Integer = 0
Shared reqdnotes As Integer = 0
Shared reqdchords As Integer = 0
Shared lvname As String
Shared lvpass As String
Shared lvhint As String

lvname = "LEVEL 1"
lvpass = "0000"
lvhint = ""

dprt(2)

#include once "loadtiles.bi"

dprt(3)

'' initialize tiles
tiles = allocate(sizeof(any ptr ptr) * 8)

dprt(4)

tiles[0] = allocate(sizeof(any ptr) * (13 + 1))
tiles[0][0] = floor
tiles[0][1] = wall
tiles[0][2] = redfloor
tiles[0][3] = redwall
tiles[0][4] = dirtblock
tiles[0][5] = dirt
tiles[0][6] = leftwall
tiles[0][7] = rightwall
tiles[0][8] = topwall
tiles[0][9] = bottomwall
tiles[0][10] = invisiblewall
tiles[0][11] = appearingwall
tiles[0][12] = popupwall
tiles[0][13] = 0

dprt(5)

tiles[1] = allocate(sizeof(any ptr) * (6 + 1))
tiles[1][0] = eater
tiles[1][1] = eyeballboss
tiles[1][2] = steak
tiles[1][3] = tooth
tiles[1][4] = weldingmachine
tiles[1][5] = capeguy
tiles[1][6] = 0

dprt(6)

tiles[2] = allocate(sizeof(any ptr) * (20 + 1))
tiles[2][0] = bluekey
tiles[2][1] = greenkey
tiles[2][2] = redkey
tiles[2][3] = yellowkey
tiles[2][4] = blackkey
tiles[2][5] = whitekey
tiles[2][6] = purplekey
tiles[2][7] = tealkey
tiles[2][8] = orangekey
tiles[2][9] = greykey
tiles[2][10] = bluedoor
tiles[2][11] = greendoor
tiles[2][12] = reddoor
tiles[2][13] = yellowdoor
tiles[2][14] = blackdoor
tiles[2][15] = whitedoor
tiles[2][16] = purpledoor
tiles[2][17] = tealdoor
tiles[2][18] = orangedoor
tiles[2][19] = greydoor
tiles[2][20] = 0

dprt(7)

tiles[3] = allocate(sizeof(any ptr) * (16 + 1))
tiles[3][0] = ice
tiles[3][1] = icetl
tiles[3][2] = icetr
tiles[3][3] = icebl
tiles[3][4] = icebr
tiles[3][5] = forceleft
tiles[3][6] = forceright
tiles[3][7] = forceup
tiles[3][8] = forcedown
tiles[3][9] = forcerandom
tiles[3][10] = fire
tiles[3][11] = water
tiles[3][12] = bomb
tiles[3][13] = teleport
tiles[3][14] = flameon
tiles[3][15] = gravel
tiles[3][16] = 0

dprt(8)

tiles[4] = allocate(sizeof(any ptr) * (10 + 1))
tiles[4][0] = greenbutton
tiles[4][1] = bluebutton
tiles[4][2] = greenwall
tiles[4][3] = greenfloor
tiles[4][4] = bluewall
tiles[4][5] = bluefloor
tiles[4][6] = redbutton
tiles[4][7] = yellowbutton
tiles[4][8] = brownbutton
tiles[4][9] = trap
tiles[4][10] = 0

dprt(9)

tiles[5] = allocate(sizeof(any ptr) * (7 + 1))
tiles[5][0] = elvis
tiles[5][1] = finish
tiles[5][2] = note
tiles[5][3] = trumpet
tiles[5][4] = chord
tiles[5][5] = guitar
tiles[5][6] = hint
tiles[5][7] = 0

dprt(10)

tiles[6] = allocate(sizeof(any ptr) * (6 + 1))
tiles[6][0] = fireboot
tiles[6][1] = waterboot
tiles[6][2] = iceboot
tiles[6][3] = forceboot
tiles[6][4] = weldingmask
tiles[6][5] = thief
tiles[6][6] = 0

dprt(11)

tiles[7] = allocate(sizeof(any ptr) * (12 + 1))
tiles[7][0] = trapconnect
tiles[7][1] = timetool
tiles[7][2] = noteamt
tiles[7][3] = chordamt
tiles[7][4] = password
tiles[7][5] = sethint
tiles[7][6] = setname
tiles[7][7] = cloneleft
tiles[7][8] = cloneright
tiles[7][9] = cloneup
tiles[7][10] = clonedown
tiles[7][11] = noclone
tiles[7][12] = 0

dprt(12)

tile = wall
rttile = floor

for i as integer = 0 to 29
	for j as integer = 0 to 29
		gameboard(i, j) = floor
	next
next

screenres 800, 600, 32
windowtitle "Chunk's Challenge Level Editor"

sub DrawPalette
	for i as integer = 0 to 7
		put (40 * i + 20, 50), floor, pset
	next
	
	put (20, 50), wall, alpha, rgb(255, 0, 255)
	put (60, 50), eater, alpha, rgb(255, 0, 255)
	put (100, 50), bluekey, alpha, rgb(255, 0, 255)
	put (140, 50), ice, alpha, rgb(255, 0, 255)
	put (180, 50), bluebutton, alpha, rgb(255, 0, 255)
	put (220, 50), elvis, alpha, rgb(255, 0, 255)
	put (260, 50), fireboot, alpha, rgb(255, 0, 255)
	put (300, 50), tools, alpha, rgb(255, 0, 255)
	
	dim tileno as integer = 0
	for i as integer = 0 to 2
		for j as integer = 0 to 7
			put (40 * j + 20, 40 * i + 130), floor, alpha, rgb(255, 0, 255)
			if tiles[tileset][tileno] <> 0 then
				put (40 * j + 20, 40 * i + 130), tiles[tileset][tileno], alpha, rgb(255, 0, 255)
				tileno += 1
			end if
		next
	next
	
	put (240+20, 240+50), floor, pset
	put (280+20, 240+50), floor, pset
	
	put (240+20, 240+50), tile, alpha, rgb(255, 0, 255)
	put (280+20, 240+50), rttile, alpha, rgb(255, 0, 255)
	
	draw string (20, 300), "Name: """ + lvname + """", rgb(255, 255, 255)
	if lvtime <> 0 then _
		draw string (20, 315), "Time: " + str(lvtime), rgb(255, 255, 255) _
	else _
		draw string (20, 315), "Time: ---", rgb(255, 255, 255)
	
	line (20, 10) - (90, 30), rgb(255, 255, 255), B
	draw string (45, 17), "New", rgb(255, 255, 255)
	
	line (100, 10) - (170, 30), rgb(255, 255, 255), B
	draw string (120, 17), "Save", rgb(255, 255, 255)
	
	line (180, 10) - (250, 30), rgb(255, 255, 255), B
	draw string (200, 17), "Open", rgb(255, 255, 255)
	
	line (260, 10) - (330, 30), rgb(255, 255, 255), B
	draw string (280, 17), "Quit", rgb(255, 255, 255)
end sub

sub DrawStage(byval grey as integer = 0)
	for i as integer = 0 to 9
		for j as integer = 0 to 9
			put (40 * i + 380, 40 * j + 50), floor, pset
			put (40 * i + 380, 40 * j + 50), gameboard(i + xoffset, j + yoffset), alpha, rgb(255, 0, 255)
			dim attr as uinteger = attribs(i + xoffset, j + yoffset)
			if attr and attrib_clone_left then
				put (40 * i + 380, 40 * j + 50), cloneleft, alpha, rgb(255, 0, 255)
			elseif attr and attrib_clone_right then
				put (40 * i + 380, 40 * j + 50), cloneright, alpha, rgb(255, 0, 255)
			elseif attr and attrib_clone_up then
				put (40 * i + 380, 40 * j + 50), cloneup, alpha, rgb(255, 0, 255)
			elseif attr and attrib_clone_down then
				put (40 * i + 380, 40 * j + 50), clonedown, alpha, rgb(255, 0, 255)
			end if
			if grey <> 0 then put (40 * i + 380, 40 * j + 50), cover, alpha, rgb(255, 0, 255)
		next
	next
	
	'' draw the scroll bars
	line (780, 50) - (799, 449), rgb(100, 100, 150), BF
	line (780, 50) - (799, 69), rgb(150, 150, 200), BF
	line (780, 430) - (799, 449), rgb(150, 150, 200), BF
	
	line (380, 450) - (779, 469), rgb(100, 100, 150), BF
	line (380, 450) - (399, 469), rgb(150, 150, 200), BF
	line (760, 450) - (779, 469), rgb(150, 150, 200), BF
	
	line (780, 450) - (799, 469), rgb(200, 200, 200), BF
end sub

sub ConnectTraps

	dim switch as integer = 0
	dim as integer firstx, firsty
	do
		screenlock
		
		cls
		DrawPalette
		DrawStage
		
		for i as integer = 0 to 9
			for j as integer = 0 to 9
				if switch = 0 then
					if gameboard(i + xoffset, j + yoffset) <> brownbutton and _
						gameboard(i + xoffset, j + yoffset) <> redbutton then
						put (40 * i + 380, 40 * j + 50), cover, alpha, rgb(255, 0, 255)
					end if
				elseif switch = 1 then
					if gameboard(i + xoffset, j + yoffset) <> trap then
						put (40 * i + 380, 40 * j + 50), cover, alpha, rgb(255, 0, 255)
					end if
				elseif switch = 2 then
					if (attribs(i + xoffset, j + yoffset) and &b1111) = 0 then
						put (40 * i + 380, 40 * j + 50), cover, alpha, rgb(255, 0, 255)
					end if
				end if
			next
		next
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 380 and mx <= 779 and my >= 50 and my <= 449 then
					if e.button = 1 then
						if switch = 0 then
							if gameboard((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) = brownbutton then
								firstx = (mx - 380) \ 40 + xoffset
								firsty = (my - 50) \ 40 + yoffset
								switch = 1
							elseif gameboard((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) = redbutton then
								firstx = (mx - 380) \ 40 + xoffset
								firsty = (my - 50) \ 40 + yoffset
								switch = 2
							end if
						elseif switch = 1 then
							if gameboard((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) = trap then
								attribs(firstx, firsty) or= ((((mx - 380) \ 40 + xoffset) shl 8) or _
									((my - 50) \ 40 + yoffset)) shl 16
								attribs((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) or= _
									((firstx shl 8) or firsty) shl 16
								return
							end if
						elseif switch = 2 then
							if (attribs((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) and &b1111) <> 0 then
								attribs(firstx, firsty) or= ((((mx - 380) \ 40 + xoffset) shl 8) or _
									((my - 50) \ 40 + yoffset)) shl 16
								attribs((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) or= _
									((firstx shl 8) or firsty) shl 16
								return
							end if
						end if
					else
						return
					end if
				end if
			end if
		end if
		
		screenunlock
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub CheckClone(byval x as integer, byval y as integer)
	dim as any ptr img = gameboard(x, y)
	
	if (attribs(x, y) shr 16) <> 0 then
		attribs(attribs(x, y) shr 24, (attribs(x, y) shr 16) and &hFF) and= &hFFFF
		attribs(x, y) and= &hFFFF
	end if
	
	if attribs(x, y) and &b1111 = 0 then return
	
	if img <> eater and img <> eyeballboss and img <> steak and img <> tooth and img <> capeguy _
		and img <> weldingmachine and img <> dirtblock then
		attribs(x, y) and= &hFFFFFFF0
	end if
end sub

sub SetClone(byval number as integer)
	do
		screenlock
		
		cls
		DrawPalette
		DrawStage
		
		for i as integer = 0 to 9
			for j as integer = 0 to 9
				dim img as any ptr = gameboard(i + xoffset, j + yoffset)
				if img <> eater and img <> eyeballboss and img <> steak and img <> tooth and img <> capeguy _
					and img <> weldingmachine and img <> dirtblock then
					put (i * 40 + 380, j * 40 + 50), cover, alpha, rgb(255, 0, 255)
				end if
			next
		next
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 380 and mx <= 779 and my >= 50 and my <= 449 then
					if e.button = 1 then
						attribs((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) or= 1 shl (number - 1)
						CheckClone((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset)
					end if
					return
				end if
			end if
		end if
		
		screenunlock
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub SetLevelTime()
	dim nr as integer = lvtime
	
	do
	
		screenlock
		
		cls
		DrawPalette
		DrawStage
		
		for i as integer = 0 to 800\40-1
			for j as integer = 0 to 600\40-1
				put (i * 40, j * 40), cover, alpha, rgb(255, 0, 255)
			next
		next
		
		put (225, 100), dlgsettime, pset
		
		if nr = 0 then _
			draw string (160 + 225, 60 + 100), "---", 0 _
		else _
			draw string (160 + 225, 60 + 100), str(nr), 0
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					lvtime = nr
					exit do
				elseif mx >= 80+225 and mx <= 166+225 and my >= 103+100 and my <= 128+100 then
					nr = lvtime
				elseif mx >= 175+225 and mx <= 261+225 and my >= 103+100 and my <= 128+100 then
					nr = 0
				end if
			elseif e.type = FB.EVENT_KEY_PRESS then
				if e.ascii >= asc("0") and e.ascii <= asc("9") then
					if nr <= 99 then
						nr = (nr * 10) + (e.ascii - asc("0"))
					end if
				end if
			end if
		end if
		
		screenunlock
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub SetNoteAmt(byval ischord as integer = 0)
	dim nr as integer = iif(ischord = 0, reqdnotes, reqdchords)

	do
	
		screenlock
		
		cls
		DrawPalette
		DrawStage
		
		for i as integer = 0 to 800\40-1
			for j as integer = 0 to 600\40-1
				put (i * 40, j * 40), cover, alpha, rgb(255, 0, 255)
			next
		next
		
		if ischord then _
			put (225, 100), dlgsetchords, pset _
		else _
			put (225, 100), dlgsetnotes, pset
		
		draw string (160 + 225, 60 + 100), str(nr), 0
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					if ischord = 0 then reqdnotes = nr else reqdchords = nr
					exit do
				elseif mx >= 36+225 and mx <= 122+225 and my >= 104+100 and my <= 129+100 then
					nr = iif(ischord = 0, reqdnotes, reqdchords)
				elseif mx >= 130+225 and mx <= 216+225 and my >= 104+100 and my <= 129+100 then
					nr = 0
				elseif mx >= 224+225 and mx <= 310+225 and my >= 104+100 and my <= 129+100 then
					'' count all the notes/chords
					nr = 0
					for i as integer = 0 to ubound(gameboard, 1)
						for j as integer = 0 to ubound(gameboard, 2)
							if ischord = 0 and gameboard(i, j) = note then nr += 1
							if ischord <> 0 and gameboard(i, j) = chord then nr += 1
						next
					next
				end if
			elseif e.type = FB.EVENT_KEY_PRESS then
				if e.ascii >= asc("0") and e.ascii <= asc("9") then
					if nr <= 99 then
						nr = (nr * 10) + (e.ascii - asc("0"))
					end if
				end if
			end if
		end if
		
		screenunlock
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub SetPassword()
	dim pswd as string = lvpass

	do
	
		screenlock
		
		cls
		DrawPalette
		DrawStage
		
		for i as integer = 0 to 800\40-1
			for j as integer = 0 to 600\40-1
				put (i * 40, j * 40), cover, alpha, rgb(255, 0, 255)
			next
		next
		
		put (225, 100), dlgsetpswd, pset
		
		draw string (90+225, 80+100), pswd, 0
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					lvpass = pswd
					exit do
				elseif mx >= 67+225 and mx <= 153+225 and my >= 165+100 and my <= 190+100 then
					pswd = ""
				end if
			elseif e.type = FB.EVENT_KEY_PRESS then
				if (e.ascii >= asc("A") and e.ascii <= asc("Z")) or _
					(e.ascii >= asc("a") and e.ascii <= asc("z")) or _
					(e.ascii >= asc("0") and e.ascii <= asc("9")) then
					if len(pswd) < 10 then pswd += ucase(chr(e.ascii))
				end if
			end if
		end if
		
		screenunlock
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub SetLevelName()
	dim nm as string = lvname

	do
	
		screenlock
		
		cls
		DrawPalette
		DrawStage
		
		for i as integer = 0 to 800\40-1
			for j as integer = 0 to 600\40-1
				put (i * 40, j * 40), cover, alpha, rgb(255, 0, 255)
			next
		next
		
		put (225, 100), dlgsetname, pset
		
		draw string (90+225, 80+100), nm, 0
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					lvname = nm
					exit do
				elseif mx >= 67+225 and mx <= 153+225 and my >= 165+100 and my <= 190+100 then
					nm = ""
				end if
			elseif e.type = FB.EVENT_KEY_PRESS then
				if (e.ascii >= asc("A") and e.ascii <= asc("Z")) or _
					(e.ascii >= asc("a") and e.ascii <= asc("z")) or _
					(e.ascii >= asc("0") and e.ascii <= asc("9")) or _
					e.ascii = asc(" ") or e.ascii = asc("-") then
					if len(nm) < 19 then nm += chr(e.ascii)
				end if
			end if
		end if
		
		screenunlock
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub SetLevelHint()
	dim hint as string = lvhint
	
	do
	
		screenlock
		
		cls
		DrawPalette
		DrawStage
		
		for i as integer = 0 to 800\40-1
			for j as integer = 0 to 600\40-1
				put (i * 40, j * 40), cover, alpha, rgb(255, 0, 255)
			next
		next
		
		put (225, 100), dlgsethint, pset
		
		draw string (97+225, 44+100), hint, 0
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					lvhint = hint
					exit do
				elseif mx >= 67+225 and mx <= 153+225 and my >= 165+100 and my <= 190+100 then
					hint = ""
				end if
			elseif e.type = FB.EVENT_KEY_PRESS then
				if (e.ascii >= asc("A") and e.ascii <= asc("Z")) or _
					(e.ascii >= asc("a") and e.ascii <= asc("z")) or _
					(e.ascii >= asc("0") and e.ascii <= asc("9")) or _
					e.ascii = asc(" ") or e.ascii = asc("-") or _
					e.ascii = asc(".") or e.ascii = asc(",") or _
					e.ascii = asc("?") or e.ascii = asc("!") then
					if len(hint) < 100 then hint += chr(e.ascii)
				elseif e.ascii = 8 then
					hint = left(hint, len(hint) - 1)
				end if
			end if
		end if
		
		screenunlock
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub NewLevel()
	dim activebox as integer = 0
	dim d1 as integer = 30, d2 as integer = 30
	do
		screenlock
		
		cls
		
		put (225, 100), dlgnewlevel, pset
		
		if activebox = 0 then _
			line (115+225, 95+100) - (160+225, 130+100), rgb(192, 192, 192), BF _
		else _
			line (60+225, 95+100) - (100+225, 130+100), rgb(192, 192, 192), BF
		
		draw string (65+225, 70+100), str(d1), 0
		draw string (119+225, 70+100), str(d2), 0
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					if d1 < 10 or d2 < 10 then
						d1 = 10
						d2 = 10
						continue do
					end if
					redim gameboard(0 to d1-1, 0 to d2-1) as any ptr
					for i as integer = 0 to d1-1
						for j as integer = 0 to d2-1
							gameboard(i, j) = floor
						next
					next
					redim attribs(0 to d1-1, 0 to d2-1) as uinteger
					xoffset = 0
					yoffset = 0
					exit do
				elseif mx >= 67+225 and mx <= 153+225 and my >= 165+100 and my <= 190+100 then
					d1 = 30
					d2 = 30
				elseif mx >= 61+225 and mx <= 103+225 and my >= 60+100 and my <= 89+100 then
					activebox = 0
				elseif mx >= 115+225 and mx <= 157+225 and my >= 60+100 and my <= 89+100 then
					activebox = 1
				end if
			elseif e.type = FB.EVENT_KEY_PRESS then
				if e.ascii >= asc("0") and e.ascii <= asc("9") then
					if activebox = 0 then
						if d1 < 10 then d1 = d1 * 10 + e.ascii - asc("0")
					else
						if d2 < 10 then d2 = d2 * 10 + e.ascii - asc("0")
					end if
				elseif e.ascii = 8 then
					if activebox = 0 then d1 \= 10 else d2 \= 10
				end if
			end if
		end if
		
		screenunlock
	loop
end sub

#macro assoc(id,img)
	case img
		return id
#endmacro

function IdFromImg(byval img as any ptr) as integer
	select case img
	assoc(tfloor,floor)
	assoc(twall,wall)
	assoc(tredfloor,redfloor)
	assoc(tredwall,redwall)
	assoc(tdirtblock,dirtblock)
	assoc(tdirt,dirt)
	assoc(tleftwall,leftwall)
	assoc(trightwall,rightwall)
	assoc(ttopwall,topwall)
	assoc(tbottomwall,bottomwall)
	assoc(tinvisiblewall,invisiblewall)
	assoc(tappearingwall,appearingwall)
	assoc(tpopupwall,popupwall)
	assoc(teater,eater)
	assoc(teyeballboss,eyeballboss)
	assoc(tsteak,steak)
	assoc(ttooth,tooth)
	assoc(tweldingmachine,weldingmachine)
	assoc(tcapeguy,capeguy)
	assoc(tbluekey,bluekey)
	assoc(tgreenkey,greenkey)
	assoc(tredkey,redkey)
	assoc(tyellowkey,yellowkey)
	assoc(tblackkey,blackkey)
	assoc(twhitekey,whitekey)
	assoc(tpurplekey,purplekey)
	assoc(ttealkey,tealkey)
	assoc(torangekey,orangekey)
	assoc(tgreykey,greykey)
	assoc(tbluedoor,bluedoor)
	assoc(tgreendoor,greendoor)
	assoc(treddoor,reddoor)
	assoc(tyellowdoor,yellowdoor)
	assoc(tblackdoor,blackdoor)
	assoc(twhitedoor,whitedoor)
	assoc(tpurpledoor,purpledoor)
	assoc(ttealdoor,tealdoor)
	assoc(torangedoor,orangedoor)
	assoc(tgreydoor,greydoor)
	assoc(tice,ice)
	assoc(ticetl,icetl)
	assoc(ticetr,icetr)
	assoc(ticebl,icebl)
	assoc(ticebr,icebr)
	assoc(tforceleft,forceleft)
	assoc(tforceright,forceright)
	assoc(tforceup,forceup)
	assoc(tforcedown,forcedown)
	assoc(tforcerandom,forcerandom)
	assoc(tfire,fire)
	assoc(twater,water)
	assoc(tbomb,bomb)
	assoc(tteleport,teleport)
	assoc(tflameon,flameon)
	assoc(tgravel,gravel)
	assoc(tgreenbuttonout,greenbutton)
	assoc(tbluebuttonout,bluebutton)
	assoc(tgreenwall,greenwall)
	assoc(tgreenfloor,greenfloor)
	assoc(tbluewall,bluewall)
	assoc(tbluefloor,bluefloor)
	assoc(tredbutton,redbutton)
	assoc(tyellowbutton,yellowbutton)
	assoc(tbrownbutton,brownbutton)
	assoc(ttrap,trap)
	assoc(tchunk,elvis)
	assoc(tfinish,finish)
	assoc(tnote,note)
	assoc(ttrumpet,trumpet)
	assoc(tchord,chord)
	assoc(tguitar,guitar)
	assoc(thint,hint)
	assoc(tfireboot,fireboot)
	assoc(twaterboot,waterboot)
	assoc(ticeboot,iceboot)
	assoc(tforceboot,forceboot)
	assoc(tweldingmask,weldingmask)
	assoc(tthief,thief)
	end select
end function

#undef assoc
#macro assoc(id,img)
	case id
		return img
#endmacro

function ImgFromId(byval id as integer) as any ptr
	select case as const id
	assoc(tfloor,floor)
	assoc(twall,wall)
	assoc(tredfloor,redfloor)
	assoc(tredwall,redwall)
	assoc(tdirtblock,dirtblock)
	assoc(tdirt,dirt)
	assoc(tleftwall,leftwall)
	assoc(trightwall,rightwall)
	assoc(ttopwall,topwall)
	assoc(tbottomwall,bottomwall)
	assoc(tinvisiblewall,invisiblewall)
	assoc(tappearingwall,appearingwall)
	assoc(tpopupwall,popupwall)
	assoc(teater,eater)
	assoc(teyeballboss,eyeballboss)
	assoc(tsteak,steak)
	assoc(ttooth,tooth)
	assoc(tweldingmachine,weldingmachine)
	assoc(tcapeguy,capeguy)
	assoc(tbluekey,bluekey)
	assoc(tgreenkey,greenkey)
	assoc(tredkey,redkey)
	assoc(tyellowkey,yellowkey)
	assoc(tblackkey,blackkey)
	assoc(twhitekey,whitekey)
	assoc(tpurplekey,purplekey)
	assoc(ttealkey,tealkey)
	assoc(torangekey,orangekey)
	assoc(tgreykey,greykey)
	assoc(tbluedoor,bluedoor)
	assoc(tgreendoor,greendoor)
	assoc(treddoor,reddoor)
	assoc(tyellowdoor,yellowdoor)
	assoc(tblackdoor,blackdoor)
	assoc(twhitedoor,whitedoor)
	assoc(tpurpledoor,purpledoor)
	assoc(ttealdoor,tealdoor)
	assoc(torangedoor,orangedoor)
	assoc(tgreydoor,greydoor)
	assoc(tice,ice)
	assoc(ticetl,icetl)
	assoc(ticetr,icetr)
	assoc(ticebl,icebl)
	assoc(ticebr,icebr)
	assoc(tforceleft,forceleft)
	assoc(tforceright,forceright)
	assoc(tforceup,forceup)
	assoc(tforcedown,forcedown)
	assoc(tforcerandom,forcerandom)
	assoc(tfire,fire)
	assoc(twater,water)
	assoc(tbomb,bomb)
	assoc(tteleport,teleport)
	assoc(tflameon,flameon)
	assoc(tgravel,gravel)
	assoc(tgreenbuttonout,greenbutton)
	assoc(tbluebuttonout,bluebutton)
	assoc(tgreenwall,greenwall)
	assoc(tgreenfloor,greenfloor)
	assoc(tbluewall,bluewall)
	assoc(tbluefloor,bluefloor)
	assoc(tredbutton,redbutton)
	assoc(tyellowbutton,yellowbutton)
	assoc(tbrownbutton,brownbutton)
	assoc(ttrap,trap)
	assoc(tchunk,elvis)
	assoc(tfinish,finish)
	assoc(tnote,note)
	assoc(ttrumpet,trumpet)
	assoc(tchord,chord)
	assoc(tguitar,guitar)
	assoc(thint,hint)
	assoc(tfireboot,fireboot)
	assoc(twaterboot,waterboot)
	assoc(ticeboot,iceboot)
	assoc(tforceboot,forceboot)
	assoc(tweldingmask,weldingmask)
	assoc(tthief,thief)
	end select
end function

#undef assoc

sub SaveStep2(byref fn as string)
	dim ff as integer = freefile
	
	kill fn
	
	if open("levels/" + fn + ".cclvl" for binary access write as #ff) = 0 then
		put #ff,, cbyte(ubound(gameboard, 1) + 1)
		put #ff,, cbyte(ubound(gameboard, 2) + 1)
		put #ff,, cbyte(len(lvname))
		put #ff,, cbyte(len(lvpass))
		
		for i as integer = 0 to len(lvname) - 1
			put #ff,, lvname[i]
		next
		
		for i as integer = 0 to len(lvpass) - 1
			put #ff,, lvpass[i]
		next
		
		put #ff,, cbyte(len(lvhint))
		
		for i as integer = 0 to len(lvhint) - 1
			put #ff,, lvhint[i]
		next
		
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				put #ff,, cbyte(IdFromImg(gameboard(i, j)))
			next
		next
		
		dim endianmarker as uinteger = &h12345678u
		put #ff,, endianmarker
		
		for i as integer = 0 to ubound(attribs, 1)
			for j as integer = 0 to ubound(attribs, 2)
				if attribs(i, j) <> 0 then
					put #ff,, (i shl 16) or j
					put #ff,, attribs(i, j)
				end if
			next
		next
		
		dim endmarker as uinteger = &hFFFFFFFF
		put #ff,, endmarker
		
		dim notesblob as uinteger = (reqdchords shl 16) or reqdnotes
		put #ff,, notesblob
		
		dim puttime as ushort = lvtime
		put #ff,, puttime
		
		close #ff
	end if
end sub

sub SaveLevel()
	dim filename as string = "Untitled"

	do
		screenlock
		
		cls
		
		put (225, 100), dlgsave, pset
		
		draw string (85+225, 90+100), filename + ".cclvl", 0
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					if filename <> "" then SaveStep2(filename)
					exit do
				end if
			elseif e.type = FB.EVENT_KEY_PRESS then
				if (e.ascii >= asc("A") and e.ascii <= asc("Z")) or _
					(e.ascii >= asc("a") and e.ascii <= asc("z")) or _
					(e.ascii >= asc("0") and e.ascii <= asc("9")) or _
					e.ascii = asc("_") or e.ascii = asc("-") or _
					e.ascii = asc("+") or e.ascii = asc(" ") then
					if len(filename) < 23 then filename += chr(e.ascii)
				elseif e.ascii = 8 then
					filename = left(filename, len(filename) - 1)
				end if
			end if
		end if
		
		screenunlock
	loop
end sub

sub OpenStep2(byref fn as string)
	dim ff as integer = freefile
	
	if open("levels/" + fn for binary access read as #ff) = 0 then
		dim as ubyte bwidth, bheight, bnamelen, bpasslen, bhintlen, tmp
		dim as zstring ptr ptname, ptpass, pthint
		
		get #ff,, bwidth
		get #ff,, bheight
		get #ff,, bnamelen
		get #ff,, bpasslen
		
		ptname = callocate(bnamelen + 1)
		ptpass = callocate(bpasslen + 1)
		
		for i as integer = 0 to bnamelen - 1
			get #ff,, tmp
			ptname[i] = tmp
		next
		lvname = *ptname
		
		for i as integer = 0 to bpasslen - 1
			get #ff,, tmp
			ptpass[i] = tmp
		next
		lvpass = *ptpass
		
		get #ff,, bhintlen
		pthint = callocate(bhintlen + 1)
		
		for i as integer = 0 to bhintlen - 1
			get #ff,, tmp
			pthint[i] = tmp
		next
		lvhint = *pthint
		
		'' read tiles, endian marker, attribs, and end marker.
		redim gameboard(0 to bwidth-1, 0 to bheight-1) as any ptr
		for i as integer = 0 to bwidth-1
			for j as integer = 0 to bheight-1
				get #ff,, tmp
				dim img as any ptr = ImgFromId(cint(tmp))
				if img <> 0 then
					gameboard(i, j) = img
				else
					gameboard(i, j) = floor
				end if
			next
		next
		redim attribs(0 to bwidth-1, 0 to bheight-1) as uinteger
		xoffset = 0
		yoffset = 0
		
		dim as uinteger endianmarker, attribmarker, attrib
		get #ff,, endianmarker
		
		do
			get #ff,, attribmarker
			if attribmarker = &hFFFFFFFF then exit do
			
			get #ff,, attrib
			attribs(attribmarker shr 16, attribmarker and &hFFFF) = attrib
		loop until eof(ff)
		
		dim notesblob as uinteger
		get #ff,, notesblob
		
		reqdchords = notesblob shr 16
		reqdnotes = notesblob and &hFFFF
		
		dim readtime as ushort
		get #ff,, readtime
		
		lvtime = readtime
		
		deallocate ptname
		deallocate ptpass
		deallocate pthint
		
		close #ff
	end if
end sub

sub OpenLevel()
	dim filename as string
	dim fnindex as integer = 0
	dim start as integer = 0

	do
		screenlock
		
		cls
		
		put (225, 100), dlgopen, pset
		
		dim cnt as integer = 0
		dim shown as integer = 0
		dim tmpfn as string = dir("levels/*.cclvl")
		do
			if cnt >= start then
				if fnindex = cnt then
					filename = tmpfn
					draw string (20+225, 43+100 + 14*(cnt-start)), tmpfn, rgb(0, 0, 255)
				else
					draw string (20+225, 43+100 + 14*(cnt-start)), tmpfn, 0
				end if
				shown += 1
			end if
			
			cnt += 1
			tmpfn = dir
		loop while (len(tmpfn) <> 0) and (cnt < 8+start)
		
		dim e as FB.EVENT
		dim mx as integer, my as integer, buttons as integer
		getmouse mx, my,, buttons
		if screenevent(@e) then
			if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
				if mx >= 158+225 and mx <= 244+225 and my >= 165+100 and my <= 190+100 then
					exit do
				elseif mx >= 249+225 and mx <= 335+225 and my >= 165+100 and my <= 190+100 then
					OpenStep2(filename)
					exit do
				elseif mx >= 67+225 and mx <= 153+225 and my >= 165+100 and my <= 190+100 then
					'' ext. editor thing
				elseif mx >= 321+225 and mx <= 332+225 and my >= 36+100 and my <= 47+100 then
					if start > 0 then start -= 1
				elseif mx >= 321+225 and mx <= 332+225 and my >= 142+100 and my <= 153+100 then
					if shown > 1 then start += 1
				elseif mx >= 16+225 and mx <= 318+225 and my >= 38+100 and my <= 151+100 then
					fnindex = (my - 138) \ 14 + start
				end if
			end if
		end if
		
		screenunlock
	loop
end sub

do
	dim e as FB.EVENT
	dim mx as integer, my as integer, buttons as integer
	getmouse mx, my,, buttons
	
	screenlock
	
	cls
	DrawPalette
	DrawStage
	
	'' Is it a trap or clone that is connected?
	if mx >= 380 and mx <= 779 and my >= 50 and my <= 449 then
		if (attribs((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) shr 16) <> 0 then
			dim as integer boxx = attribs((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) shr 24 - xoffset, _
				boxy = ((attribs((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) shr 16) and &hFF) - yoffset
			
			if boxx >= 0 and boxx <= 9 and boxy >= 0 and boxy <= 9 then _
				line (boxx * 40 + 380, boxy * 40 + 50) - (boxx * 40 + 420, boxy * 40 + 90), 0, B
		end if
	end if
	
	screenunlock
	
	''-----
	
	if screenevent(@e) then
		if e.type = FB.EVENT_WINDOW_CLOSE then
			exit do
		elseif e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
			'' where is the mouse?
			if mx >= 380 and mx <= 779 and my >= 50 and my <= 449 then
				'' on the game board
				if e.button = 1 then
					gameboard((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) = tile
				elseif e.button = 2 then
					gameboard((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) = rttile
				end if
				CheckClone((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset)
			elseif mx >= 20 and mx <= 339 and my >= 50 and my <= 89 then
				'' on the palette selector
				tileset = (mx - 20) \ 40
			elseif mx >= 20 and mx <= 339 and my >= 130 and my <= 449 then
				'' on the palette
				'' find which tile it is
				dim as integer nr = ((mx - 20) \ 40) + (8 * ((my - 130) \ 40))
				dim overflow as integer = 0
				for i as integer = 0 to nr
					if tiles[tileset][i] = 0 then overflow = 1
				next
				if tileset <> 7 then
					if overflow = 0 then
						if e.button = 1 then tile = tiles[tileset][nr] else rttile = tiles[tileset][nr]
					end if
				else
					if tiles[tileset][nr] = trapconnect then
						ConnectTraps
					elseif tiles[tileset][nr] = timetool then
						SetLevelTime
					elseif tiles[tileset][nr] = noteamt then
						SetNoteAmt
					elseif tiles[tileset][nr] = chordamt then
						SetNoteAmt 1
					elseif tiles[tileset][nr] = password then
						SetPassword
					elseif tiles[tileset][nr] = sethint then
						SetLevelHint
					elseif tiles[tileset][nr] = setname then
						SetLevelName
					elseif tiles[tileset][nr] = cloneleft then
						SetClone 1
					elseif tiles[tileset][nr] = cloneright then
						SetClone 2
					elseif tiles[tileset][nr] = cloneup then
						SetClone 3
					elseif tiles[tileset][nr] = clonedown then
						SetClone 4
					elseif tiles[tileset][nr] = noclone then
						SetClone 0
					end if
				end if
			elseif mx >= 780 and mx <= 799 and my >= 50 and my <= 69 then
				'' scroll up
				if yoffset >= 1 then yoffset -= 1
			elseif mx >= 780 and mx <= 799 and my >= 430 and my <= 449 then
				'' scroll down
				if yoffset <= ubound(gameboard, 2) - 10 then yoffset += 1
			elseif mx >= 380 and mx <= 399 and my >= 450 and my <= 469 then
				'' scroll left
				if xoffset >= 1 then xoffset -= 1
			elseif mx >= 760 and mx <= 779 and my >= 450 and my <= 469 then
				'' scroll right
				if xoffset <= ubound(gameboard, 1) - 10 then xoffset += 1
			elseif mx >= 20 and mx <= 90 and my >= 10 and my <= 30 then
				NewLevel
			elseif mx >= 100 and mx <= 170 and my >= 10 and my <= 30 then
				SaveLevel
			elseif mx >= 180 and mx <= 250 and my >= 10 and my <= 30 then
				OpenLevel
			elseif mx >= 260 and mx <= 330 and my >= 10 and my <= 30 then
				exit do
			end if
		elseif e.type = FB.EVENT_MOUSE_MOVE then
			if e.x >= 380 and e.x <= 779 and e.y >= 50 and e.y <= 449 then
				if buttons = 1 then
					gameboard((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) = tile
					CheckClone((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset)
				elseif buttons = 2 then
					gameboard((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset) = rttile
					CheckClone((mx - 380) \ 40 + xoffset, (my - 50) \ 40 + yoffset)
				end if
			end if
		end if
	end if
	
	if multikey(FB.SC_ESCAPE) then exit do
	
loop

for i as integer = 0 to 7
	deallocate tiles[i]
next

deallocate tiles

#include once "freetiles.bi"
