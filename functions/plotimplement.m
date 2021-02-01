function out=plotimplement(Type, plota,plotb)
arguments
    Type  double
    plota
    plotb = 1
end
import mlreportgen.report.*; import mlreportgen.dom.*
% Type 1 "Single Plot"
if Type==1
    out=Image(plota);
    out.Style = {ScaleToFit(true),HAlign('center')};
    out.Height = '9cm';
%Type 2 "Progplot"
elseif Type==2
        out=Image(plota);
        out.Style = {HAlign('center')};
        out.Width='16 cm';
        out.Height='5.75cm';
%Type 3 "Tiledplot"
elseif Type==3
    out=Image(plota); 
out.Style={Width('18.46cm'),Height('12.17cm')};
% Type 4 "Sidy by side plot"
elseif Type==4
        imgstyle={ScaleToFit(true)};
        Imga=Image([plota]);
        Imgb=Image([plotb]);
        
        Imga.Style=imgstyle;
        Imgb.Style=imgstyle;
        lot=Table({Imga,Imgb});
        lot.entry(1,1).Style = {Width('9.12cm'), Height('7.45 cm')};
%         lot.entry(1,2).Style = {Width('0.0001cm'), Height('7.45 cm')};
        lot.entry(1,2).Style = {Width('9.12cm'), Height('7.45 cm')};
        lot.Style = {Width('100%'), ResizeToFitContents(false)};
        out=lot;
% Type 5 " Whole page plot"
elseif Type==5
    out=Image([plota]);
    out.Style = {ScaleToFit(true),HAlign('center')};
    out.Width='26.02 cm';
    out.Height='15.61 cm';
end