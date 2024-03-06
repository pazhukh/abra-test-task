import { createElement } from "lwc";
import ExamsTable from "c/examsTable";
import getExams from "@salesforce/apex/ExamsTableController.getExams";

const mockExams = require("./mockData/exams.json");

jest.mock(
  "@salesforce/apex/ExamsTableController.getExams",
  () => {
    return { default: jest.fn() };
  },
  { virtual: true }
);

describe("c-exams-table", () => {
  afterEach(() => {
    // The jsdom instance is shared across test cases in a single file so reset the DOM
    while (document.body.firstChild) {
      document.body.removeChild(document.body.firstChild);
    }
  });

  test("connectedCallback", async () => {
    getExams.mockResolvedValue(mockExams);

    const component = createElement("c-exams-table", {
      is: ExamsTable
    });

    document.body.appendChild(component);
    await Promise.resolve();
    await Promise.resolve();

    const table = component.shadowRoot.querySelector(".slds-table");
    expect(table).not.toBeNull();
  });

  test("toggle questions", async () => {
    getExams.mockResolvedValue(mockExams);

    const component = createElement("c-exams-table", {
      is: ExamsTable
    });

    document.body.appendChild(component);
    await Promise.resolve();
    await Promise.resolve();

    const expandIcon = component.shadowRoot.querySelector("lightning-icon");

    expect(component.shadowRoot.querySelector(".questions")).toBeNull();

    // test show questions
    expandIcon.dispatchEvent(new CustomEvent("click"));
    await Promise.resolve();
    expect(component.shadowRoot.querySelector(".questions")).not.toBeNull();
    expect(component.shadowRoot.querySelectorAll(".question").length).toBe(2);

    // test hide questions
    expandIcon.dispatchEvent(new CustomEvent("click"));
    await component.updateComplete;
    expect(component.shadowRoot.querySelector(".questions")).toBeNull();
    expect(component.shadowRoot.querySelectorAll(".question").length).toBe(0);
  });

  test("no exams", async () => {
    getExams.mockResolvedValue([]);

    const component = createElement("c-exams-table", {
      is: ExamsTable
    });

    document.body.appendChild(component);
    await Promise.resolve();
    await Promise.resolve();

    expect(component.shadowRoot.querySelector(".slds-table")).toBeNull();
    expect(component.shadowRoot.querySelector(".slds-notify")).not.toBeNull();
  });
});