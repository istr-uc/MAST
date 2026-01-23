:: copy a binary Mast distribution from the buid folder
:: into a folder named "current"

:: This script is for gnat-native-13.2.2 with alire, gtkada-25.0.1 and
:: xmlada-22.0.0 used under alire 2.0.1. Other versions may require a
:: different set of DLLs, libraries or files to be copied

:: Set source and destination paths. Adjust as needed
set source_dir=C:\Users\Michael\Documents\prog\mast\mast_build\mast-src-1-6-0-0
set dest_dir=C:\Users\Michael\Documents\prog\mast-distributions\current

:: Set Gnat and Gtkada installation locations. Adjust as needed
set gnat_bin=C:\Users\Michael\AppData\Local\alire\cache\toolchains\gnat_native_13.2.2_88799c95\bin
set gtkada_location=C:\Users\Michael\AppData\Local\alire\cache\msys64\mingw64

:: ejecutables
copy %source_dir%\gmast\src\gmast_analysis.exe %dest_dir%
copy %source_dir%\gmasteditor\src\gmasteditor.exe %dest_dir%
copy %source_dir%\gmastresults\src\gmastresults.exe %dest_dir%
copy %source_dir%\mast_analysis\mast_analysis.exe %dest_dir%
copy %source_dir%\mast_xml\mast_xml_convert.exe %dest_dir%
copy %source_dir%\mast_xml\mast_xml_convert_results.exe %dest_dir%
copy %source_dir%\pt_editor\src\gmast_pt_editor.exe %dest_dir%
copy %source_dir%\to_mast2\to_mast2.exe %dest_dir%

:: batch scripts
copy %source_dir%\gmast\gmast.bat %dest_dir%
copy %source_dir%\pt_editor\gmast_pt_editor.bat %dest_dir%
copy %source_dir%\gmastresults\gmastresults.bat %dest_dir%
copy %source_dir%\gmasteditor\gmasteditor.bat %dest_dir%

:: gnat dlls
copy %gnat_bin%\*.dll  %dest_dir%

:: Gtkada dlls and libraries
mkdir %dest_dir%\bin
mkdir %dest_dir%\etc
mkdir %dest_dir%\lib
mkdir %dest_dir%\lib\gdk-pixbuf-2.0
mkdir %dest_dir%\lib\gtk-3.0
mkdir %dest_dir%\lib\glib-2.0
mkdir %dest_dir%\lib\gio
copy %gtkada_location%\bin\*.dll  %dest_dir%\bin
robocopy %gtkada_location%\etc  %dest_dir%\etc\ /e /np /ndl
robocopy %gtkada_location%\lib\gtk-3.0  %dest_dir%\lib\gtk-3.0\ /e /np /ndl
robocopy %gtkada_location%\lib\gdk-pixbuf-2.0  %dest_dir%\lib\gdk-pixbuf-2.0\ /e /np /ndl
robocopy %gtkada_location%\lib\glib-2.0  %dest_dir%\lib\glib-2.0\ /e /np /ndl
robocopy %gtkada_location%\lib\gio  %dest_dir%\lib\gio\ /e /np /ndl
robocopy %gtkada_location%\share\glib-2.0  %dest_dir%\share\glib-2.0\ /e /np /ndl

:: Icons
robocopy %gtkada_location%\share\icons  %dest_dir%\share\icons /e /np /ndl

:: documents and examples
copy %source_dir%\*.txt %dest_dir%
robocopy %source_dir%\docs %dest_dir%\docs\ /e /np /ndl
:: robocopy %source_dir%\examples %dest_dir%\examples\ /e /np /ndl
mkdir %dest_dir%\examples
copy %source_dir%\examples\*.txt %dest_dir%\examples

