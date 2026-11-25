 
ME_Processing_Resource Me_Regular_Processor cpu Proc_Res_Canvas 200 40 
ME_Scheduler Me_Primary_Scheduler cpu_scheduler Proc_Res_Canvas 40 40 
ME_Scheduler Me_Primary_Scheduler cpu_scheduler Sched_Server_Canvas 198 32 
ME_Scheduling_Server Me_Server t1 Sched_Server_Canvas 300 145 
ME_Operation Me_Simple_Operation t11 Operation_Canvas 360 40 
ME_Operation Me_Simple_Operation t12 Operation_Canvas 365 124 
ME_Transaction Me_Regular_Transaction t1 Transaction_Canvas 200 40 
ME_Link Me_External_Link t2.input,t1 t2 85 55 
ME_Link Me_Internal_Link t2.output,t1 t2 519 63 
ME_Link Me_Internal_Link t2.middle,t1 t2 272 62 
ME_Event_Handler Me_Simple_Event_Handler 1,t1 t2 152 169 
ME_Event_Handler Me_Simple_Event_Handler 2,t1 t2 375 163 
