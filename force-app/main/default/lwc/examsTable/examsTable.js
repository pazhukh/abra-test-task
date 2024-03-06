import { LightningElement, api, track } from 'lwc';
import getExams from '@salesforce/apex/ExamsTableController.getExams';

const iconExpanded = 'utility:chevrondown';
const iconCollapsed = 'utility:chevronright';

export default class ExamsTable extends LightningElement {
    @api recordId;
    @track exams;

    avgScore;
    noExams;

    async connectedCallback() {
        try {
            const exams = await getExams({ contactId: this.recordId });

            if (!exams.length) {
                this.noExams = true;

                return;
            }

            this.exams = exams.map(exam => {
                exam.hasQuestions = exam.questions__r?.length;
                exam.showQuestions = false;
                exam.iconName = iconCollapsed;

                return exam;
            })

            this.avgScore = this.calculateAvgScore(exams.filter(e => e.total_score__c || e.total_score__c == 0));

        } catch (e) {
            console.error('[ExamsTable][connectedCallback] error', error);
        }
    }

    handleToggleQuestions(e) {
        const examId = e.target.dataset.examId;

        const exam = this.exams.find(exam => exam.Id === examId);
        exam.showQuestions = !exam.showQuestions;
        exam.iconName = exam.showQuestions ? iconExpanded : iconCollapsed;
    }

    calculateAvgScore(exams) {
        const sum = exams.reduce((total, curr) => total + curr.total_score__c, 0);
        return (sum / exams.length).toFixed(1);
    }
}