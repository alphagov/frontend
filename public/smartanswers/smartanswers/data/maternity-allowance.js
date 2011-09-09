new SmartAnswer({
    title: "Maternity pay and benefits you're eligible for",
    summary: "Use this service to work out whether you may be eligible for maternity pay or maternity benefits.  You'll need to answer questions about how long you've been working for, how much you earn and when your baby is due.",
    completionTime: 3,
    
    steps: [
        // The first `step` in the data will be used as the starting point for the user.
        // Each subsequent step is called by specifying its `id` in the `next` property of the previous step.    
        {
            id: "employment-status",
            title: "What is your employment status?",
            options: [
                {
                    title: "Employed",
                    next: "minimum-average-wage"
                },
                {
                    title: "Self-employed",
                    next: "maximum-average-wage"
                },
                {
                    title: "Unemployed",
                    next: "result-unemployed"
                }
            ]
        },
				{
            id: "maximum-average-wage",
            title: "On average, do you earn £102 or more per week?",
            options: [
                {
                    title: "Yes",
                    next: "due-date"
                },
                {
                    title: "No",
                    next: "minimum-average-wage"
                }
            ]
        },
        {
            id: "minimum-average-wage",
            title: "On average, do you earn £30 or more per week?",
            options: [
                {
                    title: "Yes",
                    next: "due-date"
                },
                {
                    title: "No",
                    next: "result-unqualified"
                }
            ]
        },
        {
            id: "due-date",
            title: "When is your baby due?",
            options: [
                {
                    // A "date" option - this will be rendered as three selectboxes: day, month and year
                    type: "date",
                    // Which range of years to render: 0 = the current year. E.g. [-1,1] ranges from last year to next year
                    years: [0,1],
                    title: "is the due date",
                    next: "weeks-worked"
                }
            ]
        },
        {
            id: "weeks-worked",
            title: function(){
                return "Have you worked for more than 26 weeks (either full or part-time) since " + 
                    // Grab a previous user response (for step id "due-date") and format a date that is 67 weeks earlier than that due date
                    this.niceDate(this.decisions["due-date"], -67*7) + 
                    "?"
            },
            options: [
                {
                    title: "Yes",
                    next: function(){
                        return this.decisions["employment-status"] === "Employed" ?
                            "result-qualified-employed" : "result-qualified-selfemployed";
                    }
                },
                {
                    title: "No",
                    next: "result-unqualified"
                }
            ]
        },
        {
            id: "result-unqualified",
            title: "Sorry, you do not qualify for Maternity Allowance",
						details: [
                "You may be able to get Employment and Support Allowance (ESA) instead. If you have made a claim for Maternity Allowance you do not have to make a separate claim for ESA. Jobcentre Plus will automatically check to see if you can get ESA."
            ],
            readmore: [
                {
                    title: "Find out about ESA",
                    url: "http://www.direct.gov.uk/en/MoneyTaxAndBenefits/BenefitsTaxCreditsAndOtherSupport/Illorinjured/DG_171894"
        				},
						]
				},
        {
            id: "result-unemployed",
            title: "Sorry, you don't qualify for maternity pay.",
						details: [
                "You may be able to get other benefits, eg Employment & Support Allowance (ESA) or Income Support. You could get a maternity grant or vouchers."
            ],
            readmore: [
                {
                    title: "Find out what maternity grants or benefits you may be eligible for.",
                    url: "http://www.direct.gov.uk/en/MoneyTaxAndBenefits/BenefitsTaxCreditsAndOtherSupport/Illorinjured/DG_171894"
								},
						]
				},
        {
            id: "result-qualified-selfemployed",
         		title: "You may be entitled to Maternity Allowance.",
						details: [
							"You'll get £128.73 per week, or 90% of your average weekly earnings for 39 weeks, whichever is lower.",
							"You can fill out this form (<a href='http://www.dwp.gov.uk/advisers/claimforms/ma1.pdf'>http://www.dwp.gov.uk/advisers/claimforms/ma1.pdf</a>) to apply (send back to Jobcentre Plus)." 
						],
						readmore: [
                {
                    title: "Find your local Jobcentre Plus",
                    url: "http://www.direct.gov.uk/en/Employment/Jobseekers/ContactJobcentrePlus/DG_186347"
								},
						]
			
        },
        {
            id: "result-qualified-employed",
            title: "You may qualify for Statutory Maternity Pay (SMP) from your employer",
            details: [
                "You'll get:",
								"90% of your average weekly wage for the first 6 weeks",
                "£128.73 or 90% of your average weekly wage (whichever is lower) for the next 33 weeks",
                "You'll pay tax and national insurance on your SMP."
            ],
            readmore: [
                {
                    title: "How to claim Statutory Maternity Pay",
                    url: "http://www.direct.gov.uk/en/MoneyTaxAndBenefits/BenefitsTaxCreditsAndOtherSupport/Expectingorbringingupchildren/DG_175881"
                }
            ]
        }
    ]
});
