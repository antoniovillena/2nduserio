vcom -2008 -quiet -work sim/psx ^
../../rtl/pGTE.vhd ^
../../rtl/gte_mac0.vhd ^
../../rtl/gte_mac123.vhd ^
../../rtl/gte_UNRDivide.vhd ^
../../rtl/gte.vhd

vcom -quiet -work sim/tb ^
src/tb/tb.vhd

