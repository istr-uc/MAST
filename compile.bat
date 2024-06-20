cd mast_analysis
gnatmake -gnat05 -gnato -I../utils mast_analysis
cd ..

cd gmast
cd src
gnatmake -gnat05 -Ic:/GtkAda/include/gtkada -I../../mast_analysis -I../../utils gmast_analysis -largs -lgtkada
cd ..
cd ..

cd gmastresults
cd src
gnatmake -gnat05 -Ic:/GtkAda/include/gtkada -I../../mast_analysis -I../../utils gmastresults -largs -lgtkada
cd ..
cd ..

cd mast_xml
gnatmake -gnat05 -I../mast_analysis -I../utils -aIc:/GNAT/2014/include/xmlada mast_xml_convert
gnatmake -gnat05 -I../mast_analysis -I../utils -aIc:/GNAT/2014/include/xmlada mast_xml_convert_results
cd ..

cd gmasteditor
cd src
gnatmake -gnat05 -Ic:/GtkAda/include/gtkada -I../../mast_analysis -I../../utils -I../../gmast/src -I../../gmastresults/src gmasteditor -largs -lgtkada
cd ..
cd ..

cd pt_editor
cd src
gnatmake -g -gnat05 -Ic:/GtkAda/include/gtkada -I../../mast_analysis -I../../utils gmast_pt_editor.adb -largs -lgtkada
cd ..
cd ..

cd to_mast2
gnatmake -g -I../utils to_mast2
cd ..
