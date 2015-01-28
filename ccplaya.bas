#include once "cc.bi"
namespace crt
#include once "crt.bi"
end namespace

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
	dlgnewlevel, dlgsave, dlgopen, greenbuttonin, bluebuttonin, flameoff, _
	dlgenterstart, dlgpause, dlgyouwin

redim shared as ubyte gameboard(0 to 9, 0 to 9)
redim shared as ubyte blockboard(0 to 9, 0 to 9)
redim shared as ubyte bbdirs(0 to 9, 0 to 9)
redim shared as ubyte bbmove(0 to 9, 0 to 9)
redim shared as uinteger attribs(0 to 9, 0 to 9)
dim shared as integer chunkx = 0, chunky = 0
dim shared as integer xoffset = 0, yoffset = 0
dim shared as string lvname, lvpass, lvhint
dim shared items as uinteger = 0
dim shared reqdnotes as integer = 0
dim shared reqdchords as integer = 0
dim shared notes as integer = 0
dim shared chords as integer = 0
dim shared lvfilename as string

enum ChunkDir
	CCLeft = 0
	CCRight
	CCUp
	CCDown
end enum

dim shared olddir as ChunkDir = CCRight
dim shared keytime as double, autotime as double, bgtime as double
keytime = timer
bgtime = timer
randomize timer

dim shared as double lvtime, starttime
starttime = timer

const bgmoveinterval as double = .4
const keymoveinterval as double = .2
const automoveinterval as double = .1

const ibluekey = &b1
const igreenkey = &b10
const iredkey = &b100
const iyellowkey = &b1000
const iblackkey = &b10000
const iwhitekey = &b100000
const ipurplekey = &b1000000
const itealkey = &b10000000
const iorangekey = &b100000000
const igreykey = &b1000000000
const ifireboots = &b10000000000
const iwaterboots = &b100000000000
const iiceboots = &b1000000000000
const iforceboots = &b10000000000000
const iweldingmask = &b100000000000000

#include once "loadtiles.bi"
greenbuttonin = getpng("tiles/greenbuttonin.png")
bluebuttonin = getpng("tiles/bluebuttonin.png")
flameoff = getpng("tiles/flameoff.png")
dlgenterstart = getpng("tiles/dialog-entertostart.png")
dlgpause = getpng("tiles/dialog-pause.png")
dlgyouwin = getpng("tiles/dialog-win.png")

screenres 640, 480, 32
windowtitle "Chunk's Challenge Playa"

declare function ImgFromId(byval as integer) as any ptr
declare sub Die
declare sub Win
declare sub FocusOnChunk

sub DrawStage(byval grey as integer = 0)
	for i as integer = 0 to 9
		for j as integer = 0 to 9
			put (40 * i + 50, 40 * j + 50), floor, pset
			put (40 * i + 50, 40 * j + 50), ImgFromId(gameboard(i + xoffset, j + yoffset)), alpha, rgb(255, 0, 255)
			if blockboard(i + xoffset, j + yoffset) <> 0 then
				select case as const blockboard(i + xoffset, j + yoffset)
				case 1
					put (40 * i + 50, 40 * j + 50), dirtblock, pset
				case 2
					put (40 * i + 50, 40 * j + 50), eater, alpha, rgb(255, 0, 255)
				case 3
					put (40 * i + 50, 40 * j + 50), eyeballboss, alpha, rgb(255, 0, 255)
				case 4
					put (40 * i + 50, 40 * j + 50), steak, alpha, rgb(255, 0, 255)
				case 5
					put (40 * i + 50, 40 * j + 50), tooth, alpha, rgb(255, 0, 255)
				case 6
					put (40 * i + 50, 40 * j + 50), weldingmachine, alpha, rgb(255, 0, 255)
				case 7
					put (40 * i + 50, 40 * j + 50), capeguy, alpha, rgb(255, 0, 255)
				end select
			end if
			dim attr as uinteger = attribs(i + xoffset, j + yoffset)
			if attr and attrib_clone_left then
				put (40 * i + 50, 40 * j + 50), cloneleft, alpha, rgb(255, 0, 255)
			elseif attr and attrib_clone_right then
				put (40 * i + 50, 40 * j + 50), cloneright, alpha, rgb(255, 0, 255)
			elseif attr and attrib_clone_up then
				put (40 * i + 50, 40 * j + 50), cloneup, alpha, rgb(255, 0, 255)
			elseif attr and attrib_clone_down then
				put (40 * i + 50, 40 * j + 50), clonedown, alpha, rgb(255, 0, 255)
			end if
			
			if (i + xoffset = chunkx) and (j + yoffset = chunky) then _
				put (40 * i + 50, 40 * j + 50), elvis, alpha, rgb(255, 0, 255)
			if grey <> 0 then put (40 * i + 50, 40 * j + 50), cover, alpha, rgb(255, 0, 255)
		next
	next
	
	line (20, 10) - (90, 30), rgb(255, 255, 255), B
	draw string (40, 17), "Open", rgb(255, 255, 255)
end sub

