 
ME_Processing_Resource Me_Regular_Processor proc Proc_Res_Canvas 200 40 
ME_Scheduler Me_Primary_Scheduler scheduler Proc_Res_Canvas 15 15 
ME_Scheduler Me_Primary_Scheduler scheduler Sched_Server_Canvas 125 125 
ME_Scheduling_Server Me_Server hthread Sched_Server_Canvas 360 40 
ME_Scheduling_Server Me_Server thread0 Sched_Server_Canvas 40 40 
ME_Operation Me_Simple_Operation hoper Operation_Canvas 200 40 
ME_Operation Me_Simple_Operation oper0 Operation_Canvas 40 40 
ME_Transaction Me_Regular_Transaction htrans Transaction_Canvas 200 40 
ME_Transaction Me_Regular_Transaction trans0 Transaction_Canvas 40 40 
ME_Link Me_External_Link actevent,htrans htrans 85 55 
ME_Link Me_Internal_Link end,htrans htrans 465 55 
ME_Link Me_External_Link actevent,trans0 trans0 85 55 
ME_Link Me_Internal_Link end,trans0 trans0 465 55 
ME_Event_Handler Me_Simple_Event_Handler 1,htrans htrans 230 40 
ME_Event_Handler Me_Simple_Event_Handler 1,trans0 trans0 230 40 
