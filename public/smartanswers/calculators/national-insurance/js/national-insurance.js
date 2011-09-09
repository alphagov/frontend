(function(window, document){
    "use strict";

    var formStyles = {
            "form .controls-results-wrapper .has-prequisites": "display:none"
        },
        
        // Regex for determining if an amount string is valid. TODO: make more robust - e.g. only allow commas for complete thousands
        VALID_AMOUNT = /^([0-9,\s\.]+)$/,
        
        // Regex of characters to be removed from valid amount strings in parsing as integers - e.g. commas
        TO_BE_REMOVED_FROM_VALID_AMOUNT = /,/,
        
        dom = {
            head: jQuery("head"),
            document: jQuery(document)
        },
        earningQuestions = {
            "employed":         "How much do you earn per week?",
            "self-employed":    "How much do you expect your annual profits to be?",
            "unemployed":       ""
        };

    function cacheElements(){
        var // General elements
            form                = jQuery("form"),
            submitBtn           = jQuery("input[type=submit]", form),
            items               = jQuery(".item"),
            errorHeader         = jQuery("#error-header"),
            itemErrors          = jQuery(".error-message", items),
            hasPrequisites      = items.filter(".has-prequisites"),
            
            // Specific
            selectEmployment    = jQuery("select#select-employment", form),
            earningsQuestion    = jQuery("#earning-question", form),
            earnings            = jQuery("input#earnings", form),
            howMuch             = jQuery("#earning-question .how-much", form),
            results             = jQuery("#results");

        return {
            // General
            form:               form,
            submitBtn:          submitBtn,
            items:              items,
            errorHeader:        errorHeader,
            itemErrors:         itemErrors,
            hasPrequisites:     hasPrequisites,
            errors:             errorHeader.add(itemErrors),
            results:            results,
            resultsContents:    results.html(),
            
            // Specific
            selectEmployment:   selectEmployment,
            selectEmploymentParent: selectEmployment.parents(".item:first"),
            earningsQuestion:   earningsQuestion,
            earnings:           earnings,
            earningsParent:     earnings.parents(".item:first"),
            howMuch:            howMuch      
        };
    }

    function createCSS(styles){
        return _.map(styles, function(rules, selector){
            if (_.isArray(rules)){
                rules = rules.join(";");
            }
            return selector + "{" + rules + "}";
        });
    }

    function appendStyles(styles){
        jQuery("<style>" + createCSS(styles) + "</style>")
            .appendTo(dom.head);
    }

    function onSubmit(){
        if (validateForm()){
            onValidFormSubmit();
        }
        
        return false;
    }
    
    function getEarningsQuestionText(){
        return earningQuestions[getEmployment()];
    }

    function setEarningQuestion(){
        var msg = getEarningsQuestionText();
        
        if (msg && hasValidEmployment()){
            dom.earningsQuestion.show();
            dom.howMuch.html(msg);
        }
        
        else {
            dom.earningsQuestion.hide();
            
            // Empty earnings input if invalid
            if (!hasValidEarnings()){
                dom.earnings.val("");
            }
        }
    }

    function onEmploymentChange(){
        hideErrors();
        validateEmployment();
        setEarningQuestion();
	    restoreDefaultResults();
        setFormState();
    }

    function getEmployment(){
        return dom.selectEmployment.val();
    }

    function getEarnings(){
        return dom.earnings.val();
    }

    function hasValidEmployment(){
        return getEmployment() !== "null";
    }

    function hasValidEarnings(){
        return !getEarningsQuestionText() || VALID_AMOUNT.test(getEarnings());
    }
    
    function parseAmount(amountStr){
        return parseInt(amountStr.replace(TO_BE_REMOVED_FROM_VALID_AMOUNT, ""));
    }

    function onEarningsKeypress(){
        // setTimeout till after input value has been registered
        window.setTimeout(function(){
            hideErrors();
            validateEarnings();
	        restoreDefaultResults();
        }, 1);
        
        setFormState();
    }

    function showError(item){
        item.addClass("error")
	        .find(".error-message").show();
	        
	    dom.errorHeader.show();
    }

    function hideErrors(){
	    // Hide master error and item errors
	    dom.errors.hide();
	    dom.items.removeClass("error");
    }

    function validateEmployment(){
        if (!hasValidEmployment()){
		    showError(dom.selectEmploymentParent);
		    return false;
	    }
	    return true;
    }

    function validateEarnings(){
        if (!hasValidEarnings()){
		    showError(dom.earningsParent);
		    return false;
	    }
	    return true;
    }
    
    function restoreDefaultResults(){
        dom.results.html(dom.resultsContents);
    }

    function setFormState(){
        if (isValidForm()){
            dom.form
                .addClass("valid")
                .removeClass("invalid");
        }
        else {
            dom.form
                .addClass("invalid")
                .removeClass("valid");
            
            restoreDefaultResults();   
        }
    }

    function isValidForm(){
	    return hasValidEarnings() && hasValidEmployment();
    }

    function validateForm(){
	    var isValid = true;
	
	    // hide any existing errors
	    hideErrors();
	
	    // check for employment status
	    isValid = isValid && validateEmployment();

	    // check for earnings
	    isValid = isValid && validateEarnings();

	    return isValid;
    }

    // TODO: refactor
    function onValidFormSubmit(){
        var ni = calculate_ni();
        
        dom.results.html('<p class="giant-result">' + ni.amount + '</p>' +
            '<p>'+ni.workings+'</p><p><a href="http://www.direct.gov.uk/en/MoneyTaxAndBenefits/Taxes/BeginnersGuideToTax/NationalInsurance/index.htm">'+ 'National Insurance – a basic guide</a></p>');
    }

    // TODO: refactor
    function calculate_ni() {
	    var status = getEmployment(),
	        earnings = parseAmount(getEarnings()),
	        amount, workings;

	    switch (status) {
	        case "employed":
	            amount = 0;
	            workings = "You don't pay National Insurance if you earn less than £139 a week.";
		
			    if (earnings >= 139) {
				    amount = amount + (earnings-139) * 0.12;
				    workings = "You pay 12% of the amount you earn between £139 and £817"+(earnings-139);
			    }
			    if (earnings >= 817) {
				    amount = amount + (earnings-817) * 0.02;
				    workings = workings + "You then pay 2% of all your earnings over £817."+(earnings-817);
			    }
			    return {
				    earnings: earnings,
				    amount: "£"+Math.round(amount*100)/100+" per week",
				    workings: workings
			    };
            
            case "self-employed":
			    amount = 2.5 * 52;
			    workings = "This is based on:</p> <ul><li>A flat rate of £2.50 per week (class 2 contributions)</li>";

			    if (earnings >= 7225) {
				    amount = amount + (earnings-7225) * 0.09;
				    workings = workings + "<li>9% of £"+(earnings-7225)+". (You don't pay contributions on the first £7,225 of your profits)</li>";
			    }
			
			    if (earnings >= 42475) {
				    amount = amount + (earnings-42475) * 0.02;
				    workings = workings + "<li>An extra 2% on the remaining £"+(earnings-42475)+"</li>";
			    }
			
			    amount = Math.round((amount/52)*100)/100;
		
			    return {
				    earnings: earnings,
				    amount: "£"+ amount.toFixed(2) +" per week",
				    workings: workings
			    };
		
		    case "unemployed":
			    return {
				    earnings: null,
				    amount: "£0",
				    workings: "You don't pay National Insurance if you earn less than £139 a week."
			    };
		
		    default:
			    return {
				    earnings: earnings,
				    amount: "There was an error",
				    workings: "Please <a href=''>refresh the page</a> and try again"
			    };
	    }
    }

    function onStart(){
        appendStyles(formStyles);
    }

    function onDomReady(){
        dom = _.extend(dom, cacheElements());
        dom.form.submit(onSubmit);
        dom.selectEmployment.change(onEmploymentChange);
        dom.earnings.keyup(onEarningsKeypress); // NOTE: use keyup instead of keypress to capture backspace
    }

    /////

    onStart();
    jQuery(onDomReady);
}(this, this.document));
