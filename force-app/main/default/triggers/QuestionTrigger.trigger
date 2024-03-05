trigger QuestionTrigger on question__c (after insert, after update) {

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            QuestionHandler.afterInsert(Trigger.newMap);
        } else if (Trigger.isUpdate) {
            QuestionHandler.afterUpdate(Trigger.oldMap, Trigger.newMap);
        }
    }
}