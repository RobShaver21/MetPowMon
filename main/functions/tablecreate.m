function out=tablecreate(Typ,Header,Data,Footer)
import mlreportgen.report.*; import mlreportgen.dom.*
% small table
if Typ==1
     out = FormalTable(Header,Data,Footer);
        out.Width='100%';
        out.TableEntriesVAlign='middle';
        out.TableEntriesHAlign='center';
        out.Header.Style={Bold(true)};
        out.Header.RowSep='thick';
        out.Header.RowSepWidth = '1pt';
        out.Header.TableEntriesStyle={Height('1.08cm')};
        out.Footer.Style={Bold(true)};
        out.Footer.RowSep='thick';
        out.Footer.RowSepWidth='1pt';
        out.Body.TableEntriesStyle = {Height('0.55cm')};
% whole page table
elseif Typ==2
     out = FormalTable(Header,Data,Footer);
%         tablecom.Width='100%';
        out.TableEntriesVAlign='middle';
        out.TableEntriesHAlign='center';
%         tablecom.Body.TableEntriesStyle={Height('0.65cm')};
        out.Header.Style={Bold(true)};
        out.Header.RowSep='thick';
%         tablecom.Header.RowSepWidth='1.5','pts';
        out.Header.TableEntriesStyle={Height('0.65cm')};
        out.Footer.Style={Bold(true)};
        out.Footer.TableEntriesStyle={Height('0.65cm')};
        out.Footer.RowSep='thick';
%         tablecom.Footer.RowSepWidth='1.5','pts';
        out.Body.TableEntriesStyle = {Height('0.65cm')};
        out.Width='26.84 cm';
end
end