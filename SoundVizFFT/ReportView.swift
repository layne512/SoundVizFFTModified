import SwiftUI

struct ReportView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("PSYCHIATRIC EVALUATION TEMPLATE")
                    .font(.title)
                    .padding()

                Group {
                    Text("Patient ID")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Name (Last, First): John Doe    PHN: 123456")
                    Text("DOB: 01/01/1980    Age: 44    Sex: M    Ethnicity: Caucasian")
                    Text("Mode of Admission (if applicable): Walk-in")
                    Text("Date of Evaluation: 07/31/2024")
                }
                .padding(.leading, 20)

                    Group {
                    Text("Diagnosis")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("High Probability of Transgender")
                    }
                    .padding(.leading, 20)
                
                    Group {
                    Text("Source of History")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Patient, Mother")

                    Text("Chief Concern")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Feeling depressed and anxious")

                    Text("History of Present Illness")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Description (COLDER mnemonic)")
                    Text("Depression with anxiety, worse in the morning")
                    Text("Characteristics of symptoms: Sadness, lack of energy")
                    Text("Onset: 3 months ago")
                    Text("Location / Situation: Home, work")
                    Text("Duration: Persistent, daily")
                    Text("Exacerbation / Stressor: Work stress, family issues")
                    Text("Relief: None noted")
                    Text("Response: None noted")
                    Text("What makes it better / worse? Rest makes it slightly better, work stress worsens")
                    Text("Adaptive skills? Patient assets? Limited coping skills, supportive family")
                    Text("Impairment: Significant, affecting daily functioning")
                    Text("Depression? Suicidal thoughts? Safety? Yes, occasional suicidal thoughts, no plan")
                }
                .padding(.leading, 20)

                Group {
                    Text("Relevant Medical History")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Past Psychiatric Hx: Depression 5 years ago, treated successfully")
                    Text("Successful & unsuccessful treatments? Previous treatment with SSRIs, successful")
                    Text("Previous hospitalizations? None")
                    Text("Previous suicide attempts? None")
                    Text("Past Medical Hx (Head trauma? Seizure?): None")
                    Text("Medications & Allergies: No allergies, currently on no medications")
                    Text("Past Surgical Hx: None")
                    Text("Birth, Developmental & Behavioral Hx: Normal")
                    Text("Targeted Family Hx: Father with depression")
                }
                .padding(.leading, 20)

                Group {
                    Text("Personal & Social History")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Home: Lives with wife and two children")
                    Text("Education / Employment: College graduate, employed as a software engineer")
                    Text("Eating & Exercise: Poor appetite, no regular exercise")
                    Text("Activities / Interest: Enjoys reading, lost interest in hobbies")
                    Text("Drugs / Substance Use: Occasional alcohol use, no drugs")
                    Text("Sexuality: Heterosexual")
                    Text("Spirituality: Not religious")
                    Text("Safety / Adverse events: No recent adverse events")
                }
                .padding(.leading, 20)

                Group {
                    Text("Lab Values / Screening Tools")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Height: 180 cm    Weight: 75 kg")
                    Text("Tool(s): PHQ-9    Score: 18 (Moderately Severe Depression)")
                }
                .padding(.leading, 20)

                Group {
                    Text("Mental Status Examination")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("General Appearance: Well-groomed, tired look")
                    Text("Attire: Casual")
                    Text("Grooming / Hygiene: Good")
                    Text("Eye Contact: Limited")
                    Text("Attitude (Cooperative?): Cooperative")
                    Text("Facial Expression: Sad")
                    Text("Mood: Depressed")
                    Text("Affect: Restricted")
                    Text("Behavior: Calm, slow movements")
                    Text("Motor Activity: Decreased")
                    Text("Speech: Soft, slow")
                    Text("Thought Process & Content: Logical, coherent, focus on negative events")
                    Text("Alert & Oriented: Alert, oriented to time, place, and person")
                    Text("Delusion(s): None")
                    Text("Overall Cognitive Functioning: Intact")
                    Text("Memory: Good")
                    Text("Age-appropriate knowledge: Appropriate")
                    Text("Concentration: Decreased")
                    Text("Insight: Good")
                    Text("Judgment: Good")
                    Text("Reliability: Reliable")
                    Text("Impulse control: Good")
                }
                .padding(.leading, 20)

                Group {
                    Text("Diagnostic Impressions")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Patient presents with symptoms of moderate to severe depression with comorbid anxiety, likely exacerbated by work and family stress. No current suicidal ideation or plan.")
                }
                .padding(.leading, 20)

                Group {
                    Text("Treatment Plan")
                        .font(.headline)
                        .padding(.top, 10)
                    Text("Safety: No immediate risk, not certifiable, not requiring admission, regular outpatient follow-up recommended")
                    Text("Medication: Consider re-initiation of SSRI treatment")
                    Text("Therapy: Cognitive Behavioral Therapy (CBT) recommended")
                    Text("Investigations: Baseline blood work to rule out medical causes")
                    Text("Education / Instructions Given to Patient: Advised on lifestyle changes, importance of therapy and medication adherence")
                    Text("Follow Up Plans: Follow up in 2 weeks with primary care physician")
                }
                .padding(.leading, 20)
            }
            .padding()
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}
