// »úÆ÷Âë  µØÖ·  »ã±àÖú¼Ç·û  ×¢ÊÍ
@00
 101_11000 //00 LOOP:LDA FN2 //load value in FN2 into accum
 0000_0001 
 110_11000 //02  STO TEMP //store accumulator in TEMP
 0000_0010
 010_11000 //04  ADD FN1  //add value in FN1 to accumulator
 0000_0000
 110_11000 //06  STO FN2  //store result in FN2
 0000_0001  
 101_11000 //08  VLDA TEMP //load TEMP into the accumulator
 0000_0010
 110_11000  //0a  STO FN1 //store accumulator in FN1
 0000_0000
 100_11000   //0c  XOR LIMIT //compare  accumlatoor to LIMIT
 0000_0011
 001_00000   //0e SKZ //if accum = 0 skip to DONE
 0000_0000
 111_00000  //10   JMP LOOP //jump to address of LOOP
 0000_0000
 000_00000   //12  DONE:HLT  //end of program
 0000_0000
