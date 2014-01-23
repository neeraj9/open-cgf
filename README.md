open-cgf
========

3GPP-compliant Charging Gateway Function (CGF). Fork from Bruce open-cgf project.


This project provides a 3GPP-compliant Charging Gateway Function (CGF)
as a sink for SGSN/GGSN/etc streamed CDRs on the 3GPP Ga/Gz interface.
Refer 3GPP 32.295. These are common data elements of GSM/UMTS mobile
telephone networks.



The CDRs are streamed over the GTP' (GTP-prime) protocol, a subset of 
the main GPRS Tunnelling Protocol (GTP) protocol used between the SGSN
and GGSN.

open-cgf implements all the features of 32.295 although not all
SGSN/GGSNs implement, and therefore exercise, these features.
It is not yet clear if any CDFs (GGSNs/SGSNs/etc) implement the
special sequence number/duplicate-avoidance features described
in this standard.
