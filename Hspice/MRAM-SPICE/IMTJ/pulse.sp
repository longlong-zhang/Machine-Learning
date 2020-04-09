file pulse.sp test of pulse
.option post 
.tran .5ns 75ns
vpulse 1  0  pulse( v1 v2 td tr tf pw per )
r1 1 0 1
.param v1=1v v2=2v td=5ns tr=1ns tf=1ns pw=5ns per=12ns
.end
