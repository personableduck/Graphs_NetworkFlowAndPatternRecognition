global path_files filelist_all PATHNAME FILENAME;

path_files_old = path_files;
[file_1, path_files] = uigetfile({'*.*'},...
    'Select the image files to ANALYZE',path_files,'MultiSelect','on');
if (iscell(file_1)==0)&&(file_1(1)==0)
    path_files = path_files_old;
    fprintf('User did not select any files to process . . . . exiting\n');
    return;
end

read_dir = path_files;
single_image = ~iscell(file_1);
