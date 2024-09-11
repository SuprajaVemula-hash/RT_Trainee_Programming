trigger Contacttrigger on Contact(before insert, before update){
    if(Trigger.isBefore && Trigger.isInsert){
        new AccountTriggerHandler().beforeinsert(Trigger.new);
       
    }
   

    if(Trigger.isBefore && Trigger.isUpdate){
     
        new AccountTriggerHandler().beforeupdate(Trigger.new,Trigger.oldMap);
            
        }
    }

   



    
