# mp3-player
a mp3 player developed on fpga(nexys 4 ddr)  
<pre>  
develop information:  
  OS          : Win10  
  language    : Verilog HDL  
  software    : Vivado 2016  
  developer   : Mion-ger Park
  update time : 2019-2-10
  version     : v 0.1.2
</pre>  

<pre>  
UPDATE 2019-2-4 v 0.1.2
  Add User Manual Part II
</pre>  

<pre>  
UPDATE 2019-2-3 v 0.1.1
  Add User Manual Part I
</pre>  

## User Manual  
### I.Config the midi file  
1.Tool Software : BmpToMif.exe  
[BmpToMif.exe Download URL](http://www.xdowns.com/soft/4/25/2013/Soft_113895.html "Download")  
2.Generate the Mif file    
![](https://github.com/Mionger/mp3-player/blob/master/ConfigMidFile.jpg)  
3.Click the "生成Mif文件"  
4.Generate the Mif file successfully  
![](https://github.com/Mionger/mp3-player/blob/master/ConfigMidFileSucceed.jpg)  
  
### II.Config the binary file  
1.Tool Software : Microsoft Excel   
2.Open the Mif file by Excel  
![](https://github.com/Mionger/mp3-player/blob/master/OpenExcel.jpg)  
3.Select the Column B  
![](https://github.com/Mionger/mp3-player/blob/master/SelectColumnB.jpg)  
4.Separate the Column by ':'  
![](https://github.com/Mionger/mp3-player/blob/master/Separate.jpg)  
![](https://github.com/Mionger/mp3-player/blob/master/Separate-1.jpg)  
![](https://github.com/Mionger/mp3-player/blob/master/Separate-2.jpg)  
5.Take place all the ';' with ','  
![](https://github.com/Mionger/mp3-player/blob/master/TakePlace.jpg)  
6.Save the file  