sub DrawInfoBoard()
	for i as integer = 0 to 2
		for j as integer = 0 to 4
			put (40 * i + 470, 40 * j + 50), floor, pset
		next
	next
	
	if items and ibluekey then put (470, 50), bluekey, alpha, rgb(255, 0, 255)
	if items and igreenkey then put (470, 90), greenkey, alpha, rgb(255, 0, 255)
	if items and iredkey then put (470, 130), redkey, alpha, rgb(255, 0, 255)
	if items and iyellowkey then put (470, 170), yellowkey, alpha, rgb(255, 0, 255)
	if items and iblackkey then put (470, 210), blackkey, alpha, rgb(255, 0, 255)
	
	if items and iwhitekey then put (510, 50), whitekey, alpha, rgb(255, 0, 255)
	if items and ipurplekey then put (510, 90), purplekey, alpha, rgb(255, 0, 255)
	if items and itealkey then put (510, 130), tealkey, alpha, rgb(255, 0, 255)
	if items and iorangekey then put (510, 170), orangekey, alpha, rgb(255, 0, 255)
	if items and igreykey then put (510, 210), greykey, alpha, rgb(255, 0, 255)
	
	if items and ifireboots then put (550, 50), fireboot, alpha, rgb(255, 0, 255)
	if items and iwaterboots then put (550, 90), waterboot, alpha, rgb(255, 0, 255)
	if items and iiceboots then put (550, 130), iceboot, alpha, rgb(255, 0, 255)
	if items and iforceboots then put (550, 170), forceboot, alpha, rgb(255, 0, 255)
	if items and iweldingmask then put (550, 210), weldingmask, alpha, rgb(255, 0, 255)
	
	draw string (470, 260), "Name: " + lvname
	draw string (470, 270), "Password: " + lvpass
	if lvtime = 0.0 then
		draw string (470, 280), "Time Left: ---"
	else
		draw string (470, 280), "Time Left: " + str(int(lvtime - (timer - starttime)))
		if lvtime - (timer - starttime) <= 0 then Die
	end if
	draw string (470, 290), "Notes Left: " + str(iif(reqdnotes - notes < 0, 0, reqdnotes - notes))
	draw string (470, 300), "Chords Left: " + str(iif(reqdchords - chords < 0, 0, reqdchords - chords))
end sub

#macro assoc(id,img)
	case id
		return img
#endmacro

function ImgFromId(byval id as integer) as any ptr
	select case as const id
	assoc(tfloor,floor)
	assoc(twall,wall)
	assoc(tredfloor,redwall)
	assoc(tredwall,redwall)
	assoc(tdirtblock,dirtblock)
	assoc(tdirt,dirt)
	assoc(tleftwall,leftwall)
	assoc(trightwall,rightwall)
	assoc(ttopwall,topwall)
	assoc(tbottomwall,bottomwall)
	assoc(tinvisiblewall,floor)
	assoc(tappearingwall,floor)
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
	assoc(tflameoff,flameoff)
	assoc(tgravel,gravel)
	assoc(tgreenbuttonout,greenbutton)
	assoc(tgreenbuttonin,greenbuttonin)
	assoc(tbluebuttonout,bluebutton)
	assoc(tbluebuttonin,bluebuttonin)
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

