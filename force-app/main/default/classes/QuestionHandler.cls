public class QuestionHandler {

    public static void afterInsert(Map<Id, question__c> newMap) {
        examTotalScoreRollup(null, newMap);
    }

    public static void afterUpdate(Map<Id, question__c> oldMap, Map<Id, question__c> newMap) {
        examTotalScoreRollup(oldMap, newMap);
    }

    public static void examTotalScoreRollup(Map<Id, question__c> oldMap, Map<Id, question__c> newMap) {
        Set<Id> examIds = new Set<Id>();

        for (question__c newQuestion : newMap.values()) {
            if (oldMap == null) { // insert
                if (newQuestion.exam__c != null && newQuestion.score__c != null) {
                    examIds.add(newQuestion.exam__c);
                }

            } else { // update
                question__c oldQuestion = oldMap.get(newQuestion.Id);

                if (newQuestion.exam__c != oldQuestion.exam__c || newQuestion.score__c != oldQuestion.score__c) {
                    if (oldQuestion.exam__c != null) {
                        examIds.add(oldQuestion.exam__c);
                    }
                    if (newQuestion.exam__c != null) {
                        examIds.add(newQuestion.exam__c);
                    }
                }
                
            }
        }

        if (examIds.isEmpty()) return;

        Map<Id, Decimal> examIdVsTotalScore = new Map<Id, Decimal>();
        for (AggregateResult aggregateResult : [
                                                SELECT exam__c, SUM(score__c) totalScore
                                                FROM question__c
                                                WHERE exam__c IN :examIds
                                                GROUP BY exam__c
        ]) {
            examIdVsTotalScore.put((Id)aggregateResult.get('exam__c'), (Decimal)aggregateResult.get('totalScore'));
        }

        List<exam__c> exams = new List<exam__c>();
        for (Id examId : examIds) {
            exam__c exam = new exam__c(
                Id = examId,
                total_score__c = examIdVsTotalScore.get(examId) ?? null
            );
            exams.add(exam);
        }

        update exams;
    }
}