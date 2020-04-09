********************************************************************
* Graphene NanoRibbon Field Effect Transistors
*             HSPICE Model
*	     
*
*   
*   Copyright University of Illinois at Urbana-Champaign 2013
*   Ying-Yu Chen, Artem Rogachev, Amit Sangai, Prof. Deming Chen
*   All Rights Reserved.
*
*
*   
*   File name: gnrfet_sample.sp
********************************************************************

********************************************************************
* LICENSE AGREEMENT
* University of Illinois at Urbana-Champaign and the authors 
* provide these model files to you subject to the License Agreement, 
* which may be updated by us from time to time without notice to you. 
********************************************************************


***************************************************
*
*Sample HSPICE Deck
*
***************************************************


.TITLE 'IDS vs VGS for GNRFET'


***************************************************
*For optimal accuracy, convergence, and runtime
***************************************************
.options POST
.options AUTOSTOP
.options INGOLD=2     DCON=1
.options GSHUNT=1e-12 RMIN=1e-15 
.options ABSTOL=1e-5  ABSVDC=1e-4 
.options RELTOL=1e-2  RELVDC=1e-2 
.options NUMDGT=4     PIVOT=13

.param   TEMP=27
***************************************************


***************************************************
*Include relevant model files
***************************************************
.lib 'gnrfet.lib' GNRFET
***************************************************
*Supplies and voltage params:
.param Supply=0.5 	
.param Vg='Supply'
.param Vd='Supply'


***********************************************************************
* Define power supply
***********************************************************************
Vdd     Drain     Gnd     Vd
Vss     Source    Gnd     0
Vgg 	  Gate	Gnd	  Vg
Vsub    Sub       Gnd     0

***********************************************************************
* Main Circuits
***********************************************************************
* n type GNRFET
XGNR Drain Gate Source Sub gnrfetnmos nRib=6 n=12 L=32n Tox=0.95n sp=2n dop=0.001 p=0 

* p type GNRFET
*XGNR Drain Gate Source Sub gnrfetpmos nRib=6 n=12 L=32n Tox=0.95n sp=2n dop=0.001 p=0 

***********************************************************************
* Measurements
***********************************************************************
* test n type GNRFET, Ids vs. Vgs
.DC      Vgg   START=0     STOP='Supply'   STEP='0.01*Supply' 
+ SWEEP  Vdd   START=0     STOP='Supply'   STEP='0.1*Supply'

* test p type GNRFET, Ids vs. Vgs
*.DC      Vgg   START=0     STOP='-Supply'   STEP='-0.01*Supply' 
*+ SWEEP  Vdd   START=0     STOP='-Supply'   STEP='-0.1*Supply'

***********************************************************************

.print I(Vdd)

.end 




