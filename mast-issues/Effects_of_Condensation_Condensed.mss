 
ME_Processing_Resource Me_Regular_Processor cpu_0 Proc_Res_Canvas 360 40 
ME_Scheduler Me_Primary_Scheduler cpu_0_scheduler Proc_Res_Canvas 40 40 
ME_Scheduler Me_Primary_Scheduler cpu_0_scheduler Sched_Server_Canvas 200 40 
ME_Scheduling_Server Me_Server sch_svr_0 Sched_Server_Canvas 360 40 
ME_Scheduling_Server Me_Server sch_svr_1 Sched_Server_Canvas 40 40 
ME_Operation Me_Simple_Operation tr0_op0 Operation_Canvas 520 40 
ME_Operation Me_Simple_Operation tr1_op0 Operation_Canvas 200 40 
ME_Transaction Me_Regular_Transaction transaction_0 Transaction_Canvas 200 40 
ME_Transaction Me_Regular_Transaction transaction_1 Transaction_Canvas 40 40 
ME_Link Me_External_Link tr0_ex_evt,transaction_0 transaction_0 85 55 
ME_Link Me_Internal_Link tr0_in_evt0,transaction_0 transaction_0 465 55 
ME_Link Me_External_Link tr1_ex_evt,transaction_1 transaction_1 85 55 
ME_Link Me_Internal_Link tr1_in_evt0,transaction_1 transaction_1 465 55 
ME_Event_Handler Me_Simple_Event_Handler 1,transaction_0 transaction_0 230 40 
ME_Event_Handler Me_Simple_Event_Handler 1,transaction_1 transaction_1 230 40 
