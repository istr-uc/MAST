pragma Ada_95;
with System;
package ada_main is
   pragma Warnings (Off);

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2009 (20090519)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_test_xml_results" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure Break_Start;
   pragma Import (C, Break_Start, "__gnat_break_start");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#450b19fb#;
   u00002 : constant Version_32 := 16#6385d640#;
   u00003 : constant Version_32 := 16#4ea93bb8#;
   u00004 : constant Version_32 := 16#9c7dd3ea#;
   u00005 : constant Version_32 := 16#cc1134cf#;
   u00006 : constant Version_32 := 16#b061ea80#;
   u00007 : constant Version_32 := 16#8cddb9b3#;
   u00008 : constant Version_32 := 16#b9828a2f#;
   u00009 : constant Version_32 := 16#1bc9f0e1#;
   u00010 : constant Version_32 := 16#83f59500#;
   u00011 : constant Version_32 := 16#2f60aa04#;
   u00012 : constant Version_32 := 16#54367357#;
   u00013 : constant Version_32 := 16#e43c4f3d#;
   u00014 : constant Version_32 := 16#db404f38#;
   u00015 : constant Version_32 := 16#ebfc0b85#;
   u00016 : constant Version_32 := 16#eb103816#;
   u00017 : constant Version_32 := 16#63a35e59#;
   u00018 : constant Version_32 := 16#1f4497ab#;
   u00019 : constant Version_32 := 16#2ea84b20#;
   u00020 : constant Version_32 := 16#70dbc3e9#;
   u00021 : constant Version_32 := 16#18c4823a#;
   u00022 : constant Version_32 := 16#f5e3bedd#;
   u00023 : constant Version_32 := 16#bcda8803#;
   u00024 : constant Version_32 := 16#2720e926#;
   u00025 : constant Version_32 := 16#de4c8cc2#;
   u00026 : constant Version_32 := 16#633f84f7#;
   u00027 : constant Version_32 := 16#ba011fb9#;
   u00028 : constant Version_32 := 16#e3d85f73#;
   u00029 : constant Version_32 := 16#88c8686c#;
   u00030 : constant Version_32 := 16#c7aadac4#;
   u00031 : constant Version_32 := 16#6997f8be#;
   u00032 : constant Version_32 := 16#00b27d4a#;
   u00033 : constant Version_32 := 16#430c6fe5#;
   u00034 : constant Version_32 := 16#08a5f9f2#;
   u00035 : constant Version_32 := 16#b33118c1#;
   u00036 : constant Version_32 := 16#776b72d1#;
   u00037 : constant Version_32 := 16#37465730#;
   u00038 : constant Version_32 := 16#906233be#;
   u00039 : constant Version_32 := 16#18d15f2a#;
   u00040 : constant Version_32 := 16#a69cad5c#;
   u00041 : constant Version_32 := 16#093802d2#;
   u00042 : constant Version_32 := 16#90421990#;
   u00043 : constant Version_32 := 16#fe5e1c6e#;
   u00044 : constant Version_32 := 16#259b6760#;
   u00045 : constant Version_32 := 16#892f4d5b#;
   u00046 : constant Version_32 := 16#6f3f77bb#;
   u00047 : constant Version_32 := 16#eccbd1ca#;
   u00048 : constant Version_32 := 16#3c09e836#;
   u00049 : constant Version_32 := 16#0bae7056#;
   u00050 : constant Version_32 := 16#668486d6#;
   u00051 : constant Version_32 := 16#ec7a3063#;
   u00052 : constant Version_32 := 16#9eb1f784#;
   u00053 : constant Version_32 := 16#a70c0a76#;
   u00054 : constant Version_32 := 16#0a7e05c0#;
   u00055 : constant Version_32 := 16#04fd4e8a#;
   u00056 : constant Version_32 := 16#647de85b#;
   u00057 : constant Version_32 := 16#a23322db#;
   u00058 : constant Version_32 := 16#0d0a8d0c#;
   u00059 : constant Version_32 := 16#d9dbe86c#;
   u00060 : constant Version_32 := 16#895f8c1e#;
   u00061 : constant Version_32 := 16#9d76bf9a#;
   u00062 : constant Version_32 := 16#4e66f673#;
   u00063 : constant Version_32 := 16#d0d51bbe#;
   u00064 : constant Version_32 := 16#a8d17654#;
   u00065 : constant Version_32 := 16#62e56d2b#;
   u00066 : constant Version_32 := 16#ced5a363#;
   u00067 : constant Version_32 := 16#f972a97f#;
   u00068 : constant Version_32 := 16#f1de4b60#;
   u00069 : constant Version_32 := 16#ab1aeb7b#;
   u00070 : constant Version_32 := 16#1a3a7ed3#;
   u00071 : constant Version_32 := 16#37a7e042#;
   u00072 : constant Version_32 := 16#6d0998e1#;
   u00073 : constant Version_32 := 16#f2b1549d#;
   u00074 : constant Version_32 := 16#a0a00019#;
   u00075 : constant Version_32 := 16#f2351593#;
   u00076 : constant Version_32 := 16#293ff6f7#;
   u00077 : constant Version_32 := 16#8d087e6b#;
   u00078 : constant Version_32 := 16#2461b049#;
   u00079 : constant Version_32 := 16#0aa29e81#;
   u00080 : constant Version_32 := 16#2274d34a#;
   u00081 : constant Version_32 := 16#59507545#;
   u00082 : constant Version_32 := 16#e98c0dd7#;
   u00083 : constant Version_32 := 16#347f6220#;
   u00084 : constant Version_32 := 16#a0aa86d6#;
   u00085 : constant Version_32 := 16#cc47afb0#;
   u00086 : constant Version_32 := 16#4b4a95e1#;
   u00087 : constant Version_32 := 16#54a6bf64#;
   u00088 : constant Version_32 := 16#4be846ff#;
   u00089 : constant Version_32 := 16#e42a19e8#;
   u00090 : constant Version_32 := 16#2413d3e5#;
   u00091 : constant Version_32 := 16#a69fe202#;
   u00092 : constant Version_32 := 16#e74032b2#;
   u00093 : constant Version_32 := 16#03341198#;
   u00094 : constant Version_32 := 16#208afe59#;
   u00095 : constant Version_32 := 16#cc1b1855#;
   u00096 : constant Version_32 := 16#e86844d5#;
   u00097 : constant Version_32 := 16#a7af1709#;
   u00098 : constant Version_32 := 16#b5b04024#;
   u00099 : constant Version_32 := 16#80e564ae#;
   u00100 : constant Version_32 := 16#bedd66da#;
   u00101 : constant Version_32 := 16#2e049fe9#;
   u00102 : constant Version_32 := 16#5ba0ecc2#;
   u00103 : constant Version_32 := 16#e0f8ecf6#;
   u00104 : constant Version_32 := 16#9698a733#;
   u00105 : constant Version_32 := 16#e5e412cb#;
   u00106 : constant Version_32 := 16#d04a0779#;
   u00107 : constant Version_32 := 16#eff31f01#;
   u00108 : constant Version_32 := 16#8535bfda#;
   u00109 : constant Version_32 := 16#44ed77f3#;
   u00110 : constant Version_32 := 16#cb2faecd#;
   u00111 : constant Version_32 := 16#3407344a#;
   u00112 : constant Version_32 := 16#56f013ce#;
   u00113 : constant Version_32 := 16#3a4fe8af#;
   u00114 : constant Version_32 := 16#30a049ba#;
   u00115 : constant Version_32 := 16#b8ac4cbc#;
   u00116 : constant Version_32 := 16#2f3f02be#;
   u00117 : constant Version_32 := 16#8d02aab0#;
   u00118 : constant Version_32 := 16#597d27ff#;
   u00119 : constant Version_32 := 16#6328cde3#;
   u00120 : constant Version_32 := 16#3e7d115b#;
   u00121 : constant Version_32 := 16#8ea69b38#;
   u00122 : constant Version_32 := 16#9b936ce6#;
   u00123 : constant Version_32 := 16#b71924cc#;
   u00124 : constant Version_32 := 16#a32a7c04#;
   u00125 : constant Version_32 := 16#193c09ed#;
   u00126 : constant Version_32 := 16#6733af53#;
   u00127 : constant Version_32 := 16#e0683b80#;
   u00128 : constant Version_32 := 16#c427120b#;
   u00129 : constant Version_32 := 16#f69145f6#;
   u00130 : constant Version_32 := 16#70f768a2#;
   u00131 : constant Version_32 := 16#f0ddc3f6#;
   u00132 : constant Version_32 := 16#4e6c3190#;
   u00133 : constant Version_32 := 16#54ed61ee#;
   u00134 : constant Version_32 := 16#28e6e53e#;
   u00135 : constant Version_32 := 16#09994ec9#;
   u00136 : constant Version_32 := 16#bfc8af92#;
   u00137 : constant Version_32 := 16#c108749f#;
   u00138 : constant Version_32 := 16#86a2b7a2#;
   u00139 : constant Version_32 := 16#e2557a70#;
   u00140 : constant Version_32 := 16#7de76a78#;
   u00141 : constant Version_32 := 16#5434ff70#;
   u00142 : constant Version_32 := 16#7903ab8c#;
   u00143 : constant Version_32 := 16#21fd2bc3#;
   u00144 : constant Version_32 := 16#dd19c62c#;
   u00145 : constant Version_32 := 16#6ccb35ac#;
   u00146 : constant Version_32 := 16#0255db5c#;
   u00147 : constant Version_32 := 16#7488863c#;
   u00148 : constant Version_32 := 16#294c3b74#;
   u00149 : constant Version_32 := 16#51c79cd2#;
   u00150 : constant Version_32 := 16#cd97344a#;
   u00151 : constant Version_32 := 16#54d2b04c#;
   u00152 : constant Version_32 := 16#4335d45d#;
   u00153 : constant Version_32 := 16#513f871f#;
   u00154 : constant Version_32 := 16#96364b59#;
   u00155 : constant Version_32 := 16#b7cb9d58#;
   u00156 : constant Version_32 := 16#7b3aa22a#;
   u00157 : constant Version_32 := 16#3f823fa7#;
   u00158 : constant Version_32 := 16#32c5ff05#;
   u00159 : constant Version_32 := 16#dc280e99#;
   u00160 : constant Version_32 := 16#f88b41f4#;
   u00161 : constant Version_32 := 16#aec1acd7#;
   u00162 : constant Version_32 := 16#949cc1b5#;
   u00163 : constant Version_32 := 16#a90a12b0#;
   u00164 : constant Version_32 := 16#1c384a3b#;
   u00165 : constant Version_32 := 16#fa8631cb#;
   u00166 : constant Version_32 := 16#cee5f48f#;
   u00167 : constant Version_32 := 16#e94c8be6#;
   u00168 : constant Version_32 := 16#2f6f8874#;
   u00169 : constant Version_32 := 16#fd04e10c#;
   u00170 : constant Version_32 := 16#234291c4#;
   u00171 : constant Version_32 := 16#c2480f99#;
   u00172 : constant Version_32 := 16#d8d3cd9b#;
   u00173 : constant Version_32 := 16#b4090306#;
   u00174 : constant Version_32 := 16#e03c9abf#;
   u00175 : constant Version_32 := 16#bd936d3a#;
   u00176 : constant Version_32 := 16#014e4b85#;
   u00177 : constant Version_32 := 16#2b6bce66#;
   u00178 : constant Version_32 := 16#1295b287#;
   u00179 : constant Version_32 := 16#e9ea32ea#;
   u00180 : constant Version_32 := 16#1dd67620#;
   u00181 : constant Version_32 := 16#1dc9628f#;
   u00182 : constant Version_32 := 16#c828ab15#;
   u00183 : constant Version_32 := 16#e7bd2fd0#;
   u00184 : constant Version_32 := 16#9b932485#;
   u00185 : constant Version_32 := 16#e6bedf82#;
   u00186 : constant Version_32 := 16#67c04acb#;
   u00187 : constant Version_32 := 16#1943edd0#;
   u00188 : constant Version_32 := 16#ce457e04#;
   u00189 : constant Version_32 := 16#56f32777#;
   u00190 : constant Version_32 := 16#f0c44a1c#;
   u00191 : constant Version_32 := 16#b8b3dabd#;
   u00192 : constant Version_32 := 16#d308a9e1#;
   u00193 : constant Version_32 := 16#631c394c#;
   u00194 : constant Version_32 := 16#ea244b1b#;
   u00195 : constant Version_32 := 16#d298b95e#;
   u00196 : constant Version_32 := 16#a2dae789#;
   u00197 : constant Version_32 := 16#47ac261d#;
   u00198 : constant Version_32 := 16#f36e1b7b#;
   u00199 : constant Version_32 := 16#1de8e3df#;
   u00200 : constant Version_32 := 16#968ca55f#;
   u00201 : constant Version_32 := 16#d4c66e62#;
   u00202 : constant Version_32 := 16#f918e65d#;
   u00203 : constant Version_32 := 16#c017af94#;
   u00204 : constant Version_32 := 16#edf7636b#;
   u00205 : constant Version_32 := 16#a4a57e98#;
   u00206 : constant Version_32 := 16#5a6d7de6#;
   u00207 : constant Version_32 := 16#0b21cba1#;
   u00208 : constant Version_32 := 16#408ff843#;
   u00209 : constant Version_32 := 16#10cbaf8e#;
   u00210 : constant Version_32 := 16#ef4f1b4e#;
   u00211 : constant Version_32 := 16#3b387f22#;
   u00212 : constant Version_32 := 16#82bd3c91#;
   u00213 : constant Version_32 := 16#01f219a3#;
   u00214 : constant Version_32 := 16#e8b23d46#;
   u00215 : constant Version_32 := 16#4ed199cf#;
   u00216 : constant Version_32 := 16#142dcdac#;
   u00217 : constant Version_32 := 16#9ab468d6#;
   u00218 : constant Version_32 := 16#ae4091a8#;
   u00219 : constant Version_32 := 16#433495b0#;
   u00220 : constant Version_32 := 16#902c8c9b#;
   u00221 : constant Version_32 := 16#06f155c4#;
   u00222 : constant Version_32 := 16#6fb1a820#;
   u00223 : constant Version_32 := 16#db8ea5fa#;
   u00224 : constant Version_32 := 16#6f3d9f27#;
   u00225 : constant Version_32 := 16#9dae5d36#;
   u00226 : constant Version_32 := 16#f6b5c89b#;
   u00227 : constant Version_32 := 16#8e376119#;
   u00228 : constant Version_32 := 16#e1d7d7ea#;
   u00229 : constant Version_32 := 16#2a1392ed#;
   u00230 : constant Version_32 := 16#a01d2cc0#;
   u00231 : constant Version_32 := 16#0f9cf33a#;
   u00232 : constant Version_32 := 16#f9724488#;
   u00233 : constant Version_32 := 16#bf442fe5#;
   u00234 : constant Version_32 := 16#4da1e502#;
   u00235 : constant Version_32 := 16#cabd62d0#;
   u00236 : constant Version_32 := 16#1ab87276#;
   u00237 : constant Version_32 := 16#b7e8ed78#;
   u00238 : constant Version_32 := 16#34be3dd7#;
   u00239 : constant Version_32 := 16#5c2d19ce#;
   u00240 : constant Version_32 := 16#dc80ce83#;
   u00241 : constant Version_32 := 16#9a61d341#;
   u00242 : constant Version_32 := 16#00cddc83#;
   u00243 : constant Version_32 := 16#22c3f06a#;
   u00244 : constant Version_32 := 16#336304c9#;
   u00245 : constant Version_32 := 16#3c830d26#;
   u00246 : constant Version_32 := 16#9367a012#;
   u00247 : constant Version_32 := 16#edd6a855#;
   u00248 : constant Version_32 := 16#a8172975#;
   u00249 : constant Version_32 := 16#ccee7ab7#;
   u00250 : constant Version_32 := 16#00b53300#;
   u00251 : constant Version_32 := 16#3ff52070#;
   u00252 : constant Version_32 := 16#4d0eddc4#;
   u00253 : constant Version_32 := 16#0fec0e36#;
   u00254 : constant Version_32 := 16#6e7b30ec#;
   u00255 : constant Version_32 := 16#79c173c0#;
   u00256 : constant Version_32 := 16#538aa3ce#;
   u00257 : constant Version_32 := 16#01c25b85#;
   u00258 : constant Version_32 := 16#961f663a#;
   u00259 : constant Version_32 := 16#cf072bd6#;
   u00260 : constant Version_32 := 16#03cab32a#;
   u00261 : constant Version_32 := 16#1d5b9691#;
   u00262 : constant Version_32 := 16#574486f2#;
   u00263 : constant Version_32 := 16#836d18cc#;
   u00264 : constant Version_32 := 16#7800d564#;
   u00265 : constant Version_32 := 16#a59f9397#;
   u00266 : constant Version_32 := 16#d4ed45d6#;
   u00267 : constant Version_32 := 16#612dc7e0#;
   u00268 : constant Version_32 := 16#4cd3952f#;
   u00269 : constant Version_32 := 16#8a383d70#;
   u00270 : constant Version_32 := 16#ac16fc09#;
   u00271 : constant Version_32 := 16#79ee29d5#;
   u00272 : constant Version_32 := 16#10063d24#;
   u00273 : constant Version_32 := 16#50d8f9aa#;
   u00274 : constant Version_32 := 16#d0831272#;
   u00275 : constant Version_32 := 16#e60e90c1#;
   u00276 : constant Version_32 := 16#1a658b0a#;
   u00277 : constant Version_32 := 16#16b4410a#;
   u00278 : constant Version_32 := 16#2c1b1d9b#;
   u00279 : constant Version_32 := 16#4adc552f#;
   u00280 : constant Version_32 := 16#152a7618#;
   u00281 : constant Version_32 := 16#a03068d2#;
   u00282 : constant Version_32 := 16#f007c6cf#;
   u00283 : constant Version_32 := 16#2b2bb0f7#;
   u00284 : constant Version_32 := 16#19d9e791#;
   u00285 : constant Version_32 := 16#77d3fba7#;
   u00286 : constant Version_32 := 16#a03e7b50#;
   u00287 : constant Version_32 := 16#5bbbdddc#;
   u00288 : constant Version_32 := 16#6afd38f4#;
   u00289 : constant Version_32 := 16#df417b21#;
   u00290 : constant Version_32 := 16#24646e3a#;
   u00291 : constant Version_32 := 16#b938b2e0#;
   u00292 : constant Version_32 := 16#9f8043b5#;
   u00293 : constant Version_32 := 16#8f3a274b#;
   u00294 : constant Version_32 := 16#602aee82#;
   u00295 : constant Version_32 := 16#8d055049#;
   u00296 : constant Version_32 := 16#015e51c8#;
   u00297 : constant Version_32 := 16#0a1c48f4#;
   u00298 : constant Version_32 := 16#e174509a#;
   u00299 : constant Version_32 := 16#fafc6bfb#;
   u00300 : constant Version_32 := 16#0dd71151#;
   u00301 : constant Version_32 := 16#d77c4487#;
   u00302 : constant Version_32 := 16#db82e72c#;
   u00303 : constant Version_32 := 16#ff3715b9#;
   u00304 : constant Version_32 := 16#1acf23d5#;
   u00305 : constant Version_32 := 16#cc08a0dd#;
   u00306 : constant Version_32 := 16#17fcd68b#;
   u00307 : constant Version_32 := 16#838cc5ef#;
   u00308 : constant Version_32 := 16#10716e67#;
   u00309 : constant Version_32 := 16#5fc62fdc#;
   u00310 : constant Version_32 := 16#b8019398#;
   u00311 : constant Version_32 := 16#96410e68#;
   u00312 : constant Version_32 := 16#e1359b0c#;
   u00313 : constant Version_32 := 16#d5a02e1c#;
   u00314 : constant Version_32 := 16#e227ff7f#;
   u00315 : constant Version_32 := 16#b35739f5#;
   u00316 : constant Version_32 := 16#8400c131#;
   u00317 : constant Version_32 := 16#afdcbcd6#;
   u00318 : constant Version_32 := 16#5fc93677#;
   u00319 : constant Version_32 := 16#6159b8c4#;
   u00320 : constant Version_32 := 16#a8ab9cfd#;
   u00321 : constant Version_32 := 16#5d710dd6#;
   u00322 : constant Version_32 := 16#c4117dcd#;
   u00323 : constant Version_32 := 16#1ef1af99#;
   u00324 : constant Version_32 := 16#a41c7812#;
   u00325 : constant Version_32 := 16#7038fb28#;
   u00326 : constant Version_32 := 16#1cf5be94#;
   u00327 : constant Version_32 := 16#3fdf08af#;
   u00328 : constant Version_32 := 16#6e1aed03#;
   u00329 : constant Version_32 := 16#648c8681#;
   u00330 : constant Version_32 := 16#f549517d#;
   u00331 : constant Version_32 := 16#31d070cb#;
   u00332 : constant Version_32 := 16#1da1ef01#;
   u00333 : constant Version_32 := 16#c83f10ec#;
   u00334 : constant Version_32 := 16#8cfac485#;
   u00335 : constant Version_32 := 16#7e93ed41#;
   u00336 : constant Version_32 := 16#457693b3#;

   pragma Export (C, u00001, "test_xml_resultsB");
   pragma Export (C, u00002, "system__standard_libraryB");
   pragma Export (C, u00003, "system__standard_libraryS");
   pragma Export (C, u00004, "adaS");
   pragma Export (C, u00005, "ada__charactersS");
   pragma Export (C, u00006, "ada__characters__handlingB");
   pragma Export (C, u00007, "ada__characters__handlingS");
   pragma Export (C, u00008, "ada__characters__latin_1S");
   pragma Export (C, u00009, "ada__stringsS");
   pragma Export (C, u00010, "systemS");
   pragma Export (C, u00011, "system__exception_tableB");
   pragma Export (C, u00012, "system__exception_tableS");
   pragma Export (C, u00013, "system__htableB");
   pragma Export (C, u00014, "system__htableS");
   pragma Export (C, u00015, "system__string_hashB");
   pragma Export (C, u00016, "system__string_hashS");
   pragma Export (C, u00017, "system__soft_linksB");
   pragma Export (C, u00018, "system__soft_linksS");
   pragma Export (C, u00019, "system__parametersB");
   pragma Export (C, u00020, "system__parametersS");
   pragma Export (C, u00021, "system__secondary_stackB");
   pragma Export (C, u00022, "system__secondary_stackS");
   pragma Export (C, u00023, "system__storage_elementsB");
   pragma Export (C, u00024, "system__storage_elementsS");
   pragma Export (C, u00025, "ada__exceptionsB");
   pragma Export (C, u00026, "ada__exceptionsS");
   pragma Export (C, u00027, "ada__exceptions__last_chance_handlerB");
   pragma Export (C, u00028, "ada__exceptions__last_chance_handlerS");
   pragma Export (C, u00029, "system__exceptionsB");
   pragma Export (C, u00030, "system__exceptionsS");
   pragma Export (C, u00031, "system__tracebackB");
   pragma Export (C, u00032, "system__tracebackS");
   pragma Export (C, u00033, "system__unsigned_typesS");
   pragma Export (C, u00034, "system__wch_conB");
   pragma Export (C, u00035, "system__wch_conS");
   pragma Export (C, u00036, "system__wch_stwB");
   pragma Export (C, u00037, "system__wch_stwS");
   pragma Export (C, u00038, "system__wch_cnvB");
   pragma Export (C, u00039, "system__wch_cnvS");
   pragma Export (C, u00040, "interfacesS");
   pragma Export (C, u00041, "system__wch_jisB");
   pragma Export (C, u00042, "system__wch_jisS");
   pragma Export (C, u00043, "system__traceback_entriesB");
   pragma Export (C, u00044, "system__traceback_entriesS");
   pragma Export (C, u00045, "system__stack_checkingB");
   pragma Export (C, u00046, "system__stack_checkingS");
   pragma Export (C, u00047, "ada__strings__mapsB");
   pragma Export (C, u00048, "ada__strings__mapsS");
   pragma Export (C, u00049, "system__bit_opsB");
   pragma Export (C, u00050, "system__bit_opsS");
   pragma Export (C, u00051, "ada__strings__maps__constantsS");
   pragma Export (C, u00052, "ada__command_lineB");
   pragma Export (C, u00053, "ada__command_lineS");
   pragma Export (C, u00054, "ada__tagsB");
   pragma Export (C, u00055, "ada__tagsS");
   pragma Export (C, u00056, "system__val_unsB");
   pragma Export (C, u00057, "system__val_unsS");
   pragma Export (C, u00058, "system__val_utilB");
   pragma Export (C, u00059, "system__val_utilS");
   pragma Export (C, u00060, "system__case_utilB");
   pragma Export (C, u00061, "system__case_utilS");
   pragma Export (C, u00062, "ada__text_ioB");
   pragma Export (C, u00063, "ada__text_ioS");
   pragma Export (C, u00064, "ada__streamsS");
   pragma Export (C, u00065, "interfaces__c_streamsB");
   pragma Export (C, u00066, "interfaces__c_streamsS");
   pragma Export (C, u00067, "system__crtlS");
   pragma Export (C, u00068, "system__file_ioB");
   pragma Export (C, u00069, "system__file_ioS");
   pragma Export (C, u00070, "ada__finalizationB");
   pragma Export (C, u00071, "ada__finalizationS");
   pragma Export (C, u00072, "system__finalization_rootB");
   pragma Export (C, u00073, "system__finalization_rootS");
   pragma Export (C, u00074, "system__finalization_implementationB");
   pragma Export (C, u00075, "system__finalization_implementationS");
   pragma Export (C, u00076, "system__restrictionsB");
   pragma Export (C, u00077, "system__restrictionsS");
   pragma Export (C, u00078, "system__stream_attributesB");
   pragma Export (C, u00079, "system__stream_attributesS");
   pragma Export (C, u00080, "ada__io_exceptionsS");
   pragma Export (C, u00081, "interfaces__cB");
   pragma Export (C, u00082, "interfaces__cS");
   pragma Export (C, u00083, "system__os_libB");
   pragma Export (C, u00084, "system__os_libS");
   pragma Export (C, u00085, "system__stringsB");
   pragma Export (C, u00086, "system__stringsS");
   pragma Export (C, u00087, "system__file_control_blockS");
   pragma Export (C, u00088, "ada__finalization__list_controllerB");
   pragma Export (C, u00089, "ada__finalization__list_controllerS");
   pragma Export (C, u00090, "mastB");
   pragma Export (C, u00091, "mastS");
   pragma Export (C, u00092, "system__fat_lfltS");
   pragma Export (C, u00093, "var_stringsB");
   pragma Export (C, u00094, "var_stringsS");
   pragma Export (C, u00095, "system__compare_array_unsigned_8B");
   pragma Export (C, u00096, "system__compare_array_unsigned_8S");
   pragma Export (C, u00097, "system__address_operationsB");
   pragma Export (C, u00098, "system__address_operationsS");
   pragma Export (C, u00099, "system__concat_2B");
   pragma Export (C, u00100, "system__concat_2S");
   pragma Export (C, u00101, "mast__systemsB");
   pragma Export (C, u00102, "mast__systemsS");
   pragma Export (C, u00103, "mast__processing_resourcesB");
   pragma Export (C, u00104, "mast__processing_resourcesS");
   pragma Export (C, u00105, "mast__ioB");
   pragma Export (C, u00106, "mast__ioS");
   pragma Export (C, u00107, "ada__calendarB");
   pragma Export (C, u00108, "ada__calendarS");
   pragma Export (C, u00109, "system__os_primitivesB");
   pragma Export (C, u00110, "system__os_primitivesS");
   pragma Export (C, u00111, "ada__float_text_ioB");
   pragma Export (C, u00112, "ada__float_text_ioS");
   pragma Export (C, u00113, "ada__text_io__float_auxB");
   pragma Export (C, u00114, "ada__text_io__float_auxS");
   pragma Export (C, u00115, "ada__text_io__generic_auxB");
   pragma Export (C, u00116, "ada__text_io__generic_auxS");
   pragma Export (C, u00117, "system__img_realB");
   pragma Export (C, u00118, "system__img_realS");
   pragma Export (C, u00119, "system__fat_llfS");
   pragma Export (C, u00120, "system__img_lluB");
   pragma Export (C, u00121, "system__img_lluS");
   pragma Export (C, u00122, "system__img_unsB");
   pragma Export (C, u00123, "system__img_unsS");
   pragma Export (C, u00124, "system__powten_tableS");
   pragma Export (C, u00125, "system__val_realB");
   pragma Export (C, u00126, "system__val_realS");
   pragma Export (C, u00127, "system__exn_llfB");
   pragma Export (C, u00128, "system__exn_llfS");
   pragma Export (C, u00129, "system__fat_fltS");
   pragma Export (C, u00130, "ada__strings__fixedB");
   pragma Export (C, u00131, "ada__strings__fixedS");
   pragma Export (C, u00132, "ada__strings__searchB");
   pragma Export (C, u00133, "ada__strings__searchS");
   pragma Export (C, u00134, "binary_treesB");
   pragma Export (C, u00135, "binary_treesS");
   pragma Export (C, u00136, "mast_parser_tokensS");
   pragma Export (C, u00137, "symbol_tableB");
   pragma Export (C, u00138, "symbol_tableS");
   pragma Export (C, u00139, "list_exceptionsS");
   pragma Export (C, u00140, "named_listsB");
   pragma Export (C, u00141, "named_listsS");
   pragma Export (C, u00142, "system__concat_3B");
   pragma Export (C, u00143, "system__concat_3S");
   pragma Export (C, u00144, "system__img_enum_newB");
   pragma Export (C, u00145, "system__img_enum_newS");
   pragma Export (C, u00146, "system__img_intB");
   pragma Export (C, u00147, "system__img_intS");
   pragma Export (C, u00148, "system__val_intB");
   pragma Export (C, u00149, "system__val_intS");
   pragma Export (C, u00150, "system__fat_sfltS");
   pragma Export (C, u00151, "mast__resultsB");
   pragma Export (C, u00152, "mast__resultsS");
   pragma Export (C, u00153, "mast__graphsB");
   pragma Export (C, u00154, "mast__graphsS");
   pragma Export (C, u00155, "indexed_listsB");
   pragma Export (C, u00156, "indexed_listsS");
   pragma Export (C, u00157, "mast__eventsB");
   pragma Export (C, u00158, "mast__eventsS");
   pragma Export (C, u00159, "system__strings__stream_opsB");
   pragma Export (C, u00160, "system__strings__stream_opsS");
   pragma Export (C, u00161, "ada__streams__stream_ioB");
   pragma Export (C, u00162, "ada__streams__stream_ioS");
   pragma Export (C, u00163, "mast__graphs__linksB");
   pragma Export (C, u00164, "mast__graphs__linksS");
   pragma Export (C, u00165, "system__concat_4B");
   pragma Export (C, u00166, "system__concat_4S");
   pragma Export (C, u00167, "mast__timing_requirementsB");
   pragma Export (C, u00168, "mast__timing_requirementsS");
   pragma Export (C, u00169, "hash_listsB");
   pragma Export (C, u00170, "hash_listsS");
   pragma Export (C, u00171, "mast__scheduling_parametersB");
   pragma Export (C, u00172, "mast__scheduling_parametersS");
   pragma Export (C, u00173, "mast__synchronization_parametersB");
   pragma Export (C, u00174, "mast__synchronization_parametersS");
   pragma Export (C, u00175, "mast__processing_resources__networkB");
   pragma Export (C, u00176, "mast__processing_resources__networkS");
   pragma Export (C, u00177, "mast__scheduling_serversB");
   pragma Export (C, u00178, "mast__scheduling_serversS");
   pragma Export (C, u00179, "mast__schedulersB");
   pragma Export (C, u00180, "mast__schedulersS");
   pragma Export (C, u00181, "mast__scheduling_policiesB");
   pragma Export (C, u00182, "mast__scheduling_policiesS");
   pragma Export (C, u00183, "mast__schedulers__primaryB");
   pragma Export (C, u00184, "mast__schedulers__primaryS");
   pragma Export (C, u00185, "system__concat_5B");
   pragma Export (C, u00186, "system__concat_5S");
   pragma Export (C, u00187, "mast__schedulers__secondaryB");
   pragma Export (C, u00188, "mast__schedulers__secondaryS");
   pragma Export (C, u00189, "mast__driversB");
   pragma Export (C, u00190, "mast__driversS");
   pragma Export (C, u00191, "mast__operationsB");
   pragma Export (C, u00192, "mast__operationsS");
   pragma Export (C, u00193, "mast__shared_resourcesB");
   pragma Export (C, u00194, "mast__shared_resourcesS");
   pragma Export (C, u00195, "mast__schedulers__adjustmentB");
   pragma Export (C, u00196, "mast__schedulers__adjustmentS");
   pragma Export (C, u00197, "mast__processing_resources__processorB");
   pragma Export (C, u00198, "mast__processing_resources__processorS");
   pragma Export (C, u00199, "mast__timersB");
   pragma Export (C, u00200, "mast__timersS");
   pragma Export (C, u00201, "mast__transactionsB");
   pragma Export (C, u00202, "mast__transactionsS");
   pragma Export (C, u00203, "mast__graphs__event_handlersB");
   pragma Export (C, u00204, "mast__graphs__event_handlersS");
   pragma Export (C, u00205, "mast_parserB");
   pragma Export (C, u00206, "mast_lexB");
   pragma Export (C, u00207, "mast_lexS");
   pragma Export (C, u00208, "mast_lex_dfaB");
   pragma Export (C, u00209, "mast_lex_dfaS");
   pragma Export (C, u00210, "mast_lex_ioB");
   pragma Export (C, u00211, "mast_lex_ioS");
   pragma Export (C, u00212, "text_ioS");
   pragma Export (C, u00213, "mast_parser_error_reportB");
   pragma Export (C, u00214, "mast_parser_error_reportS");
   pragma Export (C, u00215, "system__concat_8B");
   pragma Export (C, u00216, "system__concat_8S");
   pragma Export (C, u00217, "system__concat_7B");
   pragma Export (C, u00218, "system__concat_7S");
   pragma Export (C, u00219, "system__concat_6B");
   pragma Export (C, u00220, "system__concat_6S");
   pragma Export (C, u00221, "mast_parser_gotoS");
   pragma Export (C, u00222, "mast_parser_shift_reduceS");
   pragma Export (C, u00223, "mast_put_resultsB");
   pragma Export (C, u00224, "mast_results_parserB");
   pragma Export (C, u00225, "mast_results_lexB");
   pragma Export (C, u00226, "mast_results_lexS");
   pragma Export (C, u00227, "mast_results_lex_dfaB");
   pragma Export (C, u00228, "mast_results_lex_dfaS");
   pragma Export (C, u00229, "mast_results_lex_ioB");
   pragma Export (C, u00230, "mast_results_lex_ioS");
   pragma Export (C, u00231, "mast_results_parser_tokensS");
   pragma Export (C, u00232, "mast_results_parser_error_reportB");
   pragma Export (C, u00233, "mast_results_parser_error_reportS");
   pragma Export (C, u00234, "mast_results_parser_gotoS");
   pragma Export (C, u00235, "mast_results_parser_shift_reduceS");
   pragma Export (C, u00236, "mast_xml_exceptionsB");
   pragma Export (C, u00237, "mast_xml_exceptionsS");
   pragma Export (C, u00238, "mast_xml_parserB");
   pragma Export (C, u00239, "mast_xml_parserS");
   pragma Export (C, u00240, "ada__strings__unboundedB");
   pragma Export (C, u00241, "ada__strings__unboundedS");
   pragma Export (C, u00242, "domS");
   pragma Export (C, u00243, "dom__coreB");
   pragma Export (C, u00244, "dom__coreS");
   pragma Export (C, u00245, "saxS");
   pragma Export (C, u00246, "sax__encodingsS");
   pragma Export (C, u00247, "unicodeB");
   pragma Export (C, u00248, "unicodeS");
   pragma Export (C, u00249, "unicode__namesS");
   pragma Export (C, u00250, "unicode__names__basic_latinS");
   pragma Export (C, u00251, "unicode__cesB");
   pragma Export (C, u00252, "unicode__cesS");
   pragma Export (C, u00253, "unicode__ces__utf32B");
   pragma Export (C, u00254, "unicode__ces__utf32S");
   pragma Export (C, u00255, "unicode__ccsB");
   pragma Export (C, u00256, "unicode__ccsS");
   pragma Export (C, u00257, "unicode__ces__utf8B");
   pragma Export (C, u00258, "unicode__ces__utf8S");
   pragma Export (C, u00259, "sax__htableB");
   pragma Export (C, u00260, "sax__htableS");
   pragma Export (C, u00261, "dom__core__attrsB");
   pragma Export (C, u00262, "dom__core__attrsS");
   pragma Export (C, u00263, "dom__core__nodesB");
   pragma Export (C, u00264, "dom__core__nodesS");
   pragma Export (C, u00265, "ada__text_io__text_streamsB");
   pragma Export (C, u00266, "ada__text_io__text_streamsS");
   pragma Export (C, u00267, "unicode__encodingsB");
   pragma Export (C, u00268, "unicode__encodingsS");
   pragma Export (C, u00269, "unicode__ccs__iso_8859_1B");
   pragma Export (C, u00270, "unicode__ccs__iso_8859_1S");
   pragma Export (C, u00271, "unicode__ccs__iso_8859_15B");
   pragma Export (C, u00272, "unicode__ccs__iso_8859_15S");
   pragma Export (C, u00273, "unicode__names__currency_symbolsS");
   pragma Export (C, u00274, "unicode__names__latin_1_supplementS");
   pragma Export (C, u00275, "unicode__names__latin_extended_aS");
   pragma Export (C, u00276, "unicode__ccs__iso_8859_2B");
   pragma Export (C, u00277, "unicode__ccs__iso_8859_2S");
   pragma Export (C, u00278, "unicode__names__spacing_modifier_lettersS");
   pragma Export (C, u00279, "unicode__ccs__iso_8859_3B");
   pragma Export (C, u00280, "unicode__ccs__iso_8859_3S");
   pragma Export (C, u00281, "unicode__ccs__iso_8859_4B");
   pragma Export (C, u00282, "unicode__ccs__iso_8859_4S");
   pragma Export (C, u00283, "unicode__ccs__windows_1251B");
   pragma Export (C, u00284, "unicode__ccs__windows_1251S");
   pragma Export (C, u00285, "unicode__names__cyrillicS");
   pragma Export (C, u00286, "unicode__names__general_punctuationS");
   pragma Export (C, u00287, "unicode__names__letterlike_symbolsS");
   pragma Export (C, u00288, "unicode__ccs__windows_1252B");
   pragma Export (C, u00289, "unicode__ccs__windows_1252S");
   pragma Export (C, u00290, "unicode__names__latin_extended_bS");
   pragma Export (C, u00291, "unicode__ces__basic_8bitB");
   pragma Export (C, u00292, "unicode__ces__basic_8bitS");
   pragma Export (C, u00293, "unicode__ces__utf16B");
   pragma Export (C, u00294, "unicode__ces__utf16S");
   pragma Export (C, u00295, "dom__core__documentsB");
   pragma Export (C, u00296, "dom__core__documentsS");
   pragma Export (C, u00297, "dom__core__elementsB");
   pragma Export (C, u00298, "dom__core__elementsS");
   pragma Export (C, u00299, "dom__readersB");
   pragma Export (C, u00300, "dom__readersS");
   pragma Export (C, u00301, "dom__core__character_datasB");
   pragma Export (C, u00302, "dom__core__character_datasS");
   pragma Export (C, u00303, "sax__attributesB");
   pragma Export (C, u00304, "sax__attributesS");
   pragma Export (C, u00305, "sax__modelsB");
   pragma Export (C, u00306, "sax__modelsS");
   pragma Export (C, u00307, "sax__exceptionsB");
   pragma Export (C, u00308, "sax__exceptionsS");
   pragma Export (C, u00309, "sax__locatorsB");
   pragma Export (C, u00310, "sax__locatorsS");
   pragma Export (C, u00311, "gnatS");
   pragma Export (C, u00312, "gnat__directory_operationsB");
   pragma Export (C, u00313, "gnat__directory_operationsS");
   pragma Export (C, u00314, "gnat__os_libS");
   pragma Export (C, u00315, "sax__pointersB");
   pragma Export (C, u00316, "sax__pointersS");
   pragma Export (C, u00317, "sax__readersB");
   pragma Export (C, u00318, "sax__readersS");
   pragma Export (C, u00319, "input_sourcesB");
   pragma Export (C, u00320, "input_sourcesS");
   pragma Export (C, u00321, "input_sources__fileB");
   pragma Export (C, u00322, "input_sources__fileS");
   pragma Export (C, u00323, "io_exceptionsS");
   pragma Export (C, u00324, "input_sources__stringsB");
   pragma Export (C, u00325, "input_sources__stringsS");
   pragma Export (C, u00326, "sax__utilsB");
   pragma Export (C, u00327, "sax__utilsS");
   pragma Export (C, u00328, "mast_xml_parser_extensionB");
   pragma Export (C, u00329, "mast_xml_parser_extensionS");
   pragma Export (C, u00330, "dom__core__processing_instructionsS");
   pragma Export (C, u00331, "system__val_enumB");
   pragma Export (C, u00332, "system__val_enumS");
   pragma Export (C, u00333, "mast_xml_results_parserB");
   pragma Export (C, u00334, "mast_xml_results_parserS");
   pragma Export (C, u00335, "system__memoryB");
   pragma Export (C, u00336, "system__memoryS");

   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.handling%s
   --  ada.characters.latin_1%s
   --  ada.command_line%s
   --  gnat%s
   --  interfaces%s
   --  system%s
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.bit_ops%s
   --  system.case_util%s
   --  system.case_util%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.concat_7%s
   --  system.concat_7%b
   --  system.concat_8%s
   --  system.concat_8%b
   --  system.exn_llf%s
   --  system.exn_llf%b
   --  system.htable%s
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_real%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.powten_table%s
   --  system.restrictions%s
   --  system.restrictions%b
   --  system.standard_library%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.secondary_stack%s
   --  ada.command_line%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback%s
   --  system.traceback%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  ada.exceptions.last_chance_handler%s
   --  system.soft_links%s
   --  system.soft_links%b
   --  ada.exceptions.last_chance_handler%b
   --  system.secondary_stack%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.io_exceptions%s
   --  ada.strings%s
   --  ada.tags%s
   --  ada.streams%s
   --  interfaces.c%s
   --  interfaces.c%b
   --  io_exceptions%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.os_lib%s
   --  system.os_lib%b
   --  gnat.os_lib%s
   --  system.strings.stream_ops%s
   --  system.unsigned_types%s
   --  system.bit_ops%b
   --  ada.strings.maps%s
   --  ada.strings.maps%b
   --  ada.strings.fixed%s
   --  ada.strings.maps.constants%s
   --  ada.characters.handling%b
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.strings.fixed%b
   --  gnat.directory_operations%s
   --  gnat.directory_operations%b
   --  system.fat_flt%s
   --  system.fat_lflt%s
   --  system.fat_llf%s
   --  system.fat_sflt%s
   --  system.img_llu%s
   --  system.img_llu%b
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.img_real%b
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.finalization_implementation%s
   --  system.finalization_implementation%b
   --  ada.finalization%s
   --  ada.finalization%b
   --  ada.finalization.list_controller%s
   --  ada.finalization.list_controller%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  system.file_control_block%s
   --  ada.streams.stream_io%s
   --  system.strings.stream_ops%b
   --  system.file_io%s
   --  system.file_io%b
   --  ada.streams.stream_io%b
   --  system.val_enum%s
   --  system.val_int%s
   --  system.val_real%s
   --  system.val_uns%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_uns%b
   --  system.val_real%b
   --  system.val_int%b
   --  system.val_enum%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.tags%b
   --  ada.exceptions%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.float_aux%s
   --  ada.float_text_io%s
   --  ada.float_text_io%b
   --  ada.text_io.generic_aux%s
   --  ada.text_io.generic_aux%b
   --  ada.text_io.float_aux%b
   --  ada.text_io.text_streams%s
   --  ada.text_io.text_streams%b
   --  text_io%s
   --  binary_trees%s
   --  binary_trees%b
   --  dom%s
   --  hash_lists%s
   --  indexed_lists%s
   --  list_exceptions%s
   --  indexed_lists%b
   --  hash_lists%b
   --  mast%s
   --  mast.scheduling_parameters%s
   --  mast.scheduling_policies%s
   --  mast.synchronization_parameters%s
   --  mast.timers%s
   --  mast_lex_dfa%s
   --  mast_lex_dfa%b
   --  mast_lex_io%s
   --  mast_lex_io%b
   --  mast_parser_error_report%s
   --  mast_parser_error_report%b
   --  mast_parser_goto%s
   --  mast_parser_shift_reduce%s
   --  mast_results_lex_dfa%s
   --  mast_results_lex_dfa%b
   --  mast_results_lex_io%s
   --  mast_results_lex_io%b
   --  mast_results_parser_error_report%s
   --  mast_results_parser_error_report%b
   --  mast_results_parser_goto%s
   --  mast_results_parser_shift_reduce%s
   --  mast_xml_exceptions%s
   --  sax%s
   --  sax.htable%s
   --  sax.htable%b
   --  sax.pointers%s
   --  sax.pointers%b
   --  unicode%s
   --  unicode.ccs%s
   --  unicode.ccs%b
   --  unicode.ccs.iso_8859_1%s
   --  unicode.ccs.iso_8859_1%b
   --  unicode.ccs.iso_8859_15%s
   --  unicode.ccs.iso_8859_2%s
   --  unicode.ccs.iso_8859_3%s
   --  unicode.ccs.iso_8859_4%s
   --  unicode.ccs.windows_1251%s
   --  unicode.ccs.windows_1252%s
   --  unicode.ces%s
   --  unicode.ces%b
   --  dom.core%s
   --  dom.core.documents%s
   --  dom.core.processing_instructions%s
   --  mast_xml_parser_extension%s
   --  sax.locators%s
   --  sax.locators%b
   --  sax.exceptions%s
   --  sax.exceptions%b
   --  sax.models%s
   --  sax.attributes%s
   --  sax.attributes%b
   --  sax.utils%s
   --  unicode.ces.utf32%s
   --  unicode.ces.utf32%b
   --  unicode.ces.basic_8bit%s
   --  unicode.ces.basic_8bit%b
   --  input_sources%s
   --  input_sources.file%s
   --  input_sources.strings%s
   --  sax.readers%s
   --  dom.readers%s
   --  unicode.ces.utf16%s
   --  unicode.ces.utf16%b
   --  unicode.ces.utf8%s
   --  unicode.ces.utf8%b
   --  input_sources.strings%b
   --  input_sources.file%b
   --  sax.encodings%s
   --  sax.models%b
   --  unicode.encodings%s
   --  unicode.encodings%b
   --  input_sources%b
   --  dom.core.nodes%s
   --  mast_xml_parser_extension%b
   --  dom.core.attrs%s
   --  dom.core.attrs%b
   --  dom.core.character_datas%s
   --  dom.core.character_datas%b
   --  dom.core.elements%s
   --  dom.core.elements%b
   --  dom.readers%b
   --  dom.core.documents%b
   --  unicode.names%s
   --  unicode.names.basic_latin%s
   --  dom.core.nodes%b
   --  sax.readers%b
   --  sax.utils%b
   --  dom.core%b
   --  unicode%b
   --  unicode.names.currency_symbols%s
   --  unicode.names.cyrillic%s
   --  unicode.names.general_punctuation%s
   --  unicode.names.latin_1_supplement%s
   --  unicode.names.latin_extended_a%s
   --  unicode.ccs.iso_8859_15%b
   --  unicode.names.latin_extended_b%s
   --  unicode.names.letterlike_symbols%s
   --  unicode.ccs.windows_1251%b
   --  unicode.names.spacing_modifier_letters%s
   --  unicode.ccs.windows_1252%b
   --  unicode.ccs.iso_8859_4%b
   --  unicode.ccs.iso_8859_3%b
   --  unicode.ccs.iso_8859_2%b
   --  var_strings%s
   --  var_strings%b
   --  mast_xml_exceptions%b
   --  mast%b
   --  mast.io%s
   --  mast.timers%b
   --  mast.synchronization_parameters%b
   --  mast.scheduling_policies%b
   --  mast.scheduling_parameters%b
   --  named_lists%s
   --  named_lists%b
   --  mast.events%s
   --  mast.events%b
   --  mast.graphs%s
   --  mast.graphs%b
   --  mast.results%s
   --  mast.processing_resources%s
   --  mast.processing_resources%b
   --  mast.processing_resources.processor%s
   --  mast.processing_resources.processor%b
   --  mast.schedulers%s
   --  mast.schedulers%b
   --  mast.schedulers.primary%s
   --  mast.schedulers.primary%b
   --  mast.scheduling_servers%s
   --  mast.schedulers.adjustment%s
   --  mast.schedulers.secondary%s
   --  mast.schedulers.secondary%b
   --  mast.schedulers.adjustment%b
   --  mast.scheduling_servers%b
   --  mast.shared_resources%s
   --  mast.shared_resources%b
   --  mast.operations%s
   --  mast.operations%b
   --  mast.drivers%s
   --  mast.drivers%b
   --  mast.graphs.event_handlers%s
   --  mast.graphs.event_handlers%b
   --  mast.processing_resources.network%s
   --  mast.processing_resources.network%b
   --  mast.timing_requirements%s
   --  mast.timing_requirements%b
   --  mast.graphs.links%s
   --  mast.graphs.links%b
   --  mast.results%b
   --  mast.transactions%s
   --  mast.transactions%b
   --  mast.systems%s
   --  mast.systems%b
   --  mast_put_results%b
   --  mast_xml_parser%s
   --  mast_xml_parser%b
   --  mast_xml_results_parser%s
   --  mast_xml_results_parser%b
   --  symbol_table%s
   --  symbol_table%b
   --  mast_parser_tokens%s
   --  mast.io%b
   --  mast_lex%s
   --  mast_lex%b
   --  mast_parser%b
   --  mast_results_parser_tokens%s
   --  mast_results_lex%s
   --  mast_results_lex%b
   --  mast_results_parser%b
   --  test_xml_results%b
   --  END ELABORATION ORDER

end ada_main;
