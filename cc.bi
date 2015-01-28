#ifndef CC_BI
#define CC_BI

#include once "fbgfx.bi"
#include once "fbpng.bi"
#inclib "fbpng"

#define getpng(fn) png_load( fn, PNG_TARGET_FBNEW )

enum
	tfloor
	twall
	tredfloor
	tredwall
	tdirtblock
	tdirt
	tleftwall
	trightwall
	ttopwall
	tbottomwall
	tinvisiblewall
	tappearingwall
	tpopupwall

	teater
	teyeballboss
	tsteak
	ttooth
	tweldingmachine
	tcapeguy

	tbluekey
	tgreenkey
	tredkey
	tyellowkey
	tblackkey
	twhitekey
	tpurplekey
	ttealkey
	torangekey
	tgreykey
	tbluedoor
	tgreendoor
	treddoor
	tyellowdoor
	tblackdoor
	twhitedoor
	tpurpledoor
	ttealdoor
	torangedoor
	tgreydoor

	tice
	ticetl
	ticetr
	ticebl
	ticebr
	tforceleft
	tforceright
	tforceup
	tforcedown
	tforcerandom
	tfire
	twater
	tbomb
	tteleport
	tflameon
	tflameoff
	tgravel

	tgreenbuttonout
	tgreenbuttonin
	tbluebuttonout
	tbluebuttonin
	tgreenwall
	tgreenfloor
	tbluewall
	tbluefloor
	tredbutton
	tyellowbutton
	tbrownbutton
	ttrap

	tchunk
	tfinish
	tnote
	ttrumpet
	tchord
	tguitar
	thint

	tfireboot
	twaterboot
	ticeboot
	tforceboot
	tweldingmask
	tthief
end enum

const attrib_none = &h0
const attrib_clone_left = &b1
const attrib_clone_right = &b10
const attrib_clone_up = &b100
const attrib_clone_down = &b1000
const attrib_trap = &b10000

#endif '' CC_BI
