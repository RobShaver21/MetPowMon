function errorLog(Path, failure)
if ~isempty(failure)
    ErrPath=[char(Path) '\error'];
    if ~isfolder(ErrPath)
        mkdir(ErrPath)
    end
    errlabel=[ErrPath '\Err_' datestr(now,'yyyymmdd_HHMMSS') '.mat'];
    save(errlabel,'failure');
end
end
