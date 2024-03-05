@isTest
public class QuestionHandlerTest {
    
    @isTest
    static void examTotalScoreRollupTest() {
        exam__c exam1 = new exam__c();
        exam__c exam2 = new exam__c();
        insert new List<exam__c>{exam1, exam2};

        // test insert questions
        question__c questionA = new question__c(
            exam__c = exam1.Id,
            score__c = 5
        );
        question__c questionB = new question__c(
            exam__c = exam2.Id,
            score__c = 6
        );
        insert new List<question__c>{questionA, questionB};

        Map<Id, exam__c> exams = new Map<Id, exam__c>([SELECT total_score__c FROM exam__c]);
        Assert.areEqual(5, exams.get(exam1.Id).total_score__c);
        Assert.areEqual(6, exams.get(exam2.Id).total_score__c);

        // test update exam
        questionB.exam__c = exam1.Id;
        update questionB;

        exams = new Map<Id, exam__c>([SELECT total_score__c FROM exam__c]);
        Assert.areEqual(11, exams.get(exam1.Id).total_score__c);
        Assert.isNull(exams.get(exam2.Id).total_score__c);

        // test update score
        questionB.score__c = 10;
        update questionB;

        exams = new Map<Id, exam__c>([SELECT total_score__c FROM exam__c]);
        Assert.areEqual(15, exams.get(exam1.Id).total_score__c);
        Assert.isNull(exams.get(exam2.Id).total_score__c);
    }
}