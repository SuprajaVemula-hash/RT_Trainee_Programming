trigger AccountTrigger on Account (after update) {
    if(Trigger.isAfter && Trigger.isUpdate){
        new AccountTriggerHandler().afterupdate(Trigger.new,Trigger.oldMap);
    }
}