sub OpenStep2(byref fn as string)
	dim ff as integer = freefile
	
	if open("levels/" + fn for binary access read as #ff) = 0 then
		dim as ubyte bwidth, bheight, bnamelen, bpasslen, bhintlen, tmp
		dim as zstring ptr ptname, ptpass, pthint
		
		chunkx = 0
		chunky = 0
		
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
		redim gameboard(0 to bwidth-1, 0 to bheight-1) as ubyte
		redim blockboard(0 to bwidth-1, 0 to bheight-1) as ubyte
		redim bbdirs(0 to bwidth-1, 0 to bheight-1) as ubyte
		redim bbmove(0 to bwidth-1, 0 to bheight-1) as ubyte
		for i as integer = 0 to bwidth-1
			for j as integer = 0 to bheight-1
				get #ff,, tmp
				if tmp = tchunk then
					gameboard(i, j) = tfloor
					chunkx = i
					chunky = j
				elseif tmp = tdirtblock then
					blockboard(i, j) = 1
				elseif tmp = teater then
					blockboard(i, j) = 2
				elseif tmp = teyeballboss then
					blockboard(i, j) = 3
				elseif tmp = tsteak then
					blockboard(i, j) = 4
				elseif tmp = ttooth then
					blockboard(i, j) = 5
				elseif tmp = tweldingmachine then
					blockboard(i, j) = 6
				elseif tmp = tcapeguy then
					blockboard(i, j) = 7
				else
					gameboard(i, j) = tmp
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
			if ((attrib and &b1111) <> 0) and (blockboard(attribmarker shr 16, attribmarker and &hFFFF) <> 0) then
				select case as const blockboard(attribmarker shr 16, attribmarker and &hFFFF)
				case 1
					gameboard(attribmarker shr 16, attribmarker and &hFFFF) = tdirtblock
				case 2
					gameboard(attribmarker shr 16, attribmarker and &hFFFF) = teater
				case 3
					gameboard(attribmarker shr 16, attribmarker and &hFFFF) = teyeballboss
				case 4
					gameboard(attribmarker shr 16, attribmarker and &hFFFF) = tsteak
				case 5
					gameboard(attribmarker shr 16, attribmarker and &hFFFF) = ttooth
				case 6
					gameboard(attribmarker shr 16, attribmarker and &hFFFF) = tweldingmachine
				case 7
					gameboard(attribmarker shr 16, attribmarker and &hFFFF) = tcapeguy
				end select
				blockboard(attribmarker shr 16, attribmarker and &hFFFF) = 0
			end if
			attribs(attribmarker shr 16, attribmarker and &hFFFF) = attrib
		loop until eof(ff)
		
		dim notesblob as uinteger
		get #ff,, notesblob
		
		reqdchords = notesblob shr 16
		reqdnotes = notesblob and &hFFFF
		
		items = 0
		
		dim readtime as ushort
		get #ff,, readtime
		
		lvtime = readtime
		starttime = timer
		
		deallocate ptname
		deallocate ptpass
		deallocate pthint
		
		lvfilename = fn
		
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

sub FindNextTeleporter(byval x as integer, byval y as integer, byref newx as integer, byref newy as integer)
	dim as integer beforex = -1, beforey = -1
	dim as integer afterx = -1, aftery = -1
	for j as integer = 0 to ubound(gameboard, 2)
		for i as integer = 0 to ubound(gameboard, 1)
			if gameboard(i, j) = tteleport then
				if (j < y) or ((j = y) and (i < x)) then
					if beforex = -1 then
						beforex = i
						beforey = j
					end if
				elseif (j > y) or ((j = y) and (i > x)) then
					if afterx = -1 then
						afterx = i
						aftery = j
					end if
				end if
			end if
		next
	next
	
	if afterx <> -1 then
		newx = afterx
		newy = aftery
	elseif beforex <> -1 then
		newx = beforex
		newy = beforey
	else
		newx = x
		newy = y
	end if
end sub

sub PauseLvl(byval otherscrn as integer = 0)
	dim e as FB.EVENT
	dim timeleft as double = lvtime - (timer - starttime)

	do
		screenlock
		cls
		
		DrawStage 1
		DrawInfoBoard
		
		if otherscrn = 1 then
			put (75, 150), dlgenterstart, pset
		elseif otherscrn = 2 then
			put (75, 150), dlgyouwin, pset
		else
			put (75, 150), dlgpause, pset
		end if
		
		screenunlock
		
		if screenevent(@e) then
			if e.type = FB.EVENT_KEY_PRESS then
				if otherscrn = 0 then
					if e.ascii = asc("p") then exit do
				else
					if e.scancode = FB.SC_ENTER then exit do
				end if
			end if
		end if
		
		starttime = timeleft + timer - lvtime
		
		if multikey(FB.SC_ESCAPE) then exit do
	loop
end sub

sub Win
	PauseLvl 2
	OpenStep2 lvfilename
	FocusOnChunk
	PauseLvl 1
end sub

sub Die
	OpenStep2 lvfilename
	FocusOnChunk
	PauseLvl 1
end sub

sub CheckDeath
	if blockboard(chunkx, chunky) <> 0 then
		'' you can walk on welding machines though
		if blockboard(chunkx, chunky) <> 6 then Die
	elseif gameboard(chunkx, chunky) = tfire then
		if (items and ifireboots) = 0 then Die
	elseif gameboard(chunkx, chunky) = twater then
		if (items and iwaterboots) = 0 then Die
	elseif (gameboard(chunkx, chunky) = tbomb) or (gameboard(chunkx, chunky) = tflameon) then
		Die
	elseif gameboard(chunkx, chunky) = tfinish then
		Win
	end if
end sub

sub MoveChunk(byval d as ChunkDir, byval ignoreice as integer = 0)
	dim as integer xchg = 0, ychg = 0
	select case as const d
	case CCLeft
		if ignoreice then olddir = CCRight
		if chunkx <= 0 then return
		xchg = -1
	case CCRight
		if ignoreice then olddir = CCLeft
		if chunkx >= ubound(gameboard, 1) then return
		xchg = 1
	case CCUp
		if ignoreice then olddir = CCDown
		if chunky <= 0 then return
		ychg = -1
	case CCDown
		if ignoreice then olddir = CCUp
		if chunky >= ubound(gameboard, 2) then return
		ychg = 1
	end select
	
	'' Can we move to the spot asked about?
	dim as integer oldtile = gameboard(chunkx, chunky)
	dim as integer newtile = gameboard(chunkx + xchg, chunky + ychg)
	
	'' Can I even move off of my tile?
	if oldtile = ttrap then
		if (attribs(chunkx, chunky) shr 16) = 0 then return
		if blockboard(attribs(chunkx, chunky) shr 24, (attribs(chunkx, chunky) shr 16) and &hFF) = 0 then _
			return
	elseif oldtile = trightwall then
		if xchg = 1 then return
	elseif oldtile = tleftwall then
		if xchg = -1 then return
	elseif oldtile = tbottomwall then
		if ychg = 1 then return
	elseif oldtile = ttopwall then
		if ychg = -1 then return
	end if
	
	'' Is it a clone tile?
	if attribs(chunkx + xchg, chunky + ychg) and &b1111 then return
	
	if blockboard(chunkx + xchg, chunky + ychg) = 6 then
		if (items and iweldingmask) = 0 then return
	end if
	
	'' Is the new tile a wall tile?
	if newtile = twall then
		return
	elseif newtile = tredwall then
		gameboard(chunkx + xchg, chunky + ychg) = twall
		return
	elseif newtile = tredfloor then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = tinvisiblewall then
		return
	elseif newtile = tappearingwall then
		gameboard(chunkx + xchg, chunky + ychg) = twall
		return
	elseif newtile = tpopupwall then
		gameboard(chunkx + xchg, chunky + ychg) = twall
	elseif newtile = trightwall then
		if xchg = -1 then return
	elseif newtile = tleftwall then
		if xchg = 1 then return
	elseif newtile = tbottomwall then
		if ychg = -1 then return
	elseif newtile = ttopwall then
		if ychg = 1 then return
	elseif newtile = ticetl then
		if (d = CCRight) or (d = CCDown) then return
	elseif newtile = ticetr then
		if (d = CCLeft) or (d = CCDown) then return
	elseif newtile = ticebl then
		if (d = CCRight) or (d = CCUp) then return
	elseif newtile = ticebr then
		if (d = CCLeft) or (d = CCUp) then return
	elseif newtile = tgreenwall then
		return
	elseif newtile = tbluewall then
		return
	elseif newtile = tbluedoor then
		if (items and ibluekey) = 0 then return
		items and= not(ibluekey)
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = tgreendoor then
		if (items and igreenkey) = 0 then return
		items and= not(igreenkey)
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = treddoor then
		if (items and iredkey) = 0 then return
		items and= not(iredkey)
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = tyellowdoor then
		if (items and iyellowkey) = 0 then return
		items and= not(iyellowkey)
        gameboard(chunkx + xchg, chunky + ychg) = tfloor
    ElseIf newtile = tblackdoor Then
        If (items And iblackkey) = 0 Then Return
        gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = twhitedoor then
		if (items and iwhitekey) = 0 then return
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = tpurpledoor then
		if (items and ipurplekey) = 0 then return
		items and= not(ipurplekey)
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = ttealdoor then
		if (items and itealkey) = 0 then return
		items and= not(itealkey)
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = torangedoor then
		if (items and iorangekey) = 0 then return
		items and= not(iorangekey)
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = tgreydoor then
		if (items and igreykey) = 0 then return
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	'' other stuff
	elseif newtile = tbluekey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= ibluekey
	elseif newtile = tgreenkey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= igreenkey
	elseif newtile = tredkey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iredkey
	elseif newtile = tyellowkey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iyellowkey
	elseif newtile = tblackkey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iblackkey
	elseif newtile = twhitekey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iwhitekey
	elseif newtile = tpurplekey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= ipurplekey
	elseif newtile = ttealkey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= itealkey
	elseif newtile = torangekey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iorangekey
	elseif newtile = tgreykey then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= igreykey
	elseif newtile = tfireboot then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= ifireboots
	elseif newtile = twaterboot then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iwaterboots
	elseif newtile = ticeboot then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iiceboots
	elseif newtile = tforceboot then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iforceboots
	elseif newtile = tweldingmask then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
		items or= iweldingmask
	elseif newtile = tdirt then
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = tthief then
		items and= not(ifireboots or iwaterboots or iiceboots or iforceboots or iweldingmask)
	elseif newtile = tgreenbuttonout then
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				if gameboard(i, j) = tgreenbuttonout then
					gameboard(i, j) = tgreenbuttonin
				elseif gameboard(i, j) = tgreenwall then
					gameboard(i, j) = tgreenfloor
				elseif gameboard(i, j) = tgreenfloor then
					gameboard(i, j) = tgreenwall
				end if
			next
		next
	elseif newtile = tgreenbuttonin then
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				if gameboard(i, j) = tgreenbuttonin then
					gameboard(i, j) = tgreenbuttonout
				elseif gameboard(i, j) = tgreenwall then
					gameboard(i, j) = tgreenfloor
				elseif gameboard(i, j) = tgreenfloor then
					gameboard(i, j) = tgreenwall
				end if
			next
		next
	elseif newtile = tbluebuttonout then
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				if gameboard(i, j) = tbluebuttonout then
					gameboard(i, j) = tbluebuttonin
				elseif gameboard(i, j) = tbluewall then
					gameboard(i, j) = tbluefloor
				elseif gameboard(i, j) = tbluefloor then
					gameboard(i, j) = tbluewall
				end if
			next
		next
	elseif newtile = tbluebuttonin then
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				if gameboard(i, j) = tbluebuttonin then
					gameboard(i, j) = tbluebuttonout
				elseif gameboard(i, j) = tbluewall then
					gameboard(i, j) = tbluefloor
				elseif gameboard(i, j) = tbluefloor then
					gameboard(i, j) = tbluewall
				end if
			next
		next
	elseif newtile = tyellowbutton then
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				if gameboard(i, j) = tflameon then
					gameboard(i, j) = tflameoff
				end if
			next
		next
	elseif newtile = tnote then
		notes += 1
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = tchord then
		chords += 1
		gameboard(chunkx + xchg, chunky + ychg) = tfloor
	elseif newtile = ttrumpet then
		if notes >= reqdnotes then
			gameboard(chunkx + xchg, chunky + ychg) = tfloor
		else
			return
		end if
	elseif newtile = tguitar then
		if chords >= reqdchords then
			gameboard(chunkx + xchg, chunky + ychg) = tfloor
		else
			return
		end if
	elseif newtile = tteleport then
		dim as integer nextx, nexty
		dim as integer oldchunkx = chunkx, oldchunky = chunky
		FindNextTeleporter(chunkx + xchg, chunky + ychg, nextx, nexty)
		chunkx = nextx
		chunky = nexty
		MoveChunk d
		if (chunkx = nextx) and (chunky = nexty) then
			chunkx = oldchunkx + xchg
			chunky = oldchunky + ychg
			MoveChunk d
			if (chunkx = oldchunkx + xchg) and (chunky = oldchunky + ychg) then
				chunkx = oldchunkx
				chunky = oldchunky
			end if
		end if
		return
	elseif newtile = tredbutton then
		if (attribs(chunkx + xchg, chunky + ychg) shr 16) <> 0 then
			dim as integer clonex = attribs(chunkx + xchg, chunky + ychg) shr 24, _
				cloney = (attribs(chunkx + xchg, chunky + ychg) shr 16) and &hFF
			dim as integer cxo = 0, cyo = 0
			if attribs(clonex, cloney) and attrib_clone_left then
				cxo = -1
			elseif attribs(clonex, cloney) and attrib_clone_right then
				cxo = 1
			elseif attribs(clonex, cloney) and attrib_clone_up then
				cyo = -1
			elseif attribs(clonex, cloney) and attrib_clone_down then
				cyo = 1
			end if
			
			if (clonex + cxo >= 0) and (clonex + cxo <= ubound(gameboard, 1)) and _
				(cloney + cyo >= 0) and (cloney + cyo <= ubound(gameboard, 1)) then
				'' Make sure the space is clear
				dim tile as ubyte = gameboard(clonex + cxo, cloney + cyo)
				'' TODO: Once bad guys are on the blockboard, this should be fixed.
				if ((tile = tfloor) or ((tile >= tice) and (tile <= tforcedown)) or _
					(tile = tbluefloor) or (tile = tgreenfloor)) and _
					(blockboard(clonex + cxo, cloney + cyo) = 0) then
					if gameboard(clonex, cloney) = tdirtblock then
						blockboard(clonex + cxo, cloney + cyo) = 1
					else
						blockboard(clonex + cxo, cloney + cyo) = gameboard(clonex, cloney) - teater + 2
					end if
				end if
			end if
		end if
	'' if we're on an ice tile, we can't do anything (unless we have the ice boots).
	elseif oldtile = tice then
		if ((items and iiceboots) = 0) and (ignoreice = 0) then return
	elseif oldtile = ticetl then
		if ((items and iiceboots) = 0) and (ignoreice = 0) then return
	elseif oldtile = ticetr then
		if ((items and iiceboots) = 0) and (ignoreice = 0) then return
	elseif oldtile = ticebl then
		if ((items and iiceboots) = 0) and (ignoreice = 0) then return
	elseif oldtile = ticebr then
		if ((items and iiceboots) = 0) and (ignoreice = 0) then return
	end if
	
	if blockboard(chunkx + xchg, chunky + ychg) = 1 then
		'' Can the block move?
		dim blocktile as ubyte = gameboard(chunkx + xchg, chunky + ychg)
		dim blocknewtile as ubyte = gameboard(chunkx + 2*xchg, chunky + 2*ychg)
		if (chunkx + 2*xchg < 0) or (chunkx + 2*xchg > ubound(gameboard, 1)) and _
			(chunky + 2*ychg < 0) or (chunky + 2*ychg > ubound(gameboard, 2)) then return
		
		if blockboard(chunkx + 2*xchg, chunky + 2*ychg) <> 0 then return
		
		if blocktile = tleftwall then
			if d = CCLeft then return
		elseif blocktile = trightwall then
			if d = CCRight then return
		elseif blocktile = ttopwall then
			if d = CCUp then return
		elseif blocktile = tbottomwall then
			if d = CCDown then return
		end if
		
		if blocknewtile = twater then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			gameboard(chunkx + 2*xchg, chunky + 2*ychg) = tdirt
		elseif blocknewtile = tbomb then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			gameboard(chunkx + 2*xchg, chunky + 2*ychg) = tfloor
		elseif blocknewtile = tfloor then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tgreenbuttonin then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			for i as integer = 0 to ubound(gameboard, 1)
				for j as integer = 0 to ubound(gameboard, 2)
					if gameboard(i, j) = tgreenbuttonin then
						gameboard(i, j) = tgreenbuttonout
					elseif gameboard(i, j) = tgreenwall then
						gameboard(i, j) = tgreenfloor
					elseif gameboard(i, j) = tgreenfloor then
						gameboard(i, j) = tgreenwall
					end if
				next
			next
		elseif blocknewtile = tgreenbuttonout then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			for i as integer = 0 to ubound(gameboard, 1)
				for j as integer = 0 to ubound(gameboard, 2)
					if gameboard(i, j) = tgreenbuttonout then
						gameboard(i, j) = tgreenbuttonin
					elseif gameboard(i, j) = tgreenwall then
						gameboard(i, j) = tgreenfloor
					elseif gameboard(i, j) = tgreenfloor then
						gameboard(i, j) = tgreenwall
					end if
				next
			next
		elseif blocknewtile = tgreenfloor then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tbluebuttonin then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			for i as integer = 0 to ubound(gameboard, 1)
				for j as integer = 0 to ubound(gameboard, 2)
					if gameboard(i, j) = tbluebuttonin then
						gameboard(i, j) = tbluebuttonout
					elseif gameboard(i, j) = tbluewall then
						gameboard(i, j) = tbluefloor
					elseif gameboard(i, j) = tbluefloor then
						gameboard(i, j) = tbluewall
					end if
				next
			next
		elseif blocknewtile = tbluebuttonout then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			for i as integer = 0 to ubound(gameboard, 1)
				for j as integer = 0 to ubound(gameboard, 2)
					if gameboard(i, j) = tbluebuttonout then
						gameboard(i, j) = tbluebuttonin
					elseif gameboard(i, j) = tbluewall then
						gameboard(i, j) = tbluefloor
					elseif gameboard(i, j) = tbluefloor then
						gameboard(i, j) = tbluewall
					end if
				next
			next
		elseif blocknewtile = tbluefloor then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tyellowbutton then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			for i as integer = 0 to ubound(gameboard, 1)
				for j as integer = 0 to ubound(gameboard, 2)
					if gameboard(i, j) = tflameon then
						gameboard(i, j) = tflameoff
					end if
				next
			next
		elseif blocknewtile = tredbutton then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tbrownbutton then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tflameoff then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tflameon then
			blockboard(chunkx + xchg, chunky + ychg) = 0
		elseif blocknewtile = tleftwall then
			if d <> CCRight then
				blockboard(chunkx + xchg, chunky + ychg) = 0
				blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			else
				return
			end if
		elseif blocknewtile = trightwall then
			if d <> CCLeft then
				blockboard(chunkx + xchg, chunky + ychg) = 0
				blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			else
				return
			end if
		elseif blocknewtile = ttopwall then
			if d <> CCDown then
				blockboard(chunkx + xchg, chunky + ychg) = 0
				blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			else
				return
			end if
		elseif blocknewtile = tbottomwall then
			if d <> CCUp then
				blockboard(chunkx + xchg, chunky + ychg) = 0
				blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
			else
				return
			end if
		elseif blocknewtile = tforceright then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tforceleft then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tforceup then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tforcedown then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = tice then
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = ticetl then
			if (d = CCRight) or (d = CCDown) then return
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = ticetr then
			if (d = CCLeft) or (d = CCDown) then return
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = ticebl then
			if (d = CCRight) or (d = CCUp) then return
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		elseif blocknewtile = ticebr then
			if (d = CCLeft) or (d = CCUp) then return
			blockboard(chunkx + xchg, chunky + ychg) = 0
			blockboard(chunkx + 2*xchg, chunky + 2*ychg) = 1
		else
			return
		end if
	end if
	
	if oldtile = tyellowbutton then
		dim ison as integer = 1
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				if gameboard(i, j) = tyellowbutton then
					'' is anything on it?
					if blockboard(i, j) <> 0 then
						ison = 0
						exit for, for
					end if
				end if
			next
		next
		
		for i as integer = 0 to ubound(gameboard, 1)
			for j as integer = 0 to ubound(gameboard, 2)
				if (gameboard(i, j) = tflameon) or (gameboard(i, j) = tflameoff) then
					if ison <> 0 then gameboard(i, j) = tflameon else gameboard(i, j) = tflameoff
				end if
			next
		next
	end if
	
	olddir = d
	chunkx += xchg
	chunky += ychg
	
	CheckDeath
end sub

function BGAllowed(byval x as integer, byval y as integer) as integer
	if (x < 0) or (x > ubound(gameboard, 1)) or (y < 0) or (y > ubound(gameboard, 2)) then return 0
	
	if blockboard(x, y) <> 0 then return 0
	
	select case as const gameboard(x, y)
	case tfloor, tgreenfloor, tbluefloor, tleftwall, trightwall, ttopwall, tbottomwall, _
		tice to ticebr, tforceleft to tforcedown, tfire, twater, tbomb, tteleport, _
		tflameon, tflameoff, tgreenbuttonin, tbluebuttonin, tredbutton, tyellowbutton, _
		tbrownbutton, thint, ttrap, tgreenbuttonout, tbluebuttonout
		return 1
	end select
	
	return 0
end function

sub MoveBG(byval x as integer, byval y as integer, byval newx as integer, byval newy as integer)
	dim tile as integer = gameboard(newx, newy)
	
	'' should the bad guy die?
	if (tile = tfire) or (tile = twater) or (tile = tbomb) or (tile = tflameon) then
		blockboard(x, y) = 0
		bbdirs(x, y) = 0
		return
	end if
	
	'' is there anything special that needs to be done?
	if (tile = tgreenbuttonin) or (tile = tgreenbuttonout) then
		
	elseif (tile = tbluebuttonin) or (tile = tbluebuttonout) then
		
	elseif tile = tredbutton then
		
	elseif tile = tyellowbutton then
	
	end if
	
	blockboard(newx, newy) = blockboard(x, y)
	blockboard(x, y) = 0
	if newx > x then
		bbdirs(newx, newy) = CCRight
	elseif newx < x then
		bbdirs(newx, newy) = CCLeft
	elseif newy > y then
		bbdirs(newx, newy) = CCDown
	elseif newy < y then
		bbdirs(newx, newy) = CCUp
	end if
	bbmove(newx, newy) = 1
	bbdirs(x, y) = 0
end sub

sub MoveBadGuys
	for i as integer = 0 to ubound(bbmove, 1)
		for j as integer = 0 to ubound(bbmove, 2)
			bbmove(i, j) = 0
		next
	next
	
	for i as integer = 0 to ubound(blockboard, 1)
		for j as integer = 0 to ubound(blockboard, 2)
			if bbmove(i, j) = 1 then continue for
			if blockboard(i, j) <> 0 then
				if gameboard(i, j) = tice then
					'' move on the ice
				elseif gameboard(i, j) = ticetl then
				elseif gameboard(i, j) = ticetr then
				elseif gameboard(i, j) = ticebl then
				elseif gameboard(i, j) = ticebr then
				elseif gameboard(i, j) = tforceleft then
					if BGAllowed(i - 1, j) then MoveBG(i, j, i - 1, j)
				elseif gameboard(i, j) = tforceright then
					if BGAllowed(i + 1, j) then MoveBG(i, j, i + 1, j)
				elseif gameboard(i, j) = tforceup then
					if BGAllowed(i, j - 1) then MoveBG(i, j, i, j - 1)
				elseif gameboard(i, j) = tforcedown then
					if BGAllowed(i, j + 1) then MoveBG(i, j, i, j + 1)
				else
					if blockboard(i, j) = 1 then return
					/'if bbdirs(i, j) = CCLeft then
						if BGAllowed(i - 1, j) then MoveBG(i, j, i - 1, j)
					elseif bbdirs(i, j) = CCRight then
						if BGAllowed(i + 1, j) then MoveBG(i, j, i + 1, j)
					elseif bbdirs(i, j) = CCUp then
						if BGAllowed(i, j - 1) then MoveBG(i, j, i, j - 1)
					else
						if BGAllowed(i, j + 1) then MoveBG(i, j, i, j + 1)
					end if'/
					dim asdfasdf as double = rnd * 4
					if asdfasdf < 1 then
						if BGAllowed(i - 1, j) then MoveBG(i, j, i - 1, j)
					elseif asdfasdf < 2 then
						if BGAllowed(i + 1, j) then MoveBG(i, j, i + 1, j)
					elseif asdfasdf < 3 then
						if BGAllowed(i, j - 1) then MoveBG(i, j, i, j - 1)
					elseif asdfasdf < 4 then
						if BGAllowed(i, j + 1) then MoveBG(i, j, i, j + 1)
					end if
				end if
			end if
		next
	next
	
	''CheckDeath
end sub

sub FocusOnChunk
	'' Chunk should be in one of the middle 4 squares (x = 4 or 5, y = 4 or 5)	
	'' if Chunk is on the right side of the screen, try to set so Chunk is at 5. Otherwise, try 4.
	if chunkx - xoffset >= 5 then
		xoffset = chunkx - 5
	else
		xoffset = chunkx - 4
	end if
	if xoffset > ubound(gameboard, 1) - 9 then xoffset = ubound(gameboard, 1) - 9
	if xoffset < 0 then xoffset = 0
	
	if chunky - yoffset >= 5 then
		yoffset = chunky - 5
	else
		yoffset = chunky - 4
	end if
	if yoffset > ubound(gameboard, 2) - 9 then yoffset = ubound(gameboard, 2) - 9
	if yoffset < 0 then yoffset = 0
end sub

OpenStep2 "Test.cclvl"
FocusOnChunk
PauseLvl 1

do
	dim e as FB.EVENT
	dim mx as integer, my as integer, buttons as integer
	getmouse mx, my,, buttons
	
	screenlock
	
	cls
	DrawStage
	DrawInfoBoard
	
	screenunlock
	
	if screenevent(@e) then
		if e.type = FB.EVENT_MOUSE_BUTTON_RELEASE then
			if mx >= 20 and mx <= 90 and my >= 10 and my <= 30 then OpenLevel
		elseif e.type = FB.EVENT_KEY_PRESS then
			if e.ascii = asc("p") then PauseLvl
		end if
	end if
	
	dim as ubyte tile = gameboard(chunkx, chunky)
	if (tile = tforceleft) and (items and iforceboots) = 0 then
		if autotime < timer-automoveinterval then
			'olddir = CCLeft
			MoveChunk CCLeft, 1
			autotime = timer
		end if
	elseif (tile = tforceright) and (items and iforceboots) = 0 then
		if autotime < timer-automoveinterval then
			'olddir = CCRight
			MoveChunk CCRight, 1
			autotime = timer
		end if
	elseif (tile = tforceup) and (items and iforceboots) = 0 then
		if autotime < timer-automoveinterval then
			'olddir = CCUp
			MoveChunk CCUp, 1
			autotime = timer
		end if
	elseif (tile = tforcedown) and (items and iforceboots) = 0 then
		if autotime < timer-automoveinterval then
			'olddir = CCDown
			MoveChunk CCDown, 1
			autotime = timer
		end if
	elseif (tile = tforcerandom) and (items and iforceboots) = 0 then
		if autotime < timer-automoveinterval then
			dim as double nr = rnd
			if nr < .25 then
				'olddir = CCLeft
				MoveChunk CCLeft, 1
			elseif nr < .50 then
				'olddir = CCRight
				MoveChunk CCRight, 1
			elseif nr < .75 then
				'olddir = CCUp
				MoveChunk CCUp, 1
			else
				'olddir = CCDown
				MoveChunk CCDown, 1
			end if
			autotime = timer
		end if
	'' if we're on an ice tile, we can't do anything (unless we have the ice boots).
	elseif tile = tice then
		if (items and iiceboots) = 0 then
			if autotime < timer-automoveinterval then
				MoveChunk olddir, 1
				autotime = timer
			end if
		end if
	elseif tile = ticetl then
		if (items and iiceboots) = 0 then
			if autotime < timer-automoveinterval then
				if olddir = CCLeft then
					'olddir = CCDown
					MoveChunk CCDown, 1
				else
					'olddir = CCRight
					MoveChunk CCRight, 1
				end if
				autotime = timer
			end if
		end if
	elseif tile = ticetr then
		if (items and iiceboots) = 0 then
			if autotime < timer-automoveinterval then
				if olddir = CCRight then
					'olddir = CCDown
					MoveChunk CCDown, 1
				else
					'olddir = CCLeft
					MoveChunk CCLeft, 1
				end if
				autotime = timer
			end if
		end if
	elseif tile = ticebl then
		if (items and iiceboots) = 0 then
			if autotime < timer-automoveinterval then
				if olddir = CCLeft then
					'olddir = CCUp
					MoveChunk CCUp, 1
				else
					'olddir = CCRight
					MoveChunk CCRight, 1
				end if
				autotime = timer
			end if
		end if
	elseif tile = ticebr then
		if (items and iiceboots) = 0 then
			if autotime < timer-automoveinterval then
				if olddir = CCRight then
					'olddir = CCUp
					MoveChunk CCUp, 1
				else
					'olddir = CCLeft
					MoveChunk CCLeft, 1
				end if
				autotime = timer
			end if
		end if
	end if
	
	'' If we're on an ice tile, don't even try - this has been really problematic.
	if multikey(FB.SC_LEFT) then
		if keytime < timer-keymoveinterval then
			if (gameboard(chunkx, chunky) >= tice) and (gameboard(chunkx, chunky) <= ticebr) and _
				(items and iiceboots) = 0 then goto IceSkip
			keytime = timer
			autotime = keytime
			'olddir = CCLeft
			MoveChunk(CCLeft)
		end if
	end if
	if multikey(FB.SC_RIGHT) then
		if keytime < timer-keymoveinterval then
			if (gameboard(chunkx, chunky) >= tice) and (gameboard(chunkx, chunky) <= ticebr) and _
				(items and iiceboots) = 0 then goto IceSkip
			keytime = timer
			autotime = keytime
			'olddir = CCRight
			MoveChunk(CCRight)
		end if
	end if
	if multikey(FB.SC_UP) then
		if keytime < timer-keymoveinterval then
			if (gameboard(chunkx, chunky) >= tice) and (gameboard(chunkx, chunky) <= ticebr) and _
				(items and iiceboots) = 0 then goto IceSkip
			keytime = timer
			autotime = keytime
			'olddir = CCUp
			MoveChunk(CCUp)
		end if
	end if
	if multikey(FB.SC_DOWN) then
		if keytime < timer-keymoveinterval then
			if (gameboard(chunkx, chunky) >= tice) and (gameboard(chunkx, chunky) <= ticebr) and _
				(items and iiceboots) = 0 then goto IceSkip
			keytime = timer
			autotime = keytime
			'olddir = CCDown
			MoveChunk(CCDown)
		end if
	end if
	
	IceSkip:
	FocusOnChunk
	
	if bgtime < timer-bgmoveinterval then
		bgtime = timer
		MoveBadGuys
		CheckDeath
	end if
	
	if multikey(FB.SC_ESCAPE) then exit do
loop

#include once "freetiles.bi"
deallocate greenbuttonin
deallocate bluebuttonin
deallocate flameoff
deallocate dlgenterstart
deallocate dlgpause
deallocate dlgyouwin
