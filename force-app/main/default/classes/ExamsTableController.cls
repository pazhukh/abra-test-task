public class ExamsTableController {
    
    @AuraEnabled
    public static List<exam__c> getExams(Id contactId) {
        try {
            return [
                    SELECT
                        Name, datetime_of_exam__c, total_score__c,
                        (SELECT Name, score__c FROM questions__r)
                    FROM
                        exam__c
                    WHERE
                        contact__c = :contactId
                    ORDER BY
                        datetime_of_exam__c DESC
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}