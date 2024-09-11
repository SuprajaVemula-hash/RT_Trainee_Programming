trigger OpportunityTrigger on Opportunity (after delete,after undelete) {
    if(Trigger.isAfter && Trigger.isDelete){
      new  OpportunityTriggerHandler().afterDeleteOpportunity(Trigger.old);
    }
    if(Trigger.isAfter && Trigger.isUndelete){
       new OpportunityTriggerHandler().afterUndeleteOpportunity(Trigger.new);
     
    }
    

}
  
