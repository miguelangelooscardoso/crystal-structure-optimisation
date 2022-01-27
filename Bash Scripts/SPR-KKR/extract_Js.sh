#!/bin/bash
awk '
BEGIN{
  print "IQ JQ J_ij [meV]"
}
FNR>1 && /IQ =/{
  value=$6 OFS $12
  found=1
  next
}
found && NF && !/ ->Q/{
  if(value){
     print value OFS $NF
  }
  value=found=""
}' Fe2MnGe_JXC.out > test_new

