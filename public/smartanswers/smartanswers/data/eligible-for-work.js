new SmartAnswer({
    // The main page title for this smart answer
    title: "Check you're eligible to work in the UK",
    
    // Some explanatory information
    summary: "Use this service to work out whether you need to get permission to work in the UK, and what you need to do next.",
    
    // The completion time in minutes
    completionTime: 3,
    
    // Each step of the answer
    steps: [
        {
            // A step `id` is used as the identifier to work out 
            id: "nationality",
            title: "Where are you from? (the country on your passport)",
            
            // If a `next` property is supplied in the step, then it will act as the default next step for each of the options. Any option that has a `next` property will override the default `next` for the step.
           // next: "skilled-worker",
            
            // If an `optionsSummary` is supplied, it will be used as the first option in a selectbox
            optionsSummary: "Please select a country",
            
            // If an individual option is just a string of text, it will be converted to `{title:THE_TEXT}` so this may be used as a short-hand, especially when there are many options

            options: [
						{
                title: "Afghanistan",
                next: "skilled-worker"
            },
						{
                title: "Albania",
                next: "skilled-worker"
            },
						{
                title: "Algeria",
                next: "skilled-worker"
            },
						{
                title: "American Samoa",
                next: "skilled-worker"
            },
						{
                title: "Andorra",
                next: "skilled-worker"
            },
						{
                title: "Angola",
                next: "skilled-worker"
            },
						{
                title: "Andorra",
                next: "skilled-worker"
            },
						{
                title: "Anguilla",
                next: "skilled-worker"
            },
						{
                title: "Antigua and Barbuda",
                next: "skilled-worker"
            },
						{
                title: "Argentina",
                next: "skilled-worker"
            },
						{
                title: "Armenia",
                next: "skilled-worker"
            },
						{
                title: "Aruba/Dutch Caribbeana",
                next: "skilled-worker"
            },
						{
                title: "Ascension Island",
                next: "skilled-worker"
            },
						{
                title: "Australia",
                next: "skilled-worker"
            },
						{
                title: "Austria",
                next: "eu-worker"
            },
						{
                title: "Azerbaijan",
                next: "skilled-worker"
            },
						{
                title: "Bahamas",
                next: "skilled-worker"
            },
						{
                title: "Bahrain",
                next: "skilled-worker"
            },
						{
                title: "Bangladesh",
                next: "skilled-worker"
            },
						{
                title: "Barbados",
                next: "skilled-worker"
            },
						{
                title: "Belarus",
                next: "skilled-worker"
            },
						{
                title: "Belgium",
                next: "eu-worker"
            },
						{
                title: "Belize",
                next: "skilled-worker"
            },
						{
                title: "Benin",
                next: "skilled-worker"
            },
						{
                title: "Bermuda",
                next: "skilled-worker"
            },
						{
                title: "Bhutan",
                next: "skilled-worker"
            },
						{
                title: "Bolivia",
                next: "skilled-worker"
            },
						{
                title: "Bosnia and Herzegovina",
                next: "skilled-worker"
            },
						{
                title: "Botswana",
                next: "skilled-worker"
            },
						{
                title: "Brazil",
                next: "skilled-worker"
            },
						{
                title: "British Antarctic Territory",
                next: "skilled-worker"
            },
						{
                title: "British Indian Ocean Territory",
                next: "skilled-worker"
            },
						{
                title: "British Virgin Islands",
                next: "skilled-worker"
            },
						{
                title: "Brunei",
                next: "skilled-worker"
            },
						{
                title: "Bulgaria",
                next: "exc-worker"
            },
						{
                title: "Burkina Faso",
                next: "skilled-worker"
            },
						{
                title: "Burma",
                next: "skilled-worker"
            },
						{
                title: "Burundi",
                next: "skilled-worker"
            },
						{
                title: "Cambodia",
                next: "skilled-worker"
            },
						{
                title: "Cameroon",
                next: "skilled-worker"
            },
						{
                title: "Canada",
                next: "skilled-worker"
            },
						{
                title: "Cape Verde",
                next: "skilled-worker"
            },
						{
                title: "Cayman Islands",
                next: "skilled-worker"
            },
						{
                title: "Central African Republic",
                next: "skilled-worker"
            },
						{
                title: "Chad",
                next: "skilled-worker"
            },
						{
                title: "Chile",
                next: "skilled-worker"
            },
						{
                title: "China",
                next: "skilled-worker"
            },
						{
                title: "Colombia",
                next: "skilled-worker"
            },
						{
                title: "Comoros",
                next: "skilled-worker"
            },
						{
                title: "Congo",
                next: "skilled-worker"
            },
						{
                title: "Congo (Democratic Republic)",
                next: "skilled-worker"
            },
						{
                title: "Costa Rica",
                next: "skilled-worker"
            },
						{
                title: "Croatia",
                next: "skilled-worker"
            },
						{
                title: "Cuba",
                next: "skilled-worker"
            },
						{
                title: "Cyprus",
                next: "eu-worker"
            },
						{
                title: "Czech Republic",
                next: "eu-worker"
            },
						{
                title: "Denmark",
                next: "eu-worker"
            },
						{
                title: "Djibouti",
                next: "skilled-worker"
            },
						{
                title: "Dominica, Commonwealth of",
                next: "skilled-worker"
            },
						{
                title: "Dominican Republic",
                next: "skilled-worker"
            },
						{
                title: "East Timor (Timor-Leste)",
                next: "skilled-worker"
            },
						{
                title: "Ecuador",
                next: "skilled-worker"
            },
						{
                title: "Egypt",
                next: "skilled-worker"
            },
						{
                title: "El Salvador",
                next: "skilled-worker"
            },
						{
                title: "Equatorial Guinea",
                next: "skilled-worker"
            },
						{
                title: "Eritrea",
                next: "skilled-worker"
            },
						{
                title: "Estonia",
                next: "eu-worker"
            },
						{
                title: "Ethiopia",
                next: "skilled-worker"
            },
						{
                title: "Falkland Islands",
                next: "skilled-worker"
            },
						{
                title: "Fiji",
                next: "skilled-worker"
            },
						{
                title: "Finland",
                next: "eu-worker"
            },
						{
                title: "France",
                next: "eu-worker"
            },
						{
                title: "French Guiana",
                next: "skilled-worker"
            },
						{
                title: "French Polynesia",
                next: "skilled-worker"
            },
						{
                title: "Gabon",
                next: "skilled-worker"
            },
						{
                title: "Gambia",
                next: "skilled-worker"
            },
						{
                title: "Gambia, The",
                next: "skilled-worker"
            },
						{
                title: "Georgia",
                next: "skilled-worker"
            },
						{
                title: "Germany",
                next: "eu-worker"
            },
						{
                title: "Ghana",
                next: "skilled-worker"
            },
						{
                title: "Gibraltar",
                next: "skilled-worker"
            },
						{
                title: "Greece",
                next: "eu-worker"
            },
						{
                title: "Grenada",
                next: "skilled-worker"
            },
						{
                title: "Guadeloupe",
                next: "skilled-worker"
            },
						{
                title: "Guatemala",
                next: "skilled-worker"
            },
						{
                title: "Guinea-Bissau",
                next: "skilled-worker"
            },
						{
                title: "Guyana",
                next: "skilled-worker"
            },
						{
                title: "Haiti",
                next: "skilled-worker"
            },
						{
                title: "Honduras",
                next: "skilled-worker"
            },
						{
                title: "Hong Kong",
                next: "skilled-worker"
            },
						{
                title: "Hungary",
                next: "eu-worker"
            },
						{
                title: "Iceland",
                next: "eu-worker"
            },
						{
                title: "India",
                next: "skilled-worker"
            },
						{
                title: "Indonesia",
                next: "skilled-worker"
            },
						{
                title: "Iran",
                next: "skilled-worker"
            },
						{
                title: "Iraq",
                next: "skilled-worker"
            },
						{
                title: "Ireland",
                next: "eu-worker"
            },
						{
                title: "Israel",
                next: "skilled-worker"
            },
						{
                title: "Italy",
                next: "eu-worker"
            },
						{
                title: "Ivory Coast (Cote d'Ivoire)",
                next: "skilled-worker"
            },
						{
                title: "Jamaica",
                next: "skilled-worker"
            },
						{
                title: "Japan",
                next: "skilled-worker"
            },
						{
                title: "Jordan",
                next: "skilled-worker"
            },
						{
                title: "Kazakhstan",
                next: "skilled-worker"
            },
						{
                title: "Kenya",
                next: "skilled-worker"
            },
						{
                title: "Kiribati",
                next: "skilled-worker"
            },
						{
                title: "Kosovo",
                next: "skilled-worker"
            },
						{
                title: "Kuwait",
                next: "skilled-worker"
            },
						{
                title: "Kyrgystan",
                next: "skilled-worker"
            },
						{
                title: "Kyrgyzstan",
                next: "skilled-worker"
            },
						{
                title: "Laos",
                next: "skilled-worker"
            },
						{
                title: "Latvia",
                next: "eu-worker"
            },
						{
                title: "Lebanon",
                next: "skilled-worker"
            },
						{
                title: "Lesotho",
                next: "skilled-worker"
            },
						{
                title: "Liberia",
                next: "skilled-worker"
            },
						{
                title: "Libya",
                next: "skilled-worker"
            },
						{
                title: "Liechtenstein",
                next: "eu-worker"
            },
						{
                title: "Lithuania",
                next: "eu-worker"
            },
						{
                title: "Luxembourg",
                next: "eu-worker"
            },
						{
                title: "Macao",
                next: "skilled-worker"
            },
						{
                title: "Macedonia",
                next: "skilled-worker"
            },
						{
                title: "Madagascar",
                next: "skilled-worker"
            },
						{
                title: "Malawi",
                next: "skilled-worker"
            },
						{
                title: "Malaysia",
                next: "skilled-worker"
            },
						{
                title: "Maldives",
                next: "skilled-worker"
            },
						{
                title: "Mali",
                next: "skilled-worker"
            },
						{
                title: "Malta",
                next: "skilled-worker"
            },
						{
                title: "Marshall Islands",
                next: "skilled-worker"
            },
						{
                title: "Martinique",
                next: "skilled-worker"
            },
						{
                title: "Mauritania",
                next: "skilled-worker"
            },
						{
                title: "Mauritius",
                next: "skilled-worker"
            },
						{
                title: "Mayotte",
                next: "skilled-worker"
            },
						{
                title: "Mexico",
                next: "skilled-worker"
            },
						{
                title: "Micronesia",
                next: "skilled-worker"
            },
						{
                title: "Moldova",
                next: "skilled-worker"
            },
						{
                title: "Monaco",
                next: "skilled-worker"
            },
						{
                title: "Mongolia",
                next: "skilled-worker"
            },
						{
                title: "Montserrat",
                next: "skilled-worker"
            },
						{
                title: "Morocco",
                next: "skilled-worker"
            },
						{
                title: "Morocco",
                next: "skilled-worker"
            },
						{
                title: "Mozambique",
                next: "skilled-worker"
            },
						{
                title: "Namibia",
                next: "skilled-worker"
            },
						{
                title: "Nauru",
                next: "skilled-worker"
            },
						{
                title: "Nepal",
                next: "skilled-worker"
            },
						{
                title: "Netherlands",
                next: "eu-worker"
            },
						{
                title: "New Caledonia",
                next: "skilled-worker"
            },
						{
                title: "New Zealand",
                next: "skilled-worker"
            },
						{
                title: "Nicaragua",
                next: "skilled-worker"
            },
						{
                title: "Niger",
                next: "skilled-worker"
            },
						{
                title: "Nigeria",
                next: "skilled-worker"
            },
						{
                title: "North Korea",
                next: "skilled-worker"
            },
						{
                title: "Norway",
                next: "eu-worker"
            },
						{
                title: "Pakistan",
                next: "skilled-worker"
            },
						{
                title: "Palau",
                next: "skilled-worker"
            },
						{
                title: "Panama",
                next: "skilled-worker"
            },
						{
                title: "Papua New Guinea",
                next: "skilled-worker"
            },
						{
                title: "Paraguay",
                next: "skilled-worker"
            },
						{
                title: "Peru",
                next: "skilled-worker"
            },
						{
                title: "Philippines",
                next: "skilled-worker"
            },
						{
                title: "Pitcairn",
                next: "skilled-worker"
            },
						{
                title: "Poland",
                next: "eu-worker"
            },
						{
                title: "Portugal",
                next: "eu-worker"
            },
						{
                title: "Qatar",
                next: "skilled-worker"
            },
						{
                title: "Republic of Ireland",
                next: "eu-worker"
            },
						{
                title: "Réunion",
                next: "skilled-worker"
            },
						{
                title: "Romania",
                next: "exc-worker"
            },
						{
                title: "Russian Federation",
                next: "skilled-worker"
            },
						{
                title: "Rwanda",
                next: "skilled-worker"
            },
						{
                title: "Samoa",
                next: "skilled-worker"
            },
						{
                title: "São Tomé and Principe",
                next: "skilled-worker"
            },
						{
                title: "Saudi Arabia",
                next: "skilled-worker"
            },
						{
                title: "Senegal",
                next: "skilled-worker"
            },
						{
                title: "Serbia",
                next: "skilled-worker"
            },
						{
                title: "Seychelles",
                next: "skilled-worker"
            },
						{
                title: "Sierra Leone",
                next: "skilled-worker"
            },
						{
                title: "Singapore",
                next: "skilled-worker"
            },
						{
                title: "Slovakia",
                next: "eu-worker"
            },
						{
                title: "Slovenia",
                next: "eu-worker"
            },
						{
                title: "Solomon Islands",
                next: "skilled-worker"
            },
						{
                title: "Somalia",
                next: "skilled-worker"
            },
						{
                title: "South Africa",
                next: "skilled-worker"
            },
						{
                title: "South Georgia & South Sandwich Islands",
                next: "skilled-worker"
            },
						{
                title: "South Korea",
                next: "skilled-worker"
            },
						{
                title: "South Sudan",
                next: "skilled-worker"
            },
						{
                title: "Spain",
                next: "eu-worker"
            },
						{
                title: "Sri Lanka",
                next: "skilled-worker"
            },
						{
                title: "St Helena",
                next: "skilled-worker"
            },
						{
                title: "St Kitts and Nevis",
                next: "skilled-worker"
            },
						{
                title: "St Lucia",
                next: "skilled-worker"
            },
						{
                title: "St Pierre & Miquelon",
                next: "skilled-worker"
            },
						{
                title: "St Vincent and the Grenadines",
                next: "skilled-worker"
            },
						{
                title: "Sudan",
                next: "skilled-worker"
            },
						{
                title: "Suriname",
                next: "skilled-worker"
            },
						{
                title: "Swaziland",
                next: "skilled-worker"
            },
						{
                title: "Sweden",
                next: "eu-worker"
            },
						{
                title: "Switzerland",
                next: "eu-worker"
            },
						{
                title: "Syria",
                next: "skilled-worker"
            },
						{
                title: "Taiwan",
                next: "skilled-worker"
            },
						{
                title: "Tajikistan",
                next: "skilled-worker"
            },
						{
                title: "Tanzania",
                next: "skilled-worker"
            },
						{
                title: "Thailand",
                next: "skilled-worker"
            },
						{
                title: "Timor-Leste",
                next: "skilled-worker"
            },
						{
                title: "Togo",
                next: "skilled-worker"
            },
						{
                title: "Tonga",
                next: "skilled-worker"
            },
						{
                title: "Trinidad and Tobago",
                next: "skilled-worker"
            },
						{
                title: "Tristan da Cunha",
                next: "skilled-worker"
            },
						{
                title: "Tunisia",
                next: "skilled-worker"
            },
						{
                title: "Turkey",
                next: "skilled-worker"
            },
						{
                title: "Turkmenistan",
                next: "skilled-worker"
            },
						{
                title: "Turks and Caicos Islands",
                next: "skilled-worker"
            },
						{
                title: "Tuvalu",
                next: "skilled-worker"
            },
						{
                title: "Uganda",
                next: "skilled-worker"
            },
						{
                title: "Ukraine",
                next: "skilled-worker"
            },
						{
                title: "United Arab Emirates",
                next: "skilled-worker"
            },
						{
                title: "United Kingdom",
                next: "eu-worker"
            },
						{
                title: "United States",
                next: "skilled-worker"
            },
						{
                title: "Uruguay",
                next: "skilled-worker"
            },
						{
                title: "Uzbekistan",
                next: "skilled-worker"
            },
						{
                title: "Vanuatu",
                next: "skilled-worker"
            },
						{
                title: "Venezuela",
                next: "skilled-worker"
            },
						{
                title: "Vietnam",
                next: "skilled-worker"
            },
						{
                title: "Wallis & Futuna",
                next: "skilled-worker"
            },
						{
                title: "Western Sahara",
                next: "skilled-worker"
            },
						{
                title: "Yemen",
                next: "skilled-worker"
            },
						{
                title: "Zambia",
                next: "skilled-worker"
            },
						{
                title: "Zimbabwe",
                next: "skilled-worker"
            }]
        },
        {
            id: "skilled-worker",
            title: "Are you a skilled worker with a job offer in the UK?",
            next: "nature-of-work",
            options: [
                "Yes",
                "No"
            ]
        },
        {
            id: "nature-of-work",
            title: "How would you describe yourself?",
            next: "result-tier2",
            options: [
                "Entrepreneur - you plan to set up a business in the UK",
                "Investor - you plan to make a financial investment in the UK",
                "Skilled worker",
                "Student - you're on a full-time education course",
                // If an option contains a `next` property, then it will override the step's default `next` property
                // {
                //      title: "Unskilled worker",
                //      next: "result-unqualified"
                //  },
                "Temporary worker - you plan to work in the UK for 12 months or less",
                "On the Youth Mobility Scheme"
            ]
        },
        
        // If a step does not contain any `options` or `next` properties, then it is treated as a "result"
        {
            id: "result-unqualified",
            title: "Sorry, but you are unqualified to work in the UK at this time"
        },

				// EEA worker
        {
            id: "eu-worker",
            title: "You have the right to work in the UK and don't need permission. ",
						details: ["You'll need to show your passport or identity card to your employer."],
            readmore: [
                {
                    title: "Link to European workers in the UK guide",
                    url: "#"
                }
            ]
        },

				// rule exception for bulgaria and romania
				{
            id: "exc-worker",
            title: "Unless you're self-employed, you'll need to get permission from the UK Border Agency before you start work in the UK. ",
            readmore: [
                {
                    title: "UK Border Agency",
                    url: "http://www.ukba.homeoffice.gov.uk/eucitizens/bulgaria-romania/work-permits/"
                }
            ]
        },
        // Results steps may contain additional properties - e.g. `summary`, `details` and `readmore`
        {
            id: "result-tier2",
            title: "You may be eligible to work in the UK",
            details: ["You need to apply to the UK Border Agency for permission.",
											"Click the 'Apply to work in the UK' link to start your application. "],
           
            readmore: [
                {
                    title: "Apply to work in the UK",
                    url: "https://apply.ukba.homeoffice.gov.uk/iapply.portal"
                }
            ]
        }
    ]
});
