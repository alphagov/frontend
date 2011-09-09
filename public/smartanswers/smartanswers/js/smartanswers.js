/*
    SmartAnswer library for GovUK
    by Premasagar Rose <http://premasagar.com>
*
**/
/*global window, jQuery, _, tim */

var SmartAnswer = (function(window, document){
    "use strict";

    // Console logging
    window.O = function(){
        if (window.console){
            window.console.log.apply(window.console, arguments);
        }
    };

    /////

    function SmartAnswer(options, autorender){
        this.init(options);
        
        if (autorender !== false){
            this.render();
        }
    }

    SmartAnswer.prototype = {
        MAX_OPTIONS_FOR_RADIO: 10,
        VALIDITY_CHECK_INTERVAL: 250, // Interval time used by startValidityChecking() to check the validity of the current user input
        
        lang: {
            MONTHS: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        },
        
        currentStepIndex: 0,
        
        nowDate: new Date(),

        init: function(data){
            var smartanswer = this;
        
            // Bind methods to this instance
            _.bindAll(this, "onStart", "onSubmitDecision", "onUndo", "checkStepValidity");
            
            // Extend with passed data
            _.extend(this, data);
        
            // Container for cached DOM nodes
            this.dom = {};
            
            // Array of steps (questions/decisions, results and intermediary steps)
            this.steps = [];
            
            // Array of steps and decisions that have been taken
            this.history = [];
            
            // Data store for user decisions
            this.decisions = {};
            
            // Include any steps that have been supplied
            _.each(data.steps, function(step){
                smartanswer.addStep(step);
            });
        },
        
        rand: function(){
            return Math.floor(Math.random() * 9999);
        },
        
        formatDate: function(date, plusDays){
            var d = new Date(date);
            return plusDays ?
                new Date(d.setDate(d.getDate() + plusDays)) : d;
        },
        
        // TODO: convert to "3rd August, 2011" format
        niceDate: function(date, plusDays){
            var d = this.formatDate(date, plusDays);
            return d.getDate() + "/" + (d.getMonth() + 1) + "/" + d.getFullYear();
        },

        addStep: function(data){
            this.steps.push(data);
            return this;
        },
        
        onStart: function(){
            this.pushStep(this.steps[0])
                .renderDecisionIntro()
                .renderStep();
        
            // hide intro, show form
            this.dom.intro.hide();
            this.dom.form.show();
        },
        
        getDecisionFromUserInput: function(){
            var controlElem = this.currentStepElem().find(":checked,:selected,input[type=date],select.date"),
                decision, dateComponents, dateLen, day, month, year;
            
            if (controlElem.is("select.date")){
                dateComponents = controlElem.filter(":selected").map(function(i, elem){
                    return jQuery(elem).val();
                });
                
                // Ensure that day, month & year are all selected
                if (!_.include(dateComponents, "null")){
                    dateLen = dateComponents.length;
                    year = dateComponents[dateLen-1];
                    month = dateComponents[dateLen-2] - 1; // NOTE: JavaScript months are zero-indexed
                    day = dateComponents[dateLen-3];
                
                    decision = new Date();
                    decision.setFullYear(year);
                    decision.setMonth(month || 0);
                    decision.setDate(day || 1);
                }
            }
            else if (controlElem.is("option,input[type=date]")){
                decision = controlElem.val();
            }
            else if (controlElem.is("input")){
                decision = controlElem.siblings("label:first").text();
            }
            
            return _.isUndefined(decision) || decision === "" || decision === null || decision === "null" ? 
                false : decision;
        },
        
        getStepById: function(id){
            return _.detect(this.steps, function(step){
                return step.id === id;
            });
        },
        
        updatePageTitle: function(){
            document.title = this.title;
            return this;
        },
        
        onSubmitDecision: function(event){
            var decision = this.getDecisionFromUserInput(),
                currentStep, nextStep, doPushStep;

            // Only proceed if the decision was valid
            if (decision){
                currentStep = this.currentStep();
            
                // Cache decision both in the history array and the data store, for use in step options
                this.decisions[currentStep.id] = this.history[this.currentStepIndex].decision = decision;
                
                // Render the decision
                this.renderDecision(decision);
                
                // Proceed to the next step
                nextStep = this.getNextStep(decision);
                
                // Will we need to push a new step to the end of the history stack?
                if (this.currentStepIsHistoryLast()){
                    doPushStep = true;
                }
                
                // We're changing decisions, not adding to the end, so replace the history state
                else {
                    this.replaceStep(currentStep, this.currentStepIndex);
                    
                    // If replaceStep() caused an incompatible remainder of the history stack, then the stack would have been truncated, and we will need to push the new step on to the stack.
                    if (this.currentStepIsHistoryLast()){
                        doPushStep = true;
                    }
                    else {
                        this.currentStepIndex ++;
                    }
                }
                
                if (doPushStep){
                    this.pushStep(nextStep);
                }
                
                this.renderStep(nextStep);
            }
            
            event.preventDefault();
        },
        
        onUndo: function(event){
            var stepId = jQuery(event.target).parents("[data-step]").data("step");
            this.changeDecision(stepId);
            
            event.preventDefault();
        },
        
        changeDecision: function(stepId){
            var historyStepIds = _.map(this.history, function(state){
                    return state.step.id;
                }),
                historyIndex = _.indexOf(historyStepIds, stepId);
            
            if (historyIndex === -1){
                throw "changeDecision (" + stepId + "): historyIndex not found";
            }
        
            this.currentStepIndex = historyIndex;
            this.removeRenderedDecisions(historyIndex)
                .renderStep();
            
            return this;
        },
        
        removeRenderedDecisions: function(fromDecision){
            this.dom.done.slice(fromDecision).remove();
            return this;
        },
        
        render: function(){
            this.dom.content = jQuery("div.content:first")
                .html(tim("smartanswer", this));
            
            return this.updatePageTitle().cacheElementsOnRender();
        },
        
        pushStep: function(step){
            this.history.push({step:step});
            this.currentStepIndex = this.history.length - 1;
            return this;
        },
        
        replaceStep: function(step, historyIndex){
            var oldStepId = this.history[historyIndex].step.id;
            
            // If we're replacing a step with a different kind of step, then remove the remaining history
            if (oldStepId !== step.id){
                this.history = this.history.slice(0, historyIndex);
            }
            
            this.history[historyIndex] = {step:step};
            this.currentStepIndex = historyIndex;
            
            // Verify that later steps are still valid
            return this;
        },
        
        currentStep: function(){
            return this.history[this.currentStepIndex].step;
        },
        
        currentStepElem: function(){
            return this.dom.current.eq(this.currentStepIndex);
        },
        
        currentStepIsHistoryLast: function(){
            return this.history.length === this.currentStepIndex + 1;
        },
        
        renderDecisionIntro: function(){
            this.dom.decisions.html(tim("decision-intro", this));
            return this;
        },
        
        // The user has given a decision for a step, and the decision has been validated. Now determine the next step.
        getNextStep: function(decision, step){
            var options, option, nextId, nextStep;
            
            step = step || this.currentStep();
            options = step.options;
            
            if (step.next){
                nextId = step.next;
            }
        
            if (options.length <= 1){
                option = options[0];
            }
            else {
                option = _.detect(options, function(option){
                    return option.title === decision;
                });
            }
            
            if (option && option.next){
                nextId = _.isFunction(option.next) ?
                    option.next.call(this) : option.next;
            }
            else if (step.next){
                nextId = _.isFunction(step.next) ?
                    step.next.call(this) : step.next;
            }
            else {
                throw "getNextStep (" + decision + "): Next step not found";
            }
            
            nextStep = this.getStepById(nextId);
            
            if (!nextStep){
                throw "getNextStep (" + decision + " -> " + nextId + "): Next step not found";
            }
            
            return nextStep;
        },
        
        getStepType: function(step){
            if (step.options){
                return "question";
            }
            else if (step.next){
                return "intermediary";
            }
            else {
                return "result";
            }
        },
        
        renderDecision: function(decision){
            var step = this.currentStep(),
                existingDom = this.dom.done.filter("[data-step=" + step.id + "]"),
                title = _.isFunction(step.title) ? step.title.call(this) : step.title,
                template;

            if (_.isDate(decision)){
                decision = this.niceDate(decision);
            }

            template = tim("decision", {
                id: step.id,
                historyIndex: this.currentStepIndex + 1,
                title: title,
                decision: decision
            });

            // Replace a previously given decision
            if (existingDom.length){
                existingDom.replaceWith(template);
            }
        
            // Append a new decision
            else {
                this.dom.decisions.append(template);
            }
                
            return this;
        },
        
        renderStep: function(step){
            var stepElems = this.dom.steps.children(),
                hasExistingDom, hasDynamicTitle, stepType, title, data, existingDom, template;
                
            step = step || this.currentStep();
            stepType = this.getStepType(step);
            existingDom = stepElems.filter("[data-step=" + step.id + "]");
            hasExistingDom = !!existingDom.length;
            hasDynamicTitle = _.isFunction(step.title);
            
            // Hide existing steps and results
            stepElems.add(this.dom.results).hide();
            
            if (!hasExistingDom || (hasExistingDom && hasDynamicTitle)) {
                title = hasDynamicTitle ? step.title.call(this) : step.title;
                
                // Question/decision
                switch (stepType){
                    case "question":
                        data = {
                            id: step.id,
                            title: title,
                            historyIndex: this.currentStepIndex + 1,
                            options: this.optionsTemplate(step)
                        };
                        template = tim("step", data);
                        
                        if (!hasExistingDom){
                            this.dom.steps.append(template);
                        }
                    break;
                
                    case "intermediary":
                        // This could be a simple informational step, with a Next button, but no decision to be made
                    throw "Intermediary step not yet implemented";
                
                    case "result":
                        data = _.extend({}, step, {
                            title: title,                   
                            hasDetails:  !!step.details,
                            hasReadMore: !!step.readmore,
                            hasSummary:  !!step.summary
                        });
                        template = tim("results", data);
                        
                        if (!hasExistingDom){
                            this.dom.form.after(template);
                        }
                    break;
                }
            }
            
            if (hasExistingDom){
                if (template){
                    existingDom.replaceWith(template);
                }
                existingDom.show();
            }
            
            this.cacheElementsOnStep();
            
            // Display the validity of user response during the form completion (e.g. grey -> green submit button)
            if (stepType === "question"){
                this.startValidityChecking();
            }
            else {
                this.endValidityChecking();
            }
            
            return this;
        },
        
        singleOptionTemplate: function(option, name){
            var currentYear, fromYear, toYear, monthTitles;
        
            if (_.isString(option)){
                option = {title: option};
            }
        
            option = _.extend({
                name: name,
                id: name + "_" + this.rand()
            }, option);
        
            if (option.type === "date"){
                if (!option.years || option.years.length !== 2){
                    throw "singleOptionTemplate (" + name + "): Options of type `date` must include a `years` array. E.g. `years:[-1,1]` to represent a range from last year to next year.";
                }
                
                currentYear = this.nowDate.getFullYear();
                fromYear = currentYear + option.years[0];
                toYear = currentYear + option.years[1];
                monthTitles = this.lang.MONTHS;
                
                option.days = _.map(_.range(1, 32), function(day){
                    return {title: day};
                });
                
                option.months = _.map(_.range(1, 13), function(month){
                    return {value: month, title: monthTitles[month -1]};
                });
                
                option.years = _.map(_.range(fromYear, toYear + 1), function(year){
                    return {title: year};
                });
            }
        
            return option;
        },
        
        optionsTemplate: function(step){
            var smartanswer = this,
                type = this.getOptionsType(step),
                templateName = "option-" + type,
                name = step.id + "-" + this.rand(),
                data = {
                    step: step,
                    name: name,
                    hasOptionsSummary: !!step.optionsSummary,
                    options: _.map(step.options, function(option){
                        return smartanswer.singleOptionTemplate(option, name);
                    })
                };
                
            return tim(templateName, data);
        },
        
        getOptionsType: function(step){
            var options = step.options;
        
            if (_.any(options, function(option){
                    return option.type === "date";
            })){
                return "date";
            }
            else if (step.multichoice){
                throw "Multichoice not yet implemented";
                //return "checkbox";
            }
            else if (options.length <= this.MAX_OPTIONS_FOR_RADIO){
                return "radio";
            }
            else {
                return "select";
            }
        },
        
        setFormState: function(isValid){
            this.dom.form
                .removeClass(isValid ? "invalid" : "valid")
                .addClass(isValid ? "valid" : "invalid");
               
            return this;
        },
        
        checkStepValidity: function(){
            var isValid = this.getDecisionFromUserInput() !== false;
            return this.setFormState(isValid);
        },
        
        // A method for reporting the validity of the current form
        // For the prototype, this uses setInterval to check several times a second. It could be made more efficient by instead triggering on each individual user input event.
        startValidityChecking: function(){
            // Check once, straight away
            this.checkStepValidity();
        
            // Setup interval
            if (!this.validityCheckRef){
                this.validityCheckRef = window.setInterval(this.checkStepValidity, this.VALIDITY_CHECK_INTERVAL);
            }
            
            return this;
        },
        
        endValidityChecking: function(){
            window.clearInterval(this.validityCheckRef);
            this.validityCheckRef = null;
            return this;
        },
        
        $: function(selector){
            return this.dom.content.find(selector);
        },
        
        cacheElementsOnRender: function(){
            _.extend(this.dom, {
                form:       this.$("form"),
                steps:      this.$(".steps"),
                decisions:  this.$(".done-decisions"),
                start:      this.$("p.start a"),
                intro:      this.$(".introduction")
            });
            
            // Bind handlers
            this.dom.content
                .delegate("p.start a", "click", this.onStart)
                .delegate(".undo a", "click", this.onUndo)
                .delegate("form", "submit", this.onSubmitDecision);
            
            return this;
        },
        
        cacheElementsOnStep: function(){
            _.extend(this.dom, {
                current:    this.$(".current"),
                results:    this.$(".results"),
                done:       this.$(".done"),
                nextBtn:    this.$(".next-decision input[type=submit]"),
                undos:      this.$(".undo a")
            });
            
            return this;
        }
    };
    
    return SmartAnswer;
}(this, this.document));

/*jslint browser: true, undef: true, white: true, nomen: true, plusplus: true, maxerr: 50, indent: 4 */
